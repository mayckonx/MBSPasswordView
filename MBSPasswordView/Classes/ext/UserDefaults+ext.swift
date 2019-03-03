//
//  NSUserDefaults+ext.swift
//  MBSPasswordView
//
//  Created by Mayckon on 2/28/19.
//  Copyright © 2019 Mayckon Barbosa da Silva. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit
public typealias SystemColor = UIColor
#else
import Cocoa
public typealias SystemColor = NSColor
#endif

public extension UserDefaults {
    
    func set<T>(_ value: T?, forKey key: Key) {
        set(value, forKey: key.rawValue)
    }
    
    func value<T>(forKey key: Key) -> T? {
        return value(forKey: key.rawValue) as? T
    }
    
    func register(defaults: [Key: Any]) {
        let mapped = Dictionary(uniqueKeysWithValues: defaults.map { (key, value) -> (String, Any) in
            if let color = value as? SystemColor {
                return (key.rawValue, NSKeyedArchiver.archivedData(withRootObject: color))
            } else if let url = value as? URL {
                return (key.rawValue, url.absoluteString)
            } else {
                return (key.rawValue, value)
            }
        })
        
        register(defaults: mapped)
    }
}

public extension UserDefaults {
    subscript<T>(key: Key) -> T? {
        get { return value(forKey: key) }
        set { set(newValue, forKey: key) }
    }
}

public extension UserDefaults {
    struct Key: Hashable, RawRepresentable, ExpressibleByStringLiteral {
        public var rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(stringLiteral value: String) {
            self.rawValue = value
        }
    }
}
