# SwiftySocial


<h3 align="center">
  <img src="https://github.com/manishkumar03/SwiftySocial/blob/main/Resources/SwiftySocial_AppIcon.jpg" width="224px"/><br/>
  An OAuth library for iOS
</h3>

## Overview
SwiftySocial is a tiny library for adding support for social login buttons to your app (like `Login with Google` etc). If you are tired of the data-snooping and bloatware SDKs provided by Firebase and Facebook etc, this library is for you. It does not collect any analytical data and does not track you in any way.

Since OAuth is an open standard, we can provide support for these OAuth providers without using their SDKs.

 
<p align="center">
  <a href="#usage">Usage</a> • <a href="#providers">Providers</a> •  <a href="#sample-app">Sample App</a> • <a href="#installation">Installation</a> • <a href="#other-projects">Other Projects</a> • <a href="#license">License</a>
</p>

## Usage

##### Step 1: Add login provider credentials

Add the file `SwiftySocialInfo.plist` to your app and fill in the credentials for the login provider you want to support. For example, if you want to add support for `Login with Google`, provide the following values. Do not change the key names.

```xml
<!-- ******* Google ******* -->
<key>GOOGLE_CLIENT_ID</key>
<string>your client id</string>
<key>GOOGLE_CALLBACK_SCHEME</key>
<string>your callback scheme</string>
<key>GOOGLE_CALLBACK_HOST</key>
<string>your callback host</string>
```

##### Step 2: Ask for authorization 

After importing the library, add the following code snippet in your button click handler. The returned `user` object will contain the `access_token` and other information. Please see `SwiftySocialUser.swift` for details.

```swift
import SwiftySocial

SwiftySocial(for: .google).login { result in
    switch result {
        case .success(let user):
            print(user.accessToken)
        case .failure(let error):
            print(error.description)
    }
}
```

The final response object `SwiftySocialUser` has the following fields:

```swift
public struct SwiftySocialUser {
    public let userId: String
    public let userName: String
    public let email: String?
    public let accessToken: String
    public let refreshToken: String?
}
```

## Providers
The SDK supports the following providers. More providers will be added over time.

- Google
- Github
- Reddit
- Dropbox
- LinkedIn
- Microsoft
- *More to come...*

## Sample App
The accompanying demo app `SwiftySocialDemo` implements a few of these providers.

<p align="center">
<img src="https://github.com/manishkumar03/SwiftySocial/blob/main/Resources/SwiftySocial_DemoApp_Screenshot.png" width="300px"/><br/>
</p>

## Other Projects
Some of these libraries have been around for a long time and have been battle-tested.

- [Heimdallr.swift](https://github.com/trivago/Heimdallr.swift) - Easy to use OAuth 2 library for iOS, written in Swift.
- [InstagramSimpleOAuth](https://github.com/rbaumbach/InstagramSimpleOAuth) - A quick and simple way to authenticate an Instagram user in your iPhone or iPad app.
- [LinkedInSignIn](https://github.com/serhii-londar/LinkedInSignIn) - Simple view controller to login and retrieve access token from LinkedIn.
- [OAuthSwift](https://github.com/OAuthSwift/OAuthSwift) - Swift based OAuth library for iOS.
- [OAuth2](https://github.com/p2/OAuth2) - OAuth2 framework for macOS and iOS, written in Swift.
- [ReCaptcha](https://github.com/fjcaetano/ReCaptcha) - (In)visible ReCaptcha for iOS.
- [SwiftyOAuth](https://github.com/delba/SwiftyOAuth) - A simple OAuth library for iOS with a built-in set of providers.

## License

Copyright (c) 2023 Manish Kumar (manish.bansal@gmail.com)

The detailed license text can be seen [here](https://github.com/manishkumar03/SwiftySocial/blob/main/LICENSE.md).

