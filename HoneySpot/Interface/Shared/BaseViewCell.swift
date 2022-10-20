//
//  BaseViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 07/09/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import Foundation
import UIKit

protocol BaseViewCell {

    func configureWith(data: Any?, indexPath: IndexPath?)
    static func reuseById(content: Any?) -> String

}

extension UIView: BaseViewCell {

 @objc func configureWith(data: Any?, indexPath: IndexPath?) {

    print("Configure Data")
 }
 @objc class func reuseById(content: Any?) -> String {
    return ""
 }
}

