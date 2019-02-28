//
//  RecognitionID.swift
//  MBSPasswordView
//
//  Created by Mayckon on 2/27/19.
//  Copyright © 2019 Mayckon Barbosa da Silva. All rights reserved.
//

import Foundation
import LocalAuthentication

enum AuthenticationIDError: Error {
    case notRegistered
    case canceled
    case notSupported
    case invalidID
}

protocol Authenticatable {
    func authenticateUserByTouchOrFaceId()
}

extension Authenticatable where Self: UIViewController {
    func authenticateUserByTouchOrFaceId(result: @escaping ((Error?) -> Void)) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        result(nil)
                    } else {
                        guard let error = error else {
                            return
                        }
                        switch (error)
                        {
                        case LAError.authenticationFailed:
                            result(AuthenticationIDError.invalidID)
                            break
                        case LAError.userCancel:
                            result(AuthenticationIDError.canceled)
                            break
                        case LAError.userFallback:
                            result(AuthenticationIDError.canceled)
                            break
                        case LAError.systemCancel:
                            result(AuthenticationIDError.canceled)
                            break
                        case LAError.passcodeNotSet:
                            result(AuthenticationIDError.notRegistered)
                            break
                        default:
                            result(AuthenticationIDError.canceled)
                            break
                        }
                        return
                    }
                }
            }
        } else {
            // device not supported
            result(AuthenticationIDError.notSupported)
        }
    }
}
