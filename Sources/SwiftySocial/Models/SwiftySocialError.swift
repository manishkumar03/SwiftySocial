//
//  SwiftySocialError.swift
//  
//
//  Created by Manish Kumar on 2023-03-14.
//

import Foundation

public enum SwiftySocialError: Error {
    /// The user cancelled the authorization process by closing the web browser window
    case userCancel
    
    /// The user declined to authorize by pressing the `decline` button
    case userDeclined
    
    /// Auth code missing in the authorization API response
    case missingCodeInResponse
    
    /// The `Data` object returned by access token response is nil
    case nilTokenResponseData
    
    ///The `Data` object returned by access token response could not be decoded
    case tokenResponseDataDecodingError
    
    /// The `Data` object returned by user info response is nil
    case nilUserInfoResponseData
    
    /// The `Data` object returned by user info response could not be decoded
    case userInfoResponseDataDecodingError
    
    /// Some required parameters were not provided.
    case invalidRequest
    
    public var description: String {
        switch self {
                
            case .userCancel:
                return "The user cancelled the authorization process by closing the web browser window"
                
            case .userDeclined:
                return "The user declined to authorize by pressing the decline button"
                
            case .missingCodeInResponse:
                return "Auth code missing in the authorization API response"
                
            case .nilTokenResponseData:
                return "The Data object returned by access token response is nil"
                
            case .tokenResponseDataDecodingError:
                return "The Data object returned by access token response could not be decoded"
                
            case .nilUserInfoResponseData:
                return "The Data object returned by user info response is nil"
                
            case .userInfoResponseDataDecodingError:
                return "The Data object returned by user info response could not be decoded"
                
            case .invalidRequest:
                return "Some required parameters were not provided."
        }
    }
}
