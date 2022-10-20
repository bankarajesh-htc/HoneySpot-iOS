//
//  ProfileContactsViewController.swift
//  HoneySpot
//
//  Created by Max on 2/18/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
 

enum ContactListType: String {
    case FOLLOWERS_LIST = "Followers"
    case FOLLOWING_LIST = "Following"
}

class ProfileContactsViewController: UIViewController {

    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var listType: ContactListType = ContactListType.FOLLOWERS_LIST
    
    var userModel: UserModel!
    
    var followers = [UserModel]()
    var followings = [UserModel]()
    
    // Constants
    static let STORYBOARD_IDENTIFIER = "ProfileContactsViewController"
    static let PROFILE_CONTACT_TABLEVIEWCELL_IDENTIFER = "ProfileContactTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NSNotification.Name(.NOTIFICATION_SHOW_CONTACTS), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(followerChanged), name: NSNotification.Name(.NOTIFICATION_FOLLOWER_CHANGED), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //let parentVC: ProfileViewController = self.parent as! ProfileViewController
        //self.user = parentVC.user
        
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

    @objc func followerChanged(){
        switch self.listType {
        case .FOLLOWERS_LIST:
            onFollowersButtonTap()
            break
        case .FOLLOWING_LIST:
            onFollowingButtonTap()
            break
        }
    }
    
    // MARK: - Notification Handler
    @objc func handleNotification(_ notification: Notification?) {
        if let listType: ContactListType = notification?.userInfo?["LIST_TYPE"]  as? ContactListType {
            self.listType = listType
            self.view.isUserInteractionEnabled = true
            switch listType {
            case .FOLLOWERS_LIST:
                onFollowersButtonTap()
                break
            case .FOLLOWING_LIST:
                onFollowingButtonTap()
                break
            }
        }
    }
    
    func onFollowersButtonTap() {
        if AppDelegate.originalDelegate.isGuestLogin {
            if AppDelegate.originalDelegate.isFeedProfile {
                
                self.showLoadingHud()
                self.followers.removeAll()
                ProfileDataSource().getGuestFollower(userId: self.userModel.id) { (result) in
                    self.hideAllHuds()
                    
                    switch(result){
                    case .success(let users):
                        if users.count > 0 {
                            
                            self.tableView.isHidden = false
                            self.noDataLabel.isHidden = true
                            
                            self.followers = users
                            self.tableView.reloadData()
                        }
                        else
                        {
                            self.tableView.isHidden = true
                            self.noDataLabel.isHidden = false
                        }
                    case .failure(let err):
                        print(err)
                    }
                }
            }
            else if self.userModel.id == ""
            {
                
            }
            else
            {
                self.showLoadingHud()
                self.followers.removeAll()
                ProfileDataSource().getGuestFollower(userId: self.userModel.id) { (result) in
                    self.hideAllHuds()
                    
                    switch(result){
                    case .success(let users):
                        if users.count > 0 {
                            
                            self.tableView.isHidden = false
                            self.noDataLabel.isHidden = true
                            
                            self.followers = users
                            self.tableView.reloadData()
                        }
                        else
                        {
                            self.tableView.isHidden = true
                            self.noDataLabel.isHidden = false
                        }
                    case .failure(let err):
                        print(err)
                    }
                }
            }
            
        }
        else
        {
            self.showLoadingHud()
            self.view.isUserInteractionEnabled = false
            self.followers.removeAll()
            DispatchQueue.global().async {
                ProfileDataSource().getFollower(userId: self.userModel.id) { (result) in
                    switch(result){
                    case .success(let users):
                        DispatchQueue.main.async
                        {
                            if users.count > 0 {
                                
                                self.tableView.isHidden = false
                                self.noDataLabel.isHidden = true
                                
                                self.followers = users
                                self.tableView.reloadData()
                                self.view.isUserInteractionEnabled = true
                                self.hideAllHuds()
                            }
                            else
                            {
                                self.tableView.isHidden = true
                                self.noDataLabel.isHidden = false
                                self.view.isUserInteractionEnabled = true
                                self.hideAllHuds()
                            }
                        }
                        
                    case .failure(let err):
                        print(err)
                        self.view.isUserInteractionEnabled = true
                        self.hideAllHuds()
                    }
                }
            }
        }
    }
    
    
    func onFollowingButtonTap() {
        
        if AppDelegate.originalDelegate.isGuestLogin {
            if AppDelegate.originalDelegate.isFeedProfile {
                
                self.showLoadingHud()
                ProfileDataSource().getGuestFollowing(userId: self.userModel.id) { (result) in
                    self.hideAllHuds()
                    
                    switch(result){
                    case .success(let users):
                        if users.count > 0 {
                            self.followings.removeAll()
                            self.tableView.isHidden = false
                            self.noDataLabel.isHidden = true
                            
                            self.followings = users;
                            self.tableView.reloadData()
                        }
                        else
                        {
                            self.tableView.isHidden = true
                            self.noDataLabel.isHidden = false
                        }
                    case .failure(let err):
                        print(err)
                    }
                }
            }
            else if self.userModel.id == ""
            {
                
            }
            else
            {
                self.showLoadingHud()
                ProfileDataSource().getGuestFollowing(userId: self.userModel.id) { (result) in
                    self.hideAllHuds()
                    
                    switch(result){
                    case .success(let users):
                        if users.count > 0 {
                            self.followings.removeAll()
                            self.tableView.isHidden = false
                            self.noDataLabel.isHidden = true
                            
                            self.followings = users;
                            self.tableView.reloadData()
                        }
                        else
                        {
                            self.tableView.isHidden = true
                            self.noDataLabel.isHidden = false
                        }
                    case .failure(let err):
                        print(err)
                    }
                }
            }
        }
        
        else
        {
            self.showLoadingHud()
            self.view.isUserInteractionEnabled = false
            self.followings.removeAll()
            DispatchQueue.global().async {
                ProfileDataSource().getFollowing(userId: self.userModel.id) { (result) in
                    
                    
                    switch(result){
                    case .success(let users):
                        DispatchQueue.main.async
                        {
                            if users.count > 0 {
                                self.tableView.isHidden = false
                                self.noDataLabel.isHidden = true
                                
                                self.followings = users;
                                self.tableView.reloadData()
                                self.hideAllHuds()
                                self.view.isUserInteractionEnabled = true
                            }
                            else
                            {
                                self.hideAllHuds()
                                self.tableView.isHidden = true
                                self.noDataLabel.isHidden = false
                                self.view.isUserInteractionEnabled = true
                            }
                        }
                        
                    case .failure(let err):
                        print(err)
                        self.hideAllHuds()
                        self.view.isUserInteractionEnabled = true
                    }
                }
            }
            
        }
        
        
    }
    
    func reloadFollowers() {
        
        switch listType {
        case .FOLLOWERS_LIST:
            onFollowersButtonTap()
            break
        case .FOLLOWING_LIST:
            onFollowingButtonTap()
            break
        }
        let parentVC: ProfileViewController = self.parent as! ProfileViewController
        parentVC.followingChanged()
    }

}

extension ProfileContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch listType {
        case .FOLLOWERS_LIST:
            if followers.count == 0 {
                return 0
            }
            return followers.count
        case .FOLLOWING_LIST:
            if followings.count == 0 {
                return 0
            }
            return followings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // var data = emptyUserModel()
        switch listType {
        case .FOLLOWERS_LIST:
            if followers.count > 0 {
                let  data = followers[indexPath.row]
                
                let cell: ProfileContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: ProfileContactsViewController.PROFILE_CONTACT_TABLEVIEWCELL_IDENTIFER, for: indexPath) as! ProfileContactTableViewCell
                cell.userModel = data
                cell.delegate = self
                cell.listType = self.listType
                return cell
            }
            
        case .FOLLOWING_LIST:
            
            if followings.count > 0 {
                let data = followings[indexPath.row]
                
                let cell: ProfileContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: ProfileContactsViewController.PROFILE_CONTACT_TABLEVIEWCELL_IDENTIFER, for: indexPath) as! ProfileContactTableViewCell
                cell.userModel = data
                cell.delegate = self
                cell.listType = self.listType
                return cell
            }
            
        }
        return UITableViewCell()
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController: ProfileViewController = ProfileViewControllerInstance()
        switch listType {
        case .FOLLOWERS_LIST:
            viewController.userModel = followers[indexPath.row]
        case .FOLLOWING_LIST:
            viewController.userModel = followings[indexPath.row]
        }
        self.navigationController?.show(viewController, sender: nil)
    }
}

extension ProfileContactsViewController: ProfileContactTableViewCellDelegate {
    func didTapGuestFollow(_ sender: ProfileContactTableViewCell) {
        self.showAlert(title: "Want to Follow?")
    }
    
    func didTapFollowButton(_ sender: ProfileContactTableViewCell) {
        //self.showLoadingHud()
        self.view.isUserInteractionEnabled = false
        DispatchQueue.global().async {
            ProfileDataSource().followUser(userId: self.userModel!.id) { (result) in
                switch(result){
                case .success(let successStr):
                    //self.userModel!.followingCount! += 1
                    DispatchQueue.main.async
                    {
                        print(successStr)
                        self.reloadFollowers()
                        self.hideAllHuds()
                        self.view.isUserInteractionEnabled = true
                    }
                    
                case .failure(let err):
                    self.hideAllHuds()
                    self.view.isUserInteractionEnabled = true
                    print(err)
                }
            }
        }
        print(sender.userModel?.id)
        
        
    }
    func didTapUnFollowButton(_ sender: ProfileContactTableViewCell) {
        self.showLoadingHud()
        self.view.isUserInteractionEnabled = false
        print(sender.userModel?.id)
        DispatchQueue.global().async {
            ProfileDataSource().unfollowUser(userId: sender.userModel!.id) { (result) in
                switch(result){
                case .success(let successStr):
                    DispatchQueue.main.async
                    {
                        //self.userModel!.followingCount! -= 1
                        self.reloadFollowers()
                        self.hideAllHuds()
                        self.view.isUserInteractionEnabled = true
                        print(successStr)
                    }
                case .failure(let err):
                    print(err)
                    self.hideAllHuds()
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
        
    }
}
