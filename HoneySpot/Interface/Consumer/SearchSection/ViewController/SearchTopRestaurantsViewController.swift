//
//  SearchTopRestaurantsViewController.swift
//  HoneySpot
//
//  Created by Max on 2/22/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import MapKit
 

class SearchTopRestaurantsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
	@IBOutlet var collectionView: UICollectionView!
	
    var cityName: String?
    var dataSource: [SpotModel] = []
    
    static let STORYBOARD_IDENTIFIER = "SearchTopRestaurantsViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkData(_:)), name: NSNotification.Name.init("DeepLinkData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkCityData(_:)), name: NSNotification.Name.init("DeepLinkCityData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkProfileData(_:)), name: NSNotification.Name.init("DeepLinkProfileData"), object: nil)
        if cityName == "NewYork" {
            cityName = "New York"
        }
        else if cityName == "LosAngeles" {
            cityName = "Los Angeles"
        }
        else if cityName == "SanFrancisco" {
            cityName = "San Francisco"
        }
        
        initialize()
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
    
    func initialize() {
        guard let cityName = self.cityName else {
            return
        }
        self.titleLabel.text = cityName
        if AppDelegate.originalDelegate.isGuestLogin
        {
            showLoadingHud()
            SearchDataSource().searchGuestCityTopRestaurants(city: cityName) { (result) in
                self.hideAllHuds()
                switch(result){
                case .success(let spots):
                    self.dataSource.removeAll()
                    self.dataSource += spots
                    self.collectionView.reloadData()
                case .failure(let err):
                    print(err)
                }
            }
        }
        else
        {
            showLoadingHud()
            DispatchQueue.global().async {
                SearchDataSource().searchCityTopRestaurants(city: cityName) { (result) in
                    self.hideAllHuds()
                    switch(result){
                    case .success(let spots):
                        DispatchQueue.main.async
                        {
                            self.dataSource.removeAll()
                            self.dataSource += spots
                            self.collectionView.reloadData()
                        }
                    case .failure(let err):
                        print(err)
                    }
                }
            }
            
            
        }
        
    }
    
    @IBAction func onCloseButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func shareButtonTap(_ sender: Any) {
        if AppDelegate.originalDelegate.isGuestLogin
        {
            self.showAlert(title: "Want to Share the restaurants in this city?")
        }
        else
        {
            let image = UIImage(named: "LogoSmall")
            let result = cityName!.removeWhitespace()
            print(result)
            let text = "I am Sharing the Cities in Honeyspot App!. You can see it from -> https://honeyspotapp.app.link/cityName?$custom_data=\(result)"
            let shareAll = [text , image as Any] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
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

extension SearchTopRestaurantsViewController : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 110.0)
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataSource.count
	}
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "honeyspotCellId", for: indexPath) as! SearchHoneyspotSubCollectionViewCell
		cell.honeyspotCountLabel.isHidden = true
		cell.address.text = "Address loading..."
		cell.locationName.text = dataSource[indexPath.row].name
		cell.img.contentMode = .scaleAspectFill
		cell.img.kf.setImage(with: URL(string: dataSource[indexPath.row].photoUrl), placeholder: UIImage(named: "ImagePlaceholder"), options: nil)
		
		let lat = dataSource[indexPath.row].lat
		let lon = dataSource[indexPath.row].lon
		let location: CLLocation = CLLocation(latitude: lat, longitude: lon)
		let geoCoder = CLGeocoder()
		geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) in
			if let placemarks = placemarks {
				let p: CLPlacemark = placemarks[0]
				let city = p.locality ?? ""
				let country = p.country ?? Locale.current.regionCode
				cell.address.text = city + "," + (country ?? "")
			} else {
				print("Reverse geocoding failed\(error!)")
				cell.address.text = "Address not found"
			}
		})
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let viewController = self.FeedFullPostViewControllerInstance()
        viewController.isComingFromProfile = false
		
        if AppDelegate.originalDelegate.isGuestLogin {
            viewController.spotSaveModel = SpotSaveModel(id: "", createdAt: nil, user: emptyUserModel(), spot: self.dataSource[indexPath.row], description: "", tags: [], commentCount: 0, likeCount: 0, favoriteDishes: [])
            viewController.spotSaveId = self.dataSource[indexPath.row].id
        }
        else
        {
            viewController.spotSaveModel = SpotSaveModel(id: "", createdAt: nil, user: emptyUserModel(), spot: self.dataSource[indexPath.row], description: "", tags: [], commentCount: 0, likeCount: 0, favoriteDishes: [])
        }
        
		self.navigationController?.pushViewController(viewController, animated: true)
	}
	
}


extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
  }
