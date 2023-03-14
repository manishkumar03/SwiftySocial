//
//  QueryParametersFactory.swift
//  
//
//  Created by Manish Kumar on 2023-03-13.
//

import Foundation

/// Provides query parameters to be used for the creation of user consent URL.
/// - Parameter socialLoginProvider: Social login provider whose authorization is being sought
/// - Returns: Query parameters to be used for in the creation of user consent URL
func createQueryParametersForUserConsent(for socialLoginProvider: SocialLoginProvider) -> [String: String] {
    let queryParameters: [String: String?] = [
        "state": socialLoginProvider.stateIdentifier,
        "client_id" : socialLoginProvider.clientID,
        "response_type" : socialLoginProvider.responseType,
        "redirect_uri" : socialLoginProvider.redirectUri,
        "scope": socialLoginProvider.authScopes,
        "code_challenge_method": socialLoginProvider.codeChallengeMethod,
        "code_challenge": socialLoginProvider.codeChallenge
    ]
    
    /// Remove nil values before creating URL Query Items
    let nonNilQueryParameters = queryParameters.compactMapValues { $0 }
    
    return nonNilQueryParameters
}

/// Provides query parameters to be used for the creation of URL which will be used to obtain access token.
/// - Parameters:
///   - socialLoginProvider: Social login provider whose authorization is being sought
///   - code: Authorization code obtained after user authorization
///   - codeChallenge: A unique string (code verifier) for PKCE (Proof Key for Code Exchange)
/// - Returns: Query parameters to be used for the creation of access token-related URL
func createQueryParametersForAccessToken(for socialLoginProvider: SocialLoginProvider, code: String, codeChallenge: String? = nil) -> [String: String] {
    let queryParameters: [String: String?] = [
        "client_id" : socialLoginProvider.clientID,
        "client_secret": socialLoginProvider.clientSecret,
        "grant_type": socialLoginProvider.grantType,
        "redirect_uri" : socialLoginProvider.redirectUri,
        "code" : code,
        "code_verifier": codeChallenge,
    ]
    
    /// Remove nil values before creating URL Query Items
    let nonNilQueryParameters = queryParameters.compactMapValues { $0 }
    return nonNilQueryParameters
}
