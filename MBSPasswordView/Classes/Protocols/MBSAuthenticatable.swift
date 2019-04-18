//
//  MBSAuthenticatable.swift
//  MBSPasswordView
//
//  Created by Mayckon Barbosa on 2/27/19.
//  Copyright © 2019 Mayckon Barbosa da Silva. All rights reserved.
//

import Foundation
import LocalAuthentication

public enum MBSAuthenticationIDError: Error {
    case notRegistered
    case canceled
    case notSupported
    case invalidID
}

public protocol MBSAuthenticatable {
    func isTouchIDAvailable() -> Bool
    func isFaceIDAvailable() -> Bool
    func authenticateByBiometrics(title: String, result: @escaping ((MBSPasswordResult<Bool>) -> Void))
}

extension MBSAuthenticatable where Self: UIView {
    public func authenticateByBiometrics(title: String, result:  @escaping ((MBSPasswordResult<Bool>) -> Void)) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = title
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        result(.success(true))
                    } else {
                        result(.error(error))
                    }
                }
            }
        } else {
            // device not supported or user tried several times and the OS blocked for a time...
            result(.error(MBSAuthenticationIDError.notSupported))
        }
    }
    
    /// check if device supports faceID authentication
    public func isTouchIDAvailable() -> Bool {
        if #available(iOS 11.0, *) {
            let context = LAContext()
            return (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) && context.biometryType == .touchID)
        }
        return false
    }
    
    /// check if device supports faceID authentication
    public func isFaceIDAvailable() -> Bool {
        if #available(iOS 11.0, *) {
            let context = LAContext()
            return (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) && context.biometryType == .faceID)
        }
        return false
    }
}
