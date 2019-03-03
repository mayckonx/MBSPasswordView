//
//  MBSPasswordViewTests.swift
//  MBSPasswordViewTests
//
//  Created by Mayckon Barbosa da Silva on 3/3/19.
//  Copyright © 2019 Mayckon Barbosa da Silva. All rights reserved.
//
import XCTest
@testable import MBSPasswordView

class MBSPasswordViewTests: XCTestCase {
    
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
    func testCommonInit() {
        // delegate is set
        XCTAssertNotNil(mbsPasswordView.bodyView.delegate)
        XCTAssertNotNil(mbsPasswordView.topView.delegate)
        
        // view is not nil
        XCTAssertNotNil(mbsPasswordView.view)
        
        // and views disabled
        XCTAssertEqual(mbsPasswordView.topView.isUserInteractionEnabled, false)
        XCTAssertEqual(mbsPasswordView.bodyView.isUserInteractionEnabled, false)
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
