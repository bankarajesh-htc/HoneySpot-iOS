//
//  ExploreSearchViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 24.12.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol ExploreSearchDelegate{
	func cityTapped(city : CityModel)
	func personTapped(user : UserModel)
	func spotTapped(spot: SpotModel)
}

class ExploreSearchViewController: UIViewController {

	
	@IBOutlet var searchCollectionView: UICollectionView!
	@IBOutlet var tabIndicatorBackView: UIView!
	@IBOutlet var tabIndicatorView: UIView!
	@IBOutlet var searchTextField: UITextField!
	
	@IBOutlet var citiesButton: UIButton!
	@IBOutlet var profilesButton: UIButton!
	@IBOutlet var honeyspotsButton: UIButton!
	
	var users = [UserModel]()
	var spots = [SpotModel]()
	var cities = [CityModel]()
	
	var loader = JGProgressHUD()
	
	var selectedTab = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.searchTextField.becomeFirstResponder()
	}
	
	func setupViews(){
        if AppDelegate.originalDelegate.isGuestLogin
        {
            self.showAlert(title: "Want to Search the Profile?")
        }
        else
        {
            addDoneButtonOnKeyboard()
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
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
        
    }
	
	func addDoneButtonOnKeyboard(){
		let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
		doneToolbar.barStyle = .default
	
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
	
		let items = [flexSpace, done]
		doneToolbar.items = items
		doneToolbar.sizeToFit()
	
		searchTextField.inputAccessoryView = doneToolbar
	}

	@objc func doneButtonAction(){
		searchTextField.resignFirstResponder()
	}
	
	@IBAction func backTapped(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func clearTapped(_ sender: Any) {
		searchTextField.text = ""
		users.removeAll()
		spots.removeAll()
		cities.removeAll()
		searchCollectionView.reloadData()
		searchTextField.resignFirstResponder()
	}
	
	@IBAction func searchTextChanged(_ sender: Any) {
		var term = searchTextField.text ?? ""
		term = term.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
		if term.count <= 2 {
			return
		}
		searchFromText(term: term)
	}
	
//	@IBAction func citiesTapped(_ sender: Any) {
//		if(self.selectedTab != 0){
//			self.selectedTab = 0
//			self.configureSelectedTab()
//			self.searchTextChanged(UIButton())
//		}
//		DispatchQueue.main.async {
//			UIView.animate(withDuration: 0.5) {
//				self.searchCollectionView.contentOffset.x = 0.0
//			}
//		}
//	}
	
	@IBAction func profilesTapped(_ sender: Any) {
		if(self.selectedTab != 0){
			self.selectedTab = 0
			self.configureSelectedTab()
			self.searchTextChanged(UIButton())
		}
		DispatchQueue.main.async {
			UIView.animate(withDuration: 0.5) {
				self.searchCollectionView.contentOffset.x = 0.0
			}
		}
	}
	
	@IBAction func honeyspotsTapped(_ sender: Any) {
		if(self.selectedTab != 1){
			self.selectedTab = 1
			self.configureSelectedTab()
			self.searchTextChanged(UIButton())
		}
		DispatchQueue.main.async {
			UIView.animate(withDuration: 0.5) {
				self.searchCollectionView.contentOffset.x = UIScreen.main.bounds.width
			}
		}
	}
	
	func configureSelectedTab(){
		if(self.selectedTab == 0){
			tabIndicatorView.frame = CGRect(x: 0 , y: 0, width: tabIndicatorView.frame.width, height: tabIndicatorView.frame.height)
			//citiesButton.setTitleColor(UIColor.ORANGE_COLOR, for: .normal)
			profilesButton.setTitleColor(UIColor.ORANGE_COLOR, for: .normal)
			honeyspotsButton.setTitleColor(UIColor.black, for: .normal)
			self.view.layoutIfNeeded()
		}else if(self.selectedTab == 1){
			tabIndicatorView.frame = CGRect(x: 1 * (tabIndicatorBackView.frame.width  / 2.0), y: 0, width: tabIndicatorView.frame.width, height: tabIndicatorView.frame.height)
			//citiesButton.setTitleColor(UIColor.black, for: .normal)
			profilesButton.setTitleColor(UIColor.black, for: .normal)
			honeyspotsButton.setTitleColor(UIColor.ORANGE_COLOR, for: .normal)
			self.view.layoutIfNeeded()
		}
//		else if(self.selectedTab == 2){
//			tabIndicatorView.frame = CGRect(x: 2 * (tabIndicatorBackView.frame.width  / 3.0), y: 0, width: tabIndicatorView.frame.width, height: tabIndicatorView.frame.height)
//			citiesButton.setTitleColor(UIColor.black, for: .normal)
//			profilesButton.setTitleColor(UIColor.black, for: .normal)
//			honeyspotsButton.setTitleColor(UIColor.ORANGE_COLOR, for: .normal)
//			self.view.layoutIfNeeded()
//		}
	}
	
	
	func searchFromText(term : String){
		if(self.selectedTab == 0){
			//self.searchCities(term: term)
			self.searchProfiles(term: term)
		}else if(self.selectedTab == 1){
			//self.searchProfiles(term: term)
			self.searchHoneyspots(term: term)
		}else if(self.selectedTab == 2){
			self.searchHoneyspots(term: term)
		}
	}
	
	func searchCities(term : String){
		self.loader.show(in: self.view)
		SearchDataSource().searchCity(city: term) { (result) in
			self.loader.dismiss()
			switch(result){
			case .success(let cities):
				self.cities = cities
			case .failure(let err):
				print(err)
			}
			DispatchQueue.main.async {
				self.searchCollectionView.reloadData()
			}
		}
	}
	
	func searchProfiles(term : String){
		self.loader.show(in: self.view)
        DispatchQueue.global().async {
            SearchDataSource().searchPeople(nameText: term) { (result) in
                self.loader.dismiss()
                switch(result){
                case .success(let users):
                    self.users = users
                case .failure(let err):
                    print(err)
                }
                DispatchQueue.main.async {
                    self.searchCollectionView.reloadData()
                }
            }
        }
		
	}
	
	func searchHoneyspots(term : String){
		self.loader.show(in: self.view)
		var lat = 25.0
		var lon = -80.0
		if let location = CustomLocationManager.sharedInstance.lastLocation {
			lat = location.coordinate.latitude
			lon = location.coordinate.longitude
		}
        DispatchQueue.global().async {
            SearchDataSource().searchPlaceName(text: term, latitude: lat, longitude: lon) { (results) in
                self.loader.dismiss()
                switch(results){
                case .success(let googlePlaces):
                    var res: [SpotModel] = []
                    for place: GooglePlaces.Place in googlePlaces {
                        var photoUrl = ""
                        if((place.photos ?? []).count > 0){
                            photoUrl = String.BackendBaseUrl + "/spot/image?reference=" + (place.photos ?? []).first!.photoReference
                        }
                        let spot = SpotModel(id: "", name: place.name, photoUrl: photoUrl, address: "", lat: place.geometry.location.lat, lon: place.geometry.location.lng, phoneNumber: "", googlePlaceId: place.place_id, city: "")
                        res.append(spot)
                        if res.count >= 20 {
                            break
                        }
                    }
                    self.spots = res
                case .failure(let err):
                    print(err)
                }
                DispatchQueue.main.async {
                    self.searchCollectionView.reloadData()
                }
            }
        }
		
	}
	
}

extension ExploreSearchViewController : ExploreSearchDelegate {
	
	func cityTapped(city: CityModel) {
		let c: SearchTopRestaurantsViewController = SearchTopRestaurantsViewControllerInstance()
		c.cityName = city.city
		self.navigationController?.pushViewController(c, animated: true)
	}
	
	func personTapped(user: UserModel) {
		let viewController = ProfileViewControllerInstance()
		viewController.userModel = user
		self.navigationController?.pushViewController(viewController, animated: true)
	}
	
	func spotTapped(spot: SpotModel) {
		let viewController = self.FeedFullPostViewControllerInstance()
		viewController.spotSaveModel = SpotSaveModel(id: "", createdAt: nil, user: emptyUserModel(), spot: spot, description: "", tags: [], commentCount: 0, likeCount: 0, favoriteDishes: [])
		self.navigationController?.pushViewController(viewController, animated: true)
	}
	
}

extension ExploreSearchViewController : UIScrollViewDelegate {
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		switch scrollView.currentPage {
		case 0:
			if(self.selectedTab != 0){
				self.selectedTab = 0
				self.configureSelectedTab()
				self.searchTextChanged(UIButton())
			}
		case 1:
			if(self.selectedTab != 1){
				self.selectedTab = 1
				self.configureSelectedTab()
				self.searchTextChanged(UIButton())
			}
//		case 2:
//			if(self.selectedTab != 2){
//				self.selectedTab = 2
//				self.configureSelectedTab()
//				self.searchTextChanged(UIButton())
//			}
		default:
			break
		}
	}
	
}

extension ExploreSearchViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 2
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//		if(indexPath.row == 0){
//			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCellId", for: indexPath) as! SearchCityCollectionViewCell
//			cell.prepareCell(cities : self.cities)
//			cell.delegate = self
//			return cell
//		}else
		if(indexPath.row == 0){
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCellId", for: indexPath) as! SearchProfileCollectionViewCell
			cell.prepareCell(users : self.users)
			cell.delegate = self
			return cell
		}else{
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "honeyspotCellId", for: indexPath) as! SearchHoneyspotCollectionViewCell
			cell.prepareCell(honeyspots : self.spots)
			cell.delegate = self
			return cell
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width , height: collectionView.frame.height )
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
	}
	
}
