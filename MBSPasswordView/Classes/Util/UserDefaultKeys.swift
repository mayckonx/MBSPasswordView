//
//  Enum.swift
//  MBSPasswordView
//
//  Created by Mayckon Barbosa da Silva on 3/2/19.
//  Copyright © 2019 Mayckon Barbosa da Silva. All rights reserved.
//

import Foundation

public enum MBSUserAuthetication: String {
    case done
}

public enum MBSAttemptsState: String {
    case block
    case unblock
}

public enum MBSAttempts: String {
    case quantity
    case minutes
}

public enum MBSPasswordSetValues: String {
    case isBiometricsActivate = "isBiometricsActivate"
}
