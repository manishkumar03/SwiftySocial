//
//  File.swift
//  
//
//  Created by Manish Kumar on 2023-03-12.
//

import Foundation

// MARK: - MicrosoftUserInfo

/// Structure of the `user info` API response
struct MicrosoftUserInfo: Codable {
    let sub: String // unique user identifier of the user who signed in
    let givenname: String
    let familyname: String
    let email: String
    let picture: String
    
    var name: String {
        return "\(givenname) \(familyname)"
    }
}
