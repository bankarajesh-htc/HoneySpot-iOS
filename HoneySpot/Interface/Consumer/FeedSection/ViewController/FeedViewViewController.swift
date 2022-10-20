//
//  FeedViewViewController.swift
//  HoneySpot
//
//  Created by Max on 2/13/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
 
import OneSignal
import FittedSheets



class FeedViewViewController: UIViewController {

    var tableSelection: IndexPath!
    var tapCount = 0
    
    private let refreshControl = UIRefreshControl()
    var isWishlist = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    var dataSource = [FeedModel]()
    var offset = 0
    var timer: Timer?
    
    enum THEME_STYLE: Int {
        case STYLE1 = 0
        case STYLE2 = 1
        case STYLE3 = 2
        case STYLE4 = 3
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        tableView.tableFooterView = UIView()
        
        self.navigationItem.titleView = navTitleLabel(withStyle: .STYLE2)
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "bell"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(self.notificationTapped), for: .touchUpInside)
        
        let rightBarItem = UIBarButtonItem(customView: button)
        rightBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        rightBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        rightBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        rightBarItem.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = rightBarItem
      
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 368
        
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = .clear
        refreshControl.subviews.first?.alpha = 0
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        setupAnalytics()
        
        
        checkAppVersion()
    }
    //MARK: - Deep Link Functionality
    @objc func showDeepLinkData(_ notification: NSNotification){
        
        print(notification.userInfo ?? "")
        //let fModel = dataSource[1]
        let viewController = self.FeedFullPostViewControllerInstance()
                if let dict = notification.userInfo as NSDictionary? {
                    if let spotId = dict["spotId"] as? String{
                        viewController.spotSaveId = spotId
                    }
                }
        //viewController.spotSaveModel = fModel.spotSave
        //viewController.feedModel = fModel
        self.navigationController?.pushViewController(viewController, animated: true)
       
    }
    @objc func showDeepLinkCityData(_ notification: NSNotification){
        
        print(notification.userInfo ?? "")
        let viewController = self.SearchTopRestaurantsViewControllerInstance()
                if let dict = notification.userInfo as NSDictionary? {
                    if let cityName = dict["cityName"] as? String{
                        viewController.cityName = cityName
                    }
                }
       
        self.navigationController?.pushViewController(viewController, animated: true)
       
    }
    @objc func showDeepLinkProfileData(_ notification: NSNotification){
        
        print(notification.userInfo ?? "")
        let viewController = self.ProfileViewControllerInstance()
                if let dict = notification.userInfo as NSDictionary? {
                    if let profileId = dict["userId"] as? String{
                        viewController.profileId = profileId
                    }
                }
        viewController.isProfileDeepLinked = true
//        if AppDelegate.originalDelegate.isGuestLogin {
//            viewController.isProfileDeepLinked = true
//
//        }
       
        self.navigationController?.pushViewController(viewController, animated: true)
       
    }
    
    func checkAppVersion(){
        if(AppDelegate.originalDelegate.appUpdateAvailable()){
            let alert = UIAlertController(title: "New Version Available", message: "Whoa! Looks like you haven’t updated to latest version!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Update", style: UIAlertAction.Style.default, handler: { (alt) in
                UIApplication.shared.open(URL(string: "https://itunes.apple.com/us/app/honeyspot/id1384657784?mt=8")!, options: [:], completionHandler: nil)
            }))
            //alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Navigation Bar Configuration
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
            navTitle = NSMutableAttributedString(string: "Save to Try", attributes:[
                NSAttributedString.Key.font: UIFont.fontHelveticaBold(withSize: 23),
                NSAttributedString.Key.foregroundColor: UIColor.BLACK_COLOR])
            
            navigationController?.navigationBar.barTintColor = .WHITE_COLOR
            break
        }
        navLabel.attributedText = navTitle
        
        return navLabel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //self.dataSource.removeAll()
        AppDelegate.originalDelegate.isFeedProfile = false
        AppDelegate.originalDelegate.isWishlist = false
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NSNotification.Name(.NOTIFICATION_SCROLLFEEDTOTOP), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleWishList), name: NSNotification.Name(.FEED_WISHLIST), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNormalList), name: NSNotification.Name(.FEED_NORAMLLIST), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkData(_:)), name: NSNotification.Name.init("DeepLinkData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkCityData(_:)), name: NSNotification.Name.init("DeepLinkCityData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkProfileData(_:)), name: NSNotification.Name.init("DeepLinkProfileData"), object: nil)
        self.tabBarController?.tabBar.layer.zPosition = 0
        self.navigationController?.isNavigationBarHidden = false
         if AppDelegate.originalDelegate.isSameProfile
         {
            AppDelegate.originalDelegate.isSameProfile = false
         }
        
        
        
        if AppDelegate.originalDelegate.isGuestLogin
        {
            loadMore()
            print("Guest User")
        }
        else
        {
            print("Normal User")
            //refreshTable()
            //self.offset = 0
            loadMore()
            fetchNotificationCount()
            getNotificationStatus()
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    func fetchNotificationCount(){
        NotificationDataSource().getUnreadNotificationCount { (result) in
            switch(result){
            case .success(let count):
                self.navigationItem.rightBarButtonItem?.badgeValue = count.description
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // MARK: - Notification Handler
    @objc func handleWishList(_ notification: Notification?) {
        
        
        
    }
    @objc func handleNormalList(_ notification: Notification?) {
        
        
    }
    
    @objc func handleNotification(_ notification: Notification?) {
        
        if notification?.name == NSNotification.Name(.NOTIFICATION_SCROLLFEEDTOTOP) {
            if dataSource.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    func scrollToTop() {
        // 1
        let topRow = IndexPath(row: 0,
                               section: 0)
                               
        // 2
        self.tableView.scrollToRow(at: topRow,
                                   at: .top,
                                   animated: true)
    }
    
    @objc func backButtonTapped(){
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @objc func notificationTapped(){
        
        if AppDelegate.originalDelegate.isGuestLogin
        {
            self.showAlert(title: "Want to see notifications?")
        }
        else
        {
            self.performSegue(withIdentifier: "notification", sender: nil)
        }
        
    }
    
    @objc func refreshTable(){
        self.offset = 0
        self.dataSource.removeAll()
        loadMore()
        self.tableView.reloadData()
    }
    
    @objc func loadMore() {
        self.view.isUserInteractionEnabled = false
        //UIApplication.shared.beginIgnoringInteractionEvents()
        self.noDataLabel.isHidden = true
        print("OFFSET : " + self.offset.description)
        if AppDelegate.originalDelegate.isGuestLogin
        {
            if self.dataSource.count == 0 {
                self.showLoadingHud()
                DispatchQueue.global().async {
                    FeedDataSource().getGuestLoginFeed(pageId: 0) { (result) in
                        self.hideAllHuds()
                        self.refreshControl.endRefreshing()
                        switch(result){
                        case .success(let feedArr):
                            DispatchQueue.main.async
                            {
                                if feedArr.count > 0 {
                                    print(feedArr.count)
                                    self.noDataLabel.isHidden = true
                                    self.tableView.isHidden = false
                                    self.dataSource += feedArr
                                    self.tableView.reloadData()
                                    
                                    let feed = self.dataSource[0]
                                    self.view.isUserInteractionEnabled = true
                                }
                                else
                                {
                                    self.noDataLabel.isHidden = false
                                    self.tableView.isHidden = true
                                    self.view.isUserInteractionEnabled = true
                                }
                            }
                        case .failure(let err):
                            DispatchQueue.main.async
                            {
                                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Something went wrong! Please try again.")
                                print(err.errorMessage)
                                self.view.isUserInteractionEnabled = true
                            }
                        }
                    }
                }


            }
            else
            {
                self.view.isUserInteractionEnabled = true
                self.tableView.reloadData()
            }

            
            
        }
        else
        {
            self.showLoadingHud()
            DispatchQueue.global().async {
                FeedDataSource().getFeed(pageId: self.offset) { (result) in
                    self.hideAllHuds()
                    self.refreshControl.endRefreshing()
                    switch(result){
                    case .success(let feedArr):
                        DispatchQueue.main.async
                        {
                            if feedArr.count > 0 {
                                print("Data Count \(self.dataSource.count)")
                                self.noDataLabel.isHidden = true
                                self.tableView.isHidden = false
                                if self.offset == 0 {
                                    self.dataSource = feedArr
                                }
                                else
                                {
                                    self.dataSource += feedArr
                                }
                                
                                self.tableView.reloadData()
                                self.view.isUserInteractionEnabled = true
                                
                            }
                            else if feedArr.count == 0 && self.offset == 0
                            {
                                self.noDataLabel.isHidden = false
                                self.tableView.isHidden = true
                                self.view.isUserInteractionEnabled = true
                                
                            }
                        }
                    case .failure(let err):
                        HSAlertView.showAlert(withTitle: "HoneySpot", message: err.errorMessage)
                        print(err.errorMessage)
                        self.view.isUserInteractionEnabled = true
                    }
                }
            }
            
        }
        
    }
    
    func getNotificationStatus()  {
        
        self.showLoadingHud()
        DispatchQueue.global().async {
            ProfileDataSource().notificationGetStatus { (result) in
                switch(result){
                case .success(let notificationStatus):
                    print("Status \(notificationStatus) ")
                    AppDelegate.originalDelegate.isConsumerSwitch = notificationStatus
                    self.hideAllHuds()
                    
                case .failure(let err):
                    print(err)
                    self.hideAllHuds()
                }
            }
        }
        
    }
    
    func setupAnalytics(){
        OneSignal.sendTags(["newUserId":UserDefaults.standard.string(forKey: "userId") ?? ""])
        Analytics.shared.setUserId(userId: UserDefaults.standard.string(forKey: "userId") ?? "")
    }
    deinit {
        dataSource.removeAll()
        print("Feed deinit")
    }
    
}
extension FeedViewViewController: TableViewCellDelegate {
    func singleTapDetected(in cell: FeedNewTableViewCell)  {
        if let indexPath = tableView.indexPath(for: cell) {
            tableView.deselectRow(at: indexPath, animated: true)
            let fModel = dataSource[indexPath.row]
            let viewController = self.FeedFullPostViewControllerInstance()
            viewController.isComingFromProfile = false
            viewController.spotSaveModel = fModel.spotSave
            viewController.feedModel = fModel
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
    }
    func doubleTapDetected(in cell: FeedNewTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            print("doubleTap \(indexPath) ")
            
            if AppDelegate.originalDelegate.isGuestLogin
            {
                self.showAlert(title: "Want to like the restaurant?")
            }
            else
            {
                
                guard let feedModel = cell.feedModel else {
                    return
                }
                
                if feedModel.didILike {
                    feedModel.didILike = false
                    feedModel.spotSave.likeCount -= 1
                    if(feedModel.spotSave.likeCount < 0){
                        feedModel.spotSave.likeCount = 0
                    }
                    
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    
                    FeedDataSource().postAnalyticsData(spotId: feedModel.spotSave.spot.id, eventName: "unlike")
                    showLoadingHud()
                    LikeDataSource().deleteLike(spotId: feedModel.spotSave.spot.id) { (result) in
                        switch(result){
                        case .success(let successStr):
                            self.hideAllHuds()
                            print(successStr)
                        case .failure(let err):
                            self.hideAllHuds()
                            print(err)
                        }
                    }
                } else {
                    feedModel.didILike = true
                    feedModel.spotSave.likeCount += 1
                    if(feedModel.spotSave.likeCount < 0){
                        feedModel.spotSave.likeCount = 0
                    }
                    
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    
                    FeedDataSource().postAnalyticsData(spotId: feedModel.spotSave.spot.id, eventName: "like")
                    showLoadingHud()
                    LikeDataSource().likePost(spotId: feedModel.spotSave.spot.id,saveId: feedModel.spotSave.id) { (result) in
                        switch(result){
                        case .success(let successStr):
                            self.hideAllHuds()
                            print(successStr)
                        case .failure(let err):
                            self.hideAllHuds()
                            print(err)
                        }
                    }
                }
                
            }
            
        }
    }
}
extension FeedViewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.dataSource.count > 0 {
            let cell: FeedNewTableViewCell = tableView.dequeueReusableCell(withIdentifier: FeedNewTableViewCell.CELL_IDENTIFIER, for: indexPath) as! FeedNewTableViewCell
            
            //cell.avatarView.userModel = self.dataSource[indexPath.row].user
            
            cell.feedModel = self.dataSource[indexPath.row]
            cell.indexPath = indexPath
            cell.delegate = self
            cell.celldelegate = self
            print(dataSource[indexPath.row])
    //        if self.dataSource[indexPath.row].didILike {
    //            cell.likeIcon.image = UIImage(named: "feedLikeFilled")
    //        } else {
    //            cell.likeIcon.image = UIImage(named: "feedLikeIcon")
    //        }
            
            if AppDelegate.originalDelegate.isGuestLogin
            {
                
            }
            else
            {
                if indexPath.row == self.dataSource.count - 1 {
                    self.offset += 1
                    self.loadMore()
                }
            }
                
            
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let myCell = tableView.cellForRow(at: indexPath) as? FeedNewTableViewCell
        
        switch (myCell?.tapCount) {
                case 1: //single tap
                    print("Single")
                    tableView.deselectRow(at: indexPath, animated: true)
                    let fModel = dataSource[indexPath.row]
                    let viewController = self.FeedFullPostViewControllerInstance()
                    viewController.isComingFromProfile = false
                    viewController.spotSaveModel = fModel.spotSave
                    viewController.feedModel = fModel
                    self.navigationController?.pushViewController(viewController, animated: true)
                    break;
                case 2: //double tap
                    print("Double")
                    break;
                default:
                    break;
            }
        
    }
}

extension FeedViewViewController: FeedNewTableViewCellDelegate {
	
	func didTapMore(indexPath: IndexPath) {
		let controller = HoneyspotMoreViewController.instantiate()
		controller.view.backgroundColor = UIColor.clear
		let options = SheetOptions(
			gripColor: UIColor.clear,
			presentingViewCornerRadius: 0
		)
		let sheetController = SheetViewController(controller: controller, sizes: [.fixed(280.0)], options: options)
		sheetController.contentBackgroundColor = UIColor.clear
		sheetController.overlayColor = UIColor(white: 0, alpha: 0.5)
		self.present(sheetController, animated: false, completion: nil)
	}
    
    func didLikeSpot(sender: FeedNewTableViewCell,indexPath :IndexPath) {

        if AppDelegate.originalDelegate.isGuestLogin
        {
            self.showAlert(title: "Want to like the restaurant?")
        }
        else
        {
            
            guard let feedModel = sender.feedModel else {
                return
            }
            
            if feedModel.didILike {
                feedModel.didILike = false
                feedModel.spotSave.likeCount -= 1
                if(feedModel.spotSave.likeCount < 0){
                    feedModel.spotSave.likeCount = 0
                }
                
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                
                FeedDataSource().postAnalyticsData(spotId: feedModel.spotSave.spot.id, eventName: "unlike")
                showLoadingHud()
                LikeDataSource().deleteLike(spotId: feedModel.spotSave.spot.id) { (result) in
                    switch(result){
                    case .success(let successStr):
                        self.hideAllHuds()
                        print(successStr)
                    case .failure(let err):
                        self.hideAllHuds()
                        print(err)
                    }
                }
            } else {
                feedModel.didILike = true
                feedModel.spotSave.likeCount += 1
                if(feedModel.spotSave.likeCount < 0){
                    feedModel.spotSave.likeCount = 0
                }
                
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                
                FeedDataSource().postAnalyticsData(spotId: feedModel.spotSave.spot.id, eventName: "like")
                showLoadingHud()
                LikeDataSource().likePost(spotId: feedModel.spotSave.spot.id,saveId: feedModel.spotSave.id) { (result) in
                    switch(result){
                    case .success(let successStr):
                        self.hideAllHuds()
                        print(successStr)
                    case .failure(let err):
                        self.hideAllHuds()
                        print(err)
                    }
                }
            }
            
        }
        
        
    }
    
	func didTapComment(_ sender: FeedNewTableViewCell,shouldKeyboardOpen : Bool) {
        if AppDelegate.originalDelegate.isGuestLogin
        {
            self.showAlert(title: "Want to comment?")
        }
        else
        {
            let viewController: CommentsViewController = self.CommentsViewControllerInstance()
            viewController.spotSaveModel = sender.feedModel?.spotSave
            viewController.feedModel = sender.feedModel
            viewController.shouldKeyboardOpen = shouldKeyboardOpen
            self.navigationController?.show(viewController, sender: self)
        }
        
    }
    
    func didTapSpotSave(_ sender: FeedNewTableViewCell) {
        if AppDelegate.originalDelegate.isGuestLogin
        {
            self.showAlert(title: "Want to save this restaurant?")
        }
        else
        {
            let viewController: EditSpotViewController = EditSpotViewControllerInstance()
            //AppDelegate.originalDelegate.isWishlist = false
            viewController.isInMySavedSpot = false
            viewController.spotSaveModel = sender.feedModel?.spotSave
            self.present(viewController, animated: true) {
            }
        }
        
    }
	
	func didTapShareSpot(text: String, image: UIImage) {
        if AppDelegate.originalDelegate.isGuestLogin
        {
            self.showAlert(title: "Want to Share this restaurant to your friends?")
        }
        else
        {
            let shareAll = [text , image] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
		
	}
	
	func didTapUser(sender: FeedNewTableViewCell, indexPath: IndexPath) {
        if AppDelegate.originalDelegate.isGuestLogin {
            
            AppDelegate.originalDelegate.isFeedProfile = true
            if AppDelegate.originalDelegate.isFeedProfile {
                let viewController: ProfileViewController = ProfileViewControllerInstance()
                viewController.userModel = self.dataSource[indexPath.row].user
                AppDelegate.originalDelegate.isFeedProfile = true
                self.navigationController?.show(viewController, sender: nil)
            }
        }
        else
        {
            let viewController: ProfileViewController = ProfileViewControllerInstance()
            viewController.userModel = self.dataSource[indexPath.row].user
            AppDelegate.originalDelegate.isFeedProfile = false
            self.navigationController?.show(viewController, sender: nil)
            
        }
        
        
		
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
}
