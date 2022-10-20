//
//  LoginViewController.swift
//  HoneySpot
//
//  Created by Max on 2/7/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import FBSDKLoginKit
 
import Alamofire
import GoogleSignIn

class LoginViewController: UIViewController,GIDSignInDelegate {
    
    @IBOutlet weak var usernameTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.hideAllHuds()
        
        if AppDelegate.originalDelegate.isSignUp {
            self.navigationController?.pushViewController(SignupViewControllerInstance(), animated: true)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.usernameTextField.text = ""
        self.passwordTextField.text = ""
    }
    @IBAction func onGuestLoginButtonTap(_ sender: Any) {
        AppDelegate.originalDelegate.isGuestLogin = true
        self.performSegue(withIdentifier: "onboarding", sender: nil)
        //checkOnboarding()
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
            LoginDataSource().login(usernameOrEmail: username, password: password) { (result) in
                
                switch(result){
                case .success(let successStr):
                    print(successStr!)
                    AppDelegate.originalDelegate.isGuestLogin = false
                    self.hideAllHuds()
                    self.usernameTextField.text = ""
                    self.passwordTextField.text = ""
                    self.checkOnboarding()
                case .failure(let err):
                    print(err.errorMessage)
                    self.hideAllHuds()
                    self.showErrorHud(message: err.errorMessage)
                }
            }
        }
    }
    
    @IBAction func onForgotPasswordButtonTap(_ sender: Any) {
        self.navigationController?.pushViewController(ForgotPasswordViewControllerInstance(), animated: true)
    }
    
    @IBAction func onSignupButtonTap(_ sender: Any) {
        self.navigationController?.pushViewController(SignupViewControllerInstance(), animated: true)
    }
    
    
    @IBAction func onLoginFacebookTap(_ sender: Any) {
        let loginManager = LoginManager.init()
        showLoadingHud()
        // Logout first to prevent some bugs related with previous login
        loginManager.logOut()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let err = error {
                print("\(err)")
                DispatchQueue.main.async {
                    self.hideAllHuds()
                    self.showInformationHud(message: "\(err)")
                }
                return
            }
            self.processFacebookLogin()
        }
    }
    
    @IBAction func onLoginInstagramTap(_ sender: Any) {
        showLoadingHud()
        let viewController = InstagramAuthViewControllerInstance()
        viewController.isModalInPopover = false
        viewController.authResult = { (_ accessToken: String?) in
            guard let accessToken = accessToken else {
                self.hideAllHuds()
                self.showErrorHud(message: "Failed to retrieve instagram access token")
                return
            }
            self.processInstagramLogin(withAccessToken: accessToken)
        }
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func onLoginGoogleTapped(_ sender: Any) {
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
	
	@IBAction func businessLoginTapped(_ sender: Any) {
		if(UserDefaults.standard.bool(forKey: "isBusinessOnboardingShown")){
			self.performSegue(withIdentifier: "businessLogin", sender: nil)
		}else{
			self.performSegue(withIdentifier: "businessOnboarding", sender: nil)
		}
	}
	
	
	
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID ?? ""
        let idToken = user.authentication.idToken ?? ""
        let fullName = user.profile.name ?? ""
        let givenName = user.profile.givenName ?? ""
        let userImage = user.profile.imageURL(withDimension: 200)?.absoluteString ?? ""
        
        LoginDataSource().loginWithForeign(foreignUserId: userId, username: givenName, password: "", foreignUsername: givenName, fullName: fullName, userImageUrl: userImage, foreignToken: idToken) { (result) in
            self.hideAllHuds()
            switch(result){
            case .success(let isNew):
                AppDelegate.originalDelegate.isGuestLogin = false
                if(isNew){
                    self.checkOnboarding()
                }else{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                    (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
                    //self.checkOnboarding()
                }
            case .failure(let err):
                print(err)
                self.showErrorHud(message: err.errorMessage)
            }
        }
        
    }
    
    // MARK: - Facebook Auth
    func processFacebookLogin() {
        GraphRequest(graphPath: "me").start { (connection, result, error) in
            if let error = error {
                print("\(error)")
                DispatchQueue.main.async {
                    self.hideAllHuds()
                    self.showErrorHud(message: error.localizedDescription)
                }
                return
            }
            
            guard let userData = result as? [String : Any] else {
                return
            }
            
            let accessToken = AccessToken.current?.tokenString ?? ""
            let fbUserID: String = AccessToken.current?.userID ?? ""
            let userID = "FBK\(fbUserID)"
            let name = userData["name"] as? String ?? ""
            let userImageURL = "https://graph.facebook.com/\(fbUserID)/picture?type=large"
            
            LoginDataSource().loginWithForeign(foreignUserId: userID, username: name, password: "", foreignUsername: name, fullName: name, userImageUrl: userImageURL, foreignToken: accessToken) { (result) in
                self.hideAllHuds()
                switch(result){
                case .success(let isNew):
                    AppDelegate.originalDelegate.isGuestLogin = false
                    if(isNew){
                        self.checkOnboarding()
                    }else{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
                        //self.checkOnboarding()
                    }
                case .failure(let err):
                    print(err)
                    self.showErrorHud(message: err.errorMessage)
                }
            }
        }
    }
    
    // MARK: - Instagram Auth
    func processInstagramLogin(withAccessToken accessToken: String) {
        let urlString: String = String(format: .INSTAGRAM_API_GET_USER, accessToken)
        AF.request(urlString).responseJSON(completionHandler: { (response) in
            guard response.error == nil else {
                self.hideAllHuds()
                self.showErrorHud(message: "Error calling Instagram get User API\(response.error?.localizedDescription ?? "")")
                print("Error calling Instagram get User API", response.error!)
                return
            }
                    
            guard let json = response.value as? [String: Any] else {
                print("Didn't get proper json response from API")
                if let error = response.error {
                    self.hideAllHuds()
                    self.showErrorHud(message: "Didn't get proper json response from API\(response.error?.localizedDescription ?? "")")
                    print (error)
                }
                return
            }
            
            guard let data = json["data"] as? [String : Any] else {
                return
            }
            let userID = data["id"] as? String ?? ""
            let instaUserID = "IGM\(userID)"
            let username = data["username"] as? String ?? ""
            let full_name = data["full_name"] as? String ?? ""
            let userImageURL = data["profile_picture"] as? String ?? ""
               
            LoginDataSource().loginWithForeign(foreignUserId: instaUserID, username: username, password: "", foreignUsername: username, fullName: full_name, userImageUrl: userImageURL, foreignToken: accessToken) { (result) in
                self.hideAllHuds()
                switch(result){
                case .success(let isNew):
                    AppDelegate.originalDelegate.isGuestLogin = false
                    if(isNew){
                        self.checkOnboarding()
                    }else{
                        //self.checkOnboarding()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
                    }
                case .failure(let err):
                    print(err)
                    self.showErrorHud(message: err.errorMessage)
                }
                //User.followInfluencers()
            }
            
        })
    }
    
    func checkOnboarding(){
        if (UserDefaults.standard.bool(forKey: "isLogin"))
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
            //UIViewController.APP_DELEGATE_INSTANCE.window?.rootViewController = .MAIN_VIEWCONTROLLER
        }
        else
        {
            if (UserDefaults.standard.bool(forKey: "isOnboardingShown")) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
            } else {
                self.performSegue(withIdentifier: "onboarding", sender: nil)
            }
        }
        
    }
    
//    func findInstagramFollows(completion: @escaping (_ instagramFriendsOnApp: [User], _ errorMsg: String?) -> Void) {
//        var instagramFriends: [User] = []
//
//
//        let params = ["fields": "id"]
//        let graphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: params)
//        graphRequest?.start(completionHandler: { (connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
//            if let error = error {
//                completion([], "Error getting facebook friends \(error)")
//                return
//            }
//            guard let result = result as? [String: Any] else {
//                print("No facebook friends using this app")
//                completion([], nil)
//                return
//            }
//
//            let friendsArray = result["data"] as? [[String: String]]
//            for friend in friendsArray ?? [] {
//                if let fbUserID = friend["id"] {
//                    let foreignUserID = "FBK\(fbUserID)"
//                    let q: PFQuery? = User.query()
//                    q?.whereKey("foreignUserId", equalTo: foreignUserID)
//                    do {
//                        let user: User? = try q?.getFirstObject() as? User
//                        if let user = user {
//                            facebookFriends.append(user)
//                        }
//                    } catch {
//                        print("Exception in finding a user with foreignUserId - \(foreignUserID): \(error)")
//                    }
//                }
//            }
//            // Friends who are both HoneySpot User & Facebook Friend Retrieved
//            completion(facebookFriends, nil)
//        })
//    }

}
