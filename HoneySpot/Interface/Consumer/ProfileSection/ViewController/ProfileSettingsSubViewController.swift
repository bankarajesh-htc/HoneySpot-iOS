//
//  ProfileSettingsSubViewController.swift
//  HoneySpot
//
//  Created by Max on 2/18/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SafariServices
import GoogleSignIn

class ProfileSettingsSubViewController: UIViewController {

    @IBOutlet weak var notfSwitch: UISwitch!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet var profileStackView: UIStackView!
    @IBOutlet var termsStackView: UIStackView!
    @IBOutlet var guestStackView: UIStackView!
    
    @IBOutlet weak var inviteFriendsButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var saveToTryButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var shareProfileButton: UIButton!
    
    
    var profileId = ""
    
    static let STORYBOARD_IDENTIFIER = "ProfileSettingsSubViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        if AppDelegate.originalDelegate.isGuestLogin
        {
            showGuestLoginDetails()
        }
        else
        {
            // Normal Login
            guestStackView.isHidden = true
            profileStackView.isHidden = false
            termsStackView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
            self.notfSwitch.isOn = true
        } else {
             self.notfSwitch.isOn = false
        }
    }
    
    func showGuestLoginDetails()  {
    
        guestStackView.isHidden = false
        profileStackView.isHidden = true
        termsStackView.isHidden = true
//        termsStackView.isHidden = true
//        editProfileButton.isHidden = true
//        saveToTryButton.isHidden = true
//        shareProfileButton.isHidden = true
//        notfSwitch.isHidden = true
//        notificationLabel.isHidden = true
//        signOutButton.setTitle("SignIn", for: .normal)
        
    }
    
    @IBAction func onYourContactsTap(_ sender: Any) {
        let parentVC: ProfileViewController = self.parent as! ProfileViewController
        AppDelegate.originalDelegate.isEditProfile = true
        parentVC.navigationController?.pushViewController(InviteFriendsViewControllerInstance(), animated: true)
    }
    
    @IBAction func onSaveToTryTap(_ sender: Any) {
        let parentVC: ProfileViewController = self.parent as! ProfileViewController
        AppDelegate.originalDelegate.isWishlist = true
        AppDelegate.originalDelegate.isEditProfile = true
        parentVC.navigationController?.pushViewController(FeedViewControllerInstance(), animated: true)
    }
    
    @IBAction func onEditProfileTap(_ sender: Any) {
        let parentVC: ProfileViewController = self.parent as! ProfileViewController
        parentVC.updateView(viewToChoose: .EDIT_VIEW)
    }
    @IBAction func onShareProfileTap(_ sender: Any) {
        //let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        let text = "I Honeyspotted a restaurant in Honeyspot App!. You can see it from -> https://honeyspotapp.app.link/profile?$custom_data=\(UserDefaults.standard.string(forKey: "userId") ?? "")"
        let image = UIImage(named: "avatarImage")
        let shareAll = [text , image!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onSignOutTap(_ sender: Any) {
        
        if AppDelegate.originalDelegate.isGuestLogin
        {
            let appDomain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            AppDelegate.originalDelegate.isGuestLogin = false
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNavController = storyboard.instantiateViewController(identifier: "RootNavigationController")
            //self.navigationController?.setViewControllers([loginNavController], animated: true)
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginNavController)
            
            
        }
        else
        {
            self.showLoadingHud()
            let loginManager = LoginManager()
            loginManager.logOut()
            GIDSignIn.sharedInstance().signOut()
            ProfileDataSource().signOutUser { (result) in
                self.hideAllHuds()
                switch(result){
                case .success(let successStr):
                    print(successStr)
                    self.hideAllHuds()
                    
                    
                    
                    let appDomain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    UserDefaults.standard.synchronize()
                    print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
                    AppDelegate.originalDelegate.isLogout = true
                    

                    
//                    //self.dismiss(animated: true, completion: nil)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginNavController = storyboard.instantiateViewController(identifier: "RootNavigationController")
                    //self.navigationController?.setViewControllers([loginNavController], animated: true)
                    (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginNavController)


                case .failure(let err):
                    self.hideAllHuds()
                    print(err)
                }
            }
            
        }
        
    }

    @IBAction func onPrivacyPolicyTap(_ sender: Any) {
        guard let c = WebViewController.privacyPolicyController() else {
            return
        }
		c.titleStr = "PRIVACY POLICY"
        self.presentOnRoot(with: c)
    }
    
    @IBAction func onTermsOfServiceTap(_ sender: Any) {
        guard let c = WebViewController.termsOfServiceController() else {
            return
        }
		c.titleStr = "TERMS OF SERVICE"
        self.presentOnRoot(with: c)
    }
    
    @IBAction func onDeleteTap(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(
            title: "Delete Your Account",
            message: "Are you sure you want to delete your account ? This action is not revertable",
            preferredStyle: .alert)
        
        //Add Buttons
        let yesButton: UIAlertAction = UIAlertAction(
            title: "Delete",
            style: .default) { (action: UIAlertAction) in
                self.showLoadingHud()
                ProfileDataSource().deleteUser { (result) in
                    self.hideAllHuds()
                    switch(result){
                    case .success(let successStr):
                        print(successStr)
                        let loginManager = LoginManager()
                        loginManager.logOut()
                        GIDSignIn.sharedInstance().signOut()
                        //GIDSignIn.sharedInstance().disconnect()

                        let appDomain = Bundle.main.bundleIdentifier!
                        UserDefaults.standard.removePersistentDomain(forName: appDomain)
                        UserDefaults.standard.synchronize()
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let loginNavController = storyboard.instantiateViewController(identifier: "RootNavigationController")
                        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginNavController)
                    case .failure(let err):
                        print(err)
                    }
                }
        }
        
        let noButton: UIAlertAction = UIAlertAction(
            title: "Cancel",
            style: .cancel) { (action: UIAlertAction) in
        }
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func notfValueChanged(_ sender: Any) {
        if(notfSwitch.isOn){
            notfSwitch.thumbTintColor = notfSwitch.isOn ? UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            UIApplication.shared.registerForRemoteNotifications()
        }
        else{
            notfSwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            notfSwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
            UIApplication.shared.unregisterForRemoteNotifications()
        }
        
    }
    
    
}
extension UIViewController {
    func dismissMe(animated: Bool, completion: (()->())?) {
        var count = 0
        if let c = self.navigationController?.viewControllers.count {
            count = c
        }
        if count > 1 {
            self.navigationController?.popViewController(animated: animated)
            if let handler = completion {
                handler()
            }
        } else {
            dismiss(animated: animated, completion: completion)
        }
    }
}
