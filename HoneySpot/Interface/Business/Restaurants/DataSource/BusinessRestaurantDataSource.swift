//
//  BusinessRestaurantDataSource.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 30.06.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import Foundation
import Alamofire

class BusinessRestaurantDataSource {
	
	func saveSpot(spotModel : SpotModel,completion: @escaping (Result<String,CustomError>) -> ()){
		let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: String] = [
			"spotId" : spotModel.id,
			"spotName" : spotModel.name,
			"spotOwners" : spotModel.owners ?? "",
			"spotPhotoUrl" : spotModel.photoUrl,
			"spotLogoUrl" : spotModel.logoUrl ?? "",
			"spotAddress" : spotModel.address,
			"spotWebsite" : spotModel.website ?? "",
			"spotEmail" : spotModel.email ?? "",
            "spotReservationLink" : spotModel.spotreservationlink,
            "spotReservationDescription" : spotModel.spotreservationdescription,
			"spotLatitude" : spotModel.lat.description,
			"spotLongtitude" : spotModel.lon.description,
			"spotPhoneNumber" : spotModel.phoneNumber ?? "",
			"spotDeliveryOptions" : spotModel.deliveryOptions?.joined(separator: ",") ?? "",
			"spotMenuPictureUrls" : spotModel.menuPictures.joined(separator: ","),
			"spotFoodPictureUrls" : spotModel.foodPictures.joined(separator: ","),
			"spotCustomerPictureUrls" : spotModel.customerPictures.joined(separator: ","),
			"spotDescription" : spotModel.spotDescription ,
			"spotCategories" : spotModel.categories.map({$0.description}).joined(separator: ",") ,
			"spotOtherLocations" : spotModel.otherlocations.joined(separator: ","),
			"spotOperationhours" : spotModel.operationhours.joined(separator: ",")
        ]
        print(parameters)
		AF.request(String.BackendBaseUrl + "/business/spot/save" , method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
					print(result)
                    completion(.success("Success"))
                }
            case .failure(let error):
                print(error)
                if response.value == nil {
                    completion(.failure(CustomError(errorMessage: "Please Check Your Internet Connection")))
                }
                else
                {
                    let error = response.value as! NSDictionary
                    let errorMessage = error["message"] as! String
                    completion(.failure(CustomError(errorMessage: errorMessage ?? "ERROR")))
                }
            }
        }
    }
    
    func getClaims(completion: @escaping (Result<[ClaimModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        AF.request(String.BackendBaseUrl + "/business/claim", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if(JSON["message"] != nil){
                        let result = [ClaimModel]()
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        var results = [ClaimModel]()
                        for item in records {
                            print("Items\(item)")
                            let user = UserModel(id: (item["claimedby"] as? Int ?? 0).description, username: "", fullname: "", pictureUrl: "", userBio: "", spotCount: 0, followerCount: 0, followingCount: 0, amIFollow: false)
                            let lat : Double = Double(item["spotlatitude"] as! String) ?? 0.0
                            let lon : Double = Double(item["spotlongtitude"] as! String) ?? 0.0
                            var spot = SpotModel(id: (item["spotid"] as! Int).description, name: item["spotname"] as! String, photoUrl: item["spotpictureurl"] as? String ?? "", address: item["spotaddress"] as? String ?? "", lat: lat, lon: lon, phoneNumber: item["spotphonenumber"] as? String ?? "", googlePlaceId: "", city: "")
                            
                            spot.logoUrl = item["spotlogo"] as? String ?? ""
                            spot.email = item["spotemail"] as? String ?? ""
                            spot.website = item["spotwebsite"] as? String ?? ""
                            spot.owners = item["spotowners"] as? String ?? ""
                            
                            let mPics = item["spotmenupic"] as? [String:[String]] ?? [:]
                            spot.menuPictures = mPics["stringValues"] ?? []
                            
                            let fPics = item["spotfoodpic"] as? [String:[String]] ?? [:]
                            spot.foodPictures = fPics["stringValues"] ?? []
                            
                            let cPics = item["spotcustomerpic"] as? [String:[String]] ?? [:]
                            spot.customerPictures = cPics["stringValues"] ?? []
                            
                            let sDelivery = item["spotdelivery"] as? [String:[String]] ?? [:]
                            spot.deliveryOptions = sDelivery["stringValues"] ?? []
                            
                            spot.spotDescription = item["spotdescription"] as? String ?? ""
                            
                            spot.spotreservationlink = item["spotreservationlink"] as? String ?? ""
                            spot.spotreservationdescription = item["spotreservationdescription"] as? String ?? ""

                            let sCategories = item["spotcategories"] as? [String:[String]] ?? [:]
                            spot.categories = (sCategories["stringValues"] ?? []).map({Int($0) ?? 0})
                            
                            let oLocations = item["spototherlocations"] as? [String:[String]] ?? [:]
                            spot.otherlocations = oLocations["stringValues"] ?? []
                            
                            let oHours = item["spotoperationhours"] as? [String:[String]] ?? [:]
                            spot.operationhours = oHours["stringValues"] ?? []
     
                            let claim = ClaimModel(id: (item["id"] as? Int ?? 0).description, createdat: Date(), claimedBy: user, isVerified: item["isverified"] as? Bool ?? false, isDenied: item["isdenied"] as? Bool ?? false,isPending: item["ispending"] as? Bool ?? false, spot: spot)
                            results.append(claim)
                        }
                        completion(.success(results))

                    }
                                    }
            case .failure(let error):
                print(error)
                if response.value == nil {
                    completion(.failure(CustomError(errorMessage: "Please Check Your Internet Connection")))
                }
                else
                {
                    let error = response.value as! NSDictionary
                    let errorMessage = error["message"] as! String
                    completion(.failure(CustomError(errorMessage: errorMessage ?? "ERROR")))
                }
            }
        }
    }
    
	func claimRestaurant(spotId: String,comment: String,completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: String] = [
            "spotId" : spotId,
			"comment" : comment
        ]
        
        AF.request(String.BackendBaseUrl + "/business/claim" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
					print(result)
                    completion(.success("Success"))
                }
            case .failure(let error):
                print(error)
                if response.value == nil {
                    completion(.failure(CustomError(errorMessage: "Please Check Your Internet Connection")))
                }
                else
                {
                    let error = response.value as! NSDictionary
                    let errorMessage = error["message"] as! String
                    completion(.failure(CustomError(errorMessage: errorMessage ?? "ERROR")))
                }
            }
        }
    }
    func getLastSavedSpot(completion: @escaping (Result<[SavedSpotModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        
        let originalUrl = String.BackendBaseUrl + "/business/last_saved_spot"
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        AF.request(escapedUrl ?? "" , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    let records = JSON["records"] as! [[String:Any]]
                    var result = [SavedSpotModel]()
                    for item in records {
                        let lastSaveSpot = SavedSpotModel(lastsavedspot: item["lastsavedspot"] as? Int ?? 0, lastsavedspotat: item["lastsavedspot_at"] as? String ?? "")
                        result.append(lastSaveSpot)
                    }
                    
                    completion(.success(result))
                    print(records)
                       
                    
                }
            case .failure(let error):
                print(error)
                if response.value == nil {
                    completion(.failure(CustomError(errorMessage: "Please Check Your Internet Connection")))
                }
                else
                {
                    let error = response.value as! NSDictionary
                    let errorMessage = error["message"] as! String
                    completion(.failure(CustomError(errorMessage: errorMessage)))
                }
            }
        }
    }
    func lastSavedSpot(spotId: String,completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        let parameters: [String: String] = [
            "lastSavedSpot" : spotId]
        
        let originalUrl = String.BackendBaseUrl + "/business/last_saved_spot"
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        AF.request(escapedUrl ?? "" , method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]
                    {
                        print(message)
                        completion(.success(message as! String))
                    }
                       
                    
                }
            case .failure(let error):
                print(error)
                if response.value == nil {
                    completion(.failure(CustomError(errorMessage: "Please Check Your Internet Connection")))
                }
                else
                {
                    let error = response.value as! NSDictionary
                    let errorMessage = error["message"] as! String
                    completion(.failure(CustomError(errorMessage: errorMessage)))
                }
            }
        }
    }
    
    func honeySpotters(spotId: String,completion: @escaping (Result<[HoneyspotterModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/business/honeyspotters-details?" + "spotId=" + spotId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        AF.request(escapedUrl ?? "" , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    let records = JSON["records"] as! [[String:Any]]
                    var result = [HoneyspotterModel]()
                    for item in records {
                        let honeySpotter = HoneyspotterModel(userfullname: item["userfullname"] as? String ?? "", username: item["username"] as? String ?? "", userpictureurl: item["userpictureurl"] as? String ?? "")
                        result.append(honeySpotter)
                    }
                    print(result)
                    completion(.success(result))
                }
            case .failure(let error):
                print(error)
                if response.value == nil {
                    completion(.failure(CustomError(errorMessage: "Please Check Your Internet Connection")))
                }
                else
                {
                    let error = response.value as! NSDictionary
                    let errorMessage = error["message"] as! String
                    completion(.failure(CustomError(errorMessage: errorMessage)))
                }
            }
        }
    }
    func searchHoneySpotters(spotId: String,username:String,completion: @escaping (Result<[HoneyspotterModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/business/honeyspotters-search?" + "&username=" + username + "&spotId=" + spotId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        AF.request(escapedUrl ?? "" , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    let records = JSON["records"] as! [[String:Any]]
                    var result = [HoneyspotterModel]()
                    for item in records {
                        let honeySpotter = HoneyspotterModel(userfullname: item["userfullname"] as? String ?? "", username: item["username"] as? String ?? "", userpictureurl: item["userpictureurl"] as? String ?? "")
                        result.append(honeySpotter)
                    }
                    print(result)
                    completion(.success(result))
                }
            case .failure(let error):
                print(error)
                if response.value == nil {
                    completion(.failure(CustomError(errorMessage: "Please Check Your Internet Connection")))
                }
                else
                {
                    let error = response.value as! NSDictionary
                    let errorMessage = error["message"] as! String
                    completion(.failure(CustomError(errorMessage: errorMessage ?? "ERROR")))
                }
            }
        }
    }
    func uploadImage(imageBase64 : String,completion: @escaping (Result<ImageModel,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: String] = [
            "base64String" : "data:image/jpeg;base64,\(imageBase64)",
        ]
        
        AF.request(String.BackendBaseUrl + "/image-upload" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    print(result)
                    let JSON = result as! NSDictionary
                    let imageModel = ImageModel(message: JSON["message"] as! String, ImageURL: JSON["ImageURL"] as! String, filename: JSON["filename"] as! String)
                        
                    completion(.success(imageModel))
                }
            case .failure(let error):
                print(error)
                if response.value == nil {
                    completion(.failure(CustomError(errorMessage: "Please Check Your Internet Connection")))
                }
                else
                {
                    let error = response.value as! NSDictionary
                    let errorMessage = error["message"] as! String
                    completion(.failure(CustomError(errorMessage: errorMessage ?? "ERROR")))
                }
            }
        }
    }
	
}
