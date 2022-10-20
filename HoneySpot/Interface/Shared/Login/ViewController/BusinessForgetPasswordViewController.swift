//
//  BusinessForgetPasswordViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 30.06.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit

class BusinessForgetPasswordViewController: UIViewController {

	@IBOutlet weak var emailTextField: TextField!
		
		static let STORYBOARD_IDENTIFIER = "BusinessForgetPasswordViewController"
		
		override func viewDidLoad() {
			super.viewDidLoad()
			if #available(iOS 13.0, *) {
				overrideUserInterfaceStyle = .light
			}
		}
		
		@IBAction func onBackButtonTap(_ sender: Any) {
			self.navigationController?.popViewController(animated: true)
		}
		
		@IBAction func onSignUpButtonTap(_ sender: Any) {
			var email: String = emailTextField.text?.lowercased().trimmingCharacters(in: .whitespaces) ?? ""
			email = String(email.filter { !" \n\t\r".contains($0) })
			if email.isEmpty {
				showErrorHud(message: "Please type valid email address")
				return
			}
			if !email.isValidEmail() {
				showErrorHud(message: "Please type valid email address")
				return
			}
			
			self.showLoadingHud()
			BusinessLoginDataSource().forgetPassword(email: email) { (result) in
				self.hideAllHuds()
				switch(result){
				case .success(let str):
					self.performSegue(withIdentifier: "reset", sender: nil)
				case .failure(let err):
					HSAlertView.showAlert(withTitle: "Error", message: err.errorMessage)
				}
			}
		}

}
