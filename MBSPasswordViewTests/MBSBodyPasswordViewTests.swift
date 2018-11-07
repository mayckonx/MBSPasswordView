//
//  MBSBodyPasswordViewTests.swift
//  TESTETests
//
//  Created by Mayckon Barbosa da Silva on 11/6/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import XCTest
@testable import MBSPasswordView

class MBSBodyPasswordViewTests: XCTestCase {

    var mbsPasswordView: MBSPasswordView!
    var expectation: XCTestExpectation!
    
    private func loadView() -> MBSPasswordView {
        return MBSPasswordView()
    }
    
    override func setUp() {
        self.mbsPasswordView = loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mbsPasswordView.bodyView.delegate = nil
    }
    
    // MARK: - Test properties initialization and assignments
    func testInitialization() {
        XCTAssertNotNil(mbsPasswordView.view, "Must not be nil")
        XCTAssertNotNil(mbsPasswordView.bodyView, "Must not be nil")
    }
    
    func testPropertiesAssignments() {
        let bodyView = mbsPasswordView.bodyView!
        let font = UIFont(name: "Helvetica", size: 32)
        let fontDelete = UIFont(name: "Helvetica", size: 32)
        bodyView.btnBackgroundColor = .blue
        bodyView.btnTextColor = .red
        bodyView.fontButtons = font
        bodyView.fontDelete = fontDelete
        
        XCTAssertEqual(bodyView.btnBackgroundColor, .blue)
        XCTAssertEqual(bodyView.btnTextColor, .red)
        XCTAssertEqual(bodyView.fontButtons, font)
        XCTAssertEqual(bodyView.fontDelete, fontDelete)
    }
    
    // MARK: - Delegate method tests
    func testSelect() {
        let bodyView = mbsPasswordView.bodyView!
        let mockDelegate = MockBodyPasswordDelegate()
        let button = getButtonOne()
        bodyView.delegate = mockDelegate
        mockDelegate.didCallSelected = { value in
            XCTAssertEqual(value, "1")
        }
        bodyView.selected(button)
    }
    func testRemoveLast() {
        let bodyView = mbsPasswordView.bodyView!
        let mockDelegate = MockBodyPasswordDelegate()
        bodyView.delegate = mockDelegate
        var result = false
        mockDelegate.didCallRemoveLast = { called in
            result = true
        }
        bodyView.backspace([])
        XCTAssertEqual(result, true)
    }
}

// MARK: - HELPERS
extension MBSBodyPasswordViewTests {
    private func getButtonOne() -> UIButton {
        let button = UIButton()
        button.setTitle("1", for: .normal)
        return button
    }
}

private final class MockBodyPasswordDelegate: MBSBodyPasswordDelegate {
    
    var didCallSelected: ((String) -> Void)!
    var didCallRemoveLast: ((Bool) -> Void)!
    
    func selected(_ value: String) {
        didCallSelected(value)
    }
    
    func removeLast() {
        didCallRemoveLast(true)
    }
}
