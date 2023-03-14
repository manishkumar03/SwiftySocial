//
//  GoogleJWTStruct.swift
//  
//
//  Created by Manish Kumar on 2023-03-11.
//

import Foundation

// MARK: - JWTStruct

/// Structure of the JWT returned by Google.
/// Use function `decodeGoogleJWTPayload(jwtString: String) -> GoogleJWTStruct?` to decode it.
struct GoogleJWTStruct: Codable {
    let iss: String
    let azp: String
    let aud: String
    let sub: String
    let email: String
    let emailVerified: Bool
    let atHash: String
    let name: String
    let picture: String
    let givenName: String
    let familyName: String
    let locale: String
    let iat: Int
    let exp: Int
}
