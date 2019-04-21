//
//  MBSPasswordViewTests.swift
//  MBSPasswordViewTests
//
//  Created by Mayckon Barbosa da Silva on 3/3/19.
//  Copyright © 2019 Mayckon Barbosa da Silva. All rights reserved.
//
import XCTest
import LocalAuthentication
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
        
        let userDefaults = UserDefaults()
        userDefaults.removeObject(forKey: "\(MBSAttempts.quantity)")
        userDefaults.synchronize()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mbsPasswordView.bodyView.delegate = nil
    }
    
    func testInitWithFrame() {
        let view = MBSPasswordView(frame: .zero)
        
        XCTAssertNotNil(view.bodyView.delegate)
        XCTAssertNotNil(view.topView.delegate)
        
        // view is not nil
        XCTAssertNotNil(view.view)
        
        // and views disabled
        XCTAssertEqual(view.topView.isUserInteractionEnabled, false)
        XCTAssertEqual(view.bodyView.isUserInteractionEnabled, false)
    }
    
    func testIsLimitAttemptsOutOne() {
        XCTAssertEqual(self.mbsPasswordView.isLimitAttemptsOut(), false)
    }
    
    func testIsLimitAttemptsOutThree() {
        _ = self.mbsPasswordView.isLimitAttemptsOut()
        _ = self.mbsPasswordView.isLimitAttemptsOut()
        XCTAssertEqual(self.mbsPasswordView.isLimitAttemptsOut(), true)
    }
    
    func testChangeExistingPassword() {
        mbsPasswordView.changeExistingPassword()
        XCTAssertEqual(self.mbsPasswordView.topView.changeExistingPassword, true)
    }
    
    func testDeviceBiometricsKind() {
       let kind = MBSPasswordView.deviceBiometricsKind()
       let biometricsOfDevice = LAContext().biometryType
        switch biometricsOfDevice {
        case .faceID:
            XCTAssertEqual(kind, .faceID)
        case .touchID:
            XCTAssertEqual(kind, .touchID)
        case .none:
            XCTAssertEqual(kind, .none)
        }
    }
    
    func testShakeView() {
        let kind = MBSPasswordView.deviceBiometricsKind()
        let biometricsOfDevice = LAContext().biometryType
        switch biometricsOfDevice {
        case .faceID:
            XCTAssertEqual(kind, .faceID)
        case .touchID:
            XCTAssertEqual(kind, .touchID)
        case .none:
            XCTAssertEqual(kind, .none)
        }
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
