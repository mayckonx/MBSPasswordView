//
//  Result.swift
//  MBSPasswordView
//
//  Created by Mayckon Barbosa da Silva on 3/2/19.
//  Copyright © 2019 Mayckon Barbosa da Silva. All rights reserved.
//

import Foundation

public enum MBSPasswordResult<T> {
    case success(T)
    case error(Error?)
}
