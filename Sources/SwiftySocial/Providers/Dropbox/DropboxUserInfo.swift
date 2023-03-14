//
//  DropboxUserInfo.swift
//  
//
//  Created by Manish Kumar on 2023-03-12.
//

import Foundation

// MARK: - DropboxUserInfo

/// Structure of the `user info` API response
struct DropboxUserInfo: Codable {
    let accountId: String
    let country: String
    let disabled: Bool
    let email: String
    let emailVerified: Bool
    let locale: String
    let name: DropboxUserName
    let profilePhotoUrl: String?
}

// MARK: - Name
struct DropboxUserName: Codable {
    let abbreviatedName: String
    let displayName: String
    let familiarName: String
    let givenName: String
    let surname: String
}
