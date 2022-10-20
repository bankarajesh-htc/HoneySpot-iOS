//
//  ProfileViewController.swift
//  HoneySpot
//
//  Created by Max on 2/13/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
 
import FBSDKLoginKit
import CZPhotoPickerController
import OneSignal
import AWSS3
import AWSCore

class ProfileViewController: UIViewController, SegmentButtonDelegate {
    
    @IBOutlet var scroll: UIScrollView!
    static let STORYBOARD_IDENTIFIER = "ProfileViewController"
    
    // UIComponents
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var userBioLabel: UILabel!
    
    @IBOutlet weak var numFollowersLabel: UILabel!
    @IBOutlet weak var numFollowersTitleLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var numFollowingTitleLabel: UILabel!
    @IBOutlet weak var numHoneyspotsLabel: UILabel!
    @IBOutlet weak var numHoneyspotsTitleLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var followButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileInfoTopConstraint: NSLayoutConstraint!
    
    
    @IBOutlet var segmentStackView: UIStackView!
    @IBOutlet weak var segmentButtonGridView: SegmentButton!
    @IBOutlet weak var segmentButtonListView: SegmentButton!
    @IBOutlet weak var segmentButtonSettings: SegmentButton!
    
    @IBOutlet weak var vwViewControllerContainer: UIView!
    @IBOutlet weak var inviteFriendsButton: UIButton!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var emptyView: UIView!
    
    var userModel : UserModel!
    var savesModels = [CitySaveModel]()
    var selectedTab = 0
    var profileId = ""
    
    var photoPicker: CZPhotoPickerController?
    var isInMapDrilldownMode: Bool = false
    var isFeedProfile: Bool = false
    private var segmentButtons = [SegmentButton]()
    private static let segmentButtonImages = [
        UIImage(named: "IconProfileGrid"),
        UIImage(named: "IconProfileMap"),
        UIImage(named: "IconProfileSettings")
    ]
    private static let PROFILE_INFO_TOP_CONSTRAINT_CURRENTUSER: CGFloat = 0
    private static let PROFILE_INFO_TOP_CONSTRAINT_OTHERUSER: CGFloat = 15
    private static let FOLLOW_BUTTON_HEIGHT_CONSTRAINT_CURRENTUSER: CGFloat = 0
    private static let FOLLOW_BUTTON_HEIGHT_CONSTRAINT_OTHERUSER: CGFloat = 30
    
    enum SUBVIEWCONTROLLERS: Int {
        case SPOTS_VIEW_GRID = 0
        case SPOTS_VIEW_MAP = 1
        case SETTINGS_VIEW = 2
        case MAP_VIEW = 3
        case CONTACTS_VIEW = 4
        case EDIT_VIEW = 5
    }
    
    enum ACTIVEBUTTON: Int {
        case HONEYSPOTS = 0
        case FOLLOWERS = 1
        case FOLLOWING = 2
    }

    
    var profileSpotsSubViewController: ProfileSpotsSubViewController?
    var profileSpotMapViewController: ProfileSpotMapViewController?
    var profileSettingsSubViewController: ProfileSettingsSubViewController?
    var profileContactsViewController: ProfileContactsViewController?
    var profileEditViewController: ProfileEditViewController?
    
    var isProfileInıtialized = false
    var isProfileDeepLinked = false
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        AppDelegate.originalDelegate.isSettings = false
        introLabel.text = ""
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        if profileId != "" {
            self.userModel = UserModel(id:profileId, username: "", fullname: "", pictureUrl: "", userBio: "", spotCount: 0, followerCount: 0, followingCount: 0)
            currentUser = self.userModel
        }
        else
        {
            if(userModel == nil){
                self.userModel = UserModel(id: UserDefaults.standard.string(forKey: "userId") ?? "", username: "", fullname: "", pictureUrl: "", userBio: "", spotCount: 0, followerCount: 0, followingCount: 0)
                currentUser = self.userModel
            }
            
        }
        
        initializeSubViewControllers()
        initUI()
        //initWithUser()
        if AppDelegate.originalDelegate.isGuestLogin {
            followButton.isHidden = false
            if isProfileDeepLinked || AppDelegate.originalDelegate.isFeedProfile {
                userNameLabel.text = ""
                signInButton.isHidden = true
            }
            else
            {
                userNameLabel.text = "Guest"
                signInButton.isHidden = false
            }
           
            avatarView.userModel = userModel
        }
        
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(reloadData), for: UIControl.Event.valueChanged)
        scroll.refreshControl = refreshControl
        self.view.layoutIfNeeded()
        scroll.setContentOffset(scroll.contentOffset, animated:false)
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scroll.contentSize = CGSize(width: self.view.frame.width,height: self.view.frame.height)
        

    }
    func updateView()  {
        
        if(userModel.id == UserDefaults.standard.string(forKey: "userId")){
            if AppDelegate.originalDelegate.isSameProfile
            {
                backButton.isHidden = true
                AppDelegate.originalDelegate.isSameProfile = false
            }
            else
            {

                
            }
        }
    }
    
    @objc func reloadData(){
        print("refreshed")
        refreshControl.endRefreshing()
        viewWillAppear(true)
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//       let height = scrollView.frame.size.height
//       let contentYoffset = scrollView.contentOffset.y
//       let distanceFromBottom = scrollView.contentSize.height - contentYoffset
//       if distanceFromBottom < height {
//           print(" you reached end of the table")
//       }
//   }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(UIScrollViewDelegate.scrollViewDidEndScrollingAnimation), with: nil, afterDelay: 0.3)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    // Call your function here
    }
    
    func initializeSubViewControllers() {
        profileSpotsSubViewController = ProfileSpotsSubViewControllerInstance()
        profileSpotMapViewController = ProfileSpotMapViewControllerInstance()
        profileSettingsSubViewController = ProfileSettingsSubViewControllerInstance()
        profileContactsViewController = ProfileContactsViewControllerInstance()
        profileEditViewController = ProfileEditViewControllerInstance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(followingChanged), name: NSNotification.Name(.NOTIFICATION_FOLLOWER_CHANGED), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkData(_:)), name: NSNotification.Name.init("DeepLinkData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkCityData(_:)), name: NSNotification.Name.init("DeepLinkCityData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkProfileData(_:)), name: NSNotification.Name.init("DeepLinkProfileData"), object: nil)
        self.navigationController?.isNavigationBarHidden = true
        backButton.isHidden = (self.navigationController?.viewControllers.first == self.navigationController?.visibleViewController)
        
        self.followButton.borderColor = .ORANGE_COLOR
        self.followButton.borderWidth = 1
        
        if AppDelegate.originalDelegate.isGuestLogin
        {
            if isProfileDeepLinked || AppDelegate.originalDelegate.isFeedProfile {
                getDeepLinkData()
            }
        }
        else
        {
            if AppDelegate.originalDelegate.isEditProfile
            {
                getData()
//                updateView(viewToChoose: SUBVIEWCONTROLLERS.SETTINGS_VIEW)
//            AppDelegate.originalDelegate.isEditProfile = false
//                exitEditMode()
            }
            else
            {
                getData()
                changeContentButtonLabelStyle(activeButton: .HONEYSPOTS)
                didPressButton(segmentButtonGridView)
            }
            
            updateView()
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for segmentButton in segmentButtons {
            segmentButton.active = segmentButton.active ? true : false
        }
    }
    
    func getDeepLinkData() {
        
        print("User Id...\(userModel.id)")
        if userModel.id == "" {
            userNameLabel.text = "Guest"
            return
        }
        showLoadingHud()
        let myGroup = DispatchGroup()

        myGroup.enter()
        ProfileDataSource().getDeepLinkUserProfileSaves(userId: userModel.id) { (result) in
            switch(result){
            case .success(let saves):
                let tempSaves = saves.sorted { (s1, s2) -> Bool in
                    return s1.saveCount > s2.saveCount
                }
                let model = saves.sorted { $0.city < $1.city }
                self.savesModels = tempSaves
                
                print(model)
            case .failure(let err):
                print(err)
            }
            myGroup.leave()
        }
        
        myGroup.enter()
        ProfileDataSource().getDeepLinkUser(userId: userModel.id) { (result) in
            switch(result){
            case .success(let user):
                var tempU = user
                tempU.amIFollow = self.userModel.doIFollow()
                self.userModel = tempU
                currentUser = self.userModel
                self.numFollowingLabel.text = String(format: "%lu", user.followingCount ?? 0)
                self.numFollowersLabel.text = String(format: "%lu", user.followerCount ?? 0)
                self.numHoneyspotsLabel.text = String(format: "%lu", user.spotCount ?? 0)
                
                Analytics.shared.setUserProperty(key: "honeyspotCount", value: (self.userModel.spotCount ?? 0).description)
                Analytics.shared.setUserProperty(key: "followerCount", value: (self.userModel.followerCount ?? 0).description)
                Analytics.shared.setUserProperty(key: "followingCount", value: (self.userModel.followingCount ?? 0).description)
            case .failure(let err):
                print(err)
            }
            myGroup.leave()
        }
        
     /*   if(userModel.id != UserDefaults.standard.string(forKey: "userId")){
            myGroup.enter()
            ProfileDataSource().doIFollowUser(userId: userModel.id) { (result) in
                switch(result){
                case .success(let doIFollow):
                    self.userModel.amIFollow = doIFollow
                case .failure(let err):
                    print(err)
                }
                myGroup.leave()
            }
        }*/
        

        myGroup.notify(queue: .main) {
            self.hideAllHuds()
            self.initBottomView()
            self.initTopProfileView()
            self.initWithUser()
        }
    }
    
    func getData() {
        showLoadingHud()
        self.view.isUserInteractionEnabled = false
        let myGroup = DispatchGroup()

        myGroup.enter()
        ProfileDataSource().getUserProfileSaves(userId: userModel.id) { (result) in
            switch(result){
            case .success(let saves):
                let tempSaves = saves.sorted { (s1, s2) -> Bool in
                    return s1.saveCount > s2.saveCount
                }
                //let model = saves.sorted { $0.city > $1.city }
                self.savesModels = tempSaves
                
                print(tempSaves)
            case .failure(let err):
                print(err)
            }
            myGroup.leave()
        }
        
        myGroup.enter()
        ProfileDataSource().getUser(userId: userModel.id) { (result) in
            switch(result){
            case .success(let user):
                var tempU = user
                tempU.amIFollow = self.userModel.doIFollow()
                self.userModel = tempU
                currentUser = self.userModel
                self.numFollowingLabel.text = String(format: "%lu", user.followingCount ?? 0)
                self.numFollowersLabel.text = String(format: "%lu", user.followerCount ?? 0)
                self.numHoneyspotsLabel.text = String(format: "%lu", user.spotCount ?? 0)
                
                Analytics.shared.setUserProperty(key: "honeyspotCount", value: (self.userModel.spotCount ?? 0).description)
                Analytics.shared.setUserProperty(key: "followerCount", value: (self.userModel.followerCount ?? 0).description)
                Analytics.shared.setUserProperty(key: "followingCount", value: (self.userModel.followingCount ?? 0).description)
            case .failure(let err):
                print(err)
            }
            myGroup.leave()
        }
        
        if(userModel.id != UserDefaults.standard.string(forKey: "userId")){
            myGroup.enter()
            ProfileDataSource().doIFollowUser(userId: userModel.id) { (result) in
                switch(result){
                case .success(let doIFollow):
                    self.userModel.amIFollow = doIFollow
                case .failure(let err):
                    print(err)
                }
                myGroup.leave()
            }
        }
        

        myGroup.notify(queue: .main) {
            if AppDelegate.originalDelegate.isEditProfile
            {
                self.hideAllHuds()
                //self.updateView(viewToChoose: SUBVIEWCONTROLLERS.SETTINGS_VIEW)
                AppDelegate.originalDelegate.isEditProfile = false
                self.initTopProfileView()
                self.initWithUser()
                self.exitEditMode()
            }
            else
            {
                self.hideAllHuds()
                self.initBottomView()
                self.initTopProfileView()
                self.initWithUser()
            }
            
            self.view.isUserInteractionEnabled = true
        }
    }
    @objc func showDeepLinkData(_ notification: NSNotification){
        
        print(notification.userInfo ?? "")
        let viewController = self.FeedFullPostViewControllerInstance()
                if let dict = notification.userInfo as NSDictionary? {
                    if let spotId = dict["spotId"] as? String{
                        viewController.spotSaveId = spotId
                    }
                }
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
                        self.profileId = profileId
                    }
                    
                    
                }
        viewController.isProfileDeepLinked = true
        let userID = UserDefaults.standard.string(forKey: "userId")
        if (profileId == userID) {
            getData()
        }
        else
        {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        
        
//        if AppDelegate.originalDelegate.isGuestLogin {
//            viewController.isProfileDeepLinked = true
//
//        }
        //backButton.isHidden = false
       
        
       
    }
    
    func initUI() {
        avatarView.delegate = self
        // Initialize Segment Buttons
        segmentButtons.append(segmentButtonGridView)
        segmentButtons.append(segmentButtonListView)
        segmentButtons.append(segmentButtonSettings)
        for (i, segmentButton) in segmentButtons.enumerated() {
            segmentButton.tag = i
            segmentButton.active = (i == 0)
            segmentButton.delegate = self
            segmentButton.image = ProfileViewController.segmentButtonImages[i]
        }
        changeContentButtonLabelStyle(activeButton: .HONEYSPOTS)
        
        updateView(viewToChoose: SUBVIEWCONTROLLERS.SPOTS_VIEW_GRID)
        
    }
    
    func initWithUser() {
        
        if(userModel.id == UserDefaults.standard.string(forKey: "userId")){
            // Todo
            segmentButtons.append(segmentButtonSettings)
            if isProfileDeepLinked {
                backButton.isHidden = false
            }
            else if AppDelegate.originalDelegate.isSameProfile
            {
                backButton.isHidden = true
                AppDelegate.originalDelegate.isSameProfile = false
            }
            else
            {

                
            }
            
            introLabel.text = "Get started by using the search tab below to find and save your favorite restaurant. You can also find and follow your friends"
        }else{
            
            if AppDelegate.originalDelegate.isGuestLogin
            {
                if isProfileDeepLinked {
                    
                    segmentStackView.isHidden = false
                    emptyView.isHidden = true
                    inviteFriendsButton.isHidden = true
                    
                    profileInfoTopConstraint.constant = ProfileViewController.PROFILE_INFO_TOP_CONSTRAINT_OTHERUSER
                    followButtonHeightConstraint.constant = ProfileViewController.FOLLOW_BUTTON_HEIGHT_CONSTRAINT_OTHERUSER
                    
                    
                    segmentButtonSettings.removeFromSuperview()
                    if(self.userModel.doIFollow()){
                        self.followButton.setTitle("Unfollow", for: .normal)
                    }else{
                        self.followButton.setTitle("Follow", for: .normal)
                    }
                    
                }
                else
                {
                    
                    if AppDelegate.originalDelegate.isFeedProfile {
                        segmentStackView.isHidden = false
                        emptyView.isHidden = true
                        inviteFriendsButton.isHidden = true
                        
                        profileInfoTopConstraint.constant = ProfileViewController.PROFILE_INFO_TOP_CONSTRAINT_OTHERUSER
                        followButtonHeightConstraint.constant = ProfileViewController.FOLLOW_BUTTON_HEIGHT_CONSTRAINT_OTHERUSER
                        
                        
                        segmentButtonSettings.removeFromSuperview()
                        let doIFollow = self.userModel?.doIFollow() ?? false
                        if(doIFollow){
                            self.followButton.backgroundColor = .WHITE_COLOR
                            self.followButton.setTitleColor(.ORANGE_COLOR, for: .normal)
                            self.followButton.setTitle("Unfollow", for: .normal)
                        }else{
                            self.followButton.backgroundColor = .ORANGE_COLOR
                            self.followButton.setTitleColor(.WHITE_COLOR, for: .normal)
                            self.followButton.setTitle("Follow", for: .normal)
                        }
                    }
                    else
                    {
                        segmentStackView.isHidden = true
                        emptyView.isHidden = false
                        followButton.isHidden = false
                    
                        introLabel.text = ""
                        //add(asChildViewController: profileSettingsSubViewController!)
                    }

                }
                
            }
            else
            {
                introLabel.text = "Get started by using the search tab below to find and save your favorite restaurant. You can also find and follow your friends"
                segmentStackView.isHidden = false
                emptyView.isHidden = true
                inviteFriendsButton.isHidden = true
                
                profileInfoTopConstraint.constant = ProfileViewController.PROFILE_INFO_TOP_CONSTRAINT_OTHERUSER
                followButtonHeightConstraint.constant = ProfileViewController.FOLLOW_BUTTON_HEIGHT_CONSTRAINT_OTHERUSER
                
                
                segmentButtonSettings.removeFromSuperview()
                
                let doIFollow = self.userModel?.doIFollow() ?? false
                if(doIFollow){
                    self.followButton.backgroundColor = .WHITE_COLOR
                    self.followButton.setTitleColor(.ORANGE_COLOR, for: .normal)
                    self.followButton.setTitle("Unfollow", for: .normal)
                }else{
                    self.followButton.backgroundColor = .ORANGE_COLOR
                    self.followButton.setTitleColor(.WHITE_COLOR, for: .normal)
                    self.followButton.setTitle("Follow", for: .normal)
                }
                followButton.isHidden = false
//                if(self.userModel.doIFollow()){
//                    self.followButton.setTitle("Unfollow", for: .normal)
//                }else{
//                    self.followButton.setTitle("Follow", for: .normal)
//                }
                
            }
            
            
        }
        
        if AppDelegate.originalDelegate.isGuestLogin
        {
            if isProfileDeepLinked
            {
                userNameLabel.text = userModel.username
            }
            else if AppDelegate.originalDelegate.isFeedProfile
            {
                userNameLabel.text = userModel.username
            }
            else
            {
                userNameLabel.text = "Guest"
            }
            
        }
        else
        {
            userNameLabel.text = userModel.username
        }
        
        userRealNameLabel.text = userModel.fullname
        userBioLabel.text = userModel.userBio
        avatarView.userModel = userModel
        
        profileContainerView.setNeedsLayout()
        profileView.setNeedsLayout()
        vwViewControllerContainer.setNeedsLayout()
        
    }
    
    func initTopProfileView(){
        inviteFriendsButton.isHidden = false
        profileInfoTopConstraint.constant = ProfileViewController.PROFILE_INFO_TOP_CONSTRAINT_CURRENTUSER
        followButtonHeightConstraint.constant = ProfileViewController.FOLLOW_BUTTON_HEIGHT_CONSTRAINT_CURRENTUSER
        
        numFollowingLabel.text = String(format: "%lu", userModel.followingCount ?? 0)
        numFollowersLabel.text = String(format: "%lu", userModel.followerCount ?? 0)
        numHoneyspotsLabel.text = String(format: "%lu", userModel.spotCount ?? 0)
        
        if(userModel.spotCount ?? 0 > 0){
            emptyView.isHidden = true
        }else{
            emptyView.isHidden = false
        }
    }
    
    func initBottomView(){
        self.profileSpotsSubViewController!.citySaveModels = savesModels
        self.profileSpotsSubViewController?.userId = self.userModel.id
        self.profileSpotsSubViewController!.layoutSquare = true
        if(!isProfileInıtialized){
            isProfileInıtialized = true
            didPressButton(segmentButtonGridView)
        }else{
            if(selectedTab == 1){
                onHoneyspotsButtonTap(1)
            }else if(selectedTab == 2){
                onFollowersButtonTap(1)
            }else if(selectedTab == 3){
                onFollowingButtonTap(1)
            }
        }
    }
    
    @objc func followingChanged(){
        //self.showLoadingHud()
        DispatchQueue.global().async {
            ProfileDataSource().getUser(userId: self.userModel.id) { (result) in
                switch(result){
                case .success(let user):
                    DispatchQueue.main.async
                    {
                        self.hideAllHuds()
                        var tempU = user
                        tempU.amIFollow = self.userModel.doIFollow()
                        self.userModel = tempU
                        self.numFollowingLabel.text = String(format: "%lu", user.followingCount ?? 0)
                        self.numFollowersLabel.text = String(format: "%lu", user.followerCount ?? 0)
                        self.numHoneyspotsLabel.text = String(format: "%lu", user.spotCount ?? 0)
                    }
                    
                case .failure(let err):
                    self.hideAllHuds()
                    print(err)
                }
            }
        }
        
    }
    
    @IBAction func onBackButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onSignInTap(_ sender: Any) {
        AppDelegate.originalDelegate.isLogin = true
        AppDelegate.originalDelegate.isSignUp = false
        UIViewController.LOGIN_NAVIGATIONCONTROLLER.popToRootViewController(animated: false)
        UIViewController.APP_DELEGATE_INSTANCE.window?.rootViewController = .FIRST_LOGINCONTROLLER
    }
    @IBAction func onSignUpTap(_ sender: Any) {
        AppDelegate.originalDelegate.isLogin = true
        AppDelegate.originalDelegate.isSignUp = true
        UIViewController.LOGIN_NAVIGATIONCONTROLLER.popToRootViewController(animated: false)
        UIViewController.APP_DELEGATE_INSTANCE.window?.rootViewController = .FIRST_LOGINCONTROLLER

//        let viewController = self.SignupViewControllerInstance()
//        self.navigationController?.pushViewController(viewController, animated: true)
        //self.navigationController?.pushViewController(SignupViewControllerInstance(), animated: true)
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
    
    @IBAction func onFollowButtonTap(_ sender: Any) {
        if AppDelegate.originalDelegate.isGuestLogin{
            
            self.showAlert(title: "Want to Follow your Friend?")
        }
        else
        {
            self.view.isUserInteractionEnabled = false
            self.showLoadingHud()
            
            if self.userModel.doIFollow() {
                DispatchQueue.global().async {
                    ProfileDataSource().unfollowUser(userId: self.userModel!.id) { (result) in
                        switch(result){
                        case .success(let successStr):
                            print(successStr)
                            self.getFollowUserDetails()
                        case .failure(let err):
                            print(err)
                        }
                    }
                    DispatchQueue.main.async
                    {
                        self.view.isUserInteractionEnabled = true
                        self.numFollowersLabel.text = String(format: "%lu", (self.userModel.followerCount ?? 0) - 1)
                    }
                    
                }
                
                
               // self.followButton.setTitle("Follow",for: .normal)
            }else{
                DispatchQueue.global().async {
                    ProfileDataSource().followUser(userId: self.userModel!.id) { (result) in
                        switch(result){
                        case .success(let successStr):
                            print(successStr)
                            self.getFollowUserDetails()
                        case .failure(let err):
                            print(err)
                        }
                    }
                    DispatchQueue.main.async
                    {
                        self.view.isUserInteractionEnabled = true
                        self.numFollowersLabel.text = String(format: "%lu", (self.userModel.followerCount ?? 0) + 1)
                    }
                    

                }
            }
            
            
           
        }
        
    }
    func getFollowUserDetails() {
        //showLoadingHud()
        DispatchQueue.global().async {
            ProfileDataSource().doIFollowUser(userId: self.userModel.id) { (result) in
                switch(result){
                case .success(let doIFollow):
                    DispatchQueue.main.async
                    {
                        self.userModel.amIFollow = doIFollow
                        
                        let doIFollow = self.userModel?.doIFollow() ?? false
                        if(doIFollow){
                            self.followButton.backgroundColor = .WHITE_COLOR
                            self.followButton.setTitleColor(.ORANGE_COLOR, for: .normal)
                            self.followButton.setTitle("Unfollow", for: .normal)
                        }else{
                            self.followButton.backgroundColor = .ORANGE_COLOR
                            self.followButton.setTitleColor(.WHITE_COLOR, for: .normal)
                            self.followButton.setTitle("Follow", for: .normal)
                        }
                    }
                    
                    
                    self.hideAllHuds()
                case .failure(let err):
                    print(err)
                    self.hideAllHuds()
                }
            }
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        isProfileDeepLinked = false
        
        backButton.isHidden = true
    }
    
    deinit {
        print("deinit") // gets called
    }
    
    // MARK: - Content Button Actions
    @IBAction func onFollowingButtonTap(_ sender: Any) {
        if AppDelegate.originalDelegate.isGuestLogin{
            if AppDelegate.originalDelegate.isFeedProfile || isProfileDeepLinked{
//                changeContentButtonLabelStyle(activeButton: .FOLLOWING)
//                self.updateView(viewToChoose: .CONTACTS_VIEW)
//                NotificationCenter.default.post(
//                    name: NSNotification.Name(.NOTIFICATION_SHOW_CONTACTS),
//                    object: nil,
//                    userInfo: ["LIST_TYPE": ContactListType.FOLLOWING_LIST]
//                )
                //self.showAlert(title: "Want to see Following members?")
                if userModel.id == "" {
                    self.showAlert(title: "Want to see Following members?")
                }
                else
                {
                    self.view.isUserInteractionEnabled = false
                    changeContentButtonLabelStyle(activeButton: .FOLLOWING)
                    self.updateView(viewToChoose: .CONTACTS_VIEW)
                    NotificationCenter.default.post(
                        name: NSNotification.Name(.NOTIFICATION_SHOW_CONTACTS),
                        object: nil,
                        userInfo: ["LIST_TYPE": ContactListType.FOLLOWING_LIST]
                    )
                }
                
            }
            else
            {
                self.showAlert(title: "Want to see Following members?")
            }
            
        }
        else
        {
            self.view.isUserInteractionEnabled = false
            changeContentButtonLabelStyle(activeButton: .FOLLOWING)
            self.updateView(viewToChoose: .CONTACTS_VIEW)
            NotificationCenter.default.post(
                name: NSNotification.Name(.NOTIFICATION_SHOW_CONTACTS),
                object: nil,
                userInfo: ["LIST_TYPE": ContactListType.FOLLOWING_LIST]
            )
            //self.view.isUserInteractionEnabled = true
        }
        
    }
    
    @IBAction func onFollowersButtonTap(_ sender: Any) {
        if AppDelegate.originalDelegate.isGuestLogin{
            if AppDelegate.originalDelegate.isFeedProfile || isProfileDeepLinked{

                //self.showAlert(title: "Want to see Following members?")
                if userModel.id == "" {
                    self.showAlert(title: "Want to gain more Followers?")
                }
                else
                {
                    self.view.isUserInteractionEnabled = false
                    changeContentButtonLabelStyle(activeButton: .FOLLOWERS)
                    self.updateView(viewToChoose: .CONTACTS_VIEW)
                    NotificationCenter.default.post(
                        name: NSNotification.Name(.NOTIFICATION_SHOW_CONTACTS),
                        object: nil,
                        userInfo: ["LIST_TYPE": ContactListType.FOLLOWERS_LIST]
                    )
                }
                
            }
            else
            {
                self.showAlert(title: "Want to gain more Followers?")
            }
            
        }
        else
        {
            self.view.isUserInteractionEnabled = false
            changeContentButtonLabelStyle(activeButton: .FOLLOWERS)
            self.updateView(viewToChoose: .CONTACTS_VIEW)
            NotificationCenter.default.post(
                name: NSNotification.Name(.NOTIFICATION_SHOW_CONTACTS),
                object: nil,
                userInfo: ["LIST_TYPE": ContactListType.FOLLOWERS_LIST]
            )
            //self.view.isUserInteractionEnabled = true
        }
        
    }

    @IBAction func onHoneyspotsButtonTap(_ sender: Any) {
        if AppDelegate.originalDelegate.isGuestLogin{
            if userModel.id == "" {
                //self.showAlert(title: "Want to HoneySpot a Restaurant?")
            }
            else
            {
                changeContentButtonLabelStyle(activeButton: .HONEYSPOTS)
                didPressButton(segmentButtonGridView)
            }
            
        }
        else
        {
            changeContentButtonLabelStyle(activeButton: .HONEYSPOTS)
            didPressButton(segmentButtonGridView)
        }
        
    }
    
    @IBAction func inviteFriendsTapped(_ sender: Any) {
        //self.navigationController?.pushViewController(InviteFriendsViewControllerInstance(), animated: true)
//        emptyView.isHidden = true
//        add(asChildViewController: profileSettingsSubViewController!)
//        if AppDelegate.originalDelegate.isEditProfile
//        {
//            self.exitEditMode()
//        }
//        else
//        {
//            print("Not edit profile")
//        }
        
        //Settings New Page
        let profileSettings: ProfileSettingsViewController = ProfileSettingsViewControllerInstance()
        profileSettings.userModel = self.userModel
        self.navigationController?.pushViewController(profileSettings, animated: true)
        
    }
    
    
    func changeContentButtonLabelStyle(activeButton buttonIndex: ACTIVEBUTTON) {
        let defaultFont: UIFont = UIFont.fontMonsterratLight(withSize: 11)
        let selectedFont: UIFont = UIFont.fontMonsterratBold(withSize: 11)
        let buttonLabels = [numHoneyspotsTitleLabel, numFollowersTitleLabel, numFollowingTitleLabel]
        for label in buttonLabels {
            label?.font = defaultFont
        }
        switch buttonIndex {
        case .HONEYSPOTS:
            self.selectedTab = 1
            numHoneyspotsTitleLabel.font = selectedFont
            break
        case .FOLLOWERS:
            self.selectedTab = 2
            numFollowersTitleLabel.font = selectedFont
            break
        case .FOLLOWING:
            self.selectedTab = 3
            numFollowingTitleLabel.font = selectedFont
            break
        }
    }
    

    func didPressButton(_ sender: SegmentButton) {
        for i in 0...(segmentButtons.count - 1) {
            segmentButtons[i].active = false
        }
        sender.active = true
        
            if sender == segmentButtonGridView {
                if isInMapDrilldownMode {
                    mapDrilldownBack()
                    return
                }
                //self.profileSpotsSubViewController!. = self.userModel
                self.profileSpotsSubViewController!.layoutSquare = true
            } else if sender == segmentButtonListView {
                if AppDelegate.originalDelegate.isGuestLogin {
                    
                }
                else
                {
                    isInMapDrilldownMode = true
                }
                
            }
        
        updateView(viewToChoose: SUBVIEWCONTROLLERS(rawValue: sender.tag)!)
    }
    

    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        vwViewControllerContainer.addSubview(viewController.view)
        viewController.view.frame = vwViewControllerContainer.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    func updateView(viewToChoose viewName: SUBVIEWCONTROLLERS) {
        self.view.isUserInteractionEnabled = false
        for viewController: UIViewController in self.children {
            remove(asChildViewController: viewController)
        }
        
        switch viewName {
        case .SPOTS_VIEW_GRID:
            if(userModel.spotCount ?? 0 > 0){
                emptyView.isHidden = true
            }else{
                emptyView.isHidden = false
            }
            add(asChildViewController: profileSpotsSubViewController!)
            profileSpotsSubViewController?.collectionView.reloadData()
            break
        case .SPOTS_VIEW_MAP:
            emptyView.isHidden = true
            profileSpotMapViewController!.cityModels = savesModels
            profileSpotMapViewController!.userId = userModel.id
            add(asChildViewController: profileSpotMapViewController!)
            break
        case .SETTINGS_VIEW:
            emptyView.isHidden = true
            add(asChildViewController: profileSettingsSubViewController!)
            break
        case .MAP_VIEW:
            emptyView.isHidden = true
            profileSpotMapViewController!.cityModels = savesModels
            add(asChildViewController: profileSpotMapViewController!)
            break
        case .CONTACTS_VIEW:
            emptyView.isHidden = true
            profileContactsViewController?.userModel = self.userModel
            add(asChildViewController: profileContactsViewController!)
            break
        case .EDIT_VIEW:
            emptyView.isHidden = true
            AppDelegate.originalDelegate.isEditProfile = true
            add(asChildViewController: profileEditViewController!)
            break
//        default:
//            add(asChildViewController: .PROFILE_SPOTS_SUB_VIEWCONTROLLER)
        }
        self.view.isUserInteractionEnabled = true
    }
    
    func enterEditMode() {
        if(userModel.id == UserDefaults.standard.string(forKey: "userId")){
            avatarView.editMode = true
        }else{
            avatarView.editMode = false
        }
    }

    func exitEditMode() {
        avatarView.editMode = false
    }
    
    
    // MARK: - Map Drilldown
    func mapDrilldown(spotSavesModels: [SpotSaveModel]) {
        
        isInMapDrilldownMode = true
        self.profileSpotMapViewController!.spotSaveModels = spotSavesModels
        updateView(viewToChoose: SUBVIEWCONTROLLERS.MAP_VIEW)
    }
    
    func mapDrilldownBack() {
        isInMapDrilldownMode = false
        didPressButton(segmentButtonGridView)
    }

    func triggerReCreate() {
        isInMapDrilldownMode = false
        //self.profileSpotsSubViewController!.userModel = userModel
        didPressButton(segmentButtonGridView)
    }
}

extension ProfileViewController: AvatarViewDelegate {
    func didTapAvatarView(_ sender: AvatarView) {
        if !self.avatarView.editMode {
            return
        }
        self.photoPicker = CZPhotoPickerController(completionBlock: { (imagePickerController: UIImagePickerController?, imageInfoDict: [AnyHashable : Any]?) in
            
            guard let imageInfo = imageInfoDict else {
                return
            }
            var img: UIImage? = imageInfo[UIImagePickerController.InfoKey.editedImage] as? UIImage
            if img == nil {
                img = imageInfo[UIImagePickerController.InfoKey.originalImage] as? UIImage
            }
            guard let image = img else {
                return
            }
            self.dismiss(animated: true, completion: nil)
            let pictureData: Data = image.jpegData(compressionQuality: 0.9)!
            self.uploadImage(data: pictureData)
        })
        self.photoPicker?.allowsEditing = true
        self.photoPicker?.present(from: self)
    }
    
    func uploadImage(data : Data){
        
        DispatchQueue.main.async {
            self.showLoadingHud()
        }
    
        let remoteName = UUID().uuidString + ".jpg"
        let S3BucketName = "honeyspot-user-images"

        let accessKey = "AKIAZBDUQHBVB6XBABEZ"
        let secretKey = "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"
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration

        let expression = AWSS3TransferUtilityUploadExpression()
        expression.setValue("public-read", forRequestHeader: "x-amz-acl")
        
        let transferManager = AWSS3TransferUtility.default()
        transferManager.uploadData(data, bucket: S3BucketName, key: remoteName, contentType: "image/jpeg", expression: expression) { (task, err) in
            if err != nil {
                print("Upload failed with error: (\(err!.localizedDescription))")
            }
            if let HTTPResponse = task.response {
                DispatchQueue.main.async {
                    self.hideAllHuds()
                }
                print(HTTPResponse)
                let link = "https://honeyspot-user-images.s3.us-east-2.amazonaws.com/" + remoteName
                DispatchQueue.main.async {
                    self.avatarView.imageView.image = UIImage(data: data)
                    self.userModel.pictureUrl = link
                    currentUser = self.userModel
                    self.avatarView.userModel = self.userModel
                }
            }
        }
        
    }
}
