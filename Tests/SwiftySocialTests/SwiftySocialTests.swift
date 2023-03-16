import XCTest
@testable import SwiftySocial

final class SwiftySocialTests: XCTestCase {
    var infoDictionary: [String: Any] = [:]
    
    override func setUp() {
        guard let plistPath = Bundle.module.path(forResource: "SwiftySocialInfo", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: plistPath) as? [String: Any] else {
            fatalError("SwiftySocialInfo.plist file not found in test target")
        }
        
        self.infoDictionary = plistDict
    }
    
    func testgetQueryComponentValueFromURL() {
        let callbackUrl = URL(string: "swiftysocial://oauthcallback?code=dummyCode&state=B0AF9CC9-F6A2-40EF-8D70-88E14F34A0BC")
        let authCode = getQueryComponentValueFromURL(named: "code", in: callbackUrl)
        XCTAssertEqual(authCode, "dummyCode")
    }
    
    func testCreateUrlEncodedQueryString() {
        let queryParams: [String: String?] = [
            "code": "jlklj807234",
            "state": "B0AF9CC9-F6A2-40EF",
            "scope": "profile"
        ]
        
        let urlEncodedQueryString = createUrlEncodedQueryString(queryParams)
        XCTAssertEqual(urlEncodedQueryString, "code=jlklj807234&scope=profile&state=B0AF9CC9-F6A2-40EF")
    }
    
    func testCreateUrlEncodedQueryString_withParamsContainingSpaces() {
        let queryParams: [String: String?] = [
            "code": "jlklj807234",
            "state": "B0AF9CC9-F6A2-40EF",
            "scope": "profile email"
        ]
        
        let urlEncodedQueryString = createUrlEncodedQueryString(queryParams)
        XCTAssertEqual(urlEncodedQueryString, "code=jlklj807234&scope=profile%20email&state=B0AF9CC9-F6A2-40EF")
    }
    
    func testSSConfigValues_getGoogleClientID() {
        let sut = SSConfig(isUnderTesting: true, infoDictionary: self.infoDictionary)
        XCTAssertEqual(sut.googleClientID, "dummyGoogleClientID")        
    }
    
    func testSSConfigValues_getGoogleCallbackScheme() {
        let sut = SSConfig(isUnderTesting: true, infoDictionary: self.infoDictionary)
        XCTAssertEqual(sut.getCallbackScheme(socialLoginProvider: .google), "dummyGoogleCallbackScheme")
    }
    
    func testSSConfigValues_getFacebookCallbackHost() {
        let sut = SSConfig(isUnderTesting: true, infoDictionary: self.infoDictionary)
        XCTAssertEqual(sut.getOauthCallbackHost(socialLoginProvider: .facebook), "fbdummyFacebookAppID")
    }
}
