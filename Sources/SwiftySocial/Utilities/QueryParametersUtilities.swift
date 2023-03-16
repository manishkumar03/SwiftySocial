//
//  QueryParametersUtilities.swift
//  
//
//  Created by Manish Kumar on 2023-03-11.
//

import Foundation

/// Decodes the JWT returned by Google's `auth token` API response
/// - Parameter jwtString: JWT to be decoded
/// - Returns: Decoded JWT
func decodeGoogleJWTPayload(jwtString: String) -> GoogleJWTStruct? {
    let jwtComponents = jwtString.components(separatedBy: ".")
    var jwtPayload = jwtComponents[1]
    
    /// For a JWT Payload to be valid, its length has to be a multiple of 4. To fix it, pad it with required number of "=" characters.
    if jwtPayload.count % 4 != 0 {
        let padlen = 4 - jwtPayload.count % 4
        jwtPayload.append(contentsOf: repeatElement("=", count: padlen))
    }
    
    if let data = Data(base64Encoded: jwtPayload) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let jWTStruct = try? decoder.decode(GoogleJWTStruct.self, from: data)
        return jWTStruct
    }
    
    return nil
}

/// Extracts the value for query component `name` from the URL
/// - Parameters:
///   - name: The query component to be extracted
///   - url: The URL which contains the query components
/// - Returns: Value of the query component identified by `name`
func getQueryComponentValueFromURL(named name: String, in url: URL?) -> String? {
    guard let unwrappedUrl = url, let queryItems = URLComponents(url: unwrappedUrl, resolvingAgainstBaseURL: false)?.queryItems else {
        return nil
    }
    
    guard let value = queryItems.first(where: { $0.name == name })?.value else {
        return nil
    }
    
    return value
}

/// Creates URL-Encoded string from query parameters
/// - Parameter parts: Query parameters to be chained together
/// - Returns: URL-Encoded string
func createUrlEncodedQueryString(_ parts: [String: String?]) -> String? {
    let sortedParts = parts.sorted(by: { $0.0 < $1.0 })
    return sortedParts.compactMap { key, value -> String? in
        if let value = value {
            return key + "=" + value
        } else {
            return nil
        }
    }.joined(separator: "&").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
}

/// Generate a code verifier for PKCE (Proof Key for Code Exchange)
/// Ref: https://auth0.com/docs/get-started/authentication-and-authorization-flow/authorization-code-flow-with-proof-key-for-code-exchange-pkce
func createCodeVerifier() -> String {
    var buffer = [UInt8](repeating: 0, count: 32)
    _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
    let verifier = Data(buffer).base64EncodedString()
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
    
    return verifier
}
