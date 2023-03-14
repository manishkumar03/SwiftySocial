//
//  SwiftySocialUser.swift
//  
//
//  Created by Manish Kumar on 2023-03-12.
//

import Foundation

/// Final user object to be returned to the calling app.
public struct SwiftySocialUser {
    public let userId: String
    public let userName: String
    public let email: String?
    public let accessToken: String
    public let refreshToken: String?
}
