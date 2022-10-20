//
//  BusinessLoginViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 30.06.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit

class BusinessLoginViewController: UIViewController {

	@IBOutlet var usernameOrEmailField: TextField!
	@IBOutlet var passwordField: TextField!
	
	override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        // Do any additional setup after loading the view.
    }
	
	@IBAction func backTapped(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
    @IBAction func adminloginTapped(_ sender: Any) {
        
        let username = "admin@admin.com"
        let password = "admin"
        
        let adminAuthToken = UserDefaults.standard.string(forKey: "adminauthToken")
        if (adminAuthToken == nil || adminAuthToken == "") {
            // show login page if user is not logged in
            //self.performSegue(withIdentifier: "login", sender: nil)
            self.showLoadingHud()
            AdminDatasource().login(usernameOrEmail: username, password: password) { (result) in
                switch(result){
                case .success(let successStr):
                    print(successStr!)
                    AppDelegate.originalDelegate.isGuestLogin = false
                    self.hideAllHuds()
                    let viewController = self.AdminViewControllerInstance()
                    self.navigationController?.pushViewController(viewController, animated: true)
                case .failure(let err):
                    print(err.errorMessage)
                    self.hideAllHuds()
                    self.showErrorHud(message: err.errorMessage)
                }
            }
        }
        else
        {
            AppDelegate.originalDelegate.isGuestLogin = false
            let viewController = self.AdminViewControllerInstance()
            self.navigationController?.pushViewController(viewController, animated: true)
           
        }
        
    }
	@IBAction func loginTapped(_ sender: Any) {
        let username = usernameOrEmailField.text ?? ""
        let password = passwordField.text ?? ""
        
        if username.isEmpty {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter your email or username")
        } else if password.isEmpty {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter password")
        } else {
            showLoadingHud()
            BusinessLoginDataSource().login(usernameOrEmail: username, password: password) { (result) in
                
                switch(result){
                case .success(let successStr):
                    print(successStr!)
                    AppDelegate.originalDelegate.isGuestLogin = false
                    
                    if AppDelegate.originalDelegate.isAdminLogin {
                        
                        self.showAdminOrBusiness(title: "HoneySpot")
                    }
                    else
                    {
                        BusinessRestaurantDataSource().getClaims { (result) in
                            switch(result){
                            case .success(let claims):
                                self.usernameOrEmailField.text = ""
                                self.passwordField.text = ""
                                if(claims.count > 0){
                                    self.hideAllHuds()
                                    
                                    self.performSegue(withIdentifier: "start", sender: nil)
                                }else{
                                    self.hideAllHuds()
                                    self.performSegue(withIdentifier: "lets", sender: nil)
                                }
                            case .failure(let err):
                                self.usernameOrEmailField.text = ""
                                self.passwordField.text = ""
                                self.hideAllHuds()
                                self.performSegue(withIdentifier: "lets", sender: nil)
                            }
                        }
                    }
                case .failure(let err):
                    print(err.errorMessage)
                    self.hideAllHuds()
                    self.showErrorHud(message: err.errorMessage)
                }
                
            }
        }
	}
	
	@IBAction func forgetPasswordTapped(_ sender: Any) {
	}
    
    func showAdminOrBusiness(title: String)  {
        
        let alert: UIAlertController = UIAlertController(
            title: title,
            message: "How do you wish to login?",
            preferredStyle: .alert)
        
        //Add Buttons
        let yesButton: UIAlertAction = UIAlertAction(
            title: "BUSINESS",
            style: .default) { (action: UIAlertAction) in
                BusinessRestaurantDataSource().getClaims { (result) in
                    switch(result){
                    case .success(let claims):
                        self.usernameOrEmailField.text = ""
                        self.passwordField.text = ""
                        if(claims.count > 0){
                            self.hideAllHuds()
                            
                            self.performSegue(withIdentifier: "start", sender: nil)
                        }else{
                            self.hideAllHuds()
                            self.performSegue(withIdentifier: "lets", sender: nil)
                        }
                    case .failure(let err):
                        self.usernameOrEmailField.text = ""
                        self.passwordField.text = ""
                        self.hideAllHuds()
                        self.performSegue(withIdentifier: "lets", sender: nil)
                    }
                }
        }
        
        let noButton: UIAlertAction = UIAlertAction(
            title: "ADMIN",
            style: .cancel) { (action: UIAlertAction) in
                
                let appDomain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
                UserDefaults.standard.synchronize()
                print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
            
                let username = "admin@admin.com"
                let password = "admin"
                
                let adminAuthToken = UserDefaults.standard.string(forKey: "adminauthToken")
                if (adminAuthToken == nil || adminAuthToken == "") {
                    // show login page if user is not logged in
                    //self.performSegue(withIdentifier: "login", sender: nil)
                    self.showLoadingHud()
                    AdminDatasource().login(usernameOrEmail: username, password: password) { (result) in
                        switch(result){
                        case .success(let successStr):
                            print(successStr!)
                            AppDelegate.originalDelegate.isGuestLogin = false
                            self.hideAllHuds()
                            let viewController = self.AdminViewControllerInstance()
                            self.navigationController?.pushViewController(viewController, animated: true)
                        case .failure(let err):
                            print(err.errorMessage)
                            self.hideAllHuds()
                            self.showErrorHud(message: err.errorMessage)
                        }
                    }
                }
                else
                {
                    AppDelegate.originalDelegate.isGuestLogin = false
                    let viewController = self.AdminViewControllerInstance()
                    self.navigationController?.pushViewController(viewController, animated: true)
                   
                }
        }
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
        
    }

}
