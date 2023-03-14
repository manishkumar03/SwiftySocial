//
//  File.swift
//  
//
//  Created by Manish Kumar on 2023-03-10.
//

import Foundation

class SSConfig {
    static let shared = SSConfig()
    
    lazy var infoDictionary: [String: Any] = {
        guard let plistPath = Bundle.main.path(forResource: "SwiftySocialInfo", ofType: "plist"), let plistDict = NSDictionary(contentsOfFile: plistPath) as? [String: AnyObject] else {
            fatalError("Plist file not found")
        }
        
        return plistDict
    }()
    
    // MARK: - Client IDs
    lazy var googleClientID: String = {
        guard let googleClientID = self.infoDictionary["GOOGLE_CLIENT_ID"] as? String else {
            fatalError("GOOGLE_CLIENT_ID missing from SwiftySocialInfo.plist")
        }
        
        return googleClientID
    }()
    
    lazy var facebookAppID: String = {
        guard let facebookAppID = self.infoDictionary["FACEBOOK_APP_ID"] as? String else {
            fatalError("FACEBOOK_APP_ID missing from SwiftySocialInfo.plist")
        }
        
        return facebookAppID
    }()
    
    lazy var githubClientID: String = {
        guard let githubClientID = self.infoDictionary["GITHUB_CLIENT_ID"] as? String else {
            fatalError("GITHUB_CLIENT_ID missing from SwiftySocialInfo.plist")
        }
        
        return githubClientID
    }()
    
    lazy var redditClientID: String = {
        guard let redditClientID = self.infoDictionary["REDDIT_CLIENT_ID"] as? String else {
            fatalError("REDDIT_CLIENT_ID missing from SwiftySocialInfo.plist")
        }
        
        return redditClientID
    }()
    
    lazy var dropboxClientID: String = {
        guard let dropboxClientID = self.infoDictionary["DROPBOX_CLIENT_ID"] as? String else {
            fatalError("DROPBOX_CLIENT_ID missing from SwiftySocialInfo.plist")
        }
        
        return dropboxClientID
    }()
    
    lazy var linkedinClientID: String = {
        guard let linkedinClientID = self.infoDictionary["LINKEDIN_CLIENT_ID"] as? String else {
            fatalError("LINKEDIN_CLIENT_ID missing from SwiftySocialInfo.plist")
        }
        
        return linkedinClientID
    }()
    
    lazy var microsoftClientID: String = {
        guard let microsoftClientID = self.infoDictionary["MICROSOFT_CLIENT_ID"] as? String else {
            fatalError("MICROSOFT_CLIENT_ID missing from SwiftySocialInfo.plist")
        }
        
        return microsoftClientID
    }()
    
    // MARK: - Client Secrets
    lazy var facebookClientSecret: String = {
        guard let facebookClientSecret = self.infoDictionary["FACEBOOK_APP_SECRET"] as? String else {
            fatalError("FACEBOOK_APP_SECRET missing from SwiftySocialInfo.plist")
        }
        
        return facebookClientSecret
    }()
    
    lazy var githubClientSecret: String = {
        guard let githubClientSecret = self.infoDictionary["GITHUB_CLIENT_SECRET"] as? String else {
            fatalError("GITHUB_CLIENT_SECRET missing from SwiftySocialInfo.plist")
        }
        
        return githubClientSecret
    }()
    
    
    lazy var dropboxClientSecret: String = {
        guard let dropboxClientSecret = self.infoDictionary["DROPBOX_CLIENT_SECRET"] as? String else {
            fatalError("DROPBOX_CLIENT_SECRET missing from SwiftySocialInfo.plist")
        }
        
        return dropboxClientSecret
    }()
    
    lazy var linkedinClientSecret: String = {
        guard let linkedinClientSecret = self.infoDictionary["LINKEDIN_CLIENT_SECRET"] as? String else {
            fatalError("LINKEDIN_CLIENT_SECRET missing from SwiftySocialInfo.plist")
        }
        
        return linkedinClientSecret
    }()
    
    // MARK: - Redirect URIs
    func getCallbackScheme(socialLoginProvider: SocialLoginProvider) -> String {
        switch socialLoginProvider {
            case .google:
                guard let googleCallbackScheme = self.infoDictionary["GOOGLE_CALLBACK_SCHEME"] as? String else {
                    fatalError("GOOGLE_CALLBACK_SCHEME not added in SwiftySocialInfo.plist")
                }
                
                return googleCallbackScheme
                
            case .facebook:
                return "fb\(facebookAppID)"
                
            case .github:
                guard let githubCallbackScheme = self.infoDictionary["GITHUB_CALLBACK_SCHEME"] as? String else {
                    fatalError("GITHUB_CALLBACK_SCHEME not added in SwiftySocialInfo.plist")
                }
                
                return githubCallbackScheme
                
            case .reddit:
                guard let redditCallbackScheme = self.infoDictionary["REDDIT_CALLBACK_SCHEME"] as? String else {
                    fatalError("REDDIT_CALLBACK_SCHEME not added in SwiftySocialInfo.plist")
                }
                
                return redditCallbackScheme
                
            case .dropbox:
                guard let dropboxCallbackScheme = self.infoDictionary["DROPBOX_CALLBACK_SCHEME"] as? String else {
                    fatalError("DROPBOX_CALLBACK_SCHEME not added in SwiftySocialInfo.plist")
                }
                
                return dropboxCallbackScheme
                
            case .linkedin:
                guard let linkedinCallbackScheme = self.infoDictionary["LINKEDIN_CALLBACK_SCHEME"] as? String else {
                    fatalError("LINKEDIN_CALLBACK_SCHEME not added in SwiftySocialInfo.plist")
                }
                
                return linkedinCallbackScheme
                
            case .microsoft:
                guard let microsoftCallbackScheme = self.infoDictionary["MICROSOFT_CALLBACK_SCHEME"] as? String else {
                    fatalError("MICROSOFT_CALLBACK_SCHEME not added in SwiftySocialInfo.plist")
                }
                
                return microsoftCallbackScheme
        }
    }
    
    func getOauthCallbackHost(socialLoginProvider: SocialLoginProvider) -> String {
        switch socialLoginProvider {
            case .google:
                guard let googleCallbackHost = self.infoDictionary["GOOGLE_CALLBACK_HOST"] as? String else {
                    fatalError("GOOGLE_CALLBACK_HOST not added in SwiftySocialInfo.plist")
                }
                
                return googleCallbackHost
                
            case .facebook:
                return "fb\(facebookAppID)"
                
            case .github:
                guard let githubCallbackHost = self.infoDictionary["GITHUB_CALLBACK_HOST"] as? String else {
                    fatalError("GITHUB_CALLBACK_HOST not added in SwiftySocialInfo.plist")
                }
                
                return githubCallbackHost
                
            case .reddit:
                guard let redditCallbackHost = self.infoDictionary["REDDIT_CALLBACK_HOST"] as? String else {
                    fatalError("REDDIT_CALLBACK_HOST not added in SwiftySocialInfo.plist")
                }
                
                return redditCallbackHost
                
            case .dropbox:
                guard let dropboxCallbackHost = self.infoDictionary["DROPBOX_CALLBACK_HOST"] as? String else {
                    fatalError("DROPBOX_CALLBACK_HOST not added in SwiftySocialInfo.plist")
                }
                
                return dropboxCallbackHost
                
            case .linkedin:
                guard let linkedinCallbackHost = self.infoDictionary["LINKEDIN_CALLBACK_HOST"] as? String else {
                    fatalError("LINKEDIN_CALLBACK_HOST not added in SwiftySocialInfo.plist")
                }
                
                return linkedinCallbackHost
                
            case .microsoft:
                guard let microsoftCallbackHost = self.infoDictionary["MICROSOFT_CALLBACK_HOST"] as? String else {
                    fatalError("MICROSOFT_CALLBACK_HOST not added in SwiftySocialInfo.plist")
                }
                
                return microsoftCallbackHost
        }
    }
}
