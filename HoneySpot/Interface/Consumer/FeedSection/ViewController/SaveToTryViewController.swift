//
//  SaveToTryViewController.swift
//  HoneySpot
//
//  Created by htcuser on 26/01/22.
//  Copyright © 2022 HoneySpot. All rights reserved.
//

import UIKit

class SaveToTryViewController: UIViewController {
    
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
      
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 368
        
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = .clear
        refreshControl.subviews.first?.alpha = 0
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
      
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
        
        AppDelegate.originalDelegate.isWishlist = true
        AppDelegate.originalDelegate.isSaveToTry = true
        super.viewWillAppear(animated)
        
        self.dataSource.removeAll()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkData(_:)), name: NSNotification.Name.init("DeepLinkData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkCityData(_:)), name: NSNotification.Name.init("DeepLinkCityData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkProfileData(_:)), name: NSNotification.Name.init("DeepLinkProfileData"), object: nil)
        self.tabBarController?.tabBar.layer.zPosition = 0
        self.navigationController?.isNavigationBarHidden = false
        
        loadMore()
        print("Wishlist")

        
        if !AppDelegate.originalDelegate.isGuestLogin && !AppDelegate.originalDelegate.isWishlist {
           // getNotification()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
        
        
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
    
    
    @objc func refreshTable(){
        self.offset = 0
        self.dataSource.removeAll()
        loadMore()
        self.tableView.reloadData()
    }
    
    @objc func loadMore() {
        self.noDataLabel.isHidden = true
        print("OFFSET : " + self.offset.description)
        
        self.dataSource.removeAll()
        self.showLoadingHud()
        FeedDataSource().getSavetoTryFeed(pageId: 1) { (result) in
            self.hideAllHuds()
            self.refreshControl.endRefreshing()
            switch(result){
            case .success(let feedArr):
                if feedArr.count > 0 {
                    self.noDataLabel.isHidden = true
                    self.tableView.isHidden = false
                    self.dataSource += feedArr
                    self.tableView.reloadData()
                    self.scrollToTop()
                }
                else
                {
                    self.noDataLabel.isHidden = false
                    self.tableView.isHidden = true
                    
                }
                
            case .failure(let err):
                HSAlertView.showAlert(withTitle: "HoneySpot", message: err.errorMessage)
                print(err.errorMessage)
            }
        }
        
    }
    
    func setupAnalytics(){
        Analytics.shared.setUserId(userId: UserDefaults.standard.string(forKey: "userId") ?? "")
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
extension SaveToTryViewController: TableViewCellDelegate {
    func singleTapDetected(in cell: FeedNewTableViewCell)  {
        if let indexPath = tableView.indexPath(for: cell) {
            if AppDelegate.originalDelegate.isWishlist
            {
                tableView.deselectRow(at: indexPath, animated: true)
                let fModel = dataSource[indexPath.row]
                let viewController = self.FeedFullPostViewControllerInstance()
                viewController.spotSaveModel = fModel.spotSave
                viewController.feedModel = fModel
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else
            {
                tableView.deselectRow(at: indexPath, animated: true)
                let fModel = dataSource[indexPath.row]
                let viewController = self.FeedFullPostViewControllerInstance()
                viewController.isComingFromProfile = false
                viewController.spotSaveModel = fModel.spotSave
                viewController.feedModel = fModel
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
            
        }
    }
    func doubleTapDetected(in cell: FeedNewTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            print("doubleTap \(indexPath) ")
            
            if AppDelegate.originalDelegate.isGuestLogin
            {
                self.showAlert(title: "Want to like the restaurant?")
            }
            else if AppDelegate.originalDelegate.isWishlist
            {
                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Save HoneySpot to like this restaurant")
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
extension SaveToTryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataSource.count > 0 {
            let cell: FeedNewTableViewCell = tableView.dequeueReusableCell(withIdentifier: FeedNewTableViewCell.CELL_IDENTIFIER, for: indexPath) as! FeedNewTableViewCell
            //cell.avatarView.userModel = self.dataSource[indexPath.row].user
            
            cell.feedModel = self.dataSource[indexPath.row]
            cell.indexPath = indexPath
            cell.delegate = self
            cell.celldelegate = self
            print(dataSource[indexPath.row])
            if self.dataSource[indexPath.row].didILike {
                cell.likeIcon.image = UIImage(named: "feedLikeFilled")
            } else {
                cell.likeIcon.image = UIImage(named: "feedLikeIcon")
            }
            
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if AppDelegate.originalDelegate.isWishlist
        {
            tableView.deselectRow(at: indexPath, animated: true)
            let fModel = dataSource[indexPath.row]
            let viewController = self.FeedFullPostViewControllerInstance()
            viewController.spotSaveModel = fModel.spotSave
            viewController.feedModel = fModel
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else
        {
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
}
extension SaveToTryViewController: FeedNewTableViewCellDelegate {
    func didTapMore(indexPath: IndexPath) {
        
    }
    
    
    func didLikeSpot(sender: FeedNewTableViewCell,indexPath :IndexPath) {

        if AppDelegate.originalDelegate.isGuestLogin
        {
            self.showAlert(title: "Want to like the restaurant?")
        }
        else if AppDelegate.originalDelegate.isWishlist
        {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Save HoneySpot to like this restaurant")
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
        else if AppDelegate.originalDelegate.isWishlist
        {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Save HoneySpot to Comment about this restaurant")
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
    

}
