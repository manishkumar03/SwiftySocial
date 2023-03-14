//
//  FacebookUserInfo.swift
//  
//
//  Created by Manish Kumar on 2023-03-13.
//

import Foundation

// MARK: - FacebookUserInfo

/// Structure of the `user info` API response
struct FacebookUserInfo: Codable {
    let id: String // unique user identifier of the user who signed in
    let name: String
    let firstName: String
    let lastName: String
    let profilePic: String
    let gender: String
}
