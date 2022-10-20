//
//  NotificationViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 18.06.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
 

class NotificationViewController: UIViewController {

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet var noDataLabel: UILabel!
    var notifications = [NotificationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func navTitleLabel(withStyle style: Int) -> UILabel {
        let navLabel = UILabel()
        var navTitle: NSMutableAttributedString = NSMutableAttributedString(string: "HoneySpot")
        navTitle = NSMutableAttributedString(string: "Honey", attributes:[
            NSAttributedString.Key.font: UIFont.fontMonsterratBold(withSize: 24),
            NSAttributedString.Key.foregroundColor: UIColor.ORANGE_COLOR])
        navTitle.append(NSMutableAttributedString(string: "Spot", attributes:[
            NSAttributedString.Key.font: UIFont.fontMonsterratBold(withSize: 24),
            NSAttributedString.Key.foregroundColor: UIColor.YELLOW_COLOR]))
        navigationController?.navigationBar.barTintColor = .WHITE_COLOR
        navLabel.attributedText = navTitle
        return navLabel
    }
    
    @IBAction func onBackTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.applicationIconBadgeNumber = 0
        //self.navigationController?.isNavigationBarHidden = true
        
        fetchNotifications()
    }
    
    func fetchNotifications(){
        showLoadingHud()
        NotificationDataSource().getNotifications { (result) in
            self.hideAllHuds()
            switch(result){
            case .success(let notifications):
                self.notifications = notifications
                
                DispatchQueue.main.async {
                    if(self.notifications.count > 0){
                        //self.emptyView.isHidden = true
                        self.noDataLabel.isHidden = true
                    }else{
                        //self.emptyView.isHidden = false
                        self.noDataLabel.isHidden = false
                        self.noDataLabel.text = "You don't have any notifications"
                    }
                }
                
                self.notificationTableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                     self.readAllNotifications()
                })
            case .failure(let err):
                print(err.errorMessage)
            }
        }
    }
    
    func readAllNotifications(){
        NotificationDataSource().updateNotifications()
    }


}

extension NotificationViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}

extension NotificationViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NotificationDataSource().deleteNotification(id: notifications[indexPath.row].feedid)
            notifications.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! NotificationTableViewCell
        //cell.avatarView.userModel = notifications[indexPath.row].user
        
        cell.topLabel.text = notifications[indexPath.row].spotSaveModel.spot.name
        cell.descriptionLabel.text = notifications[indexPath.row].feedtitle
//        if(notifications[indexPath.row].type == "Like"){
//            cell.descriptionLabel.text = (notifications[indexPath.row].user.fullname ?? "") + " liked your spot"
//        }else if(notifications[indexPath.row].type == "Comment"){
//            cell.descriptionLabel.text = (notifications[indexPath.row].user.fullname ?? "") + " commented your post"
//        }else if(notifications[indexPath.row].type == "Follow"){
//            cell.descriptionLabel.text = (notifications[indexPath.row].user.fullname ?? "") + " followed you"
//        }
        
        cell.index = indexPath.row
        cell.superVc = self
        cell.selectionStyle = .none
        
//        if(notifications[indexPath.row].isRead){
//            cell.notificationReadView.isHidden = true
//        }else{
//            cell.notificationReadView.isHidden = false
//        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notificationModel = notifications[indexPath.row]
        let announcementModel = AnnouncementListModel(create_date: notificationModel.create_date, description: notificationModel.feeddescription, end_date: notificationModel.end_date, announcementId: 0, imageurl: notificationModel.imageurl, postedby: notificationModel.postedby ?? 0, spotid: Int(notificationModel.spotSaveModel.spot.id) ?? 0, title: notificationModel.feedtitle)
        
        let viewController = self.AnnouncementViewControllerInstance()
        viewController.announcementModel = announcementModel
        viewController.isFromNotification = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func imageTapped(index : Int){
        let data = notifications[index]
        let viewController: ProfileViewController = ProfileViewControllerInstance()
        viewController.userModel = data.user
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.show(viewController, sender: nil)
    }
    
    func nameTapped(index : Int){
        let data = notifications[index]
        let viewController: ProfileViewController = ProfileViewControllerInstance()
        viewController.userModel = data.user
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.show(viewController, sender: nil)
    }
    
    func detailTapped(index : Int){
        let data = notifications[index]
        
       /* if(data.type == "Follow"){
            let viewController: ProfileViewController = ProfileViewControllerInstance()
            viewController.userModel = data.user
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.show(viewController, sender: nil)
        }else{
            self.navigationController?.isNavigationBarHidden = true
            let viewController = self.FeedFullPostViewControllerInstance()
            viewController.spotSaveId = data.spotSaveModel.id
            self.navigationController?.pushViewController(viewController, animated: true)
        }*/
    }
    
}
