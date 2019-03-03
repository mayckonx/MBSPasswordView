//
//  MKBtn.swift
//  Safe Photos
//
//  Created by Mayckon Barbosa da Silva on 9/16/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import UIKit

class MBSButton: UIButton {
    
    var textColor: UIColor = .flatDarkBlue
    var customBackgroundColor: UIColor = .white
    
    override var isHighlighted: Bool {
        didSet {
            setTitleColor(customBackgroundColor, for: .highlighted)
            backgroundColor = isHighlighted ? textColor : customBackgroundColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        //provide custom style
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = customBackgroundColor
        self.setTitleColor(textColor, for: .normal)
        self.layer.borderColor = customBackgroundColor.cgColor
    }
}
