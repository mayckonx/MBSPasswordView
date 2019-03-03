//
//  MBSPasswordViewController.swift
//  MBSPasswordView
//
//  Created by Mayckon Barbosa da Silva on 11/3/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import UIKit

public protocol MBSPasswordViewType {
    var isShakable: Bool { get set }
    var titleToRequestAuthentication: String { get set }
    
    func start(enableBiometrics: Bool)
}

public protocol MBSPasswordDelegate: class {
    func password(_ result: [String])
    func passwordFromBiometrics(_ result: Result<[String]>)
}

public class MBSPasswordView: UIView, MBSPasswordViewType {
    
    @IBOutlet public weak var topView: MBSTopPasswordView!
    @IBOutlet public weak var bodyView: MBSBodyPasswordView!
    
    weak public var delegate: MBSPasswordDelegate!
    
    // MARK: - MBSPasswordViewType protocol vars
    public var isShakable: Bool = true
    public var titleToRequestAuthentication: String = "Identify yourself!"
    
    // private
    public var view: UIView!
    private var enableBiometricsAuthentication: Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        commonInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
        commonInit()
    }
    
    private func loadNib() {
        // load and instantantiate xib
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        // set frame and constraints to superview's size.
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        // add on view
        self.addSubview(view)
        self.view = view
    }
    
    private func commonInit() {
        topView.delegate = self
        topView.passwordRegistered = self.passwordRegistered()
        bodyView.delegate = self
        disableViews()
    }
    
    private func disableViews() {
        topView.isUserInteractionEnabled = false
        bodyView.isUserInteractionEnabled = false
    }
    private func enableViews() {
        topView.isUserInteractionEnabled = true
        bodyView.isUserInteractionEnabled = true
    }
    
    public func start(enableBiometrics: Bool) {
        enableViews()
        enableBiometricsAuthentication = enableBiometrics
        if let password = passwordRegistered() {
            callBiometricsIfEnabled(password)
        }
    }
}

// MARK: - Protocols to support MBSTopPasswordView
extension MBSPasswordView: MBSTopPasswordDelegate, Shakable {
   public func password(_ result: [String]) {
        registerPassword(result)
        disableViews()
        callBiometricsIfEnabled(result)
    }
    public func invalidMatch() {
        if isShakable {
           shake()
        }
    }
}

// MARK: - Protocols to support MBSBodyPasswordView
extension MBSPasswordView: MBSBodyPasswordDelegate {
   public func selected(_ value: String) {
        topView.insert(value)
    }
   public func removeLast() {
        topView.removeLast()
    }
}

// MARK: - Flag the authentication
extension MBSPasswordView {
    private func registerPassword(_ password: [String]) {
        if passwordRegistered() == nil {
            let userDefaults = UserDefaults()
            userDefaults.set(password, forKey: MBSUserAuthetication.done.rawValue)
        }
    }
    
    private func passwordRegistered() -> [String]? {
        let userDefaults = UserDefaults()
        return userDefaults.value(forKey: MBSUserAuthetication.done.rawValue) as? [String]
    }
    
    public func cleanPasswordUserDefaults() {
        let userDefaults = UserDefaults()
        if let _ = userDefaults.value(forKey: MBSUserAuthetication.done.rawValue) as? [String] {
            userDefaults.removeObject(forKey: MBSUserAuthetication.done.rawValue)
            userDefaults.synchronize()
        }
    }
}

// MARK: - Request Authentication
extension MBSPasswordView: MBSAuthenticatable {
    private func callBiometricsIfEnabled(_ password: [String]) {
        if enableBiometricsAuthentication {
            self.authenticateByBiometrics(title: titleToRequestAuthentication) { result in
                switch result {
                case .success:
                    self.delegate?.passwordFromBiometrics(Result.success(password))
                case .error(let error):
                    // we won't request on the next try... User should try by password
                    self.enableBiometricsAuthentication = false
                    self.delegate?.passwordFromBiometrics(Result.error(error))
                }
            }
        } else {
            delegate?.password(password)
        }
    }
}




