//
//  TextField.swift
//  HoneySpot
//
//  Created by Max on 4/5/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class TextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
