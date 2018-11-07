//
//  MBSBodyPasswordView.swift
//  MBSPasswordView
//
//  Created by Mayckon Barbosa da Silva on 11/3/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import UIKit

protocol MBSBodyPasswordDelegate: class {
    func selected(_ value: String)
    func removeLast()
}

public protocol MBSBodyPasswordViewType: class {
    var btnBackgroundColor: UIColor { get set }
    var btnTextColor: UIColor { get set }
    var fontButtons: UIFont? { get set }
    var fontDelete: UIFont? { get set }
}

public class MBSBodyPasswordView: UIView, MBSBodyPasswordViewType {
    weak var delegate: MBSBodyPasswordDelegate!
    @IBOutlet private var buttons: [MBSButton]!
    
    public var btnBackgroundColor: UIColor = .clear {
        didSet {
            for button in self.buttons {
                button.customBackgroundColor = btnBackgroundColor
            }
        }
    }
    public var btnTextColor: UIColor = .clear {
        didSet {
            for button in self.buttons {
                button.textColor = btnTextColor
            }
        }
    }
    public var fontButtons: UIFont? = UIFont(name: "Helvetica", size: 32) {
        didSet {
            for button in self.buttons {
                button.titleLabel?.font = fontButtons
            }
        }
    }
    
    public var fontDelete: UIFont? = UIFont(name: "Helvetica", size: 32) {
        didSet {
            if let button = self.viewWithTag(755) as? UIButton {
                button.titleLabel?.font = fontDelete
            }
        }
    }
    
    
}

// MARK: IBActions
extension MBSBodyPasswordView {
    @IBAction func selected(_ sender: Any) {
        guard let button = sender as? UIButton else { fatalError("must be a UIButton") }
        delegate?.selected(button.currentTitle ?? "")
        executeImpact()
    }
    
    @IBAction func backspace(_ sender: Any) {
        delegate?.removeLast()
    }
}

// MARK: Vibrate on touch
extension MBSBodyPasswordView {
    func executeImpact() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

// MARK: 
