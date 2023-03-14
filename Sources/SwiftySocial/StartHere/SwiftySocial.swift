//
//  SwiftySocial.swift
//
//
//  Created by Manish Kumar on 2023-03-10.
//

import Foundation

public typealias UserCompletion = (Result<SwiftySocialUser, SwiftySocialError>) -> Void

/// Entry point for the SDK
/// 
public struct SwiftySocial {
    private var socialLoginProvider: SocialLoginProvider

    public init(for socialLoginProvider: SocialLoginProvider) {
        self.socialLoginProvider = socialLoginProvider
    }
    
    public func login(userCompletion: @escaping UserCompletion) {
        startOAuthLoginFlow(with: self.socialLoginProvider, userCompletion: userCompletion)
    }
}
