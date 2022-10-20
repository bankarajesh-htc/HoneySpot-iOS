//
//  ForgotPasswordViewController.swift
//  HoneySpot
//
//  Created by Max on 4/26/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
 

class ForgotPasswordViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: TextField!
    
    static let STORYBOARD_IDENTIFIER = "ForgotPasswordViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
        LoginDataSource().forgetPassword(email: email) { (result) in
            self.hideAllHuds()
            switch(result){
            case .success(let str):
                self.performSegue(withIdentifier: "reset", sender: nil)
            case .failure(let err):
                HSAlertView.showAlert(withTitle: "Error", message: err.errorMessage)
            }
        }
//        PFUser.requestPasswordResetForEmail(inBackground: email) { (success: Bool, error: Error?) in
//            if success {
//                HSAlertView.showAlert(withTitle: "Success", message: "Success! Check your email!")
//            } else {
//                guard let _ = error else {
//                    HSAlertView.showAlert(withTitle: "Error", message: "Cannot complete request. Please try again later.")
//                    return
//                }
//                HSAlertView.showAlert(withTitle: "Error", message: "Cannot complete request. Is your email address correct?")
////                HSAlertView.showAlert(withTitle: "Error", message: "Cannot complete request. Please try again later. \(error)")
//            }
//        }
    }
    
    
}
