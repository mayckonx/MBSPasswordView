//
//  MBSUserDefaultsTests.swift
//  MBSPasswordViewTests
//
//  Created by Mayckon Barbosa da Silva on 3/3/19.
//  Copyright © 2019 Mayckon Barbosa da Silva. All rights reserved.
//

import XCTest
@testable import MBSPasswordView

class MBSUserDefaultsTests: XCTestCase {
    
    let key = "test"
    let value = "value"
    let userDefaults = UserDefaults()

    override func setUp() {
        userDefaults.setValue(value, forKey: key)
        userDefaults.synchronize()
    }
    
    private func removeAllDataFromUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.dictionaryRepresentation().keys.forEach { defaults.removeObject(forKey: $0) }
    }
    
    override func tearDown() {
        removeAllDataFromUserDefaults()
    }
    
    func testValueMethod() {
        XCTAssertEqual(userDefaults.value(forKey: key) as! String, value)
    }
    func testSetMethod() {
        let newKey = "newKey"
        let newValue = "newValue"
        userDefaults.setValue(newValue, forKey: newKey)
        
        let obtedValue = userDefaults.value(forKey: newKey) as! String
        
        XCTAssertEqual(obtedValue, newValue)
    }
    
    func testRegisterMethod() {
        let objects = ["a": 4, "b": 5, "c": 9]
        
        let userDefaults = UserDefaults()
        userDefaults.register(defaults: objects)
        userDefaults.synchronize()
        
        let a = 4
        let b = 5
        let c = 9
        
        XCTAssertEqual(userDefaults.value(forKey: "a") as! Int, a)
        XCTAssertEqual(userDefaults.value(forKey: "b") as! Int, b)
        XCTAssertEqual(userDefaults.value(forKey: "c") as! Int, c)
    }
}

