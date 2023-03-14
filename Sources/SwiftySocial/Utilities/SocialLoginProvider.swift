//
//  SocialLoginProvider.swift
//  
//
//  Created by Manish Kumar on 2023-03-12.
//

import Foundation

/// Provides all the parameters required for the auth flow.
public enum SocialLoginProvider: String {
    case google
    case facebook
    case github
    case reddit
    case dropbox
    case linkedin
    case microsoft
    
    var authCallback: String {
        SSConfig.shared.getOauthCallbackHost(socialLoginProvider: self)
    }
    
    var stateIdentifier: String? {
        switch self {
            case .facebook, .github, .reddit, .linkedin, .microsoft:
                return UUID().uuidString
            default:
                return nil
        }
    }
    
    var codeChallenge: String? {
        switch self {
            case .dropbox:
                return createCodeVerifier()
            default:
                return nil
        }
    }
    
    var codeChallengeMethod: String? {
        switch self {
            case .dropbox:
                return "plain"
            default:
                return nil
        }
    }
    
    var callbackScheme: String {
        SSConfig.shared.getCallbackScheme(socialLoginProvider: self)
    }
    
    var redirectUri: String {
        switch self {
            case .google:
                return "\(self.callbackScheme):/\(self.authCallback)" // Note: Single forward slash
            default:
                return "\(self.callbackScheme)://\(self.authCallback)"
        }
    }
    
    var clientID: String {
        switch self {
            case .google:
                return SSConfig.shared.googleClientID
            case .facebook:
                return SSConfig.shared.facebookAppID
            case .github:
                return SSConfig.shared.githubClientID
            case .reddit:
                return SSConfig.shared.redditClientID
            case .dropbox:
                return SSConfig.shared.dropboxClientID
            case .linkedin:
                return SSConfig.shared.linkedinClientID
            case .microsoft:
                return SSConfig.shared.microsoftClientID
        }
    }
    
    var clientSecret: String? {
        switch self {
            case .facebook:
                return SSConfig.shared.facebookClientSecret
            case .github:
                return SSConfig.shared.githubClientSecret
            case .linkedin:
                return SSConfig.shared.linkedinClientSecret
            default:
                return nil
        }
    }
    
    var responseType: String? {
        switch self {
            case .google:
                return OAuthConstants.responseTypeCodeKey
            case .facebook:
                return OAuthConstants.responseTypeCodeKey
            case .github:
                return nil
            case .reddit:
                return OAuthConstants.responseTypeCodeKey
            case .dropbox:
                return OAuthConstants.responseTypeCodeKey
            case .linkedin:
                return OAuthConstants.responseTypeCodeKey
            case .microsoft:
                return OAuthConstants.responseTypeCodeKey
        }
    }
    
    var authScopes: String? {
        switch self {
            case .google:
                return "email profile"
            case .facebook:
                return "public_profile email"
            case .github:
                return "user"
            case .reddit:
                return "identity"
            case .dropbox:
                return "account_info.read"
            case .linkedin:
                return "openid profile email"
            case .microsoft:
                return "openid profile email"
        }
    }
    
    var grantType: String? {
        switch self {
            case .google:
                return OAuthConstants.authorizationCodeKey
            case .reddit:
                return OAuthConstants.authorizationCodeKey
            case .dropbox:
                return OAuthConstants.authorizationCodeKey
            case .linkedin:
                return OAuthConstants.authorizationCodeKey
            case .microsoft:
                return OAuthConstants.authorizationCodeKey
            default:
                return nil
        }
    }
    
    // MARK: - URLs
    var consentURL: URL {
        switch self {
            case .google:
                return URL(string: "https://accounts.google.com/o/oauth2/v2/auth")!
            case .facebook:
                return URL(string: "https://www.facebook.com/v16.0/dialog/oauth")!
            case .github:
                return URL(string: "https://github.com/login/oauth/authorize")!
            case .reddit:
                return URL(string: "https://old.reddit.com/api/v1/authorize.compact")!
            case .dropbox:
                return URL(string: "https://www.dropbox.com/oauth2/authorize")!
            case .linkedin:
                return URL(string: "https://www.linkedin.com/oauth/v2/authorization")!
            case .microsoft:
                return URL(string: "https://login.microsoftonline.com/consumers/oauth2/v2.0/authorize")!
        }
    }
    
    var accessTokenURL: URL {
        switch self {
            case .google:
                return URL(string: "https://www.googleapis.com/oauth2/v4/token")!
            case .facebook:
                return URL(string: "https://graph.facebook.com/v16.0/oauth/access_token")!
            case .github:
                return URL(string: "https://github.com/login/oauth/access_token")!
            case .reddit:
                return URL(string: "https://www.reddit.com/api/v1/access_token")!
            case .dropbox:
                return URL(string: "https://api.dropboxapi.com/oauth2/token")!
            case .linkedin:
                return URL(string: "https://www.linkedin.com/oauth/v2/accessToken")!
            case .microsoft:
                return URL(string: "https://login.microsoftonline.com/consumers/oauth2/v2.0/token")!
        }
    }
    
    var userInfoURL: URL {
        switch self {
            case .google:
                return URL(string: "https://www.googleapis.com/oauth2/v3/userinfo")!
            case .facebook:
                return OAuthConstants.dummyURL
            case .github:
                return URL(string: "https://api.github.com/user")!
            case .reddit:
                return URL(string: "https://oauth.reddit.com/api/v1/me")!
            case .dropbox:
                return URL(string: "https://api.dropboxapi.com/2/users/get_current_account")!
            case .linkedin:
                return URL(string: "https://api.linkedin.com/v2/userinfo")!
            case .microsoft:
                return URL(string: "https://graph.microsoft.com/oidc/userinfo")!
        }
    }
    
    var userEmailURL: URL {
        switch self {
            case .github:
                return URL(string: "https://api.github.com/user/emails")!
            default:
                return OAuthConstants.dummyURL
        }
    }
}
