//
//  BusinessRestaurantEditUpdateContactInfoViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 27.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class BusinessRestaurantEditUpdateContactInfoViewController: UIViewController {

	@IBOutlet var emailTextField: UITextField!
	@IBOutlet var phoneTextField: UITextField!
	@IBOutlet var websiteTextField: UITextField!
	
	var spotModel :SpotModel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
    }
	
	func setupViews(){
		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
		emailTextField.text = spotModel.email
		websiteTextField.text = spotModel.website
		phoneTextField.text = spotModel.phoneNumber
	}
    
	@IBAction func closeTapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func updateTapped(_ sender: Any) {
		
        var email = emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        email = String(email.filter { !" \n\t\r".contains($0) })
        
        
        if phoneTextField.text == "" &&  websiteTextField.text == "" && emailTextField.text == ""{
            HSAlertView.showAlert(withTitle: "Contacts", message: "Enter all the required details")
        }
        else
        {
            
            if phoneTextField.text == "" {
                HSAlertView.showAlert(withTitle: "Location", message: "Enter phone number")
            }
            else if websiteTextField.text == "" {
                HSAlertView.showAlert(withTitle: "Location", message: "Enter website details")
            }
            else if emailTextField.text == "" {
                HSAlertView.showAlert(withTitle: "Location", message: "Enter email details")
            }
            else if !email.isValidEmail() {
                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter a valid email")
            }
            else
            {
                showLoadingHud()
                
                spotModel.email = emailTextField.text ?? ""
                spotModel.website = websiteTextField.text ?? ""
                spotModel.phoneNumber = phoneTextField.text ?? ""
                BusinessRestaurantDataSource().saveSpot(spotModel: spotModel) { (result) in
                    self.hideAllHuds()
                    switch(result){
                    case .success(let str):
                        print(str)
                        NotificationCenter.default.post(name: NSNotification.Name.init("dataChanged"), object: nil)
                        self.dismiss(animated: true, completion: nil)
                    case .failure(let err):
                        print(err.localizedDescription)
                        self.showErrorHud(message: err.localizedDescription)
                    }
                }
            }
            
        }
        
	}
	
}
