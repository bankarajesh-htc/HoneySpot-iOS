//
//  FirstLoadingViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 11.05.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class FirstLoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.navigationController?.navigationBar.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkUser()
    }
    
    
    
    func checkUser(){
        // Decide Root View Controller
        let authToken = UserDefaults.standard.string(forKey: "authToken")
        if (authToken == nil || authToken == "") {
            // show login page if user is not logged in
            if AppDelegate.originalDelegate.isGuestLogin && !AppDelegate.originalDelegate.isLogin {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
                //self.performSegue(withIdentifier: "main", sender: nil)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
                (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginNavController)
                
            }
            
        } else {
			if(UserDefaults.standard.bool(forKey: "isBusiness")){
				BusinessRestaurantDataSource().getClaims { (result) in
					switch(result){
					case .success(let claims):
						if(claims.count > 0){
							var isVerified = false
							for c in claims {
								if(c.isVerified){
									isVerified = true
								}
							}
							if(isVerified){
								self.performSegue(withIdentifier: "businessMain", sender: nil)
							}else{
								self.performSegue(withIdentifier: "verification", sender: nil)
							}
						}else{
							self.performSegue(withIdentifier: "login", sender: nil)
						}
					case .failure(let err):
						print(err.localizedDescription)
						self.performSegue(withIdentifier: "login", sender: nil)
					}
				}
			}
            else{
                AppDelegate.originalDelegate.isGuestLogin = false
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
                
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
