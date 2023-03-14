//
//  GoogleUserInfo.swift
//  
//
//  Created by Manish Kumar on 2023-03-10.
//

import Foundation

// MARK: - GoogleUserInfo

/// Structure of the `user info` API response
struct GoogleUserInfo: Codable {
    let sub: String // unique user identifier of the user who signed in
    let name: String
    let givenName: String
    let familyName: String
    let picture: String
    let email: String
    let emailVerified: Bool
    let locale: String
}
