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

        passwordView?.delegate = self
        passwordView?.titleToRequestAuthentication = "Please, identify your self!"
        passwordView?.start(enableBiometrics: false)

        // when user wants to change the registered password... you just use this method and mbspasswordview will take care of it and gives you the new password on the password delegate method.
        //passwordView?.changeExistingPassword()
        
    }
    
    /*private func customize() {
        // customize top view
        passwordView?.topView.dotColor = UIColor.blue
        passwordView?.topView.errorBackgroundColor = UIColor.green
        passwordView?.topView.labelColor = UIColor.red
        passwordView?.topView.backgroundColor = UIColor.yellow
        passwordView?.topView.font = UIFont(name: "Arial", size: 20)
        
        // customize body view
        passwordView?.bodyView.btnBackgroundColor = UIColor.purple
        passwordView?.bodyView.btnTextColor = UIColor.brown
        passwordView?.bodyView.fontButtons = UIFont(name: "Arial", size: 20)
        passwordView?.bodyView.fontDelete = UIFont(name: "Arial", size: 20)
        
    }*/
}

extension ViewController: MBSPasswordDelegate {
    func wrongPassword(_ result: InvalidPasswordResult) {
        switch result {
        case .biometrics:
            print("Biometrics failed")
        case .loginPassword(let wrongPassword):
            print("Wrong password when login:\(wrongPassword)")
        case .registerPassword(let wrongPassword):
            print("Wrong p(assword when try to confirm the first password provided.\(wrongPassword)")
        }
    }
    
    func password(_ result: [String]) {
        print("Password confirmed. Result:\(result)")
        let alert = UIAlertController(title: "Success", message: "Password Validated!", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    func passwordFromBiometrics(_ result: MBSPasswordResult<[String]>) {
        switch result {
        case .success(let password):
            print("Authenticated by password and biometrics. Password:\(password)")
        case .error(let error):
            print("Error to authenticate:\(error?.localizedDescription ?? "")")
        }
    }
}

