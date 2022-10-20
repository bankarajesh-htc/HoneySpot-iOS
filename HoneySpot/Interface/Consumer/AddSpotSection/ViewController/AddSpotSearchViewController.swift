//
//  AddSpotSearchViewController.swift
//  HoneySpot
//
//  Created by Max on 4/5/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
import SVProgressHUD

class AddSpotSearchViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nearYouTableView: UITableView!
    @IBOutlet weak var searchTableView: UITableView!
    
    static let STORYBOARD_IDENTIFIER = "AddSpotSearchViewController"
    
    var dataSource: [SpotModel] = []
    var placesNearMe: [SpotModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        initialize()
    }
    
    func initialize() {
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.isNavigationBarHidden = true
        
        let attributes:[NSAttributedString.Key:Any] = [
            NSAttributedString.Key.foregroundColor : UIColor.ORANGE_COLOR,
            NSAttributedString.Key.font : UIFont(name: "Montserrat-Bold", size: 17.0)
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        searchBar.autocapitalizationType = .none
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.font = UIFont(name: "Montserrat-Regular", size: 17.0)
        } else {
            // Fallback on earlier versions
        }
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CustomLocationManager.sharedInstance.delegate = self
        CustomLocationManager.sharedInstance.startUpdatingLocation()
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        searchBar.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        self.searchTableView.isHidden = true
        self.dataSource.removeAll()
        self.placesNearMe.removeAll()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
        self.perform(#selector(self.reload), with: nil, afterDelay: 0.3)
    }
    
    @objc func reload() {
        let term = searchBar.text ?? ""
        
        if(term.count > 0){
            searchBar.setShowsCancelButton(true, animated: true)
            self.searchTableView.isHidden = false
        }else{
            searchBar.setShowsCancelButton(false, animated: true)
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

extension AddSpotSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return dataSource.count == 0 ? "HoneySpots near you" : ""
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let myLabel = UILabel()
//        myLabel.frame = CGRect(x: 20, y: 8, width: tableView.bounds.size.width, height: 30)
//        myLabel.font = UIFont(name: "Montserrat-Regular", size: 13)!
//        myLabel.text = dataSource.count == 0 ? "HoneySpots near you" : ""
//        myLabel.textColor = UIColor.darkGray
//        myLabel.sizeToFit()
//        let headerView = UIView()
//        headerView.addSubview(myLabel)
//        headerView.backgroundColor = .white
//
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == nearYouTableView){
            return 110
        }else{
            return 65
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == nearYouTableView){
            return placesNearMe.count
        }else{
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == nearYouTableView){
            let cell = self.nearYouTableView.dequeueReusableCell(withIdentifier: "nearYouCellId", for: indexPath) as! AddSpotSearchTableViewCell
            cell.spot = placesNearMe[indexPath.row]
            cell.saveButton.layer.cornerRadius = cell.saveButton.frame.height / 2
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = self.searchTableView.dequeueReusableCell(withIdentifier: "searchCellId", for: indexPath) as! AddSpotSearchResultTableViewCell
            cell.spot = dataSource[indexPath.row]
            cell.tags.text = "Tap to see details"
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == nearYouTableView){
            tableView.deselectRow(at: indexPath, animated: true)
            let spot: SpotModel = placesNearMe[indexPath.row]
            let viewController = self.FeedFullPostViewControllerInstance()
			viewController.spotSaveModel = SpotSaveModel(id: "", createdAt: nil, user: emptyUserModel(), spot: spot, description: "", tags: [], commentCount: 0, likeCount: 0, favoriteDishes: [])
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            tableView.deselectRow(at: indexPath, animated: true)
            let spot: SpotModel = dataSource[indexPath.row]
            let viewController = self.FeedFullPostViewControllerInstance()
			viewController.spotSaveModel = SpotSaveModel(id: "", createdAt: nil, user: emptyUserModel(), spot: spot, description: "", tags: [], commentCount: 0, likeCount: 0, favoriteDishes: [])
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
}

extension AddSpotSearchViewController: AddSpotSearchTableViewCellDelegate {
    
    func didPressSaveSpotButton(_ sender: AddSpotSearchTableViewCell) {
        let indexPath = self.nearYouTableView.indexPath(for: sender)!
        let spot: SpotModel = self.dataSource.count > 0 ? self.dataSource[indexPath.row] : self.placesNearMe[indexPath.row]
        
        let viewController: EditSpotViewController = EditSpotViewControllerInstance()
        viewController.isInMySavedSpot = false
        viewController.isAddingSpot = true
		viewController.spotSaveModel = SpotSaveModel(id: "", createdAt: nil, user: emptyUserModel(), spot: spot, description: "", tags: [], commentCount: 0, likeCount: 0, favoriteDishes: [])
        self.present(viewController, animated: true, completion: nil)
    }
    
}

extension AddSpotSearchViewController: CustomLocationServiceDelegate {
    // MARK: - CustomLocationServiceDelegate
    func locationDidUpdateToLocation(currentLocation: CLLocation) {
        //        CustomLocationManager.sharedInstance.stopUpdatingLocation()
        self.getGooglePlacesNearMe { (spots: [SpotModel], success: Bool) in
            self.placesNearMe.removeAll()
            self.placesNearMe += spots
            self.nearYouTableView.reloadData()
        }
        
    }
    
    func locationUpdateDidFailWithError(error: Error) {
        //        CustomLocationManager.sharedInstance.stopUpdatingLocation()
    }
}
