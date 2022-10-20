////
////  FollowSocialAccountFriendsViewController.swift
////  HoneySpot
////
////  Created by Max on 3/1/19.
////  Copyright © 2019 HoneySpot. All rights reserved.
////
//
//import UIKit
//
//class FollowSocialAccountFriendsViewController: UIViewController {
//
//
//    @IBOutlet weak var descriptionLabel: UILabel!
//    @IBOutlet weak var selectAllButton: UIButton!
//    @IBOutlet weak var tableView: UITableView!
//
//    var socialFriendsOnApp: [User] = []
//    var isFacebookLogin: Bool = false
//    var isInstagramLogin: Bool = false
//    var selectedArray: [Bool] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if #available(iOS 13.0, *) {
//            overrideUserInterfaceStyle = .light
//        }
//        // Do any additional setup after loading the view.
//        if isFacebookLogin {
//            descriptionLabel.text = "Follow your Facebook friends to see what they are doing."
//        } else if isInstagramLogin {
//            descriptionLabel.text = "Follow your Instagram friends to see what they are doing."
//        }
//
//        // Select All Items
//        selectedArray = [Bool](repeating: true, count: socialFriendsOnApp.count)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        tableView.reloadData()
//        selectAllButton.setTitle("DESELECT ALL", for: .normal)
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    @IBAction func onSelectAllTap(_ sender: Any) {
//        // Check if all items are selected
//        if self.allItemsSelected() {
//            // Deselect All
//            self.selectedArray = [Bool](repeating: false, count: socialFriendsOnApp.count)
//            selectAllButton.setTitle("SELECT ALL", for: .normal)
//            tableView.reloadData()
//            return
//        }
//
//        // Mark all as true if any of the items are deselected
//        self.selectedArray = [Bool](repeating: true, count: socialFriendsOnApp.count)
//        selectAllButton.setTitle("DESELECT ALL", for: .normal)
//        tableView.reloadData()
//    }
//
//    @IBAction func onFollowTap(_ sender: Any) {
//        showLoadingHud()
//        let friendsSelected: [User] = zip(selectedArray, socialFriendsOnApp).filter { $0.0 }.map { $1 }
//        var friendsToFollow: [User] = []
//        for friend in friendsSelected {
//            let friends = AppManager.sharedInstance.currentUser?.followingUsers.filter { $0.objectId == friend.objectId }
//            if friends?.count == 0 {
//                friendsToFollow.append(friend)
//            }
//        }
//
//        AppManager.sharedInstance.currentUser?.followingUsers += friendsToFollow
//
//        for friend in friendsToFollow {
//            let f: Follow = Follow(fromUser: AppManager.sharedInstance.currentUser!, toUser: friend)
//            do {
//                try f.save()
//            } catch {
//                print("Error saving new follow object \(error)")
//            }
//        }
//
//        self.hideAllHuds()
//        self.checkOnboarding()
//    }
//
//    // Returns true if all items are selected otherwise return false
//    func allItemsSelected() -> Bool {
//        return self.selectedArray.filter{ $0 == false }.count == 0
//    }
//
//    func checkOnboarding(){
//        if (UserDefaults.standard.bool(forKey: "isOnboardingShown")) {
//            UIViewController.APP_DELEGATE_INSTANCE.window?.rootViewController = .MAIN_VIEWCONTROLLER
//        } else {
//            self.performSegue(withIdentifier: "onboarding", sender: nil)
//        }
//    }
//}
//
//extension FollowSocialAccountFriendsViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: SocialAccountFriendTableViewCell = tableView.dequeueReusableCell(withIdentifier: SocialAccountFriendTableViewCell.CELL_IDENTIFIER, for: indexPath) as! SocialAccountFriendTableViewCell
//        cell.user = self.socialFriendsOnApp[indexPath.row]
//        cell.shouldFollow = self.selectedArray[indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.socialFriendsOnApp.count
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 85
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        self.selectedArray[indexPath.row] = !self.selectedArray[indexPath.row]
//        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
//        if allItemsSelected() {
//            selectAllButton.setTitle("DESELECT ALL", for: .normal)
//        } else {
//            selectAllButton.setTitle("SELECT ALL", for: .normal)
//        }
//    }
//}
