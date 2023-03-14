//
//  GithubUserEmail.swift
//  
//
//  Created by Manish Kumar on 2023-03-11.
//

import Foundation

// MARK: - GithubUserEmail

/// Structure of the `user email` API response
struct GithubUserEmail: Codable {
    let email: String
    let primary: Bool
    let verified: Bool
    let visibility: String?
}
