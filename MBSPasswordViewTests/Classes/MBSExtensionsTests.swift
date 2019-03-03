//
//  MBSExtensionsTests.swift
//  MBSPasswordViewTests
//
//  Created by Mayckon Barbosa da Silva on 3/3/19.
//  Copyright © 2019 Mayckon Barbosa da Silva. All rights reserved.
//

import XCTest
@testable import MBSPasswordView

class MBSExtensionsTests: XCTestCase {
    
    var mbsPasswordView: MBSPasswordView!
    var expectation: XCTestExpectation!
    
    private func loadView() -> MBSPasswordView {
        return MBSPasswordView()
    }
    
    override func setUp() {
        self.mbsPasswordView = loadView()
        self.mbsPasswordView.cleanPasswordUserDefaults()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mbsPasswordView.bodyView.delegate = nil
    }
    
    // MARK: - Test properties initialization and assignments
    func testCustomColors() {
        let flatDarkBlue = UIColor(red: 45/255.0, green: 62/255.0, blue: 82/255.0, alpha: 1.00)
        let flatRed = UIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1.00)
        
        XCTAssertEqual(UIColor.flatDarkBlue, flatDarkBlue)
        XCTAssertEqual(UIColor.flatRed, flatRed)
    }
    
    func testUserDefaultsExtension() {
        let key = "test"
        let value = "value"
        
        let userDefaults = UserDefaults()
        userDefaults.setValue(value, forKey: key)
        userDefaults.synchronize()
        
        XCTAssertEqual(userDefaults.value(forKey: key) as! String, value)
        
        userDefaults.removeObject(forKey: key)
        
        XCTAssertNil(userDefaults.value(forKey: key))
    }
    
    func testStart() {
        mbsPasswordView.start(enableBiometrics: false)
        // views enabled
        XCTAssertEqual(mbsPasswordView.topView.isUserInteractionEnabled, true)
        XCTAssertEqual(mbsPasswordView.bodyView.isUserInteractionEnabled, true)
        
        // biometric false
        XCTAssertEqual(mbsPasswordView.enableBiometricsAuthentication, false)
    }
}
