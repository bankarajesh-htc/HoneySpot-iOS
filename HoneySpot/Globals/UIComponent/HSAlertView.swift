//
//  HSAlertView.swift
//  HoneySpot
//
//  Created by Max on 4/25/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class HSAlertView: NSObject {
    
    static func showAlert(withTitle title: String,
                   message: String,
                   cancelButtonTitle: String,
                   otherButtonTitles: [String]?,
                   completion: @escaping (_ selectedOtherButtonIndex: Int) -> Void) {
        let alertController: UIAlertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        
        let alertActionHandler: ((UIAlertAction?) -> Void)? = ({ action in
            if action?.style == .cancel {
                completion(NSNotFound)
            } else {
                var index: Int? = nil
                if let action = action {
                    index = alertController.actions.firstIndex(of: action)
                }
                completion((index ?? 0) - 1)
            }
        })
        
        alertController.addAction(UIAlertAction(title: cancelButtonTitle,
                                                style: .cancel,
                                                handler: alertActionHandler))
        
        for buttonTitle in otherButtonTitles ?? [] {
            alertController.addAction(UIAlertAction(title: buttonTitle,
                                                    style: .default,
                                                    handler: alertActionHandler))
        }
        
        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
        var viewController: UIViewController? = keyWindow?.rootViewController
        while (viewController?.presentedViewController != nil) {
            viewController = viewController?.presentedViewController
        }
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlert(withTitle title: String, message: String) {
        showAlert(withTitle: title, message: message, cancelButtonTitle: "OK", otherButtonTitles: nil, completion: { (index) in
            
        })
    }
}
