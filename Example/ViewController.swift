//
//  ViewController.swift
//  Example
//
//  Created by Mayckon Barbosa da Silva on 11/7/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import UIKit
import MBSPasswordView


class ViewController: UIViewController {

    @IBOutlet weak var passwordView: MBSPasswordView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passwordView?.delegate = self
    }
}

extension ViewController: MBSPasswordDelegate {
    func password(_ result: [String]) {
        print("Password confirmed. Result:\(result)")
        let alert = UIAlertController(title: "Success", message: "Password Validated!", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}

