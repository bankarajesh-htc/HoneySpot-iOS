//
//  AdminLoginViewController.swift
//  HoneySpot
//
//  Created by htcuser on 02/01/22.
//  Copyright © 2022 HoneySpot. All rights reserved.
//

import UIKit



class AdminLoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func onLoginButtonTap(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if username.isEmpty {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter your email or username")
        } else if password.isEmpty {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter password")
        } else {
            showLoadingHud()
            self.showLoadingHud()
            AdminDatasource().login(usernameOrEmail: username, password: password) { (result) in
                switch(result){
                case .success(let successStr):
                    print(successStr!)
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
