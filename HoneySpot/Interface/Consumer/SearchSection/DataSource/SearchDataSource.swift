//
//  SpotDataSource.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 22.12.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import Alamofire

class SearchDataSource {
    
    func searchTopUsers(completion: @escaping (Result<[UserModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
         let headers: HTTPHeaders = [
           "Accept-Encoding": "gzip",
           "Accept": "application/json",
			"Cache-Control": "max-age=0",
           "AuthToken" : authToken
         ]
         
         let originalUrl = String.BackendBaseUrl + "/search/top-users"
         let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
         AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
             switch response.result {
             case .success:
                 if let result = response.value {
                     let JSON = result as! NSDictionary
                    if(JSON["message"] != nil){
                        let result = [UserModel]()
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        var result = [UserModel]()
                        for item in records {
                            let user = UserModel(id: (item["id"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: (item["fullname"] as? String ?? ""), pictureUrl: (item["pictureurl"] as? String ?? ""), userBio: "", spotCount: item["honeyspotcount"] as? Int ?? 0, followerCount: item["followercount"] as? Int ?? 0, followingCount: 0)
                            result.append(user)
                        }
                        completion(.success(result))
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
    
    func searchPlaceName(text : String,latitude : Double,longitude : Double,completion: @escaping (Result<[GooglePlaces.Place],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
			"Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/search/place?" + "latitude=" + latitude.description + "&longitude=" + longitude.description + "&text=" + text
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseDecodable { (response: DataResponse<GooglePlaces,AFError>) in
            switch response.result {
            case .success(let googlePlaces):
                completion(.success(googlePlaces.results))
            case .failure(let error):
                print(error)
                if response.value == nil {
                    completion(.failure(CustomError(errorMessage: "Please Check Your Internet Connection")))
                }
                else
                {
                    completion(.failure(CustomError(errorMessage:  error.errorDescription ?? "Error getting place")))
                }
                
            }
        }
    }
    
    func searchPeople(nameText: String,completion: @escaping (Result<[UserModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
			"Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/search/user?" + "username=" + nameText
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    let records = JSON["records"] as! [[String:Any]]
                    var result = [UserModel]()
                    for item in records {
                        let user = UserModel(id: (item["id"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: (item["fullname"] as? String ?? ""), pictureUrl: (item["pictureurl"] as? String ?? ""), userBio: "", spotCount: item["spotcount"] as? Int ?? 0, followerCount: item["followercount"] as? Int ?? 0, followingCount: 0)
                        result.append(user)
                    }
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
    func searchGuestCityTopRestaurants(city : String,completion: @escaping (Result<[SpotModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
            "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/guest/search/city-top-restaurants?" + "cityName=" + city
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if(JSON["message"] != nil){
                        let result = [SpotModel]()
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        print(records)
                        var result = [SpotModel]()
                        for item in records {
                            
                            let spot = SpotModel(id: (item["id"] as? Int ?? 0).description, name: item["name"] as? String ?? "", photoUrl: item["photourl"] as? String ?? "", address: "", lat: item["latitude"] as? Double ?? 0.0, lon: item["longtitude"] as? Double ?? 0.0, phoneNumber: "", googlePlaceId: item["googleplaceid"] as? String ?? "", city: item["city"] as? String ?? "")
                            result.append(spot)
                        }
                        completion(.success(result))
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
    func searchCityTopRestaurants(city : String,completion: @escaping (Result<[SpotModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
			"Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/search/city-top-restaurants?" + "cityName=" + city
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    let records = JSON["records"] as! [[String:Any]]
                    print(records)
                    var result = [SpotModel]()
                    for item in records {
                        
						let spot = SpotModel(id: (item["id"] as? Int ?? 0).description, name: item["name"] as? String ?? "", photoUrl: item["photourl"] as? String ?? "", address: "", lat: item["latitude"] as? Double ?? 0.0, lon: item["longtitude"] as? Double ?? 0.0, phoneNumber: "", googlePlaceId: item["googleplaceid"] as? String ?? "", city: item["city"] as? String ?? "")
                        result.append(spot)
                    }
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
	
	func searchCity(city : String,completion: @escaping (Result<[CityModel],CustomError>) -> ()){
		let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
		let headers: HTTPHeaders = [
		  "Accept-Encoding": "gzip",
		  "Accept": "application/json",
		  "AuthToken" : authToken
		]
		
		let originalUrl = String.BackendBaseUrl + "/search/city?" + "cityName=" + city
		let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
		AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
			switch response.result {
			case .success:
				if let result = response.value {
					let JSON = result as! NSDictionary
					let records = JSON["records"] as! [[String:Any]]
					var result = [CityModel]()
					for item in records {
						let photo = item["photourl"] as? String ?? ""
						let city = CityModel(city: item["city"] as? String ?? "",honeyspotCount: item["count"] as? Int ?? 0,photoUrl: photo)
						result.append(city)
					}
					result.sort { (c1, c2) -> Bool in
						return c1.honeyspotCount > c2.honeyspotCount
					}
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
    
}
