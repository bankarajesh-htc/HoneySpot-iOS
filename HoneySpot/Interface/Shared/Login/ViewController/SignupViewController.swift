//
//  SignupViewController.swift
//  HoneySpot
//
//  Created by Max on 4/24/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    static let STORYBOARD_IDENTIFIER = "SignupViewController"
    
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var usernameTextField: TextField!
    @IBOutlet weak var fullnameTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        AppDelegate.originalDelegate.isSignUp = false
        // Do any additional setup after loading the view.
    }
    

    @IBAction func onSignupButtonTap(_ sender: Any) {
        
        var email = emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        email = String(email.filter { !" \n\t\r".contains($0) })
        var username = usernameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        username = String(username.filter { !" \n\t\r".contains($0) })
        let fullname = fullnameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if fullname.isEmpty {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter your full name")
        }
        else if fullname.isValidFullName(testStr: fullname) {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter valid full name")
        }
        else if email.isEmpty {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter your email address")
        } else if !email.isValidEmail() {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter a valid email")
        } else if username.isEmpty {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter your username")
        } else if !username.isValidUserName() {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter valid username")
        } else if password.isEmpty {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter password")
        } else if password.count < 6 {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Minimum password length is 6")
        } else {
            self.showLoadingHud()
            LoginDataSource().register(username: username, password: password, email: email, fullName: fullname) { (result) in
                self.hideAllHuds()
                switch(result){
                case .success(let successStr):
                    print(successStr!)
                    AppDelegate.originalDelegate.isGuestLogin = false
                    self.checkOnboarding()
                case .failure(let err):
                    print(err)
                    self.showErrorHud(message: err.errorMessage)
                }
            }
        }
    }
    
    @IBAction func onLoginButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkOnboarding(){
        if (UserDefaults.standard.bool(forKey: "isOnboardingShown")) {
            //UIViewController.APP_DELEGATE_INSTANCE.window?.rootViewController = .MAIN_VIEWCONTROLLER
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
        } else {
            self.performSegue(withIdentifier: "onboarding", sender: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
