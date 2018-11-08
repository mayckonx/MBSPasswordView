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
    // kind of animation
    var passwordAnimation: PasswordAnimation { get set }
    // color of password views
    var dotColor: UIColor { get set }
    // background which appears when passwords don't match
    var errorBackgroundColor: UIColor { get set }
    // color of uilabel
    var labelColor: UIColor { get set }
    // font of label alert
    var font: UIFont? { get set }
}

public protocol MBSTopPasswordDelegate: class {
    func invalidMatch()
    func password(_ result: [String])
}

// Implementation
public class MBSTopPasswordView : UIView, MBSTopPasswordViewType {
    
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
    // private
    
    private let passwordLenght: Int = 4
    private var isConfirmationMode = false
    
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
        self.backgroundColor = UIColor.flatDarkBlue
    }
    
    // MARK: Flow methods
    internal func insert(_ value: String) {
        // limited to 4
        if passwordViews.count == passwordLenght { return }
        // normal flow
        if isConfirmationMode {
            self.confirmationValues.append(value)
            self.addDotView()
            if confirmationValues.count == passwordLenght {
                handleConfirmation()
            }
        } else {
            self.passwordValues.append(value)
            self.addDotView()
            if passwordValues.count == passwordLenght {
                self.switchMode {
                   self.removeAllPasswordViews()
                }
            }
        }
    }
    
    internal func removeLast() {
        guard let viewPassword = self.passwordViews.last else { return }
        self.passwordViews.removeLast()
        self.hideAnimatedPassword(viewPassword)
        
        if isConfirmationMode {
            confirmationValues.removeLast()
        } else {
            passwordValues.removeLast()
        }
    }
}

// MARK: Auxiliar flow methods
extension MBSTopPasswordView {
    private func insertPasswordView() -> UIView {
        var xPosition = self.frame.size.width - (self.frame.size.width * 0.8)
        
        if let last = passwordViews.last {
            xPosition = last.frame.origin.x + (self.frame.size.width * 0.17)
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
        for viewPassword in self.passwordViews {
            viewPassword.removeFromSuperview()
        }
        self.passwordViews = []
    }
    private func removePasswordArrayData() {
        removeAllPasswordViews()
        self.passwordValues.removeAll()
        self.confirmationValues.removeAll()
    }
    
    private func handleConfirmation() {
        if passwordValues == confirmationValues {
            self.delegate?.password(passwordValues)
        } else {
            switchMode {
                self.notifyPasswordInvalid()
                self.removeAllPasswordViews()
                self.removePasswordArrayData()
            }
        }
    }
    
    private func addDotView() {
        let passwordView = self.insertPasswordView()
        self.passwordViews.append(passwordView)
        self.showAnimatedPassword(passwordView)
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
            self.isConfirmationMode ?
                self.passwordMode():
                self.confirmationMode()
            completion()
        }
    }
    
    private func showErrorAnimation(with completion: @escaping () -> Void) {
        let currentBackgroundColor = backgroundColor
        self.backgroundColor = errorBackgroundColor
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
        guard let superview = self.superview else { fatalError("There is no superview. Please, add a superview to this view.") }
        return superview
    }
    
    private func getLastPasswordView() -> UIView {
        guard let passwordView = self.passwordViews.last else { fatalError("Crash on apple API. Attribute: isEmpty is false, but there's no element on array") }
        return passwordView
    }
}

// MARK: - Screen modes
extension MBSTopPasswordView {
    private func confirmationMode() {
        isConfirmationMode = true
        self.lblPasswordRequest.text = "Confirm new password"
    }
    private func passwordMode() {
        isConfirmationMode = false
        self.lblPasswordRequest.text = "Enter new password"
    }
}
