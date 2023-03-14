//
//  CommonOAuthTokenResponse.swift
//  
//
//  Created by Manish Kumar on 2023-03-13.
//

import Foundation

// MARK: - CommonOAuthTokenResponse

/// Common structure for the `auth token` API response for all providers.
struct CommonOAuthTokenResponse: Codable {
    /// Common to all providers
    let accessToken: String
    let scope: String
    let tokenType: String

    /// Provider-specific fields
    let expiresIn: Int?
    let refreshToken: String?
    let idToken: String? // JWT
    let accountId: String? // Only for Dropbox
}
