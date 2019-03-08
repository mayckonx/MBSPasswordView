//
//  UIViewController+ext.swift
//  MBSPasswordView
//
//  Created by Mayckon Barbosa da Silva on 3/2/19.
//  Copyright © 2019 Mayckon Barbosa da Silva. All rights reserved.
//

import Foundation

// Workaround to make those method optionals
// Perhaps the user wants to use only one of them
extension MBSPasswordDelegate where Self: UIViewController {
    func passwordFromBiometrics(_ result: MBSPasswordResult<[String]>) {}
    func password(_ result: [String]) {}
}
