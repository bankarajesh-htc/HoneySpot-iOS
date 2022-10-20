//
//  BusinessRenewPasswordViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 30.06.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit

class BusinessRenewPasswordViewController: UIViewController {

	@IBOutlet var emailCodeTextField: TextField!
    @IBOutlet var newPasswordTextField: TextField!
    @IBOutlet var newPasswordRepeatTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HSAlertView.showAlert(withTitle: "Success", message: "We sent an email about your reset token.You can write it down and reset your password")
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        let code = emailCodeTextField.text
        let newPassword = newPasswordTextField.text
        let newPasswordRepeat = newPasswordRepeatTextField.text
        
        if(code == "" || newPassword == "" || newPasswordRepeat == ""){
             HSAlertView.showAlert(withTitle: "Error", message: "Fields cannot be empty!")
        }else{
            if(newPassword != newPasswordRepeat){
                 HSAlertView.showAlert(withTitle: "Mismatch", message: "Please be sure your password and repeated passwords are same")
            }else{
                showLoadingHud()
                BusinessLoginDataSource().resetPassword(code: code!, newPass: newPassword!) { (result) in
                    self.hideAllHuds()
                    switch(result){
                    case .success(let str):
                        print(str)
                        HSAlertView.showAlert(withTitle: "Success", message: "We successfully changed your password", cancelButtonTitle: "Ok", otherButtonTitles: nil) { (finished) in
                            self.performSegue(withIdentifier: "return", sender: nil)
                        }
                    case .failure(let err):
                        HSAlertView.showAlert(withTitle: "Error", message: err.errorMessage)
                        
                    }
                }
            }
        }
    }
	
}
