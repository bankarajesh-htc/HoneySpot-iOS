//
//  TabBarHighlightableContentView.swift
//  HoneySpot
//
//  Created by Max on 2/13/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class TabBarHighlightableContentView: ESTabBarItemContentView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.init(white: 165.0 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        
//        // Style 1
//        iconColor = UIColor.WHITE_COLOR
//        backdropColor = UIColor.ORANGE_COLOR
//
//        highlightIconColor = UIColor.ORANGE_COLOR
//        highlightBackdropColor = UIColor.WHITE_COLOR
        
        // Style 2
        iconColor = UIColor.ORANGE_COLOR
        backdropColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)

        highlightIconColor = UIColor.WHITE_COLOR
        highlightBackdropColor = UIColor.ORANGE_COLOR
        
//        // Style 3
//        iconColor = UIColor.WHITE_COLOR
//        backdropColor = UIColor.ORANGE_COLOR
//
//        highlightIconColor = UIColor.ORANGE_COLOR
//        highlightBackdropColor = UIColor.WHITE_COLOR
        
        let transform = CGAffineTransform.identity
        imageView.transform = transform.scaledBy(x: 1.15, y: 1.15)
    }
    
    public convenience init(specialWithAutoImplies implies: Bool) {
        self.init(frame: CGRect.zero)
        textColor = .white
        highlightTextColor = .white
        iconColor = .white
        highlightIconColor = .white
        backdropColor = UIColor.init(red: 17/255.0, green: 86/255.0, blue: 136/255.0, alpha: 1.0)
        highlightBackdropColor = UIColor.init(red: 22/255.0, green: 24/255.0, blue: 25/255.0, alpha: 1.0)
        if implies {
            let timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(TabBarHighlightableContentView.playImpliesAnimation(_:)), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        }
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc internal func playImpliesAnimation(_ sender: AnyObject?) {
        if self.selected == true || self.highlighted == true {
            return
        }
        let view = self.imageView
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.15, 0.8, 1.15]
        impliesAnimation.duration = 0.3
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        impliesAnimation.isRemovedOnCompletion = true
        view.layer.add(impliesAnimation, forKey: nil)
    }
    
    override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.beginAnimations("small", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = imageView.transform.scaledBy(x: 0.8, y: 0.8)
        imageView.transform = transform
        UIView.commitAnimations()
        completion?()
    }
    
    override func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.beginAnimations("big", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = CGAffineTransform.identity
        imageView.transform = transform.scaledBy(x: 1.15, y: 1.15)
        UIView.commitAnimations()
        completion?()
    }

}
