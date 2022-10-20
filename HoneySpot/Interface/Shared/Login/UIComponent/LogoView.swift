//
//  LogoView.swift
//  HoneySpot
//
//  Created by Max on 2/7/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class LogoView: UIView {

    @IBInspectable var borderTopColor: UIColor = UIColor(red:0.980, green:0.851, blue:0.380, alpha:1.000)
    @IBInspectable var borderBottomColor: UIColor = UIColor(red:0.965, green:0.420, blue:0.110, alpha:1.000)
    @IBInspectable var fillTopColor: UIColor = UIColor(red:0.980, green:0.851, blue:0.380, alpha:1.000)
    @IBInspectable var fillBottomColor: UIColor = UIColor(red:0.965, green:0.420, blue:0.110, alpha:1.000)
    
    var borderShapeLayer: CAShapeLayer = CAShapeLayer()
    var fillShapeLayer: CAShapeLayer = CAShapeLayer()
    var fillLayer: CALayer = CALayer()
    var fillMaskShapeLayer: CAShapeLayer = CAShapeLayer()
    var borderGradientLayer: CAGradientLayer = CAGradientLayer()
    var fillGradientLayer: CAGradientLayer = CAGradientLayer()
    var path: UIBezierPath = UIBezierPath()
    
    // Initialize via code
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    // Initialize via IB
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        _init()
    }
    
    func _init() {
        
        self.backgroundColor = UIColor.clear
        
        borderShapeLayer.fillColor = nil
        borderShapeLayer.lineWidth = 2
        borderShapeLayer.strokeColor = UIColor.black.cgColor
        
        fillShapeLayer.fillColor = UIColor.black.cgColor
        fillShapeLayer.lineWidth = 0
        fillShapeLayer.strokeColor = nil
        
        fillMaskShapeLayer.fillColor = UIColor.black.cgColor
        fillMaskShapeLayer.lineWidth = 0
        fillMaskShapeLayer.strokeColor = nil
        
        let combinedShape = UIBezierPath()
        combinedShape.move(to: CGPoint(x: 101.68, y: 108.68))
        combinedShape.addLine(to: CGPoint(x: 19.45, y: 108.7))
        combinedShape.addLine(to: CGPoint(x: 20.07, y: 109.76))
        combinedShape.addCurve(to: CGPoint(x: 6.64, y: 85.04), controlPoint1: CGPoint(x: 14.38, y: 100.74), controlPoint2: CGPoint(x: 9.91, y: 92.5))
        combinedShape.addLine(to: CGPoint(x: 114.4, y: 85.04))
        combinedShape.addCurve(to: CGPoint(x: 101.68, y: 108.68), controlPoint1: CGPoint(x: 111.35, y: 92.09), controlPoint2: CGPoint(x: 107.08, y: 100.02))
        combinedShape.close()
        
        combinedShape.move(to: CGPoint(x: 91.19, y: 124.44))
        combinedShape.addCurve(to: CGPoint(x: 60.54, y: 163.84), controlPoint1: CGPoint(x: 82.76, y: 136.41), controlPoint2: CGPoint(x: 72.54, y: 149.55))
        combinedShape.addCurve(to: CGPoint(x: 29.88, y: 124.44), controlPoint1: CGPoint(x: 48.53, y: 149.55), controlPoint2: CGPoint(x: 38.32, y: 136.41))
        combinedShape.addLine(to: CGPoint(x: 91.19, y: 124.44))
        combinedShape.close()
        
        combinedShape.move(to: CGPoint(x: 119.83, y: 69.28))
        combinedShape.addLine(to: CGPoint(x: 1.21, y: 69.13))
        combinedShape.addCurve(to: CGPoint(x: 0, y: 59.1), controlPoint1: CGPoint(x: 0.4, y: 65.52), controlPoint2: CGPoint(x: 0, y: 62.18))
        combinedShape.addCurve(to: CGPoint(x: 1.64, y: 45.39), controlPoint1: CGPoint(x: 0, y: 54.38), controlPoint2: CGPoint(x: 0.57, y: 49.79))
        combinedShape.addCurve(to: CGPoint(x: 1.61, y: 45.64), controlPoint1: CGPoint(x: 1.63, y: 45.48), controlPoint2: CGPoint(x: 1.62, y: 45.56))
        combinedShape.addLine(to: CGPoint(x: 119.44, y: 45.64))
        combinedShape.addCurve(to: CGPoint(x: 119.39, y: 45.18), controlPoint1: CGPoint(x: 119.42, y: 45.49), controlPoint2: CGPoint(x: 119.4, y: 45.34))
        combinedShape.addCurve(to: CGPoint(x: 121.07, y: 59.1), controlPoint1: CGPoint(x: 120.49, y: 49.65), controlPoint2: CGPoint(x: 121.07, y: 54.31))
        combinedShape.addCurve(to: CGPoint(x: 119.83, y: 69.28), controlPoint1: CGPoint(x: 121.07, y: 62.22), controlPoint2: CGPoint(x: 120.66, y: 65.62))
        combinedShape.close()
        
        combinedShape.move(to: CGPoint(x: 113.51, y: 30.48))
        combinedShape.addCurve(to: CGPoint(x: 113.11, y: 29.89), controlPoint1: CGPoint(x: 113.38, y: 30.28), controlPoint2: CGPoint(x: 113.25, y: 30.08))
        combinedShape.addLine(to: CGPoint(x: 7.9, y: 29.89))
        combinedShape.addCurve(to: CGPoint(x: 60.54, y: 0), controlPoint1: CGPoint(x: 18.32, y: 12.04), controlPoint2: CGPoint(x: 37.99, y: 0))
        combinedShape.addCurve(to: CGPoint(x: 113.51, y: 30.48), controlPoint1: CGPoint(x: 83.33, y: 0), controlPoint2: CGPoint(x: 103.19, y: 12.3))
        combinedShape.close()
        combinedShape.move(to: CGPoint(x: 113.51, y: 30.48))
        
        path = combinedShape
        borderShapeLayer.path = combinedShape.cgPath
        fillShapeLayer.path = combinedShape.cgPath
        
        fillGradientLayer.frame = self.bounds
        fillGradientLayer.colors = [fillTopColor.cgColor, fillBottomColor.cgColor]
        fillGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        fillGradientLayer.endPoint = CGPoint(x: 0, y: 1)
        fillGradientLayer.mask = fillShapeLayer
        fillLayer.mask = fillMaskShapeLayer
        layer.addSublayer(fillLayer)
        
        borderGradientLayer.frame = bounds
        borderGradientLayer.colors = [borderTopColor.cgColor, borderBottomColor.cgColor]
        borderGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        borderGradientLayer.endPoint = CGPoint(x: 0, y: 1)
        borderGradientLayer.mask = borderShapeLayer
        layer.addSublayer(borderGradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w: CGFloat = self.bounds.size.width
        let h: CGFloat = self.bounds.size.height
        
        let bounds: CGRect = path.bounds
        let center: CGPoint = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        let sw: CGFloat = (w - 3) / bounds.size.width
        let sh: CGFloat = (h - 3) / bounds.size.height
        let factor: CGFloat = min(sw, max(sh, 0))
        let scale = CGAffineTransform(scaleX: factor, y: factor)
        applyCentered(scale)
        
        let zeroedTo = CGPoint(x: w / 2 - bounds.origin.x, y: h / 2 - bounds.origin.y)
        let vector: CGVector = CGVector(dx: zeroedTo.x - center.x, dy: zeroedTo.y - center.y)
        let translate = CGAffineTransform(translationX: vector.dx, y: vector.dy)
        applyCentered(translate)
        borderShapeLayer.path = path.cgPath
        fillShapeLayer.path = path.cgPath
        borderGradientLayer.frame = bounds
        fillGradientLayer.frame = bounds
        fillMaskShapeLayer.frame = bounds
        fillLayer.frame = bounds
        
        fillGradientLayer.setNeedsDisplay()
        UIGraphicsBeginImageContextWithOptions(bounds.size, _: false, _: UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        if let ctx = ctx {
            fillGradientLayer.render(in: ctx)
        }
        let renderedImageOfMyself: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        fillLayer.contents = renderedImageOfMyself?.cgImage
        fillMaskShapeLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: w, height: h)).cgPath
    }
    
    func applyCentered(_ transform: CGAffineTransform) {
        let bounds: CGRect = path.bounds
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        var xform: CGAffineTransform = .identity
        xform = xform.concatenating(CGAffineTransform(translationX: -center.x, y: -center.y))
        xform = xform.concatenating(transform)
        xform = xform.concatenating(CGAffineTransform(translationX: center.x, y: center.y))
        path.apply(xform)
    }
    
    func animate() {
        let w: CGFloat = bounds.size.width
        let h: CGFloat = bounds.size.height
        
        let animationGroup = CAAnimationGroup.init()
        animationGroup.duration = 3.5
        animationGroup.repeatCount = .infinity
        
        let animation = CABasicAnimation()
        animation.keyPath = "path"
        animation.duration = 1.5
        animation.fromValue = UIBezierPath(rect: CGRect(x: 0, y: h, width: w, height: h)).cgPath
        animation.toValue = UIBezierPath(rect: CGRect(x: 0, y: 0, width: w, height: h)).cgPath
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        animationGroup.animations = [animation]
        fillMaskShapeLayer.add(animationGroup, forKey: "path")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
