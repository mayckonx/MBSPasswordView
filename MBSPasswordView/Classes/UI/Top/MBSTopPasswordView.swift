//
//  MBSTopPasswordView.swift
//  MBSPasswordView
//
//  Created by Mayckon Barbosa da Silva on 11/3/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//
import UIKit
import AVFoundation

// Enums and Protocol
public enum PasswordAnimation {
    case bottomToTop
    //case growUp
}

public protocol MBSTopPasswordViewType {
    /// kind of animation
    var passwordAnimation: PasswordAnimation { get set }
    /// color of password views
    var dotColor: UIColor { get set }
    /// background which appears when passwords don't match
    var errorBackgroundColor: UIColor { get set }
    /// color of uilabel
    var labelColor: UIColor { get set }
    /// font of label alert
    var font: UIFont? { get set }
}

public protocol MBSTopPasswordDelegate: class {
    func invalidMatch()
    func password(_ result: [String])
}

// Implementation
public class MBSTopPasswordView : UIView, MBSTopPasswordViewType {
    
    enum ViewState {
        case login
        case confirmation
        case validatePassword
        case newPassword
        case passwordInvalid
        case passwordMatch
        case changePasswordRequest
        case changePasswordNewPassword
    }
    
    @IBOutlet weak var lblPasswordRequest: UILabel!
    
    // protocol variables
    public var passwordAnimation: PasswordAnimation = .bottomToTop
    public var dotColor: UIColor = .white
    public var errorBackgroundColor: UIColor = .flatRed
    public var labelColor: UIColor = .white {
        didSet { self.lblPasswordRequest.textColor = labelColor }
    }
    public var font: UIFont? = UIFont(name: "Helvetica", size: 32) {
        didSet { self.lblPasswordRequest.font = font }
    }
    
    // internal
    internal var passwordValues: [String] = []
    internal var confirmationValues: [String] = []
    internal var passwordViews: [UIView] = []
    internal var passwordRegistered: [String]? {
        didSet {
            if let password = passwordRegistered {
                passwordValues.append(contentsOf: password)
                changeStateTo(newState: .login)
            }
        }
    }
    internal var changeExistingPassword = false {
        didSet {
            if self.changeExistingPassword, let password = passwordRegistered {
                self.isConfirmationMode = true
                passwordValues = password
                changeStateTo(newState: .changePasswordRequest)
            }
        }
    }
    internal var isConfirmationMode = false
    
    // private
    private let passwordLenght: Int = 4
    private var viewState: ViewState = .newPassword
    private var isLogin: Bool {
        return self.passwordRegistered != nil
    }
    
    // delegate
    weak var delegate: MBSTopPasswordDelegate!
    
    // Property size variables
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.flatDarkBlue
    }
    
    private func changeStateTo(newState: ViewState) {
        self.viewState = newState
        switch newState {
        case .newPassword:
            removeAllPasswordViews()
            removePasswordArrayData()
            passwordMode()
            
        case .confirmation:
            self.switchMode {
                self.removeAllPasswordViews()
            }
            
        case .login:
            registeredPassswordMode()
            
        case .changePasswordRequest:
            changePasswordMode()
        
        case .changePasswordNewPassword:
            isConfirmationMode = false
            changeExistingPassword = false
            passwordRegistered = nil
            
            removeAllPasswordViews()
            removePasswordArrayData()
            passwordMode()
            
        case .validatePassword:
            handleConfirmation()
            
        case .passwordInvalid:
            if isLogin {
                let newState = changeExistingPassword ? ViewState.changePasswordRequest : ViewState.login
                changeToNewStateWithDelay(newState: newState) {
                    self.invalidPassword()
                }
            } else {
                changeToNewStateWithDelay(newState: .newPassword) {
                    self.invalidPassword()
                }
            }
            
        case .passwordMatch:
            delegate?.password(passwordValues)
        }
    }
    
    private func invalidPassword() {
        self.removeAllPasswordViews()
        self.removePasswordArrayData()
        self.notifyPasswordInvalid()
    }
    
    private func changeToNewStateWithDelay(newState: ViewState, completion: (() -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.changeStateTo(newState: newState)
            completion?()
        }
    }
    
    // MARK: Flow methods
    internal func insert(_ value: String) {
        // limited to 4
        if passwordViews.count == passwordLenght { return }
        // normal flow
        if isConfirmationMode {
            confirmationValues.append(value)
            addDotView()

            if confirmationValues.count == passwordLenght {
                changeStateTo(newState: .validatePassword)
            }
        } else {
            passwordValues.append(value)
            addDotView()
            if passwordValues.count == passwordLenght {
                changeStateTo(newState: .confirmation)
            }
        }
    }
    
    internal func removeLast() {
        guard let viewPassword = passwordViews.last else { return }
        passwordViews.removeLast()
        hideAnimatedPassword(viewPassword)
        
        if isConfirmationMode || isLogin {
            confirmationValues.removeLast()
        } else {
            passwordValues.removeLast()
        }
    }
}

// MARK: Auxiliar flow methods
extension MBSTopPasswordView {
    private func insertPasswordView() -> UIView {
        var xPosition = frame.size.width - (frame.size.width * 0.8)
        
        if let last = passwordViews.last {
            xPosition = last.frame.origin.x + (frame.size.width * 0.17)
        }
        
        // add the view
        let viewPassword = UIView()
        viewPassword.backgroundColor = .clear
        getSuperview().addSubview(viewPassword)
        viewPassword.frame = CGRect(x: xPosition, y: self.frame.size.height+10, width: 30, height: 30)
        viewPassword.layer.cornerRadius = viewPassword.frame.size.width/2
        viewPassword.clipsToBounds = true
        viewPassword.alpha = 0.0
        
        return viewPassword
    }
    private func removeAllPasswordViews() {
        for viewPassword in passwordViews {
            viewPassword.removeFromSuperview()
        }
        passwordViews = []
    }
    private func removePasswordArrayData() {
        removeAllPasswordViews()
        if passwordRegistered == nil {
            passwordValues.removeAll()
        }
        confirmationValues.removeAll()
    }
    
    private func handleConfirmation() {
        if passwordValues == confirmationValues {
            if changeExistingPassword {
                changeToNewStateWithDelay(newState: .changePasswordNewPassword, completion: nil)
            } else {
                changeStateTo(newState: .passwordMatch)
            }
        } else {
            changeStateTo(newState: .passwordInvalid)
        }
    }
    
    private func addDotView() {
        let passwordView = insertPasswordView()
        passwordViews.append(passwordView)
        showAnimatedPassword(passwordView)
    }
    
    private func notifyPasswordInvalid() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        showErrorAnimation() {
            self.delegate?.invalidMatch()
        }
    }
}

// MARK: Animations
extension MBSTopPasswordView {
    private func showAnimatedPassword(_ viewPassword: UIView) {
        UIView.animate(withDuration: 0.2,
                       animations: {
                        let xPosition = viewPassword.frame.origin.x+(viewPassword.frame.size.width/2)
                        let yPosition = self.lblPasswordRequest.frame.origin.y + (self.frame.size.height * 0.32)
                        viewPassword.center = CGPoint(x: xPosition, y: yPosition)
                        viewPassword.backgroundColor = self.dotColor
                        viewPassword.alpha = 0.8
        }, completion: { _ in
            UIView.animate(withDuration: 0.17,
                           animations: {
                            viewPassword.center = CGPoint(x: viewPassword.center.x, y: viewPassword.center.y+6)
                            viewPassword.alpha = 1.0
            })
        })
    }
    private func hideAnimatedPassword(_ viewPassword: UIView) {
        UIView.animate(withDuration: 0.2,
                       animations: {
                        let xPosition = viewPassword.frame.origin.x+(viewPassword.frame.size.width/2)
                        let yPosition = self.frame.size.height + viewPassword.frame.size.height
                        viewPassword.center = CGPoint(x: xPosition, y: yPosition)
                        viewPassword.backgroundColor = .white
                        viewPassword.alpha = 0.0
        })
    }
    
    private func switchMode(with completion: @escaping (() -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.viewState == .changePasswordRequest {
                self.passwordMode()
            } else {
                self.isConfirmationMode ? self.passwordMode() : self.confirmationMode()
            }
            completion()
        }
    }
    
    private func showErrorAnimation(with completion: @escaping () -> Void) {
        let currentBackgroundColor = backgroundColor
        backgroundColor = errorBackgroundColor
        UIView.animate(withDuration: 2.0,
                       animations: {
                        self.backgroundColor = currentBackgroundColor
                        completion()
        })
    }
}

// MARK: Get views
extension MBSTopPasswordView {
    private func getSuperview() -> UIView {
        guard let superview = superview else { fatalError("There is no superview. Please, add a superview to this view.") }
        return superview
    }
    
    private func getLastPasswordView() -> UIView {
        guard let passwordView = passwordViews.last else { fatalError("Crash on apple API. Attribute: isEmpty is false, but there's no element on array") }
        return passwordView
    }
}

// MARK: - Screen modes
extension MBSTopPasswordView {
    private func confirmationMode() {
        isConfirmationMode = true
        lblPasswordRequest.text = "Confirm new password"
    }
    private func passwordMode() {
        isConfirmationMode = false
        lblPasswordRequest.text = "Enter new password"
    }
    private func registeredPassswordMode() {
        isConfirmationMode = true
        lblPasswordRequest.text = "Inform your password"
    }
    func updateLabel() {
        if changeExistingPassword {
            changePasswordMode()
        } else {
            registeredPassswordMode()
        }
    }
    private func changePasswordMode() {
        isConfirmationMode = true
        lblPasswordRequest.text = "Inform the current password"
    }
}
