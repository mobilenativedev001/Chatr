// AuthService.swift
// Chatr Design System — Login Demo
//
// Protocol-driven authentication service with a live URLSession implementation
// and a mock implementation for SwiftUI Previews and unit tests.
//
// Security notes:
//   • Tokens are returned to the caller — storage is the ViewModel's responsibility.
//   • Passwords are never logged.
//   • TLS enforcement is handled by App Transport Security (ATS).

import Foundation
import UIKit

// MARK: - AuthServiceProtocol

/// Defines the authentication contract consumed by `LoginViewModel`.
/// Swap implementations freely (live, mock, staging).
protocol AuthServiceProtocol {
    /// Authenticate with `username` + `password`.
    /// - Throws: `AuthError` on failure.
    func login(username: String, password: String) async throws -> LoginResponse
    /// Invalidate the current session on the server.
    func logout(refreshToken: String) async throws
}

// MARK: - LiveAuthService

/// Production implementation backed by URLSession.
final class LiveAuthService: AuthServiceProtocol {

    // MARK: Configuration

    private let baseURL: URL
    private let session: URLSession

    init(
        baseURL: URL = URL(string: "https://api.Chatr.com/v1/auth")!,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }

    // MARK: AuthServiceProtocol

    func login(username: String, password: String) async throws -> LoginResponse {
        let url = baseURL.appendingPathComponent("login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let body = LoginRequest(
            username: username,
            password: password,
            deviceId: UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        )
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await performRequest(request)
        return try decode(LoginResponse.self, from: data, response: response)
    }

    func logout(refreshToken: String) async throws {
        let url = baseURL.appendingPathComponent("logout")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["refresh_token": refreshToken]
        request.httpBody = try JSONEncoder().encode(body)
        _ = try await performRequest(request)
    }

    // MARK: - Helpers

    private func performRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.unknown
            }
            return (data, httpResponse)
        } catch let error as AuthError {
            throw error
        } catch {
            throw AuthError.network(error.localizedDescription)
        }
    }

    private func decode<T: Decodable>(_ type: T.Type, from data: Data, response: HTTPURLResponse) throws -> T {
        switch response.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(type, from: data)
            } catch {
                throw AuthError.decodingError
            }
        case 401:
            throw AuthError.invalidCredentials
        case 423:
            throw AuthError.accountLocked
        case 429:
            throw AuthError.tooManyAttempts
        default:
            throw AuthError.httpError(response.statusCode)
        }
    }
}

// MARK: - MockAuthService

/// Deterministic mock for Xcode Previews and unit tests.
final class MockAuthService: AuthServiceProtocol {

    indirect enum Behaviour {
        case success
        case failure(AuthError)
        case delayed(seconds: Double, then: Behaviour)
    }

    private let behaviour: Behaviour

    init(behaviour: Behaviour = .success) {
        self.behaviour = behaviour
    }

    func login(username: String, password: String) async throws -> LoginResponse {
        try await resolveBehaviour(behaviour)
    }

    func logout(refreshToken: String) async throws {
        // No-op in mock
    }

    // MARK: Private

    private func resolveBehaviour(_ behaviour: Behaviour) async throws -> LoginResponse {
        switch behaviour {
        case .success:
            return LoginResponse(
                accessToken: "mock_access_token_\(UUID().uuidString)",
                refreshToken: "mock_refresh_token",
                expiresIn: 3600,
                user: AuthUser(
                    id: "usr_001",
                    email: "demo@Chatr.com",
                    displayName: "Chatr Demo User"
                )
            )
        case .failure(let error):
            throw error
        case .delayed(let seconds, let next):
            try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            return try await resolveBehaviour(next)
        }
    }
}
