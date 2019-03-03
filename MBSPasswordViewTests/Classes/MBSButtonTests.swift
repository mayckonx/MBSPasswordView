//
//  MBSButtonTests.swift
//  MBSPasswordViewTests
//
//  Created by Mayckon Barbosa da Silva on 3/3/19.
//  Copyright © 2019 Mayckon Barbosa da Silva. All rights reserved.
//

import XCTest
@testable import MBSPasswordView

class MBSButtonTests: XCTestCase {
    
    var button = MBSButton(frame: .zero)
    
    override func setUp() {
       button = MBSButton(frame: .zero)
    }
    
    func testHighlightedMode() {
        button.isHighlighted = true
        XCTAssertEqual(button.backgroundColor, button.textColor)
        XCTAssertEqual(button.currentTitleColor, button.customBackgroundColor)
    }
    
    func testLayoubSubviews() {
        button.layoutSubviews()
        
        XCTAssertEqual(button.backgroundColor, button.customBackgroundColor)
        XCTAssertEqual(button.currentTitleColor, button.textColor)
        XCTAssertEqual(button.layer.borderColor, button.customBackgroundColor.cgColor)
    }
}


