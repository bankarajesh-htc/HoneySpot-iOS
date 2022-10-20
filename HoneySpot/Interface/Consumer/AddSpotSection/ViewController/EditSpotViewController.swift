//
//  EditSpotViewController.swift
//  HoneySpot
//
//  Created by Max on 4/5/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
 
import Alamofire
import MapKit

class EditSpotViewController: UIViewController {

    @IBOutlet weak var honeySpotScrollView: UIScrollView!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var spotNameLabel: UILabel!
    @IBOutlet weak var spotAddressLabel: UILabel!
    @IBOutlet weak var spotPictureImageView: UIImageView!
    
    @IBOutlet weak var descriptionCharacterCount: UILabel!
    @IBOutlet weak var descriptionTextField: TextField!
    @IBOutlet weak var favoriteDishesTextField: TextField!
    @IBOutlet weak var tagsView: UIView!
    
    @IBOutlet weak var addHoneyspot: UIButton!
    @IBOutlet weak var deleteHoneySpotButton: UIButton!
    @IBOutlet weak var saveHoneySpotButton: UIButton!
	@IBOutlet var tagIndicatorView: UIView!
	@IBOutlet var tagIndicatorBackView: UIView!
	
	@IBOutlet var cuisinesButton: UIButton!
	@IBOutlet var vibesButton: UIButton!
	@IBOutlet var mealsButton: UIButton!
	@IBOutlet var dietsButton: UIButton!
	
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    var selectedTags = [Int]()
	
	
    
    var tags = [Tag]()
    
//    var spot: Spot?
    var spotSaveModel : SpotSaveModel?
    var isInMySavedSpot: Bool = false
    var isAddingSpot: Bool = false
    var superVC : FeedFullPostViewController!
    
    static let STORYBOARD_IDENTIFIER = "EditSpotViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        spotPictureImageView.clipsToBounds = true
        self.tags = allTags
        self.tagsCollectionView.reloadData()
        spotAddressLabel.adjustsFontSizeToFitWidth = true
        
        self.showLoadingHud()
		self.spotPictureImageView.layer.cornerRadius = 6
		self.spotPictureImageView.clipsToBounds = true
		self.spotPictureImageView.contentMode = .scaleAspectFill
        
        
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       // honeySpotScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 900)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.originalDelegate.isSaveToTry = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initializeUI(withSpot: self.spotSaveModel!.spot)
        self.showLoadingHud()
        SpotDataSource().getSpotSaveOfMe(spotId: (self.spotSaveModel?.spot.id)!) { (result) in
            switch(result){
            case .success(let saves):
                if(saves.count > 0 ){
                    self.hideAllHuds()
                    self.isInMySavedSpot = true
                    self.addHoneyspot.setTitle("Save", for: .normal)
                    self.deleteHoneySpotButton.isHidden = false
                    self.spotSaveModel = saves[0]
                    self.initializeUI(withSpot: self.spotSaveModel!.spot)
                    self.selectedTags = self.spotSaveModel?.tags ?? []
                    self.favoriteDishesTextField.text = self.spotSaveModel?.favoriteDishes.joined(separator: ",")
                    self.descriptionTextField.text = self.spotSaveModel?.description
                    self.tagsCollectionView.reloadData()
                }else{
                    self.findGooglePlace()
                    self.hideAllHuds()
                    self.isInMySavedSpot = false
                    if AppDelegate.originalDelegate.isWishlist {
                        self.saveHoneySpotButton.isHidden = true
                        self.addHoneyspot.isHidden = false
                    }
                    else
                    {
                        self.saveHoneySpotButton.isHidden = false
                        self.addHoneyspot.isHidden = false
                    }
                    
                    //self.addHoneyspot.setTitle("Save HoneySpot", for: .normal)
                    self.deleteHoneySpotButton.isHidden = true
                }
            case .failure(let err):
                print(err)
                self.findGooglePlace()
                self.hideAllHuds()
                self.isInMySavedSpot = false
                if AppDelegate.originalDelegate.isWishlist {
                    self.saveHoneySpotButton.isHidden = true
                }
                else
                {
                    self.saveHoneySpotButton.isHidden = false
                }
                //self.addHoneyspot.setTitle("Save HoneySpot", for: .normal)
                self.deleteHoneySpotButton.isHidden = true
            }
        }
    }
    
    func getSpotId()  {
        SpotDataSource().getSpotSaveOfMe(spotId: (self.spotSaveModel?.spot.id)! ) { (result) in
            switch(result){
            case .success(let saves):
                if(saves.count > 0 ){
                    let spotdata = saves[0]
                    let dataDict:[String: String] = ["saveId": spotdata.id]
                    NotificationCenter.default.post(name: NSNotification.Name.init("PostSpotData"), object: nil,userInfo: dataDict)
                    print(saves)
                   
                }else{
                    let dataDict:[String: String] = ["saveId": "0"]
                    NotificationCenter.default.post(name: NSNotification.Name.init("PostSpotData"), object: nil,userInfo: dataDict)
                }
            case .failure(let err):
                let dataDict:[String: String] = ["saveId": "0"]
                NotificationCenter.default.post(name: NSNotification.Name.init("PostSpotData"), object: nil,userInfo: dataDict)
                print(err.localizedDescription)
               
            }
        }
    }
    
    func findGooglePlace(){
        if(self.spotSaveModel!.spot.googlePlaceId != ""){
            SpotDataSource().getSpot(googlePlaceId: self.spotSaveModel!.spot.googlePlaceId) { (result) in
                switch(result){
                case .success(let spot):
                    let user = UserModel(id: "", username: nil, fullname: nil, pictureUrl: nil, userBio: nil, spotCount: nil, followerCount: nil, followingCount: nil)
					let ssModel = SpotSaveModel(id: "", createdAt: nil, user: user, spot: spot, description: "", tags: self.selectedTags, commentCount: 0, likeCount: 0, favoriteDishes: [])
                    self.spotSaveModel = ssModel
                case.failure(let err):
                    print(err)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    // Initialize UI related with SpotSave
    func initializeUI(withSpotSave spotSave: SpotSaveModel) {
        self.descriptionTextField.text = spotSave.description
        self.favoriteDishesTextField.text = spotSave.favoriteDishes.joined(separator: ",")
        self.descriptionCharacterCount.text = (descriptionTextField.text?.count.description ?? "0") + "/140"
        self.tagsCollectionView.reloadData()
    }
    
    // Initialize UI related with spot
    func initializeUI(withSpot spot: SpotModel) {
        spotNameLabel.text = spot.name
        spotAddressLabel.text = spot.address
        self.spotPictureImageView.contentMode = .scaleAspectFill
        self.spotPictureImageView.kf.setImage(with: URL(string: spot.photoUrl))
        self.spotPictureImageView.clipsToBounds = true
    }
    
    @IBAction func descriptionChanged(_ sender: Any) {
        if((descriptionTextField.text?.count ?? 0) > 140){
            var tempText = descriptionTextField.text!
            tempText.removeLast(1)
            descriptionTextField.text = tempText
        }
        descriptionCharacterCount.text = (descriptionTextField.text?.count.description ?? "0") + "/140"
    }
    
    @IBAction func onCloseButtonTap(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            
        })
    }
    @IBAction func onSavetoTry(_ sender: Any) {
        self.showLoadingHud()
        let desc: String = descriptionTextField.text ?? ""
        var favoriteDishes = favoriteDishesTextField.text ?? ""
        favoriteDishes = favoriteDishes.replacingOccurrences(of: ", ", with: ",")
        let seperatedDishes = favoriteDishes.components(separatedBy: ",")
        SpotDataSource().savetoTry(spotId: (self.spotSaveModel?.spot.id)!, favoriteDishes: seperatedDishes, insiderTips: "", description: desc, tags: selectedTags) { (result) in
            self.hideAllHuds()
            switch(result){
            case .success(let successStr):
                print(successStr)
                if(successStr == "You have already wishlisted this restaurant")
                {
                    self.showAlert(title: "You have already wishlisted this restaurant")
                }
                else
                {
                    self.getSpotId()
                    self.dismiss(animated: true, completion: nil)
                    HoneySpotSaveAlert.instance.showAlert(honeySpotString: "HoneySpot Saved to Try!") { (aa) in
                        if(aa == .actionTapped){
                            let text = "I Honeyspotted a restaurant in Honeyspot App!. You can see it from -> https://honeyspotapp.app.link/spot?$custom_data=\(self.spotSaveModel!.id)"
                           // let text = "I have saved a restaurant in Honeyspot App!. You can see it from -> https://itunes.apple.com/app/id1384657784?mt=8 "
                            let shareAll = [text] as [Any]
                            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                            activityViewController.popoverPresentationController?.sourceView = self.view
                            getVisiblVc()!.present(activityViewController, animated: true, completion: nil)
                        }
                    }
                }
                
                
                
                
            case .failure(let err):
                print(err)
            }
        }
        
            
    }
    
    @IBAction func onSaveButtonTap(_ sender: Any) {
        self.showLoadingHud()
        let desc: String = descriptionTextField.text ?? ""
        var favoriteDishes = favoriteDishesTextField.text ?? ""
        favoriteDishes = favoriteDishes.replacingOccurrences(of: ", ", with: ",")
		let seperatedDishes = favoriteDishes.components(separatedBy: ",")
        //let insiderTips: String = insiderTipsTextView.text

        if(self.isInMySavedSpot){

            SpotDataSource().editSpotSave(saveId: self.spotSaveModel!.id, favoriteDishes: seperatedDishes, insiderTips: "", description: desc, tags: selectedTags) { (result) in
                self.hideAllHuds()
                switch(result){
                case .success(let successStr):
					FeedDataSource().postAnalyticsData(spotId: self.spotSaveModel!.spot.id, eventName: "spotEdit")
                    self.superVC.viewWillAppear(true)
                    print(successStr)
                    self.dismiss(animated: true, completion: nil)
                    Analytics.shared.sendAnalyticsEvent(eventName: "spotSaved", eventParameters:
                        [
                            "userId" : UserDefaults.standard.string(forKey: "userId") ?? "",
                            "spotCity" : self.spotSaveModel?.spot.city ?? "",
                            "description" : self.spotSaveModel?.description ?? "",
                            "googlePlaceId" : self.spotSaveModel?.spot.googlePlaceId ?? ""
                        ]
                    )
					HoneySpotSaveAlert.instance.showAlert(honeySpotString: "HoneySpot Saved!") { (aa) in
						if(aa == .actionTapped){
							let text = "I honeyspot a place in Honeyspot App!. You can see it from -> https://itunes.apple.com/app/id1384657784?mt=8 "
							let shareAll = [text] as [Any]
							let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
							activityViewController.popoverPresentationController?.sourceView = self.view
							getVisiblVc()!.present(activityViewController, animated: true, completion: nil)
						}
					}
                case .failure(let err):
                    print(err)
                }
            }
        }else{
            SpotDataSource().addSpotSave(spotId: (self.spotSaveModel?.spot.id)!, favoriteDishes: seperatedDishes, insiderTips: "", description: desc, tags: selectedTags) { (result) in
                self.hideAllHuds()
                switch(result){
                case .success(let successStr):
                    print(successStr)
                    if successStr == "You have already honeyspotted this restaurant" {
                        self.showAlert(title: "You have already honeyspotted this restaurant")
//                        self.dismiss(animated: true, completion: nil)
//                        let dataDict:[String: String] = ["saveId": "0"]
//                        NotificationCenter.default.post(name: NSNotification.Name.init("PostSpotData"), object: nil,userInfo: dataDict)
                       // HSAlertView.showAlert(withTitle: "HoneySpot", message: "You have already honeyspotted this restaurant")
                        
                    }
                    else
                    {
                        self.getSpotId()
                        self.dismiss(animated: true, completion: nil)
                        FeedDataSource().postAnalyticsData(spotId: self.spotSaveModel!.spot.id, eventName: "spotAdd")
                        Analytics.shared.sendAnalyticsEvent(eventName: "spotSaved", eventParameters:
                            [
                                "userId" : UserDefaults.standard.string(forKey: "userId") ?? "",
                                "spotCity" : self.spotSaveModel?.spot.city ?? "",
                                "description" : self.spotSaveModel?.description ?? "",
                                "googlePlaceId" : self.spotSaveModel?.spot.googlePlaceId ?? ""
                            ]
                        )
                        HoneySpotSaveAlert.instance.showAlert(honeySpotString: "HoneySpot Saved!") { (aa) in
                            if(aa == .actionTapped){
                                let text = "I Honeyspotted a restaurant in Honeyspot App!. You can see it from -> https://honeyspotapp.app.link/spot?$custom_data=\(self.spotSaveModel!.id)"
                                //let text = "I honeyspot a place in Honeyspot App!. You can see it from -> https://itunes.apple.com/app/id1384657784?mt=8 "
                                let shareAll = [text] as [Any]
                                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                                activityViewController.popoverPresentationController?.sourceView = self.view
                                getVisiblVc()!.present(activityViewController, animated: true, completion: nil)
                            }
                        }
                    }
                    
                case .failure(let err):
                    print(err)
                }
            }
        }
        
        
    }
    
    @IBAction func onDeleteButtonTap(_ sender: Any) {
        showLoadingHud()
        SpotDataSource().deleteSpot(saveId: self.spotSaveModel!.id) { (result) in
            self.hideAllHuds()
            switch(result){
            case .success(let successStr):
                print(successStr)
                self.dismiss(animated: true) {
                    self.superVC.navigationController?.popViewController(animated: true)
                }
                self.dismiss(animated: true, completion: nil)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    @IBAction func directionsTapped(_ sender: Any) {
        let urlString: String = String(format: .APPLE_MAP_URL, (self.spotSaveModel?.spot.address.addingPercentEncoding(withAllowedCharacters: String.ENCODING_ALLOWED_CHARACTERS)!)!)
        UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
    }
    
	
	@IBAction func cuisinesTapped(_ sender: Any) {
		configureTab(index: 0)
		tagsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
	}
	
	@IBAction func vibesTapped(_ sender: Any) {
		configureTab(index: 1)
		tagsCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
	}
	
	@IBAction func mealsTapped(_ sender: Any) {
		configureTab(index: 2)
		tagsCollectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredHorizontally, animated: true)
	}
	
	@IBAction func dietsTapped(_ sender: Any) {
		configureTab(index: 3)
		tagsCollectionView.scrollToItem(at: IndexPath(row: 3, section: 0), at: .centeredHorizontally, animated: true)
	}
	
	func configureTab(index : Int){
		if(index == 0){
			tagIndicatorView.frame = CGRect(x: 0 , y: 0, width: tagIndicatorView.frame.width, height: tagIndicatorView.frame.height)
			cuisinesButton.setTitleColor(UIColor.ORANGE_COLOR, for: .normal)
			vibesButton.setTitleColor(UIColor.black, for: .normal)
			mealsButton.setTitleColor(UIColor.black, for: .normal)
			dietsButton.setTitleColor(UIColor.black, for: .normal)
			self.view.layoutIfNeeded()
		}else if(index == 1){
			tagIndicatorView.frame = CGRect(x: 1 * (tagIndicatorBackView.frame.width  / 4.0), y: 0, width: tagIndicatorView.frame.width, height: tagIndicatorView.frame.height)
			cuisinesButton.setTitleColor(UIColor.black, for: .normal)
			vibesButton.setTitleColor(UIColor.ORANGE_COLOR, for: .normal)
			mealsButton.setTitleColor(UIColor.black, for: .normal)
			dietsButton.setTitleColor(UIColor.black, for: .normal)
			self.view.layoutIfNeeded()
		}else if(index == 2){
			tagIndicatorView.frame = CGRect(x: 2 * (tagIndicatorBackView.frame.width  / 4.0), y: 0, width: tagIndicatorView.frame.width, height: tagIndicatorView.frame.height)
			cuisinesButton.setTitleColor(UIColor.black, for: .normal)
			vibesButton.setTitleColor(UIColor.black, for: .normal)
			mealsButton.setTitleColor(UIColor.ORANGE_COLOR, for: .normal)
			dietsButton.setTitleColor(UIColor.black, for: .normal)
			self.view.layoutIfNeeded()
		}else if(index == 3){
			tagIndicatorView.frame = CGRect(x: 3 * (tagIndicatorBackView.frame.width  / 4.0), y: 0, width: tagIndicatorView.frame.width, height: tagIndicatorView.frame.height)
			cuisinesButton.setTitleColor(UIColor.black, for: .normal)
			vibesButton.setTitleColor(UIColor.black, for: .normal)
			mealsButton.setTitleColor(UIColor.black, for: .normal)
			dietsButton.setTitleColor(UIColor.ORANGE_COLOR, for: .normal)
			self.view.layoutIfNeeded()
		}
	}
	
	@IBAction func backTapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
    
    func showAlert(title: String)  {
        
        let alert: UIAlertController = UIAlertController(
            title: "HoneySpot",
            message: title,
            preferredStyle: .alert)
        
        //Add Buttons
        let yesButton: UIAlertAction = UIAlertAction(
            title: "Ok",
            style: .default) { (action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)

        }
        
        let noButton: UIAlertAction = UIAlertAction(
            title: "CANCEL",
            style: .cancel) { (action: UIAlertAction) in
            
        }
        
        alert.addAction(yesButton)
       // alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
        
    }
	
}

extension EditSpotViewController : UIScrollViewDelegate {
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		configureTab(index: scrollView.currentPage)
	}
	
}

extension EditSpotViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagContainerCellId", for: indexPath) as! AddSpotTagContainerCollectionViewCell
		if(indexPath.row == 0){
			cell.tags = cusinesTags
		}else if(indexPath.row == 1){
			cell.tags = occasionsTags
		}else if(indexPath.row == 2){
			cell.tags = mealsTags
		}else if(indexPath.row == 3){
			cell.tags = dietsTags
		}
		cell.superVc = self
		cell.prepareCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
	
}


struct Tag {
    let id : Int
    let name : String
    var image : UIImage
    let grayImage : UIImage
}

