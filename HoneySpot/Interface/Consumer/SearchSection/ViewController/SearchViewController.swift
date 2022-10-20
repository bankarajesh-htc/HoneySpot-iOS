//
//  SearchViewController.swift
//  HoneySpot
//
//  Created by Max on 2/13/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
 
import Alamofire

class SearchViewController: UIViewController,UISearchBarDelegate {

    static let STORYBOARD_IDENTIFIER = "SearchViewController"

    @IBOutlet weak var citiesCollectionView: UICollectionView!
    @IBOutlet weak var topUsersCollectionView: UICollectionView!
	@IBOutlet var searchView: UIView!
 
    var autocompleteController: SearchAutocompleteViewController?
    var runningFullSearchOperation: Bool = false
    var runningQuickSearchOperation: Bool = false
    var dataSource: [Any] = []
    var peopleDataSource: [UserModel] = []
    var placesDataSource: [SpotModel] = []
    var autocompleteResults: [Any] = []
    
    var topUsers = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }

        self.hideKeyboardWhenTappedAround()
        initialize()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkData(_:)), name: NSNotification.Name.init("DeepLinkData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkCityData(_:)), name: NSNotification.Name.init("DeepLinkCityData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkProfileData(_:)), name: NSNotification.Name.init("DeepLinkProfileData"), object: nil)
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
        self.navigationController?.isNavigationBarHidden = true
		
		self.searchView.layer.applySketchShadow(color: UIColor(rgb: 0xA2A2A2), alpha: 0.5, x: 0.0, y: 5.0, blur: 10.0, spread: 0.0)
		self.searchView.layer.cornerRadius = 10
		
        self.peopleDataSource = []
        self.placesDataSource = []
        self.autocompleteResults = []
		searchTopUsers()
    }
	
    func searchTopUsers(){
        self.view.isUserInteractionEnabled = false
        showLoadingHud()
        DispatchQueue.global().async {
            SearchDataSource().searchTopUsers { (result) in
                DispatchQueue.main.async {
                    self.hideAllHuds()
                    switch(result){
                    case .success(let users):
                        DispatchQueue.main.async
                        {
                            self.topUsers = users
                            self.topUsersCollectionView.reloadData()
                            self.view.isUserInteractionEnabled = true
                        }
                    case .failure(let err):
                        print(err)
                    }
                }
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //self.hidesBottomBarWhenPushed = true
        if segue.identifier == "showTopSearch" {
            
        }
        
    }
	
	@IBAction func searchTapped(_ sender: Any) {
        if AppDelegate.originalDelegate.isGuestLogin
        {
            self.showAlert(title: "Want to search profile and restaurant?")
        }
        else
        {
            self.performSegue(withIdentifier: "showTopSearch", sender: self)
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
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            NotificationCenter.default.removeObserver(self)
        }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == topUsersCollectionView){
            return topUsers.count
        }else{
            return 4
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == topUsersCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topUserCellId", for: indexPath) as! TopUsersCollectionViewCell
			cell.img.kf.setImage(with: URL(string: topUsers[indexPath.row].pictureUrl ?? ""), placeholder: UIImage(named: "AvatarPlaceHolder"), options: nil)
            cell.name.text = self.topUsers[indexPath.row].fullname
            cell.nickname.text = self.topUsers[indexPath.row].username?.capitalizingFirstLetter()
			let spotCountStr = (self.topUsers[indexPath.row].spotCount?.description ?? "0") + " " + "Honeyspots"
			let followerCountStr = (self.topUsers[indexPath.row].followerCount?.description ?? "0") + " " + "Followers"
			cell.infoLabel.text = spotCountStr + " • " + followerCountStr
            return cell
        }else{
            let cell: SearchTopCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchTopCollectionViewCell", for: indexPath) as! SearchTopCollectionViewCell
            var text: String = ""
            var img: String = ""
            if indexPath.row == 0 {
                text = "Los Angeles"
                img = "losangeles"
                
            } else if indexPath.row == 1 {
                text = "Miami"
                img = "miami"
                
            } else if indexPath.row == 2 {
                text = "New York"
                img = "newyork"
               
            } else if indexPath.row == 3 {
                text = "San Francisco"
                img = "sanfrancisco"
                
            }
            cell.configureData(img, name: text)
            cell.backgroundColor = UIColor.clear
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == topUsersCollectionView){
            if AppDelegate.originalDelegate.isGuestLogin
            {
                //self.showAlert(title: "Want to view the Profile?")
                let viewController = ProfileViewControllerInstance()
                AppDelegate.originalDelegate.isFeedProfile = true
                viewController.userModel = self.topUsers[indexPath.row]
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
            else
            {
                let viewController = ProfileViewControllerInstance()
                AppDelegate.originalDelegate.isFeedProfile = false
                viewController.userModel = self.topUsers[indexPath.row]
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
        }else{
            if AppDelegate.originalDelegate.isGuestLogin
            {
                //self.showAlert(title: "Want to view the restaurants in the City?")
            }
            else
            {
                
            }
            collectionView.deselectItem(at: indexPath, animated: true)
            let c: SearchTopRestaurantsViewController = SearchTopRestaurantsViewControllerInstance()
            var text: String = ""
            if indexPath.row == 0 {
                text = "Los Angeles"
            } else if indexPath.row == 1 {
                text = "Miami"
            } else if indexPath.row == 2 {
                text = "New York"
            } else if indexPath.row == 3 {
                text = "San Francisco"
            }
            c.cityName = text
            self.navigationController?.pushViewController(c, animated: true)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == topUsersCollectionView){
            return CGSize(width: collectionView.frame.size.width , height: 80)
        }else{
			return CGSize(width: 140.0, height: 140.0)
        }
        
    }
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		if(collectionView == topUsersCollectionView){
			return UIEdgeInsets(top: 0, left: 0.0, bottom: 0.0, right: 0.0)
		}else{
			return UIEdgeInsets(top: 0, left: 16.0, bottom: 0.0, right: 0.0)
		}
		
	}
	
}



