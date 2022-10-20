//
//  BusinessRestaurantSearchViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 2.07.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit

import UIKit
import Alamofire
import MapKit
import SVProgressHUD

class BusinessRestaurantSearchViewController: UIViewController {

	@IBOutlet var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
	@IBOutlet var searchCancelButton: UIButton!
	
	var superVc : BusinessRestaurantViewController!
    static let STORYBOARD_IDENTIFIER = "BusinessRestaruantSearchViewController"
    
    var dataSource: [SpotModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        initialize()
    }
    
    func initialize() {
		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
		
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.isNavigationBarHidden = true
        
        let attributes:[NSAttributedString.Key:Any] = [
            NSAttributedString.Key.foregroundColor : UIColor.ORANGE_COLOR,
            NSAttributedString.Key.font : UIFont(name: "Montserrat-Bold", size: 17.0)
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
		searchTextField.autocapitalizationType = .none
        addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

	@IBAction func closeTapped(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc func doneButtonAction(){
        searchTextField.resignFirstResponder()
    }
	
	@IBAction func searchCancelTapped(_ sender: Any) {
		searchTextField.text = ""
		searchCancelButton.isHidden = true
		self.searchTableView.isHidden = true
		self.dataSource.removeAll()
	}
	
	@IBAction func searchChanged(_ sender: Any) {
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
		self.perform(#selector(self.reload), with: nil, afterDelay: 0.3)
	}
	
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
        self.perform(#selector(self.reload), with: nil, afterDelay: 0.3)
    }
    
    @objc func reload() {
        let term = searchTextField.text ?? ""
        
        if(term.count > 0){
			searchCancelButton.isHidden = false
            self.searchTableView.isHidden = false
        }else{
			searchCancelButton.isHidden = false
            self.searchTableView.isHidden = true
        }
        
        if term.count <= 1 {
            return
        }
        
        self.placesAutocomplete(term) { (results: [SpotModel]?) in
            guard let results = results else {
                return
            }
            self.dataSource.removeAll()
            
            var c: Int = 0
            for r: SpotModel in results as! [SpotModel] {
                self.dataSource.append(r)
                c += 1
                if c >= 4 {
                    break
                }
            }
        
            self.searchTableView.reloadData()
            
            SVProgressHUD.dismiss()
        }
    }
    
    func placesAutocomplete(_ term: String, completion: @escaping ([SpotModel]?) -> Void) {
        if term.count <= 2 {
            completion([])
            return
        }
        
        var lat = 25.0
        var lon = -80.0
        if let location = CustomLocationManager.sharedInstance.lastLocation {
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
        }
        
        SpotDataSource().searchPlaceName(text: term, latitude: lat, longitude: lon) { (response) in
            switch response {
            case .success(let googlePlaces):
                var res: [SpotModel] = []
                if googlePlaces.count > 0 {
                    for place: GooglePlaces.Place in googlePlaces {
                        var photoUrl = ""
                        if((place.photos ?? []).count > 0){
                            photoUrl = String.BackendBaseUrl + "/spot/image?reference=" + (place.photos ?? []).first!.photoReference
                        }
                        let spot = SpotModel(id: "", name: place.name, photoUrl: photoUrl, address: "", lat: 0.0, lon: 0.0, phoneNumber: "", googlePlaceId: place.place_id, city: "")
                        res.append(spot)
                        if res.count >= 5 {
                            break
                        }
                    }
                    DispatchQueue.main.async {
                        completion(res)
                    }
                    break
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    completion([])
                }
                break
            }
        }
    }

    func getGooglePlacesNearMe(completion: @escaping (_ spots: [SpotModel], _ success: Bool) -> Void) {
        guard let location = CustomLocationManager.sharedInstance.lastLocation else {
            DispatchQueue.main.async {
                completion([], false)
            }
            return
        }
        
        showLoadingHud()
        SpotDataSource().searchPlaceNearMe(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { (response) in
            self.hideAllHuds()
            switch response {
            case .success(let googlePlaces):
                if googlePlaces.count > 0 {
                    var spots: [SpotModel] = []
                    for place: GooglePlaces.Place in googlePlaces {
                        var photoUrl = ""
                        if((place.photos ?? []).count > 0){
                            photoUrl = String.BackendBaseUrl + "/spot/image?reference=" + (place.photos ?? []).first!.photoReference
                        }
                        
                        let spot = SpotModel(id: "", name: place.name, photoUrl: photoUrl, address: "", lat: 0.0, lon: 0.0, phoneNumber: "", googlePlaceId: place.place_id, city: "")
                        spots.append(spot)
                        if spots.count >= 5 {
                            break
                        }
                    }
                    DispatchQueue.main.async {
                        completion(spots, true)
                    }
                }
                break
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    completion([], false)
                }
                break
            }
        }
    }
}

extension BusinessRestaurantSearchViewController: UITableViewDelegate, UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchTableView.dequeueReusableCell(withIdentifier: "searchCellId", for: indexPath) as! AddSpotSearchResultTableViewCell
		cell.spot = dataSource[indexPath.row]
		cell.tags.text = dataSource[indexPath.row].address
		cell.selectionStyle = .none
		return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		
        tableView.deselectRow(at: indexPath, animated: true)
		
		let alert: UIAlertController = UIAlertController(
			title: "Claim",
			message: "Do you want to claim this restaurant?",
			preferredStyle: .alert)
		
		//Add Buttons
		let yesButton: UIAlertAction = UIAlertAction(
			title: "Claim",
			style: .default) { (action: UIAlertAction) in
				let spot: SpotModel = self.dataSource[indexPath.row]
				self.showLoadingHud()
				SpotDataSource().getSpot(googlePlaceId: self.dataSource[indexPath.row].googlePlaceId) { (result) in
					switch(result){
					case .success(let str):
						print("Success Google Place Id")
					case .failure(let err):
						print(err)
					}
					BusinessRestaurantDataSource().claimRestaurant(spotId: spot.googlePlaceId, comment: "") { (result) in
						self.hideAllHuds()
						switch(result){
						case .success(let str):
							print(str)
							self.dismiss(animated: true) {
								self.superVc.getData()
							}
						case .failure(let err):
							print(err)
							self.showErrorHud(message: err.errorMessage)
						}
					}
				}
		}
		
		let noButton: UIAlertAction = UIAlertAction(
			title: "Cancel",
			style: .cancel) { (action: UIAlertAction) in
		}
		
		alert.addAction(yesButton)
		alert.addAction(noButton)
		present(alert, animated: true, completion: nil)

    }
}
