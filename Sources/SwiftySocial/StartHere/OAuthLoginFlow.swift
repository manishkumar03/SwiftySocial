//
//  File.swift
//  
//
//  Created by Manish Kumar on 2023-03-10.
//

import UIKit
import AuthenticationServices

var loginWithLinkedIn: LoginWithLinkedIn?

/// Starts the OAuth flow
/// - Parameters:
///   - socialLoginProvider: Social login provider whose authorization is being sought
///   - userCompletion: Completion handler containing the `SwiftySocialUser`
func startOAuthLoginFlow(with socialLoginProvider: SocialLoginProvider, userCompletion: @escaping UserCompletion) {
    switch socialLoginProvider {
        case .linkedin:
            loginWithLinkedIn = LoginWithLinkedIn(with: socialLoginProvider, userCompletion: userCompletion)
            loginWithLinkedIn?.login()
        default:
            obtainUserConsent(for: socialLoginProvider, userCompletion: userCompletion)
    }
}

// MARK: - Obtain user consent

/// Displays the consent screen to the user requesting them to authorize the request
/// - Parameters:
///   - socialLoginProvider: Social login provider whose authorization is being sought
///   - userCompletion: Completion handler containing the `SwiftySocialUser`
func obtainUserConsent(for socialLoginProvider: SocialLoginProvider, userCompletion: @escaping UserCompletion) {
    let vc = UIViewController()
    let queryParameters = createQueryParametersForUserConsent(for: socialLoginProvider)
    
    let consentUrl = socialLoginProvider.consentURL
    var urlComponents = URLComponents(url: consentUrl, resolvingAgainstBaseURL: false)!
    
    urlComponents.queryItems = queryParameters.map { key, value in
        return URLQueryItem(name: key, value: value)
    }
    
    let authSession = ASWebAuthenticationSession(url: urlComponents.url!,
                                                 callbackURLScheme: socialLoginProvider.callbackScheme) {(callbackUrl, authError) in
        guard authError == nil else {
            /// The user cancelled the authorization process by closing the web browser window.
            debugPrint("Authentication Error: ", authError.debugDescription)
            return userCompletion(.failure(.userCancel))
        }
        
        /// If the user declines to authorize our app, some oauth servers send `authError` as `nil` but send the error as
        /// a query component in the `callbackUrl`.
        if let errorQueryComponent = getQueryComponentValueFromURL(named: "error", in: callbackUrl) {
            debugPrint("Authentication Error: ", errorQueryComponent)
            return userCompletion(.failure(.userDeclined))
        }
        
        /// If we are here, the oauth code will (hopefully) be present as a query component named `code` in the `callbackUrl`.
        if let code = getQueryComponentValueFromURL(named: "code", in: callbackUrl) {
            let codeChallenge = queryParameters["code_challenge"] // Required only for Dropbox
            exchangeAuthCodeForAccessToken(code: code, with: socialLoginProvider, codeChallenge: codeChallenge, userCompletion: userCompletion)
        } else {
            debugPrint("Authentication Error: code not found in the callback query parameters")
            return userCompletion(.failure(.missingCodeInResponse))
        }
    }
    
    authSession.presentationContextProvider = vc
    authSession.start()
}

// MARK: - Obtain access token

/// Exchange the auth code obtained after user authorization for an access token
/// - Parameters:
///   - code: Authorization code obtained after user authorization
///   - socialLoginProvider: Social login provider whose authorization is being sought
///   - userCompletion: Completion handler containing the `SwiftySocialUser`
///   - codeChallenge: A unique string (code verifier) for PKCE (Proof Key for Code Exchange)
func exchangeAuthCodeForAccessToken(code: String, with socialLoginProvider: SocialLoginProvider, codeChallenge: String? = nil, userCompletion: @escaping UserCompletion) {
    let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    let url = socialLoginProvider.accessTokenURL
    
    let requestParams = createQueryParametersForAccessToken(for: socialLoginProvider, code: code, codeChallenge: codeChallenge)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    switch socialLoginProvider {
        case .reddit:
            let blankString = ""
            let userPassword = "\(socialLoginProvider.clientID):\(blankString)"
            let userPasswordBase64 = userPassword.data(using: .utf8)!.base64EncodedString()
            request.addValue("Basic \(userPasswordBase64)", forHTTPHeaderField: "Authorization")
        default:
            break
    }
    
    request.httpBody = createUrlEncodedQueryString(requestParams)?.data(using: String.Encoding.utf8)
    
    let task = session.dataTask(with: request) { (data, response, error) -> Void in
        guard let data = data else {
            debugPrint("Authentication Error: No access token data returned")
            return userCompletion(.failure(.nilTokenResponseData))
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let tokenResponse = try decoder.decode(CommonOAuthTokenResponse.self, from: data)
            debugPrint("tokenResponse: ", tokenResponse)
            getUserInfo(tokenResponse: tokenResponse, with: socialLoginProvider, userCompletion: userCompletion)
        } catch (let error) {
            debugPrint(error)
            return userCompletion(.failure(.tokenResponseDataDecodingError))
        }
    }
    
    task.resume()
}

// MARK: - Fetch user info

/// Sends the access token to `user info` API for obtaining the user profile info
/// - Parameters:
///   - tokenResponse: Access token response obtained upon exchange of auth code
///   - socialLoginProvider: Social login provider whose authorization is being sought
///   - userCompletion: Completion handler containing the `SwiftySocialUser`
func getUserInfo(tokenResponse: CommonOAuthTokenResponse, with socialLoginProvider: SocialLoginProvider, userCompletion: @escaping UserCompletion) {
    let url = socialLoginProvider.userInfoURL
    var urlRequest = URLRequest(url: url)
    
    switch socialLoginProvider {
        case .dropbox:
            urlRequest.httpMethod = "POST"  // Why Dropbox, why?
        default:
            urlRequest.httpMethod = "GET"
    }
    
    urlRequest.addValue("Bearer \(tokenResponse.accessToken)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) -> Void in
        guard let data = data else {
            debugPrint("Authentication Error: No user info data returned")
            return userCompletion(.failure(.nilUserInfoResponseData))
        }
        
        switch socialLoginProvider {
            case .github:
                /// Github does not provide the user's email ID as part of the `user info` API response. Need to make an additonal call.
                getUserEmail(accessToken: tokenResponse.accessToken, with: socialLoginProvider) { userEmail in
                    let additionalUserInfo = AdditionalUserInfo(email: userEmail)
                    parseUserData(for: socialLoginProvider, data: data, tokenResponse: tokenResponse, additionalUserInfo: additionalUserInfo, userCompletion: userCompletion)
                }
                
            default:
                parseUserData(for: socialLoginProvider, data: data, tokenResponse: tokenResponse, additionalUserInfo: nil, userCompletion: userCompletion)
        }
    }
    
    task.resume()
}

// MARK: - Fetch additional user info

/// Sends the access token to `user info` API for obtaining the user's email ID
/// - Parameters:
///   - accessToken: Access token obtained upon exchange of auth code
///   - socialLoginProvider: Social login provider whose authorization is being sought
///   - emailCompletion: Completion handler containing the user's email ID
func getUserEmail(accessToken: String, with socialLoginProvider: SocialLoginProvider, emailCompletion: @escaping (String?) -> Void) {
    let url = socialLoginProvider.userEmailURL
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) -> Void in
        guard let data = data else {
            debugPrint("Authentication Error: No user email data returned")
            return emailCompletion(nil)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let githubUserEmails = try decoder.decode([GithubUserEmail].self, from: data)
            debugPrint("githubUserEmails: ", githubUserEmails)
            if let primaryEmail = githubUserEmails.first(where: { emailElement in emailElement.primary == true })?.email {
                debugPrint(primaryEmail)
                emailCompletion(primaryEmail)
            }
        } catch (let error) {
            debugPrint(error)
            emailCompletion(nil)
        }
    }
    
    task.resume()
}

// MARK: - Combine all the information and send it to the caller

/// Combines all the pieces and creates the final struct to be sent back to the caller.
/// - Parameters:
///   - socialLoginProvider: Social login provider whose authorization is being sought
///   - data: Data object containing user info. Will be decoded here using provider-specific structs.
///   - tokenResponse: Access token response obtained upon exchange of auth code
///   - additionalUserInfo: `AdditionalUserInfo` Struct containing additonal user info
///   - userCompletion: Completion handler containing the `SwiftySocialUser`
func parseUserData(for socialLoginProvider: SocialLoginProvider, data: Data, tokenResponse: CommonOAuthTokenResponse, additionalUserInfo: AdditionalUserInfo? = nil, userCompletion: @escaping UserCompletion) {
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        switch socialLoginProvider {
            case .google:
                let userInfo = try decoder.decode(GoogleUserInfo.self, from: data)
                let swiftySocialUser = SwiftySocialUser(userId: userInfo.sub, userName: userInfo.name, email: userInfo.email, accessToken: tokenResponse.accessToken, refreshToken: tokenResponse.refreshToken)
                debugPrint("SwiftySocialUser: ", swiftySocialUser)
                userCompletion(.success(swiftySocialUser))
            case .facebook:
                break
            case .github:
                let userInfo = try decoder.decode(GithubUserInfo.self, from: data)
                let swiftySocialUser = SwiftySocialUser(userId: userInfo.nodeId, userName: userInfo.name, email: additionalUserInfo?.email, accessToken: tokenResponse.accessToken, refreshToken: tokenResponse.refreshToken)
                debugPrint("SwiftySocialUser: ", swiftySocialUser)
                userCompletion(.success(swiftySocialUser))
            case .reddit:
                let userInfo = try decoder.decode(RedditUserInfo.self, from: data)
                let swiftySocialUser = SwiftySocialUser(userId: userInfo.id, userName: userInfo.name, email: nil, accessToken: tokenResponse.accessToken, refreshToken: tokenResponse.refreshToken)
                debugPrint("SwiftySocialUser: ", swiftySocialUser)
                userCompletion(.success(swiftySocialUser))
            case .dropbox:
                let userInfo = try decoder.decode(DropboxUserInfo.self, from: data)
                let swiftySocialUser = SwiftySocialUser(userId: userInfo.accountId, userName: userInfo.name.displayName, email: userInfo.email, accessToken: tokenResponse.accessToken, refreshToken: tokenResponse.refreshToken)
                debugPrint("SwiftySocialUser: ", swiftySocialUser)
                userCompletion(.success(swiftySocialUser))
            case .linkedin:
                let userInfo = try decoder.decode(LinkedInUserInfo.self, from: data)
                let swiftySocialUser = SwiftySocialUser(userId: userInfo.sub, userName: userInfo.name, email: userInfo.email, accessToken: tokenResponse.accessToken, refreshToken: tokenResponse.refreshToken)
                debugPrint("SwiftySocialUser: ", swiftySocialUser)
                userCompletion(.success(swiftySocialUser))
            case .microsoft:
                let userInfo = try decoder.decode(MicrosoftUserInfo.self, from: data)
                let swiftySocialUser = SwiftySocialUser(userId: userInfo.sub, userName: userInfo.name, email: userInfo.email, accessToken: tokenResponse.accessToken, refreshToken: tokenResponse.refreshToken)
                debugPrint("SwiftySocialUser: ", swiftySocialUser)
                userCompletion(.success(swiftySocialUser))
        }
    } catch (let error) {
        debugPrint(error)
        userCompletion(.failure(.userInfoResponseDataDecodingError))
    }
}
