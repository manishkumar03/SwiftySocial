//
//  LinkedInUserInfo.swift
//  
//
//  Created by Manish Kumar on 2023-03-12.
//

import Foundation

// MARK: - LinkedInUserInfo

/// Structure of the `user info` API response
struct LinkedInUserInfo: Codable {
    let sub: String // unique user identifier of the user who signed in
    let emailVerified: Bool
    let name: String
    let locale: Locale
    let givenName: String
    let familyName: String
    let email: String
}

// MARK: - Locale
struct Locale: Codable {
    let country: String
    let language: String
}
