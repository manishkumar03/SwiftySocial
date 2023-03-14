# SwiftySocial


<h3 align="center">
  <img src="https://github.com/manishkumar03/SwiftySocial/blob/main/Resources/SwiftySocial_AppIcon.jpg" width="224px"/><br/>
  An OAuth library for iOS
</h3>

## Overview
SwiftySocial is a tiny library for adding support for social login buttons to your app (like `Login with Google` etc). If you are tired of the data-snooping and bloatware SDKs provided by Firebase and Facebook etc, this library is for you. It does not collect any analytical data and does not track you in any way.

Since OAuth is an open standard, we can provide support for these OAuth providers without using their SDKs.

 
<p align="center">
  <a href="#usage">Usage</a> • <a href="#providers">Providers</a> •  <a href="#sample-app">Sample App</a> • <a href="#installation">Installation</a> • <a href="#license">License</a>
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


## License

Copyright (c) 2023 Manish Kumar (manish.bansal@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
