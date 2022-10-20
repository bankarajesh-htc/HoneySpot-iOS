//
//  MapLocationFilterViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 18.08.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import JGProgressHUD

class MapLocationFilterViewController: UIViewController,UISearchBarDelegate {


    @IBOutlet weak var locationBackgroundView: UIView!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var recentTableView: UITableView!
	@IBOutlet var searchBar: UITextField!
	
    
    private let locationManager = CLLocationManager()
    var delegate : MapLocationChangeDelegate!
    
    var progress = JGProgressHUD(style: .dark)
    var searchedLocations = [MapLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        setupViews()
    }
    
    func setupViews(){
        self.resultTableView.isHidden = true
        
        loadRecents()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        self.resultTableView.isHidden = true
        self.searchedLocations.removeAll()
        self.resultTableView.reloadData()
    }
	
	@IBAction func backTapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func searchChanged(_ sender: Any) {
		let term = searchBar.text ?? ""
		
		if(term.count > 0){
			self.resultTableView.isHidden = false
		}else{
			self.resultTableView.isHidden = true
		}
		
		if term.count <= 1 {
			return
		}
		
		self.progress.show(in: self.view)
		self.searchedLocations.removeAll()
		let urlString: String = String(format: .GOOGLEPLACES_API_GET_CITY_FORMATSTRING, term.addingPercentEncoding(withAllowedCharacters: String.ENCODING_ALLOWED_CHARACTERS)!)
		AF.request(urlString)
			.responseDecodable { (response: DataResponse<GooglePredictions,AFError>) in
				
				self.progress.dismiss()
				
				switch response.result {
				case .success(let googlePredictions):
					for predict: GooglePredictions.Prediction in googlePredictions.predictions {
						let googlePlaceId = predict.place_id
						let cityname = predict.terms[0]
						let countryname = predict.terms[predict.terms.count - 1]
						self.searchedLocations.append(MapLocation(googlePlaceId: googlePlaceId, cityName: cityname.value, countryName: countryname.value, location: nil))
					}
					self.resultTableView.reloadData()
					break
				case .failure(let error):
					print("Error with getting google place info", urlString, error)
					break
				}
		}
	}
    
    @IBAction func currentLocationTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate.locationChangedToCurrent()
        }
    }
    
    @IBAction func clearAllTapped(_ sender: Any) {
        recents.removeAll()
        saveRecents()
        recentTableView.reloadData()
    }
    
}

extension MapLocationFilterViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == recentTableView){
            return recents.count
        }else{
            return searchedLocations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == recentTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "recentCellId") as! LocationRecentTableViewCell
            cell.name.text = recents[indexPath.row].cityName
            return cell
        }else{
            let data = searchedLocations[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultCellId") as! LocationFilterResultTableViewCell
            cell.cityName.text = data.cityName
            cell.countryName.text = data.countryName
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == recentTableView){
            self.progress.show(in: self.view)
            let data = recents[indexPath.row]
            
			let lat: Double = Double(data.latitude)!
            let lng: Double = Double(data.longtitude)!
            let location: CLLocation = CLLocation(latitude: lat, longitude: lng)
            
            self.dismiss(animated: true) {
                self.delegate.locationChanged(location: MapLocation(googlePlaceId: data.googlePlaceId, cityName: data.cityName, countryName: data.countryName, location: location))
            }
        }else{
            self.progress.show(in: self.view)
            var data = searchedLocations[indexPath.row]
            
            DispatchQueue.global(qos: .background).async {
                APIClient.getGooglePlaceDetail(GooglePlaceID: data.googlePlaceId) { (googlePlace: GooglePlace?) in
                    
                    self.progress.dismiss()
                    guard let googlePlace = googlePlace else {
                        return
                    }
                    let lat: Double = googlePlace.result.geometry.location.lat
                    let lng: Double = googlePlace.result.geometry.location.lng
                    let location: CLLocation = CLLocation(latitude: lat, longitude: lng)
                    data.location = location
                    
					recents.append(RecentPlace(name: data.cityName, latitude: lat.description, longtitude: lng.description, googlePlaceId: data.googlePlaceId, cityName: data.cityName, countryName: data.countryName))
                    saveRecents()
                    self.recentTableView.reloadData()
                    
                    self.dismiss(animated: true) {
                        self.delegate.locationChanged(location: data)
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == recentTableView){
            return 40
        }else{
            return 72
        }
    }
    
}

class RecentPlace : NSObject, NSCoding {
    
    var name : String
    var latitude : String
    var longtitude : String
    var googlePlaceId : String
    var cityName : String
    var countryName : String
    
    
    init(name : String,latitude:String,longtitude:String,googlePlaceId : String,cityName:String,countryName:String) {
        self.name = name
        self.latitude = latitude
        self.longtitude = longtitude
        self.googlePlaceId = googlePlaceId
        self.cityName = cityName
        self.countryName = countryName
    }
    
    required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "name") as? String ?? ""
        self.latitude = coder.decodeObject(forKey: "latitude") as? String ?? "0.0"
        self.longtitude = coder.decodeObject(forKey: "longtitude") as? String ?? "0.0"
        self.googlePlaceId = coder.decodeObject(forKey: "googlePlaceId") as? String ?? ""
        self.cityName = coder.decodeObject(forKey: "cityName") as? String ?? ""
        self.countryName = coder.decodeObject(forKey: "countryName") as? String ?? ""
    }

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(latitude, forKey: "latitude")
        coder.encode(longtitude, forKey: "longtitude")
        coder.encode(googlePlaceId, forKey: "googlePlaceId")
        coder.encode(cityName, forKey: "cityName")
        coder.encode(countryName, forKey: "countryName")
    }
    
    
}
