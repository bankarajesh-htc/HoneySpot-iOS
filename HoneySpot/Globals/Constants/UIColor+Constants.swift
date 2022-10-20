//
//  UIColor+Constants.swift
//  HoneySpot
//
//  Created by Max on 2/8/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    // Custom Colors
    static let BLUE_COLOR = UIColor(rgb: 0x0F4375)
    static let YELLOW_COLOR = UIColor(rgb: 0xF5C851)
    static let ORANGE_COLOR = UIColor(rgb: 0xF96332)
    static let GREEN_COLOR = UIColor(rgb: 0x5ABC93)
    static let WHITE_COLOR = UIColor(rgb: 0xFFFFFF)
    static let LIGHTGRAY_COLOR = UIColor(rgb: 0xEFEFEF)
    static let BLACK_COLOR = UIColor(rgb: 0x000000)
    
    // Convenience Method that returns UIColor from RGB values between 0 and 255
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    // Convenience Method that returns UIColor from Hexadecimal value
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
