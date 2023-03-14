//
//  File.swift
//  
//
//  Created by Manish Kumar on 2023-03-11.
//

import UIKit
import AuthenticationServices

/// Used by `ASWebAuthenticationSession` to display the webview
extension UIViewController: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
