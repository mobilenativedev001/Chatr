// AuthModels.swift
// Chatr Design System — Login Demo
//
// Pure data models for the authentication flow.
// No business logic — just Codable structs and domain errors.

import Foundation

// MARK: - Login Request

/// Payload sent to the authentication endpoint.
struct LoginRequest: Encodable {
    let username: String   // email or account ID
    let password: String
    let deviceId: String   // device fingerprint for security tracking

    private enum CodingKeys: String, CodingKey {
        case username
        case password
        case deviceId = "device_id"
    }
}

// MARK: - Login Response

/// Successful authentication response from the server.
struct LoginResponse: Decodable {
    /// Short-lived JWT access token.
    let accessToken: String
    /// Opaque refresh token (store in Keychain, not UserDefaults).
    let refreshToken: String
    /// Access-token lifetime in seconds.
    let expiresIn: Int
    /// Authenticated user summary.
    let user: AuthUser

    private enum CodingKeys: String, CodingKey {
        case accessToken  = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn    = "expires_in"
        case user
    }
}

// MARK: - Auth User

struct AuthUser: Decodable {
    let id: String
    let email: String
    let displayName: String

    private enum CodingKeys: String, CodingKey {
        case id
        case email
        case displayName = "display_name"
    }
}

// MARK: - Auth Error

/// Typed errors surfaced from the authentication layer.
enum AuthError: LocalizedError, Equatable {
    /// HTTP 401 — wrong credentials.
    case invalidCredentials
    /// HTTP 429 — too many attempts.
    case tooManyAttempts
    /// HTTP 423 — account locked after repeated failures.
    case accountLocked
    /// Network or transport error (wraps the underlying description).
    case network(String)
    /// Server returned an unexpected HTTP status code.
    case httpError(Int)
    /// Response payload could not be decoded.
    case decodingError
    /// Any other unexpected error.
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "The email or password you entered is incorrect. Please try again."
        case .tooManyAttempts:
            return "Too many sign-in attempts. Please wait a moment and try again."
        case .accountLocked:
            return "Your account has been locked. Please contact Chatr support."
        case .network(let msg):
            return "A network error occurred: \(msg)"
        case .httpError(let code):
            return "An error occurred (HTTP \(code)). Please try again later."
        case .decodingError:
            return "We received an unexpected response. Please try again."
        case .unknown:
            return "An unknown error occurred. Please try again."
        }
    }

    // MARK: Equatable
    static func == (lhs: AuthError, rhs: AuthError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidCredentials, .invalidCredentials),
             (.tooManyAttempts, .tooManyAttempts),
             (.accountLocked, .accountLocked),
             (.decodingError, .decodingError),
             (.unknown, .unknown):
            return true
        case (.network(let a), .network(let b)):
            return a == b
        case (.httpError(let a), .httpError(let b)):
            return a == b
        default:
            return false
        }
    }
}
