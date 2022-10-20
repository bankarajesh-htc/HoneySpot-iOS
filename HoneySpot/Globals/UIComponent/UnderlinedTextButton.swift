//
//  UnderlinedTextButton.swift
//  HoneySpot
//
//  Created by Max on 2/19/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

@IBDesignable
class UnderlinedTextButton: UIButton {

    @IBInspectable var underlined: Bool {
        get {
            return !borderLayer.isHidden
        }
        set {
            borderLayer.isHidden = !newValue
        }
    }
    @IBInspectable var underlineColor: UIColor {
        get {
            return UIColor(cgColor: borderLayer.backgroundColor ?? UIColor.ORANGE_COLOR.cgColor)
        }
        set {
            borderLayer.backgroundColor = underlineColor.cgColor
        }
    }
    @IBInspectable var underlineThickness: Int = 0 {
        didSet {
            self.setNeedsLayout()
        }
    }

    var borderLayer: CALayer = CALayer()

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
        underlined = false
//        setTitleColor(.ORANGE_COLOR, for: .normal)
//        if let font = UIFont(name: "Montserrat-Bold", size: 16) {
//            titleLabel?.font = font
//        }

        borderLayer.backgroundColor = underlineColor.cgColor
        layer.addSublayer(borderLayer)
        layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let w = bounds.size.width
        let h = bounds.size.height
        
        var s = sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
        s.width += 4
        borderLayer.frame = CGRect(x: (w - s.width) / 2, y: CGFloat(h / 2) + (h - s.height) / 2 + 7, width: s.width, height: CGFloat(underlineThickness))
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
