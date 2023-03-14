//
//  AdditionalUserInfo.swift
//  
//
//  Created by Manish Kumar on 2023-03-13.
//

import Foundation

/// Some of the providers (e.g. Github) do not provide the user's email ID as part of the `user info` API response. This kind of
/// provider-specific additional user info will be stored in this struct.
///
struct AdditionalUserInfo {
    let email: String?
}
