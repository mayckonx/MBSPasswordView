//
//  MBSTopPasswordViewTests.swift
//  TESTETests
//
//  Created by Mayckon Barbosa da Silva on 11/6/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import XCTest
@testable import MBSPasswordView

class MBSTopPasswordViewTests: XCTestCase {
    
    var mbsPasswordView: MBSPasswordView!
    
    private func loadView() -> MBSPasswordView {
         return MBSPasswordView()
    }
    
    override func setUp() {
        self.mbsPasswordView = loadView()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mbsPasswordView.topView.delegate = nil
    }
    
    // MARK: - Test properties initialization and assignments
    func testInitialization() {
        XCTAssertNotNil(mbsPasswordView.view, "Must not be nil")
        XCTAssertNotNil(mbsPasswordView.topView, "Must not be nil")
    }
    
    func testPropertiesAssignments() {
        let topView = mbsPasswordView.topView!
        let font = UIFont(name: "Helvetica", size: 32)
        topView.passwordAnimation = .bottomToTop
        topView.dotColor = .red
        topView.errorBackgroundColor = .blue
        topView.labelColor = .green
        topView.font = font
        XCTAssertEqual(topView.passwordAnimation, .bottomToTop)
        XCTAssertEqual(topView.dotColor, .red)
        XCTAssertEqual(topView.errorBackgroundColor, .blue)
        XCTAssertEqual(topView.labelColor, .green)
        XCTAssertEqual(topView.font, font)
    }
    
    // MARK: - Delegate method tests
    func testInsert() {
        let topView = mbsPasswordView.topView!
        topView.insert("1")
        topView.insert("2")
        topView.insert("3")
        topView.insert("4")
        XCTAssertEqual(topView.passwordValues, ["1","2","3","4"])
        XCTAssertEqual(topView.passwordViews.count, 4)
    }
    
    func testInsertMoreThanFourElements() {
        let topView = mbsPasswordView.topView!
        topView.insert("1")
        topView.insert("2")
        topView.insert("3")
        topView.insert("4")
        // must not accept
        topView.insert("5")
        XCTAssertEqual(topView.passwordValues, ["1","2","3","4"])
        XCTAssertEqual(topView.passwordViews.count, 4)
    }
    
    func testRemoveLast() {
        let topView = mbsPasswordView.topView!
        topView.insert("1")
        topView.insert("2")
        topView.insert("3")
        topView.insert("4")
        // remove the last
        topView.removeLast()
        XCTAssertEqual(topView.passwordValues, ["1","2","3"])
        XCTAssertEqual(topView.passwordViews.count, 3)
    }
    
    func testRemoveLastWithinZeroElements() {
        let topView = mbsPasswordView.topView!
        // remove the last
        topView.removeLast()
        XCTAssertEqual(topView.passwordValues,[])
        XCTAssertEqual(topView.passwordViews.count, 0)
    }
    
    // MARK: - Confirmation Mode
    func testConfirmationValues() {
        let topView = mbsPasswordView.topView!
        let delayExpectation = expectation(description: "Delegate method invalidMatch not called")
        // must be called 1 time
        delayExpectation.expectedFulfillmentCount = 1
        insertMatchPasswords(delayExpectation)
        // wait for animation ends
        waitForExpectations(timeout: 1.1)
        
        XCTAssertEqual(topView.passwordValues, ["1","2","3","4"])
        XCTAssertEqual(topView.confirmationValues, ["1","2","3","4"])
        XCTAssertEqual(topView.passwordViews.count, 4)
    }
    
    // MARK: - Shakable
    func testIsShakable() {
        mbsPasswordView.isShakable = false
        XCTAssertEqual(mbsPasswordView.isShakable, false)
        mbsPasswordView.isShakable = true
        XCTAssertEqual(mbsPasswordView.isShakable, true)
    }
    
    // MARK: Delegate call tests
    func testInvalidMatchCall() {
        let mockDelegate = MockTopPasswordDelegate()
        mbsPasswordView.topView.delegate = mockDelegate
        let delayExpectation = expectation(description: "Delegate method invalidMatch not called")
        // must be called 1 time
        delayExpectation.expectedFulfillmentCount = 1
        
        insertInvalidMatchPasswords()
        
        mockDelegate.didCallInvalidMatch = {
            delayExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.1)
    }
    
    func testPasswordCall() {
        let mockDelegate = MockTopPasswordDelegate()
        mbsPasswordView.topView.delegate = mockDelegate
        let delayExpectation = expectation(description: "Delegate method invalidMatch not called")
        // must be called 1 time
        delayExpectation.expectedFulfillmentCount = 1
        
        insertMatchPasswords()
        
        mockDelegate.didCallPassword = { password in
            XCTAssertEqual(password.count, 4)
            XCTAssertEqual(password, ["1", "2", "3", "4"])
            delayExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.1)
    }
    
    func testDelegateInvalidScenearios() {
        let mockDelegate = MockTopPasswordDelegate()
        mbsPasswordView.topView.delegate = mockDelegate
        let delayExpectation = expectation(description: "Delegate method invalidMatch not called")
        // must be called 1 time
        delayExpectation.expectedFulfillmentCount = 1
        
        insertInvalidScenario(delayExpectation)
        
        mockDelegate.didCallPassword = { password in
            // mustn't be called
            XCTFail("Mustn't be called")
        }
        mockDelegate.didCallInvalidMatch = {
            XCTFail("Mustn't be called")
        }
        waitForExpectations(timeout: 1.1)
    }
}

// MARK: - HELPERS
extension MBSTopPasswordViewTests {
    private func insertMatchPasswords(_ delayExpectation: XCTestExpectation? = nil) {
        self.mbsPasswordView.topView.insert("1")
        self.mbsPasswordView.topView.insert("2")
        self.mbsPasswordView.topView.insert("3")
        self.mbsPasswordView.topView.insert("4")
        // we add this async because an animation runs to switch to confirmation mode after insert the first four values
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.mbsPasswordView.topView.insert("1")
            self.mbsPasswordView.topView.insert("2")
            self.mbsPasswordView.topView.insert("3")
            self.mbsPasswordView.topView.insert("4")
            
            if let expectation = delayExpectation {
                expectation.fulfill()
            }
        }
    }
    
    private func insertInvalidMatchPasswords() {
        self.mbsPasswordView.topView.insert("1")
        self.mbsPasswordView.topView.insert("2")
        self.mbsPasswordView.topView.insert("3")
        self.mbsPasswordView.topView.insert("5")
        // we add this async because an animation runs to switch to confirmation mode after insert the first four values
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.mbsPasswordView.topView.insert("1")
            self.mbsPasswordView.topView.insert("2")
            self.mbsPasswordView.topView.insert("3")
            self.mbsPasswordView.topView.insert("4")
        }
    }
    
    private func insertInvalidScenario(_ delayExpectation: XCTestExpectation) {
        self.mbsPasswordView.topView.insert("1")
        self.mbsPasswordView.topView.insert("2")
        // we add this async because an animation runs to switch to confirmation mode after insert the first four values
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.mbsPasswordView.topView.insert("1")
            self.mbsPasswordView.topView.insert("2")
            
            delayExpectation.fulfill()
        }
    }
}

// MARK: - MOCK
private final class MockTopPasswordDelegate: MBSTopPasswordDelegate {
    
    var didCallInvalidMatch: (() -> Void)!
    var didCallPassword: (([String]) -> Void)!
    
    func invalidMatch() {
        didCallInvalidMatch()
    }
    func password(_ result: [String]) {
        didCallPassword(result)
    }
}
