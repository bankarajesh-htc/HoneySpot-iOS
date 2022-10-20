//
//  EditTextField.swift
//  HoneySpot
//
//  Created by Max on 2/19/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

@IBDesignable
class EditTextField: UITextField {

    var borderLayer: CALayer = CALayer()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        sharedInit()
    }
    
    func sharedInit() {
        self.borderStyle = UITextField.BorderStyle.none
        borderLayer.backgroundColor = UIColor.ORANGE_COLOR.cgColor
        self.layer.addSublayer(borderLayer)
        self.layer.masksToBounds = true
        
        let v: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 13, height: 13))
        v.backgroundColor = UIColor.clear
        v.image = UIImage(named: "IconProfileEdit")
        v.contentMode = UIView.ContentMode.scaleAspectFit
        self.rightView = v
        self.rightViewMode = UITextField.ViewMode.always
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w: CGFloat = self.bounds.size.width
        let h: CGFloat = self.bounds.size.height
        self.borderLayer.frame = CGRect(x: 0, y: h-1, width: w, height: 1)
    }
}
