//
//  UIFont+Constants.swift
//  HoneySpot
//
//  Created by Max on 5/15/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    static func fontMonsterratRegular(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat", size: size)!
    }
    static func fontMonsterratBold(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Bold", size: size)!
    }
    static func fontMonsterratLight(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Light", size: size)!
    }
    static func fontHelveticaRegular(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica Neue", size: size)!
    }
    static func fontHelveticaBold(withSize size: CGFloat) -> UIFont {
        let normalFont = UIFont(name: "Helvetica Neue", size: size)!
        let boldFont = UIFont(descriptor: normalFont.fontDescriptor.withSymbolicTraits(.traitBold)!, size: normalFont.pointSize)
        
        return boldFont
    }
    
//    static let normalFont = UIFont(name: "Helvetica Neue", size: CGFloat(16))!
//    static let boldFont = UIFont(descriptor: normalFont.fontDescriptor.withSymbolicTraits(.traitBold)!, size: normalFont.pointSize)
}
