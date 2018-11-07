//
//  MBSPasswordViewController.swift
//  MBSPasswordView
//
//  Created by Mayckon Barbosa da Silva on 11/3/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import UIKit

public protocol MBSPasswordViewType {
    // view
    var isShakable: Bool { get set }
}

public protocol MBSPasswordDelegate: class {
    func password(_ result: [String])
}

public class MBSPasswordView: UIView, MBSPasswordViewType {
    
    @IBOutlet public weak var topView: MBSTopPasswordView!
    @IBOutlet public weak var bodyView: MBSBodyPasswordView!
    
    weak public var delegate: MBSPasswordDelegate!
    public var isShakable: Bool = true
    
    // internal
    internal var view: UIView!
    
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
    
    public func loadNib() {
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
    
    func commonInit() {
        topView.delegate = self
        bodyView.delegate = self
    }
}

// MARK: - Protocols to support MBSTopPasswordView
extension MBSPasswordView: MBSTopPasswordDelegate, Shakable {
   public func password(_ result: [String]) {
        self.delegate?.password(result)
        self.view.isUserInteractionEnabled = false
    }
    public func invalidMatch() {
        if isShakable {
           self.shake()
        }
    }
}

// MARK: - Protocols to support MBSBodyPasswordView
extension MBSPasswordView: MBSBodyPasswordDelegate {
   public func selected(_ value: String) {
        self.topView.insert(value)
    }
   public func removeLast() {
        self.topView.removeLast()
    }
}




