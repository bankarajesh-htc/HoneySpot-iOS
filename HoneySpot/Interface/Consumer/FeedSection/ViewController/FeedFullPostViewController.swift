


//OLD FEED FULL POST VIEW
//
//  FeedFullPostViewController.swift
//  HoneySpot
//
//  Created by Max on 2/23/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//


import UIKit
import MapKit
 
import Alamofire

protocol FeedImageCellDelegate {
    func didLikeSpot(sender: ConsumerDetailImageTableViewCell)
    func didTapComment(_ sender: ConsumerDetailImageTableViewCell,shouldKeyboardOpen : Bool)
    func didLikeSpot(sender: ConsumerImageTableViewCell)
    func didTapComment(_ sender: ConsumerImageTableViewCell,shouldKeyboardOpen : Bool)
    func didTapShareSpot(text: String, image: UIImage)
    func didSaveSpot(isInMySavedSpot: Bool,spotSaveModel:SpotSaveModel)
    
    func didClickBack()
}
protocol MediaCellDelegate {
    func onDirectionsButtonTap(spotSaveModel:SpotSaveModel)
    func onCallTapped(phoneNumber:String)
    func onLocationTap(spotSaveModel:SpotSaveModel)
}
protocol CommentCellDelegate {
    func didAddComment(_ sender: ConsumerDetailCommentsTableViewCell,shouldKeyboardOpen : Bool)
    func didViewAllComment(_ sender: ConsumerDetailCommentsTableViewCell,shouldKeyboardOpen : Bool)
}



class FeedFullPostViewController: UIViewController {
    
    @IBOutlet var feedTableView: UITableView!

	@IBOutlet weak var contentScrollView: UIScrollView!
    
	@IBOutlet var spotInfoTimeLabel: UILabel!
	@IBOutlet weak var spotInfoViewImageView: UIImageView!
    @IBOutlet weak var spotInfoViewAvatarView: UIImageView!
    @IBOutlet weak var spotInfoViewUsernameLabel: UILabel!
    @IBOutlet weak var spotInfoViewNameLabel: UILabel!
    @IBOutlet weak var spotInfoViewCommentLabel: UILabel!
    @IBOutlet weak var spotInfoViewAddressLabel: UILabel!
	
	@IBOutlet var saveView: UIView!
	@IBOutlet var saveLabel: UILabel!
	@IBOutlet var saveTickIcon: UIImageView!
	@IBOutlet var saveButton: UIButton!
	
	@IBOutlet var friendsSavedHoneyspotStackView: UIStackView!
	@IBOutlet var friendsSavedThisHoneyspotLabel: UILabel!
	
    @IBOutlet weak var mapViewMapView: MKMapView!
    @IBOutlet weak var mapViewAddressLabel: UILabel!
	
	@IBOutlet var favoriteDishesCollectionView: UICollectionView!
	@IBOutlet weak var tagsCollectionView: UICollectionView!
	
	@IBOutlet var shareIcon: UIImageView!
	@IBOutlet var shareCountLabel: UILabel!
	@IBOutlet var commentCountLabel: UILabel!
	@IBOutlet var likeCountLabel: UILabel!
	@IBOutlet var likeIcon: UIImageView!
	@IBOutlet var commentIcon: UIImageView!
	
	@IBOutlet var honeyspotNearbyLabel: UILabel!
	@IBOutlet var favoriteDishesLabel: UILabel!
	
    @IBOutlet weak var commentsViewViewAllButton: UIButton!
	@IBOutlet var directionsButton: UIButton!
	@IBOutlet var callButton: UIButton!
	
	@IBOutlet var tagviewTopConstant: NSLayoutConstraint!
	@IBOutlet var tagviewHeightContstraint: NSLayoutConstraint!
	
	@IBOutlet var favoriteDishesHeightConstraint: NSLayoutConstraint!
	@IBOutlet var favoriteDishesLabelTopConstant: NSLayoutConstraint!
	@IBOutlet var favoriteDishesLabelBottomConstant: NSLayoutConstraint!
	
	@IBOutlet var honeyspotNearbyTopConstant: NSLayoutConstraint!
	@IBOutlet var honeyspotNearbyHeightConstant: NSLayoutConstraint!
	
	
	var isInMyHonespot = false
	
	weak var feedModel : FeedModel?
    var visibleCells : [CellTypes] = []
    private var sections = [Section]()
	
    var friendsDataSource: [UserModel] = []
    var spotSaveId = ""
    var spotSaveModel : SpotSaveModel!
    var tempSpotSaveModel : SpotSaveModel!
    var isComingFromProfile: Bool = false
    
    var isComingFromMap: Bool = false
    var onCancelBlock: (() -> Void)?
    
    var phoneNumber = ""
    var tags = [Int]()
    var addingFromSearch = false
    var reservationIndex = 10
    var serviceIndex = 10
    var deliveryIndex = 10
    
    
    var comments : [CommentModel] = []
    var days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var commentCount = 0

    static let COMMUNITY_CONTENT_VIEW_FULL_HEIGHT: CGFloat = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkData(_:)), name: NSNotification.Name.init("DeepLinkData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkCityData(_:)), name: NSNotification.Name.init("DeepLinkCityData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkProfileData(_:)), name: NSNotification.Name.init("DeepLinkProfileData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callSpotData(_:)), name: NSNotification.Name.init("PostSpotData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callSaveToTry(_:)), name: NSNotification.Name.init("PostSaveToTry"), object: nil)
        visibleCells.removeAll()
        if(spotSaveId == ""){
            if spotSaveModel != nil {
                self.spotSaveId = spotSaveModel.id
            }
            else if tempSpotSaveModel != nil
            {
                spotSaveModel = tempSpotSaveModel
                self.spotSaveId = tempSpotSaveModel.id
            }
        }
        
        if(spotSaveId == ""){
            showLoadingHud()
            self.addingFromSearch = true
            DispatchQueue.global().async {
                SpotDataSource().getSpot(googlePlaceId: self.spotSaveModel.spot.googlePlaceId) { (result) in
                    self.hideAllHuds()
                    switch(result){
                    case .success(let spotModel):
                        DispatchQueue.main.async
                        {
                            let userModel = UserModel(id: UserDefaults.standard.string(forKey: "userId") ?? "", username: UserDefaults.standard.string(forKey: "username") ?? "", fullname: "", pictureUrl: UserDefaults.standard.string(forKey: "pictureurl") ?? "", userBio: "", spotCount: 0, followerCount: 0, followingCount: 0)
                            let saveModel = SpotSaveModel(id: "", createdAt: nil, user: userModel, spot: spotModel, description: "", tags: [], commentCount: 0, likeCount: 0, favoriteDishes: [])
                            self.spotSaveModel = saveModel
                            
                        
                            let delivery = self.spotSaveModel.spot.deliveryOptions?.contains("delivery")
                            let totalCount = self.spotSaveModel.spot.customerPictures.count + self.spotSaveModel.spot.foodPictures.count
                            
                            if totalCount > 0 {
                                
                                self.visibleCells.append(CellTypes.imageCell)
                            }
                            if totalCount == 0 {
                                
                                self.visibleCells.append(CellTypes.detailImageCell)
                            }
                            self.visibleCells.append(CellTypes.detailGeneralCell)
                            
                            if self.spotSaveModel.spot.categories.count > 0  {
                                
                                self.sections.append(Section(type: .Mandatory, items: [.categoryCell]))
                                self.visibleCells.append(CellTypes.categoryCell)
                            }
                            if(self.spotSaveModel.spot.website != "" || self.spotSaveModel.spot.website != nil ) && (self.spotSaveModel.spot.phoneNumber != "" || self.spotSaveModel.spot.phoneNumber != nil) && (self.spotSaveModel.spot.email != "" || self.spotSaveModel.spot.email != nil)
                            {
                                if(self.spotSaveModel.spot.website == "" || self.spotSaveModel.spot.website == nil ) && (self.spotSaveModel.spot.phoneNumber == "" || self.spotSaveModel.spot.phoneNumber == nil) && (self.spotSaveModel.spot.email == "" || self.spotSaveModel.spot.email == nil){
                                    print("Web")
                                }
                                else
                                {
                                    self.sections.append(Section(type: .Mandatory, items: [.contactCell]))
                                    self.visibleCells.append(CellTypes.contactCell)
                                }
                                
                            }
                            if self.spotSaveModel.spot.lat != 0.0
                            {
                                self.visibleCells.append(CellTypes.detailMediaCell)
                            }
                            if self.spotSaveModel.spot.lat != 0.0 || self.spotSaveModel.spot.lat != 0.0
                            {
                                CommentDataSource().getSpotSaveComments(spotId: self.spotSaveModel!.spot.id) { (result) in
                                    switch(result){
                                    case .success(let comments):
                                        self.comments = comments
                                        let commentCount = comments.count
                                        self.commentCount = commentCount
                                        if commentCount > 0 {
                                            DispatchQueue.main.async {
                                                self.sections.append(Section(type: .Mandatory, items: [.commentsCell]))
                                                self.visibleCells.append(CellTypes.commentsCell)
                                                self.feedTableView.reloadData()
                                            }
                                        }else{
                                            self.commentCount = 0
                                        }
                                    case .failure(let err):
                                        print(err.errorMessage)
                                    }
                                }
                                
                            }
                            if self.spotSaveModel.spot.operationhours.count > 0
                            {
                                self.sections.append(Section(type: .Mandatory, items: [.detailHoursCell]))
                                self.visibleCells.append(CellTypes.detailHoursCell)
                            }
                            self.feedTableView.reloadData()
                        }
                        
                        
                        self.hideAllHuds()
                        FeedDataSource().postAnalyticsData(spotId: spotModel.id, eventName: "feedFull")
                        
                        
                    case .failure(let error):
                        HSAlertView.showAlert(withTitle: "HoneySpot", message: error.errorMessage)
                        self.hideAllHuds()
                        //self.navigationController?.popViewController(animated: true)
                        print(error.errorMessage)
                    }
                }
            }
			
            
        }else{
            if AppDelegate.originalDelegate.isGuestLogin
            {
                
                showLoadingHud()
                DispatchQueue.global().async {
                    FeedDataSource().getGuestSpotSave(saveId: self.spotSaveModel.spot.id) { (result) in
                        
                        switch(result){
                        case .success(let spotSaveArr):
                            DispatchQueue.main.async
                            {
                                if spotSaveArr.count > 0 {
                                    self.hideAllHuds()
                                    self.spotSaveModel = spotSaveArr.first
                                    
                                    let delivery = self.spotSaveModel.spot.deliveryOptions?.contains("delivery")
                                    let totalCount = self.spotSaveModel.spot.customerPictures.count + self.spotSaveModel.spot.foodPictures.count
                                    if totalCount > 0 {
                                        
                                        self.visibleCells.append(CellTypes.imageCell)
                                    }
                                    if totalCount == 0 {
                                        
                                        self.visibleCells.append(CellTypes.detailImageCell)
                                    }
                                    self.visibleCells.append(CellTypes.detailGeneralCell)
                                    
                                    if self.spotSaveModel.spot.lat != 0.0 || self.spotSaveModel.spot.lat != 0.0
                                    {
                                        
                                        
                                    }
                                    if self.spotSaveModel.spot.categories.count > 0  {
                                        
                                        self.sections.append(Section(type: .Mandatory, items: [.categoryCell]))
                                        self.visibleCells.append(CellTypes.categoryCell)
                                    }
                                    if(self.spotSaveModel.spot.website != "" || self.spotSaveModel.spot.website != nil ) && (self.spotSaveModel.spot.phoneNumber != "" || self.spotSaveModel.spot.phoneNumber != nil) && (self.spotSaveModel.spot.email != "" || self.spotSaveModel.spot.email != nil)
                                    {
                                        if(self.spotSaveModel.spot.website == "" || self.spotSaveModel.spot.website == nil ) && (self.spotSaveModel.spot.phoneNumber == "" || self.spotSaveModel.spot.phoneNumber == nil) && (self.spotSaveModel.spot.email == "" || self.spotSaveModel.spot.email == nil){
                                            print("Web")
                                        }
                                        else
                                        {
                                            self.sections.append(Section(type: .Mandatory, items: [.contactCell]))
                                            self.visibleCells.append(CellTypes.contactCell)
                                        }
                                        
                                    }
                                    if self.spotSaveModel.spot.lat != 0.0
                                    {
                                        self.visibleCells.append(CellTypes.detailMediaCell)
                                    }
                                    if self.spotSaveModel.spot.operationhours.count > 0
                                    {
                                        self.sections.append(Section(type: .Mandatory, items: [.detailHoursCell]))
                                        self.visibleCells.append(CellTypes.detailHoursCell)
                                    }
                                    
                                    if self.spotSaveModel.spot.deliveryOptions!.count > 0
                                    {
                                        self.sections.append(Section(type: .Mandatory, items: [.serviceCell]))
                                        self.visibleCells.append(CellTypes.serviceCell)
                                    }
                                    if delivery! {
                                        
                                        self.sections.append(Section(type: .Mandatory, items: [.deliveryPartnerCell]))
                                        self.visibleCells.append(CellTypes.deliveryPartnerCell)
                                    }
                                    if self.spotSaveModel.spot.spotreservationlink != "" {
                                        
                                        self.sections.append(Section(type: .Mandatory, items: [.reservationCell]))
                                        self.visibleCells.append(CellTypes.reservationCell)
                                    }
                                    
                                    self.feedTableView.reloadData()
                                    FeedDataSource().postAnalyticsData(spotId: self.spotSaveModel.spot.id, eventName: "feedFull")
                                }
                                else
                                {
                                    self.hideAllHuds()
                                    print("No Data Available")
                                }
                            }
                            
                            
                            
                        case .failure(let err):
                            self.hideAllHuds()
                            print(err.errorMessage)
                            HSAlertView.showAlert(withTitle: "Error", message: err.errorMessage)
                        }
                    }
                }
                
            }
            else
            {
                showLoadingHud()
                DispatchQueue.global().async {
                    FeedDataSource().getSpotSave(saveId: self.spotSaveId) { (result) in
                        
                        switch(result){
                        case .success(let spotSaveArr):
                            DispatchQueue.main.async
                            {
                                if spotSaveArr.count > 0 {
                                    
                                    self.spotSaveModel = spotSaveArr.first
                                    
                                    
                                
                                    let delivery = self.spotSaveModel.spot.deliveryOptions?.contains("delivery")
                                    let totalCount = self.spotSaveModel.spot.customerPictures.count + self.spotSaveModel.spot.foodPictures.count
                                    
                                    if totalCount > 0 {
                                        
                                        self.visibleCells.append(CellTypes.imageCell)
                                    }
                                    if totalCount == 0 {
                                        
                                        self.visibleCells.append(CellTypes.detailImageCell)
                                    }
                                    self.visibleCells.append(CellTypes.detailGeneralCell)
                                    if self.spotSaveModel.spot.lat != 0.0 || self.spotSaveModel.spot.lat != 0.0
                                    {
                                        CommentDataSource().getSpotSaveComments(spotId: self.spotSaveModel!.spot.id) { (result) in
                                            switch(result){
                                            case .success(let comments):
                                                self.comments = comments
                                                let commentCount = comments.count
                                                self.commentCount = commentCount
                                                if commentCount > 0 {
                                                    DispatchQueue.main.async {
                                                        self.sections.append(Section(type: .Mandatory, items: [.commentsCell]))
                                                        self.visibleCells.append(CellTypes.commentsCell)
                                                        self.feedTableView.reloadData()
                                                    }
                                                }else{
                                                    self.commentCount = 0
                                                }
                                            case .failure(let err):
                                                print(err.errorMessage)
                                            }
                                        }
                                        
                                    }
                                    
                                    if self.spotSaveModel.spot.categories.count > 0  {
                                        
                                        self.sections.append(Section(type: .Mandatory, items: [.categoryCell]))
                                        self.visibleCells.append(CellTypes.categoryCell)
                                    }
                                    if(self.spotSaveModel.spot.website != "" || self.spotSaveModel.spot.website != nil ) && (self.spotSaveModel.spot.phoneNumber != "" || self.spotSaveModel.spot.phoneNumber != nil) && (self.spotSaveModel.spot.email != "" || self.spotSaveModel.spot.email != nil)
                                    {
                                        if(self.spotSaveModel.spot.website == "" || self.spotSaveModel.spot.website == nil ) && (self.spotSaveModel.spot.phoneNumber == "" || self.spotSaveModel.spot.phoneNumber == nil) && (self.spotSaveModel.spot.email == "" || self.spotSaveModel.spot.email == nil){
                                            print("Web")
                                        }
                                        else
                                        {
                                            self.sections.append(Section(type: .Mandatory, items: [.contactCell]))
                                            self.visibleCells.append(CellTypes.contactCell)
                                        }
                                        
                                    }
                                    if self.spotSaveModel.spot.lat != 0.0
                                    {
                                        self.visibleCells.append(CellTypes.detailMediaCell)
                                    }
                                    if self.spotSaveModel.spot.operationhours.count > 0
                                    {
                                        self.sections.append(Section(type: .Mandatory, items: [.detailHoursCell]))
                                        self.visibleCells.append(CellTypes.detailHoursCell)
                                    }
                                    
                                    if self.spotSaveModel.spot.deliveryOptions!.count > 0
                                    {
                                        self.sections.append(Section(type: .Mandatory, items: [.serviceCell]))
                                        self.visibleCells.append(CellTypes.serviceCell)
                                    }
                                    if delivery! {
                                        
                                        self.sections.append(Section(type: .Mandatory, items: [.deliveryPartnerCell]))
                                        self.visibleCells.append(CellTypes.deliveryPartnerCell)
                                    }
                                    if self.spotSaveModel.spot.spotreservationlink != "" {
                                        
                                        self.sections.append(Section(type: .Mandatory, items: [.reservationCell]))
                                        self.visibleCells.append(CellTypes.reservationCell)
                                    }
                                    
                                    print(self.sections.count)
                                    self.hideAllHuds()
                                    
                                    FeedDataSource().postAnalyticsData(spotId: self.spotSaveModel.spot.id, eventName: "feedFull")
                                    DispatchQueue.main.async {
                                        //self.feedTableView.reloadData()
                                    }
                                    self.feedTableView.reloadData()
                                }
                                else
                                {
                                    self.visibleCells.append(CellTypes.detailImageCell)
                                    //self.visibleCells.append(CellTypes.detailGeneralCell)
                                    DispatchQueue.main.async {
                                        self.feedTableView.reloadData()
                                    }
                                    
                                    self.hideAllHuds()
                                    
                                    print("No Data Available")
                                }

                            }
                                                        
                        case .failure(let err):
                            self.hideAllHuds()
                            print(err.errorMessage)
                            HSAlertView.showAlert(withTitle: "Error", message: err.errorMessage)
                        }
                    }
                    
                }
                
            }
            
        }
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        AppDelegate.originalDelegate.isMap = false
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		//self.tagsCollectionView.reloadData()
	}
    
    func updateFeed()
    {
        FeedDataSource().getSpotSave(saveId: spotSaveModel.id) { (result) in
            
            switch(result){
            case .success(let spotSaveArr):
                if spotSaveArr.count > 0 {
                    self.hideAllHuds()
                    self.spotSaveModel = spotSaveArr.first
                    self.feedTableView.reloadData()
                    FeedDataSource().postAnalyticsData(spotId: self.spotSaveModel.spot.id, eventName: "feedFull")
                }
                else
                {
                    self.hideAllHuds()
                    print("No Data Available")
                }
                
            case .failure(let err):
                self.hideAllHuds()
                print(err.errorMessage)
                HSAlertView.showAlert(withTitle: "Error", message: err.errorMessage)
            }
        }
    }
	
    
    func dishLabel(_ dishName: String) -> UILabel {
        let label = UILabel()
        label.text = "  " + dishName + "  "
        label.backgroundColor = UIColor.LIGHTGRAY_COLOR
        label.font = UIFont(name: "Montserrat-Light", size: 12)!
        label.sizeToFit()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = label.frame.size.height / 2
        return label
    }

	
	@IBAction func shareTapped(_ sender: Any) {
		FeedDataSource().postAnalyticsData(spotId: (self.spotSaveModel.spot.id ?? ""), eventName: "share")
		let text = "I honeyspot a place in Honeyspot App!. You can see it from -> https://itunes.apple.com/app/id1384657784?mt=8 "
		let image = self.spotInfoViewImageView.image
		let shareAll = [text , image] as [Any]
		let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = self.view
		self.present(activityViewController, animated: true, completion: nil)
	}
	
	@IBAction func commentTapped(_ sender: Any) {
		let viewController: CommentsViewController = self.CommentsViewControllerInstance()
		viewController.feedModel = self.feedModel
		viewController.spotSaveModel = self.spotSaveModel
		self.navigationController?.show(viewController, sender: self)
	}
    
    @IBAction func phoneTapped(_ sender: Any) {
        self.phoneNumber = self.phoneNumber.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.phoneNumber = self.phoneNumber.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.phoneNumber = self.phoneNumber.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        if(self.phoneNumber != ""){
            let phoneUrl = URL(string: "tel://\(self.phoneNumber)")!
            if(UIApplication.shared.canOpenURL(phoneUrl)){
                UIApplication.shared.open(phoneUrl, options: [:], completionHandler: nil)
            }
        }
    }
    

    @IBAction func onBackButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAvatarButtonTap(_ sender: Any) {
        let viewController: ProfileViewController = ProfileViewControllerInstance()
        viewController.userModel = self.spotSaveModel.user
        self.navigationController?.show(viewController, sender: nil)
    }
    
    @IBAction func onSaveButtonTap(_ sender: Any) {
        let viewController: EditSpotViewController = EditSpotViewControllerInstance()
		viewController.isInMySavedSpot = self.isInMyHonespot
        viewController.spotSaveModel = spotSaveModel
        viewController.superVC = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func onReservationsButtonTap(_ sender: Any) {
        
    }
    
    @IBAction func onDirectionsButtonTap(_ sender: Any) {
        let spot = self.spotSaveModel.spot
        let urlString: String = String(format: .APPLE_MAP_URL, spot.address.addingPercentEncoding(withAllowedCharacters: String.ENCODING_ALLOWED_CHARACTERS)!)
        UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
    }
	
	@IBAction func addCommentTapped(_ sender: Any) {
		let viewController: CommentsViewController = self.CommentsViewControllerInstance()
		viewController.spotSaveModel = self.spotSaveModel
		viewController.feedModel = self.feedModel
		viewController.shouldKeyboardOpen = true
		self.navigationController?.show(viewController, sender: self)
	}
	
    @IBAction func onViewAllCommentsButtonTap(_ sender: Any) {
        let viewController: CommentsViewController = self.CommentsViewControllerInstance()
        viewController.spotSaveModel = self.spotSaveModel
		viewController.feedModel = self.feedModel
        self.navigationController?.show(viewController, sender: self)
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
    
    @objc func callSpotData(_ notification: NSNotification){
        
        print(notification.userInfo ?? "")
                if let dict = notification.userInfo as NSDictionary? {
                    if let spotSaveId = dict["saveId"] as? String{
                        self.spotSaveId = spotSaveId
                    }
                }
        if self.spotSaveId == "0" {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            FeedDataSource().getSpotSave(saveId: self.spotSaveId) { (result) in
                
                switch(result){
                case .success(let spotSaveArr):
                    if spotSaveArr.count > 0 {
                        self.hideAllHuds()
                        self.spotSaveModel = spotSaveArr.first
                        self.feedTableView.reloadData()
                        FeedDataSource().postAnalyticsData(spotId: self.spotSaveModel.spot.id, eventName: "feedFull")
                    }
                    else
                    {
                        self.hideAllHuds()
                        print("No Data Available")
                    }
                    
                case .failure(let err):
                    self.hideAllHuds()
                    print(err.errorMessage)
                    HSAlertView.showAlert(withTitle: "Error", message: err.errorMessage)
                }
            }
        }
        
    }
    @objc func callSaveToTry(_ notification: NSNotification){
        print("Save to Try")
        self.navigationController?.popViewController(animated: true)
        
    }
    func getComments() {
        CommentDataSource().getSpotSaveComments(spotId: spotSaveModel!.spot.id) { (result) in
            switch(result){
            case .success(let comments):
                self.comments = comments
                let commentCount = comments.count
                self.commentCount = commentCount
                if commentCount > 0 {
                    DispatchQueue.main.async {
                        if(commentCount > 2){
                            self.commentCount = 2
                        }else{
                            self.commentCount = commentCount
                        }
                    }
                }else{
                    self.commentCount = 0
                }
            case .failure(let err):
                print(err.errorMessage)
            }
        }
    }
    deinit {
        feedModel = nil
        print("Feed Detail deinit")
    }
}


extension FeedFullPostViewController {
	
	private func createLeftAlignedLayoutTag() -> UICollectionViewLayout {
	  let item = NSCollectionLayoutItem(          // this is your cell
		layoutSize: NSCollectionLayoutSize(
		  widthDimension: .estimated(40),         // variable width
		  heightDimension: .absolute(40)          // fixed height
		)
	  )
	  
	  let group = NSCollectionLayoutGroup.horizontal(
		layoutSize: .init(
		  widthDimension: .fractionalWidth(1.0),  // 100% width as inset by its Section
		  heightDimension: .estimated(40)         // variable height; allows for multiple rows of items
		),
		subitems: [item]
	  )
	  group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
	  group.interItemSpacing = .fixed(8)         // horizontal spacing between cells

	  return UICollectionViewCompositionalLayout(section: .init(group: group))
	}
	
	private func createLeftAlignedLayoutFavorite() -> UICollectionViewLayout {
	  let item = NSCollectionLayoutItem(          // this is your cell
		layoutSize: NSCollectionLayoutSize(
		  widthDimension: .estimated(40),         // variable width
		  heightDimension: .absolute(20)          // fixed height
		)
	  )
	  
	  let group = NSCollectionLayoutGroup.horizontal(
		layoutSize: .init(
		  widthDimension: .fractionalWidth(1.0),  // 100% width as inset by its Section
		  heightDimension: .estimated(20)         // variable height; allows for multiple rows of items
		),
		subitems: [item]
	  )
	  group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
	  group.interItemSpacing = .fixed(4)         // horizontal spacing between cells

	  return UICollectionViewCompositionalLayout(section: .init(group: group))
	}
	
}

extension FeedFullPostViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var v: SpotAnnotationView? = self.mapViewMapView.dequeueReusableAnnotationView(withIdentifier: SpotAnnotationView.SPOT_ANNOTATION_VIEW_REUSE_IDENTIFICATION) as? SpotAnnotationView
        
        if v == nil {
            v = SpotAnnotationView.init(annotation: annotation, reuseIdentifier: SpotAnnotationView.SPOT_ANNOTATION_VIEW_REUSE_IDENTIFICATION)
        } else {
            v!.annotation = annotation
        }
        
        return v
    }
}

extension FeedFullPostViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.favoriteDishesCollectionView){
            if (self.spotSaveModel != nil) {
                return self.spotSaveModel.favoriteDishes.count
            }
            return 0
            
        }else{
            return self.tags.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.favoriteDishesCollectionView){
            let cell: FavoriteDishCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteDishCell", for: indexPath) as! FavoriteDishCollectionViewCell
			cell.favoriteDishLabel.text = self.spotSaveModel.favoriteDishes[indexPath.row]
			cell.favoriteDishLabel.layer.cornerRadius = 10
			cell.favoriteDishLabel.clipsToBounds = true
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCellId", for: indexPath) as! FeedTagCollectionViewCell
            let tag = getTagFromInt(id: self.tags[indexPath.row] )
            if(tag != nil){
                cell.img.image = tag!.image
                cell.label.text = tag!.name
				cell.bView.layer.cornerRadius = 16
				cell.bView.clipsToBounds = true
            }
            
            return cell
        }
    }
    


}
extension FeedFullPostViewController:MediaCellDelegate
{
    func onLocationTap(spotSaveModel: SpotSaveModel) {
        
        let viewController = self.LocationsViewControllerInstance()
        viewController.spotSavemodel = spotSaveModel
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func onDirectionsButtonTap(spotSaveModel: SpotSaveModel) {
        
        let spot = spotSaveModel.spot
        let urlString: String = String(format: .APPLE_MAP_URL, spot.address.addingPercentEncoding(withAllowedCharacters: String.ENCODING_ALLOWED_CHARACTERS)!)
        UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
    }
    
    func onCallTapped(phoneNumber: String) {
        self.phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        if(self.phoneNumber != ""){
            let phoneUrl = URL(string: "tel://\(self.phoneNumber)")!
            if(UIApplication.shared.canOpenURL(phoneUrl)){
                UIApplication.shared.open(phoneUrl, options: [:], completionHandler: nil)
            }
        }
    }
    
    
}
extension FeedFullPostViewController:CommentCellDelegate
{
    func didAddComment(_ sender: ConsumerDetailCommentsTableViewCell, shouldKeyboardOpen: Bool) {
        
        if AppDelegate.originalDelegate.isGuestLogin
        {
            self.showAlert(title: "Want to comment?")
        }
        else
        {
            if spotSaveModel.id == "" {
                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Save HoneySpot to Comment about this restaurant")
            }
            else
            {
                let viewController: CommentsViewController = self.CommentsViewControllerInstance()
                viewController.spotSaveModel = self.spotSaveModel
                viewController.feedModel = self.feedModel
                viewController.shouldKeyboardOpen = shouldKeyboardOpen
                self.navigationController?.show(viewController, sender: self)
            }
            
        }
        
    }
    
    func didViewAllComment(_ sender: ConsumerDetailCommentsTableViewCell, shouldKeyboardOpen: Bool) {
        
        if AppDelegate.originalDelegate.isGuestLogin
        {
            self.showAlert(title: "Want to comment?")
        }
        else
        {
            if spotSaveModel.id == "" {
                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Save HoneySpot to Comment about this restaurant")
            }
            else
            {
                let viewController: CommentsViewController = self.CommentsViewControllerInstance()
                viewController.spotSaveModel = self.spotSaveModel
                viewController.feedModel = self.feedModel
                viewController.shouldKeyboardOpen = shouldKeyboardOpen
                self.navigationController?.show(viewController, sender: self)
            }
            
        }
        
        
    }
    
}

extension FeedFullPostViewController:FeedImageCellDelegate{
    func didSaveSpot(isInMySavedSpot: Bool, spotSaveModel: SpotSaveModel) {
        if AppDelegate.originalDelegate.isGuestLogin
        {
            self.showAlert(title: "Want to save the restaurant?")
        }
        else
        {
            let viewController: EditSpotViewController = EditSpotViewControllerInstance()
            if AppDelegate.originalDelegate.isWishlist {
                
            }
            else
            {
                AppDelegate.originalDelegate.isWishlist = false
            }
            
            viewController.isInMySavedSpot = isInMySavedSpot
            viewController.spotSaveModel = spotSaveModel
            viewController.superVC = self
            self.present(viewController, animated: true, completion: nil)
        }
       
    }
    
    func didClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didLikeSpot(sender: ConsumerDetailImageTableViewCell) {
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
            if spotSaveModel != nil {
                
                if spotSaveModel.id == "" {
                    HSAlertView.showAlert(withTitle: "HoneySpot", message: "Save HoneySpot to like this restaurant")
                    return
                }
                else
                {
                    if spotSaveModel.spot.didILike {
                        spotSaveModel.spot.didILike = false
                        spotSaveModel.likeCount -= 1
                        if(spotSaveModel.likeCount < 0){
                            spotSaveModel.likeCount = 0
                        }
                        self.feedTableView.reloadData()
                        FeedDataSource().postAnalyticsData(spotId: spotSaveModel.spot.id, eventName: "unlike")
                        
                        LikeDataSource().deleteLike(spotId: spotSaveModel.spot.id) { (result) in
                            switch(result){
                            case .success(let successStr):
                                
                                print(successStr)
                            case .failure(let err):
                                print(err)
                            }
                        }
                    } else {
                        spotSaveModel.spot.didILike = true
                        spotSaveModel.likeCount += 1
                        if(spotSaveModel.likeCount < 0){
                            spotSaveModel.likeCount = 0
                        }
                        self.feedTableView.reloadData()
                        FeedDataSource().postAnalyticsData(spotId: spotSaveModel.spot.id, eventName: "like")
                        
                        LikeDataSource().likePost(spotId: spotSaveModel.spot.id,saveId: spotSaveModel.id) { (result) in
                            switch(result){
                            case .success(let successStr):
                                print(successStr)
                                
                            case .failure(let err):
                                print(err)
                            }
                        }
                    }
                }
                
            }
            
            
        }
        
    }
    
    func didTapComment(_ sender: ConsumerDetailImageTableViewCell, shouldKeyboardOpen: Bool) {
        if AppDelegate.originalDelegate.isGuestLogin
        {
            self.showAlert(title: "Want to comment about the restaurant?")
        }
        else if AppDelegate.originalDelegate.isWishlist
        {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Save HoneySpot to Comment about this restaurant")
        }
        else
        {
            if spotSaveModel.id == "" {
                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Save HoneySpot to Comment about this restaurant")
            }
            else
            {
                let viewController: CommentsViewController = self.CommentsViewControllerInstance()
                viewController.spotSaveModel = self.spotSaveModel
                viewController.feedModel = sender.feedModel
                viewController.shouldKeyboardOpen = shouldKeyboardOpen
                self.navigationController?.show(viewController, sender: self)
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
            if spotSaveModel.id == "" {
                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Save HoneySpot to Share this restaurant")
            }
            else
            {
                FeedDataSource().postAnalyticsData(spotId: (self.spotSaveModel.spot.id ?? ""), eventName: "share")
                let shareAll = [text , image] as [Any]
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
        
        
    }
    
    func didLikeSpot(sender: ConsumerImageTableViewCell) {
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
            if spotSaveModel != nil {
                
                if spotSaveModel.id == "" {
                    HSAlertView.showAlert(withTitle: "HoneySpot", message: "Save HoneySpot to like this restaurant")
                    return
                }
                else
                {
                    if spotSaveModel.spot.didILike {
                        spotSaveModel.spot.didILike = false
                        spotSaveModel.likeCount -= 1
                        if(spotSaveModel.likeCount < 0){
                            spotSaveModel.likeCount = 0
                        }
                        self.feedTableView.reloadData()
                        FeedDataSource().postAnalyticsData(spotId: spotSaveModel.spot.id, eventName: "unlike")
                        
                        LikeDataSource().deleteLike(spotId: spotSaveModel.spot.id) { (result) in
                            switch(result){
                            case .success(let successStr):
                                
                                print(successStr)
                            case .failure(let err):
                                print(err)
                            }
                        }
                    } else {
                        spotSaveModel.spot.didILike = true
                        spotSaveModel.likeCount += 1
                        if(spotSaveModel.likeCount < 0){
                            spotSaveModel.likeCount = 0
                        }
                        self.feedTableView.reloadData()
                        FeedDataSource().postAnalyticsData(spotId: spotSaveModel.spot.id, eventName: "like")
                        
                        LikeDataSource().likePost(spotId: spotSaveModel.spot.id,saveId: spotSaveModel.id) { (result) in
                            switch(result){
                            case .success(let successStr):
                                print(successStr)
                                
                            case .failure(let err):
                                print(err)
                            }
                        }
                    }
                }
                
            }
            
            
        }
        
    }
    
    func didTapComment(_ sender: ConsumerImageTableViewCell, shouldKeyboardOpen: Bool) {
        if AppDelegate.originalDelegate.isGuestLogin
        {
            self.showAlert(title: "Want to comment about the restaurant?")
        }
        else if AppDelegate.originalDelegate.isWishlist
        {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Save HoneySpot to Comment about this restaurant")
        }
        else
        {
            if spotSaveModel.id == "" {
                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Save HoneySpot to Comment about this restaurant")
            }
            else
            {
                let viewController: CommentsViewController = self.CommentsViewControllerInstance()
                viewController.spotSaveModel = self.spotSaveModel
                viewController.feedModel = sender.feedModel
                viewController.shouldKeyboardOpen = shouldKeyboardOpen
                self.navigationController?.show(viewController, sender: self)
            }
            
        }
        
    }
    
    
}

extension FeedFullPostViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(spotSaveModel != nil){
            return visibleCells.count
            
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if visibleCells.count > 0 {
            switch visibleCells[indexPath.row] {
            case .imageCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "consumerImageCellId") as! ConsumerDetailImageTableViewCell
                cell.isAdmin = false
                cell.delegate = self
                if feedModel != nil {
                    cell.feedModel = feedModel
                }
                cell.prepareCell(spotSavemodel: self.spotSaveModel)
                return cell
            case .detailImageCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "detailImageCellId") as! ConsumerImageTableViewCell
                cell.isAdmin = false
                cell.delegate = self
                if feedModel != nil {
                    cell.feedModel = feedModel
                }
                cell.prepareCell(spotSavemodel: self.spotSaveModel)
                return cell
            case .detailGeneralCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "consumerDetailGeneralCellId") as! ConsumerDetailGeneralTableViewCell
                    //cell.superVc = self
                 cell.prepareCell(spotSavemodel: self.spotSaveModel)
                return cell
            case .categoryCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "consumerDetailCategoryCellId") as! ConsumerDetailCategoriesTableViewCell
                //cell.superVc = self
                cell.prepareCell(spotSavemodel: self.spotSaveModel)
                return cell
            case .contactCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "consumerDetailContactCellId") as! ConsumerDetailContactInfoTableViewCell
               // cell.superVc = self
                cell.prepareCell(spotSavemodel: self.spotSaveModel)
                return cell
            case .detailHoursCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "consumerDetailHoursCellId") as! ConsumerDetailHoursOfOperationTableViewCell
                //cell.superVc = self
                cell.prepareCell(spotSavemodel: self.spotSaveModel)
                return cell
            case .detailMediaCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "consumerDetailmediaCellId") as! ConsumerDetailMediaTableViewCell
                //cell.superVc = self
                cell.delegate = self
                cell.isAdmin = false
                cell.prepareCell(spotSavemodel: self.spotSaveModel)
                return cell
            case .commentsCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCellId") as! ConsumerDetailCommentsTableViewCell
                //cell.superVc = self
                cell.delegate = self
                cell.prepareCell(spotSavemodel: self.spotSaveModel)
                return cell
            case .serviceCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "consumerDetailServiceCellId") as! ConsumerDetailServicesOfferedTableViewCell
                //cell.superVc = self
                cell.prepareCell(spotSavemodel: self.spotSaveModel)
                return cell
            case .deliveryPartnerCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "consumerDetailDeliveryCellId") as! ConsumerDetailDeliveyTableViewCell
                //cell.superVc = self
                //cell.delegate = self
                cell.prepareCell(spotSavemodel: self.spotSaveModel)
                return cell
            case .reservationCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "reservationCellId") as! RestaurantDetailReservationTableViewCell
                cell.prepareCell(model : self.spotSaveModel.spot)
                return cell
            default:
                print("Hi")
                
                
            }
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if visibleCells.count > 0 {
            switch visibleCells[indexPath.row] {
            case .imageCell:
                return 325  //325
            case .detailImageCell:
                return 225
            case .detailGeneralCell:
                return UITableView.automaticDimension
            case .categoryCell:
                 return UITableView.automaticDimension
            case .contactCell:
                return 145
            case .detailHoursCell:
                return 310
            case .detailMediaCell:
                return 580
            case .commentsCell:
                return 170
            case .serviceCell:
                return 160
            case .deliveryPartnerCell:
                return 180
            case .reservationCell:
                return 120
                
            default:
                print("Hi")
                
            }
        }
        return 120
    }
    
}


enum CellTypes {
    case imageCell , detailGeneralCell, claimCommentCell ,categoryCell, contactCell, detailHoursCell, detailMediaCell, commentsCell, serviceCell, deliveryPartnerCell, reservationCell, detailImageCell
}
private struct Section {
  var type: SectionType
  var items: [CellTypes]
}
private enum SectionType {
  case Mandatory
  case NotMandatory
}
