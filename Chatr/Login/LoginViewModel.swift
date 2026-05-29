// LoginViewModel.swift
// Chatr Design System — Login Demo
//
// ObservableObject ViewModel for the Login screen.
//
// Responsibilities:
//   • Owns all mutable UI state (email, password, loading, errors, navigation).
//   • Calls AuthServiceProtocol — fully unit-testable via injection.
//   • Persists tokens securely via KeychainService.
//   • Does NOT import SwiftUI or UIKit — pure business logic.

import Foundation
import Combine
import Security

// MARK: - LoginViewModel

@MainActor
final class LoginViewModel: ObservableObject {

    // MARK: - Input state (bound directly to DS text fields)

    @Published var email: String = ""
    @Published var password: String = ""

    // MARK: - UI state

    @Published private(set) var isLoading: Bool = false
    @Published private(set) var loginError: AuthError? = nil
    @Published var isLoggedIn: Bool = false   // writable so SwiftUI can reset on dismiss
    @Published private(set) var failureCount: Int = 0
    @Published private(set) var loggedInUser: AuthUser? = nil

    // MARK: - Derived

    var isSignInEnabled: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty &&
        !isLoading
    }

    var errorMessage: String? {
        loginError?.errorDescription
    }

    var isAccountLocked: Bool {
        loginError == .accountLocked
    }

    // MARK: - Dependencies

    private let authService: AuthServiceProtocol
    private let keychain: KeychainServiceProtocol

    // MARK: - Init

    init(
        authService: AuthServiceProtocol = LiveAuthService(),
        keychain: KeychainServiceProtocol = KeychainService.shared
    ) {
        self.authService = authService
        self.keychain    = keychain
    }

    // MARK: - Actions

    func signIn() async {
        guard isSignInEnabled else { return }

        isLoading  = true
        loginError = nil

        defer { isLoading = false }

        do {
            let response = try await authService.login(
                username: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
            try keychain.save(token: response.accessToken, for: .accessToken)
            try keychain.save(token: response.refreshToken, for: .refreshToken)
            failureCount  = 0
            loggedInUser  = response.user
            isLoggedIn    = true
        } catch let error as AuthError {
            failureCount += 1
            loginError    = error
        } catch {
            failureCount += 1
            loginError    = .unknown
        }
    }

    func clearSensitiveData() {
        password   = ""
        loginError = nil
    }

    func dismissError() {
        loginError = nil
    }
}

// MARK: - KeychainServiceProtocol

protocol KeychainServiceProtocol {
    func save(token: String, for key: KeychainKey) throws
    func load(for key: KeychainKey) throws -> String
    func delete(for key: KeychainKey) throws
}

// MARK: - KeychainKey

enum KeychainKey: String {
    case accessToken  = "com.Chatr.auth.accessToken"
    case refreshToken = "com.Chatr.auth.refreshToken"
}

// MARK: - KeychainService

final class KeychainService: KeychainServiceProtocol {

    static let shared = KeychainService()
    private init() {}

    func save(token: String, for key: KeychainKey) throws {
        guard let data = token.data(using: .utf8) else {
            throw KeychainError.encodingFailed
        }
        try? delete(for: key)

        let query: [CFString: Any] = [
            kSecClass:           kSecClassGenericPassword,
            kSecAttrAccount:     key.rawValue,
            kSecValueData:       data,
            kSecAttrAccessible:  kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }

    func load(for key: KeychainKey) throws -> String {
        let query: [CFString: Any] = [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecReturnData:  true,
            kSecMatchLimit:  kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            throw KeychainError.notFound
        }
        return token
    }

    func delete(for key: KeychainKey) throws {
        let query: [CFString: Any] = [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status)
        }
    }
}

// MARK: - KeychainError

enum KeychainError: LocalizedError {
    case encodingFailed
    case saveFailed(OSStatus)
    case notFound
    case deleteFailed(OSStatus)

    var errorDescription: String? {
        switch self {
        case .encodingFailed:       return "Failed to encode token data."
        case .saveFailed(let s):    return "Keychain save failed (OSStatus \(s))."
        case .notFound:             return "Token not found in Keychain."
        case .deleteFailed(let s):  return "Keychain delete failed (OSStatus \(s))."
        }
    }
}
