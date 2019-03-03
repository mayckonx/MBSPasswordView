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
    func authenticateByBiometrics(title: String, result: @escaping ((Result<Bool>) -> Void))
}

extension MBSAuthenticatable where Self: UIView {
    public func authenticateByBiometrics(title: String, result:  @escaping ((Result<Bool>) -> Void)) {
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
                        guard let error = error else {
                            result(.error(MBSAuthenticationIDError.canceled))
                            return
                        }
                        switch (error)
                        {
                        case LAError.authenticationFailed:
                            result(.error(MBSAuthenticationIDError.invalidID))
                            break
                        case LAError.userCancel:
                            result(.error(MBSAuthenticationIDError.canceled))
                            break
                        case LAError.userFallback:
                            result(.error(MBSAuthenticationIDError.canceled))
                            break
                        case LAError.systemCancel:
                            result(.error(MBSAuthenticationIDError.canceled))
                            break
                        case LAError.passcodeNotSet:
                            result(.error(MBSAuthenticationIDError.notRegistered))
                            break
                        default:
                            result(.error(MBSAuthenticationIDError.canceled))
                            break
                        }
                        return
                    }
                }
            }
        } else {
            // device not supported
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
