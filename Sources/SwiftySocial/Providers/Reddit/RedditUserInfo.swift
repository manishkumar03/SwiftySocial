//
//  RedditUserInfo.swift
//  
//
//  Created by Manish Kumar on 2023-03-12.
//

import Foundation

// MARK: - RedditUserInfo

/// Structure of the `user info` API response
struct RedditUserInfo: Codable {
    let verified: Bool
    let id: String
    let hasVerifiedEmail: Bool
    let iconImg: String
    let name: String
}
