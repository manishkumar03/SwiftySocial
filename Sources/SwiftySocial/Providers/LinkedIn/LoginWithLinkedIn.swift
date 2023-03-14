//
//  LoginWithLinkedIn.swift
//  
//
//  Created by Manish Kumar on 2023-03-12.
//

import UIKit
import AuthenticationServices
import WebKit

/// LinkedIn does not allow custom URL schemes for `redirect_uri` unlike other providers. They only allow `https://` which means that our
/// app cannot get the callback once the user has authorized our app in the webview. To get around this limitation, we use a regular `WebKit`
/// webview instead of `ASWebAuthenticationSession` and become its delegate.
///
class LoginWithLinkedIn: NSObject {
    private let authWebView:WKWebView
    private let authViewController:UIViewController
    private var navigationController: UINavigationController
    var socialLoginProvider: SocialLoginProvider
    var userCompletion: UserCompletion
    
    init(with socialLoginProvider: SocialLoginProvider, userCompletion: @escaping UserCompletion) {
        self.socialLoginProvider = socialLoginProvider
        self.userCompletion = userCompletion
        
        self.authViewController = UIViewController(nibName: nil, bundle: nil)
        self.authViewController.view.frame = UIScreen.main.bounds
        self.authWebView = WKWebView(frame: self.authViewController.view.frame)
        self.navigationController = UINavigationController(rootViewController: self.authViewController)
        super.init()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        self.authViewController.navigationItem.leftBarButtonItem = cancelButton
        self.authWebView.navigationDelegate = self
        self.authViewController.view.addSubview(authWebView)
    }
    
    func login() {
        let queryParameters = createQueryParametersForUserConsent(for: socialLoginProvider)
        let consentUrl = socialLoginProvider.consentURL
        var urlComponents = URLComponents(url: consentUrl, resolvingAgainstBaseURL: false)!
        
        urlComponents.queryItems = queryParameters.map({ (key, value) in
            URLQueryItem(name: key, value: value)
        })
        
        let authRequest = URLRequest(url: urlComponents.url!)
        self.authWebView.load(authRequest)
        UIApplication.shared.windows
            .filter {$0.isKeyWindow}.first?
            .rootViewController?.present(self.navigationController, animated: true)
    }
    
    @objc func cancelAction() {
        self.navigationController.dismiss(animated: true)
        return self.userCompletion(.failure(.userCancel))
    }
}

extension LoginWithLinkedIn: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let callbackUrlString = navigationAction.request.url?.absoluteString {
            if callbackUrlString.hasPrefix(self.socialLoginProvider.redirectUri) {
                /// The `callbackUrl` has our `redirect_uri` as the prefix. If we are here, it means the user has either authorized
                /// our app or declined it.
                let callbackUrl = navigationAction.request.url
                
                /// If the user declines to authorize our app, some oauth servers send the error as a query component in the `callbackUrl`.
                if let errorQueryComponent = getQueryComponentValueFromURL(named: "error", in: callbackUrl) {
                    debugPrint("Authentication Error: ", errorQueryComponent)
                    decisionHandler(.cancel)
                    self.navigationController.dismiss(animated: true)
                    return self.userCompletion(.failure(.userDeclined))
                }
                
                /// If we are here, the user has authorized our app and the oauth code will (hopefully) be present as a
                /// query component named `code` in the `callbackUrl`.
                if let code = getQueryComponentValueFromURL(named: "code", in: callbackUrl) {
                    exchangeAuthCodeForAccessToken(code: code, with: self.socialLoginProvider, userCompletion: self.userCompletion)
                } else {
                    /// Something went wrong.
                    decisionHandler(.cancel)
                    self.navigationController.dismiss(animated: true)
                    return self.userCompletion(.failure(.missingCodeInResponse))
                }
                
                /// We are done here. No need to load this URL as it's just our callback scheme.
                decisionHandler(.cancel)
                self.navigationController.dismiss(animated: true)
                return
            }
        }
        
        /// The URL being redirected to is not our callback scheme. Let it pass through.
        decisionHandler(.allow)
    }
}
