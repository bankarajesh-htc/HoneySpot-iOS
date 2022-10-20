//
//  BusinessProfileViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 24.02.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit
import JGProgressHUD

class BusinessProfileViewController: UIViewController {

	
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var fullnameTextField: UITextField!
	@IBOutlet var emailTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
	
	var loader = JGProgressHUD()
	var userModel : UserModel!
    var textValueChanged = false
    
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.layer.zPosition = 0
        
		setupViews()
		setupLabels()
		getData()
        
        
    }
	
	func getData(){
		self.loader.show(in: self.view)
		ProfileDataSource().getUser(userId: UserDefaults.standard.string(forKey: "userId") ?? "") { (result) in
			self.loader.dismiss()
			switch(result){
			case .success(let userM):
				self.userModel = userM
				DispatchQueue.main.async {
					self.fullnameTextField.text = userM.username
					self.emailTextField.text = userM.email
                    
				}
			case .failure(let err):
				print(err.localizedDescription)
				self.navigationController?.popViewController(animated: true)
			}
		}
	}
    
    
    
	
	func setupViews(){
		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
        self.saveButton.backgroundColor = UIColor.init(red: 229.0/255.0, green: 229.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        saveButton.isUserInteractionEnabled = false
        fullnameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
	}
	
	func setupLabels(){
		titleLabel.text = "EDIT ACCOUNT"
		fullnameTextField.placeholder = "Full name"
		emailTextField.placeholder = "Email"
	}
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == fullnameTextField {

            if textField.text == userModel.username {

                print("Same username")
                if emailTextField.text == userModel.email {
                    textValueChanged = false
                }
                else
                {
                    textValueChanged = true
                }

            }
            else{

                textValueChanged = true
            }
        }
        else if textField == emailTextField
        {
            if textField.text == userModel.email {
                print("Same email")
                if fullnameTextField.text == userModel.username {
                    textValueChanged = false
                }
                else
                {
                    textValueChanged = true
                }
                

            }
            else{
                textValueChanged = true
            }
        }
        
        
        if textValueChanged
        {
            saveButton.isUserInteractionEnabled = true
            saveButton.backgroundColor = UIColor.init(red: 249.0/255.0, green: 99.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        }
        else
        {
            saveButton.isUserInteractionEnabled = false
            self.saveButton.backgroundColor = UIColor.init(red: 229.0/255.0, green: 229.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        }
        

    }
	
	@IBAction func backTapped(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func updateTapped(_ sender: Any) {
		if(self.userModel != nil){
			
            let name = fullnameTextField.text ?? ""
            let email = emailTextField.text ?? ""
            if email.isEmpty {
                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter your email address")
            } else if !email.isValidEmail() {
                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter a valid email")
            } else if name.isEmpty
            {
                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter your name")
            }
            else
            {
                self.loader.show(in: self.view)
                ProfileDataSource().updateUser(username: name, email: email, bio: userModel.userBio ?? "", pictureUrl: userModel.pictureUrl ?? "") { (result) in
                    self.loader.dismiss()
                    switch(result){
                    case .success(let str):
                        print(str)
                        DispatchQueue.main.async {
                            let hud = JGProgressHUD(style: .dark)
                            hud.textLabel.text = "Updated Successfully"
                            hud.indicatorView = JGProgressHUDSuccessIndicatorView.init()
                            hud.show(in: self.view)
                            hud.dismiss(afterDelay: 1.0)
                        }
                       
                        self.navigationController?.popViewController(animated: true)
                        
                    case .failure(let err):
                        print(err.localizedDescription)
                        self.showErrorHud(message: "Error : Please try again")
                    }

                }
            }
            
		}
	}
	
	
}
extension BusinessProfileViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == fullnameTextField {
            
        }
        else if textField == emailTextField
        {
            
        }
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == fullnameTextField {

            if textField.text == userModel.username {

                print("Same username")
                if emailTextField.text == userModel.email {
                    textValueChanged = false
                }
                else
                {
                    textValueChanged = true
                }

            }
            else{

                textValueChanged = true
            }
        }
        else if textField == emailTextField
        {
            if textField.text == userModel.email {
                print("Same email")
                if fullnameTextField.text == userModel.username {
                    textValueChanged = false
                }
                else
                {
                    textValueChanged = true
                }

            }
            else{
                textValueChanged = true
            }
        }
        
        
        if textValueChanged
        {
            saveButton.isUserInteractionEnabled = true
            saveButton.backgroundColor = UIColor.init(red: 249.0/255.0, green: 99.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        }
        else
        {
            saveButton.isUserInteractionEnabled = false
            self.saveButton.backgroundColor = UIColor.init(red: 229.0/255.0, green: 229.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        }
        
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == fullnameTextField {

            if textField.text == userModel.username {

                print("Same username")
                if emailTextField.text == userModel.email {
                    textValueChanged = false
                }
                else
                {
                    textValueChanged = true
                }

            }
            else{

                textValueChanged = true
            }
        }
        else if textField == emailTextField
        {
            if textField.text == userModel.email {
                print("Same email")
                if fullnameTextField.text == userModel.username {
                    textValueChanged = false
                }
                else
                {
                    textValueChanged = true
                }

            }
            else{
                textValueChanged = true
            }
        }
        
        
        if textValueChanged
        {
            saveButton.isUserInteractionEnabled = true
            saveButton.backgroundColor = UIColor.init(red: 249.0/255.0, green: 99.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        }
        else
        {
            saveButton.isUserInteractionEnabled = false
            self.saveButton.backgroundColor = UIColor.init(red: 229.0/255.0, green: 229.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        }
        textField.resignFirstResponder()
        
        return true
    }
    
}
