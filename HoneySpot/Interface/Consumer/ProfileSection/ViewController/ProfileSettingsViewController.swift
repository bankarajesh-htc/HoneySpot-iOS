//
//  ProfileSettingsViewController.swift
//  HoneySpot
//
//  Created by htcuser on 25/01/22.
//  Copyright © 2022 HoneySpot. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SafariServices
import GoogleSignIn

protocol SettingsDelegate {
    func onToggleSwitch()
    
    
}

class ProfileSettingsViewController: UIViewController, SettingsDelegate {
    func onToggleSwitch() {
        self.showAlert(title: "Want to Turn On Notification")
    }
    

    static let STORYBOARD_IDENTIFIER = "ProfileSettingsViewController"
    var userModel : UserModel!
    var isTerms = false
    
    
    @IBOutlet var settingsTableView: UITableView!
    enum THEME_STYLE: Int {
        case STYLE1 = 0
        case STYLE2 = 1
        case STYLE3 = 2
        case STYLE4 = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userModel != nil {
            
        }
//        self.navigationController?.isNavigationBarHidden = false
//
//        self.navigationItem.titleView = navTitleLabel(withStyle: .STYLE4)
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "backIcon"), for: .normal)
//        button.imageView?.contentMode = .scaleAspectFit
//        button.tintColor = UIColor.black
//        button.addTarget(self, action: #selector(self.backButtonTapped), for: .touchUpInside)
//
//        let rightBarItem = UIBarButtonItem(customView: button)
//        rightBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
//        rightBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
//        rightBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
//        rightBarItem.tintColor = UIColor.black
//
//        self.navigationItem.leftBarButtonItem = rightBarItem
        
        settingsTableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    func navTitleLabel(withStyle style: THEME_STYLE) -> UILabel {
        let navLabel = UILabel()
        var navTitle: NSMutableAttributedString = NSMutableAttributedString(string: "HoneySpot")
        switch style {
        case .STYLE1, .STYLE2:
            navTitle = NSMutableAttributedString(string: "Honey", attributes:[
                NSAttributedString.Key.font: UIFont.fontMonsterratBold(withSize: 24),
                NSAttributedString.Key.foregroundColor: UIColor.ORANGE_COLOR])
            navTitle.append(NSMutableAttributedString(string: "Spot", attributes:[
                NSAttributedString.Key.font: UIFont.fontMonsterratBold(withSize: 24),
                NSAttributedString.Key.foregroundColor: UIColor.YELLOW_COLOR]))
            navigationController?.navigationBar.barTintColor = .WHITE_COLOR
            break
        case .STYLE3:
            navTitle = NSMutableAttributedString(string: "HoneySpot", attributes:[
                NSAttributedString.Key.font: UIFont.fontMonsterratBold(withSize: 25),
                NSAttributedString.Key.foregroundColor: UIColor.WHITE_COLOR])
            navigationController?.navigationBar.barTintColor = .ORANGE_COLOR
            break
        case .STYLE4:
            navTitle = NSMutableAttributedString(string: "Settings", attributes:[
                NSAttributedString.Key.font: UIFont.fontHelveticaBold(withSize: 23),
                NSAttributedString.Key.foregroundColor: UIColor.BLACK_COLOR])
            navigationController?.navigationBar.barTintColor = .WHITE_COLOR
            break
        }
        navLabel.attributedText = navTitle
        
        return navLabel
    }
    @objc func backButtonTapped(){
        
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.originalDelegate.isSettings = true
        AppDelegate.originalDelegate.isWishlist = false
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationItem.titleView = navTitleLabel(withStyle: .STYLE4)
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "backIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(self.backButtonTapped), for: .touchUpInside)
        
        let rightBarItem = UIBarButtonItem(customView: button)
        rightBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        rightBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        rightBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        rightBarItem.tintColor = UIColor.black
        
        self.navigationItem.leftBarButtonItem = rightBarItem
        
        getUser()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "webViewController"){
            let dest = segue.destination as! WebViewController
            if isTerms  {
                dest.termsOfServices()
            }
            else
            {
                dest.loadPrivacyPolicy()
            }
            
        }
    
    }
    
    func getUser()  {
        
        self.showLoadingHud()
        ProfileDataSource().getUser(userId: userModel.id) { (result) in
            switch(result){
            case .success(let user):
                var tempU = user
                tempU.amIFollow = self.userModel.doIFollow()
                self.userModel = tempU
                self.settingsTableView.reloadData()
                self.hideAllHuds()
                
            case .failure(let err):
                print(err)
                self.hideAllHuds()
            }
        }
        
    }

    @IBAction func onBackButtonTap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    func showAlert(title: String)  {
        
        let alert: UIAlertController = UIAlertController(
            title: title,
            message: "Sign in to make your opinion count",
            preferredStyle: .alert)
        
        //Add Buttons
        let yesButton: UIAlertAction = UIAlertAction(
            title: "SIGNIN",
            style: .default) { (action: UIAlertAction) in
            AppDelegate.originalDelegate.isLogin = true
            UIViewController.LOGIN_NAVIGATIONCONTROLLER.popToRootViewController(animated: false)
            UIViewController.APP_DELEGATE_INSTANCE.window?.rootViewController = .FIRST_LOGINCONTROLLER

        }
        
        let noButton: UIAlertAction = UIAlertAction(
            title: "CANCEL",
            style: .cancel) { (action: UIAlertAction) in
            
        }
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
        
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
extension ProfileSettingsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AppDelegate.originalDelegate.isGuestLogin {
            return 9
        }
        else
        {
            return 10
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCellId") as! BusinessSettingsInfoTableViewCell
            if AppDelegate.originalDelegate.isGuestLogin {
                
                cell.name.text = "Guest"
                cell.email.text = ""
                cell.member.text = ""
            }
            else
            {
                if userModel != nil {
                    cell.name.text = userModel.fullname
                    cell.email.text = userModel.email
                    cell.member.text = userModel.username
                    
                }
                else
                {
                    cell.name.text = "-"
                    cell.email.text = "-"
                    cell.member.text = "-"
                }
            }
            
            
            
            return cell
        }else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCellId") as! BusinessSettingsSwitchTableViewCell
            cell.img.image = UIImage(named: "businessNotf")
            cell.delegate = self
            cell.prepareCell()
            cell.titleLabel.text = "Notifications"
            return cell
        }else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! BusinessSettingsTableViewCell
            cell.img.image = UIImage(named: "inviteFriends")
            cell.upgradeButton.isHidden = true
            cell.titleLabel.text = "Invite Friends"
            return cell
        }
        else if(indexPath.row == 3){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! BusinessSettingsTableViewCell
            cell.img.image = UIImage(named: "saveToTry")
            cell.upgradeButton.isHidden = true
            cell.titleLabel.text = "Save to Try"
            return cell
        }else if(indexPath.row == 4){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! BusinessSettingsTableViewCell
            cell.img.image = UIImage(named: "businessEdit")
            cell.upgradeButton.isHidden = true
            cell.titleLabel.text = "Edit Profile"
            return cell
        }else if(indexPath.row == 5){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! BusinessSettingsTableViewCell
            cell.img.image = UIImage(named: "businessSignOut")
            cell.upgradeButton.isHidden = true
            if AppDelegate.originalDelegate.isGuestLogin {
                cell.titleLabel.text = "Sign In"
            }
            else
            {
                cell.titleLabel.text = "Sign Out"
            }
            
            return cell
        }else if(indexPath.row == 6){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! BusinessSettingsTableViewCell
            cell.img.image = UIImage(named: "shareProfile")
            cell.upgradeButton.isHidden = true
            cell.titleLabel.text = "Share Profile"
            return cell
        }
        else if(indexPath.row == 7){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! BusinessSettingsTableViewCell
            cell.img.image = UIImage(named: "businessTerms")
            cell.upgradeButton.isHidden = true
            cell.titleLabel.text = "Terms of Service"
            return cell
        }
        else if(indexPath.row == 8){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! BusinessSettingsTableViewCell
            cell.img.image = UIImage(named: "businessPrivacy")
            cell.upgradeButton.isHidden = true
            cell.titleLabel.text = "Privacy Policy"
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! BusinessSettingsTableViewCell
            cell.img.image = UIImage(named: "businessDelete")
            cell.upgradeButton.isHidden = true
            cell.titleLabel.text = "Delete Account"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 2){
            if AppDelegate.originalDelegate.isGuestLogin {
                let inviteFriends: InviteFriendsViewController = InviteFriendsViewControllerInstance()
                self.navigationController?.pushViewController(inviteFriends, animated: true)
            }
            else
            {
                let inviteFriends: InviteFriendsViewController = InviteFriendsViewControllerInstance()
                self.navigationController?.pushViewController(inviteFriends, animated: true)
            }
           
           
            
        } else if(indexPath.row == 3)
        {
            if AppDelegate.originalDelegate.isGuestLogin {
                
                self.showAlert(title: "Want to Wishlist your Favorite Restaurant")
            }
            else
            {
                let saveToTryController: SaveToTryViewController = SaveToTryViewControllerInstance()
                AppDelegate.originalDelegate.isSettings = true
                AppDelegate.originalDelegate.isWishlist = true
                self.navigationController?.pushViewController(saveToTryController, animated: true)
            }
            
            
        }
        else if(indexPath.row == 4){
            
            if AppDelegate.originalDelegate.isGuestLogin {
                self.showAlert(title: "Want to Create Profile?")
            }
            else
            {
                let profileEditViewController: ProfileEditViewController = ProfileEditViewControllerInstance()
                profileEditViewController.userModel = self.userModel
                self.navigationController?.pushViewController(profileEditViewController, animated: true)
            }
            
            
            
        }else if(indexPath.row == 5){
            
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
                let alert: UIAlertController = UIAlertController(
                    title: "SignOut Your Account",
                    message: "Are you sure you want to signout?",
                    preferredStyle: .alert)
                
                //Add Buttons
                let yesButton: UIAlertAction = UIAlertAction(
                    title: "Ok",
                    style: .default) { (action: UIAlertAction) in
                        
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
                
                let noButton: UIAlertAction = UIAlertAction(
                    title: "Cancel",
                    style: .cancel) { (action: UIAlertAction) in
                }
                
                alert.addAction(yesButton)
                alert.addAction(noButton)
                present(alert, animated: true, completion: nil)
                
            }
           
        }else if(indexPath.row == 6){
            if AppDelegate.originalDelegate.isGuestLogin
            {
                self.showAlert(title: "Want to share your profile?")
            }
            else
            {
                let text = "I Honeyspotted a restaurant in Honeyspot App!. You can see it from -> https://honeyspotapp.app.link/profile?$custom_data=\(UserDefaults.standard.string(forKey: "userId") ?? "")"
                let image = UIImage(named: "avatarImage")
                let shareAll = [text , image!] as [Any]
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
            
            
        }else if(indexPath.row == 7){
            
            isTerms = true
            self.performSegue(withIdentifier: "webViewController", sender: nil)

        }
        else if(indexPath.row == 8){
            
            isTerms = false
            self.performSegue(withIdentifier: "webViewController", sender: nil)
            
        }
        else if(indexPath.row == 9){
            
            if AppDelegate.originalDelegate.isGuestLogin {
                
                self.showAlert(title: "HoneySpot")
            }
            else
            {
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
            
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 90
        }else if(indexPath.row == 1){
            return 75
        }else{
            return 75
        }
    }
    
}
