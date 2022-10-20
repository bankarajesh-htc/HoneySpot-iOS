//
//  BusinessSignupViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 30.06.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit

class BusinessSignupViewController: UIViewController {

	@IBOutlet var emailField: TextField!
	@IBOutlet var fullnameField: TextField!
	@IBOutlet var passwordField: TextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
	
	@IBAction func backTapped(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
    @IBAction func onLoginButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
	
	@IBAction func signupTapped(_ sender: Any) {
        var email = emailField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        email = String(email.filter { !" \n\t\r".contains($0) })
        let fullname = fullnameField.text ?? ""
        let password = passwordField.text ?? ""
        
        if email.isEmpty {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter your email address")
        } else if !email.isValidEmail() {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter a valid email")
        } else if fullname.isEmpty {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter your full name")
        } else if password.isEmpty {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter password")
        } else if password.count < 6 {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Minimum password length is 6")
        } else {
            self.showLoadingHud()
			BusinessLoginDataSource().register(username: fullname, password: password, email: email, fullName: fullname) { (result) in
                self.hideAllHuds()
                switch(result){
                case .success(let successStr):
                    print(successStr!)
					HSAlertView.showAlert(withTitle: "Almost done...", message: "We'll send an email in couple of seconds. Verify your email in order to activate your account.", cancelButtonTitle: "OK", otherButtonTitles: nil) { (success) in
						self.navigationController?.popViewController(animated: true)
					}
                case .failure(let err):
                    print(err)
					if(err.errorMessage == "Success"){
						HSAlertView.showAlert(withTitle: "Almost done...", message: "We'll send an email in couple of seconds. Verify your email in order to activate your account.", cancelButtonTitle: "OK", otherButtonTitles: nil) { (success) in
							self.navigationController?.popViewController(animated: true)
						}
					}else{
						self.showErrorHud(message: err.errorMessage)
					}
                }
            }
        }
	}
	
}
