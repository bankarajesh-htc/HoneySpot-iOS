//
//  SpotDataSource.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 22.12.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import Alamofire

class SpotDataSource {
    
    func getSpotSaveOfMe(spotId : String,completion: @escaping (Result<[SpotSaveModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/user/has-save" + "?spotId=" + spotId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    let records = JSON["records"] as? [[String:Any]]
                    if(records == nil){
                        completion(.failure(CustomError(errorMessage: "Err")))
                    }else{
                        var results = [SpotSaveModel]()
                        for item in records! {
                            print(item)
                            let user = UserModel(id: (item["userid"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: (item["userfullname"] as? String ?? ""), pictureUrl: (item["userpictureurl"] as? String ?? ""), userBio: nil, spotCount: nil, followerCount: nil, followingCount: nil)
                            let spotModel = SpotModel(id: (item["spotid"] as? Int ?? 0).description, name: item["spotname"] as? String ?? "", photoUrl: item["spotpictureurl"] as? String ?? "", address: item["spotaddress"] as? String ?? "", lat: Double(item["spotlatitude"] as! String) ?? 0.0, lon: Double(item["spotlongtitude"] as! String) ?? 0.0, phoneNumber: item["spotphonenumber"] as? String ?? "", googlePlaceId: "", city: "")
                            let tagsDic = item["tags"] as? [String : [Int]?] ?? [:]
                            let tagsArr = tagsDic["longValues"] ?? []
                            let favoriteDishesDic = item["favoritedishes"] as? [String : [String]?] ?? [:]
                            let favDishesArr = favoriteDishesDic["stringValues"] ?? []
							let spotSaveModel = SpotSaveModel(id: (item["saveid"] as! Int).description, createdAt: nil, user: user, spot: spotModel, description: item["description"] as! String, tags: tagsArr ?? [], commentCount: 0, likeCount: 0,favoriteDishes: favDishesArr ?? [])
                            results.append(spotSaveModel)
                        }
                        completion(.success(results))
                    }
                    
                }
            case .failure(let error):
                print(error)
                if response.value == nil {
                   // let errorMessage = error["message"] as! String
                    completion(.failure(CustomError(errorMessage: error.localizedDescription)))
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
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/search/place?" + "latitude=" + latitude.description + "&longitude=" + longitude.description + "&text=" + text
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        /* AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
         
         if let result = response.value {
             let JSON = result as! NSDictionary
             let records = JSON["results"] as! [[String:Any]]
             print(records)
             for item in records {
                 
                 print(item)
                 
             }

         }*/
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
    
    func searchPlaceNearMe(latitude : Double,longitude : Double,completion: @escaping (Result<[GooglePlaces.Place],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/search/place-nearby?" + "latitude=" + latitude.description + "&longitude=" + longitude.description
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request( escapedUrl ?? "" , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseDecodable { (response: DataResponse<GooglePlaces,AFError>) in
            switch response.result {
            case .success(let googlePlaces):
                completion(.success(googlePlaces.results))
            case .failure(let error):
                print(error)
                completion(.failure(CustomError(errorMessage:  error.errorDescription ?? "Error getting place")))
            }
        }
    }
    
    func getSpot(googlePlaceId : String,completion: @escaping (Result<SpotModel,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/spot?" + "placeId=" + googlePlaceId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as? NSDictionary
                    if(JSON == nil){
                        completion(.failure(CustomError(errorMessage: "unknown error")))
                        return
                    }
                    let records = JSON!["records"] as? [[String:Any]]
                    if(records == nil){
                        completion(.failure(CustomError(errorMessage: "unknown error")))
                        return
                    }
                    var result : SpotModel!
                    for item in records! {
                        let spot = SpotModel(id: (item["id"] as? Int ?? 0).description, name: item["name"] as? String ?? "", photoUrl: item["photourl"] as? String ?? "", address: item["address"] as? String ?? "", lat: Double(item["latitude"] as! String) ?? 0.0, lon: Double(item["longtitude"] as! String) ?? 0.0, phoneNumber: (item["phonenumber"] as? String) ?? "", googlePlaceId: item["googleplaceid"] as? String ?? "", city: item["city"] as? String ?? "")
                        result = spot
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
    
    func deleteSpot(saveId : String,completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/spot/save?" + "saveId=" + saveId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                completion(.success("Delete Completed"))
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
    
    func addSpotSave(spotId : String,favoriteDishes : [String],insiderTips : String,description : String,tags : [Int],completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: Any] = [
            "spotId": spotId,
            "favoriteDishes": favoriteDishes,
            "insiderTips": insiderTips,
            "description": description,
            "tags": tags
        ]
        
        AF.request(String.BackendBaseUrl + "/spot/save" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value{
                    let JSON = result as! NSDictionary
                    if let mess = JSON.value(forKey: "message") {
                        print(mess)
                        completion(.success(mess as! String))
                    }
                    else
                    {
                        completion(.success("Success"))
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
    func savetoTry(spotId : String,favoriteDishes : [String],insiderTips : String,description : String,tags : [Int],completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: Any] = [
            "spotId": spotId,
            "favoriteDishes": favoriteDishes,
            "insiderTips": insiderTips,
            "description": description,
            "tags": tags
        ]
        
        AF.request(String.BackendBaseUrl + "/user/save-and-try" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value{
                    let JSON = result as! NSDictionary
                    if let mess = JSON.value(forKey: "message") {
                        print(mess)
                        completion(.success(mess as! String))
                    }
                    else
                    {
                        completion(.success("Success"))
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
    
    func editSpotSave(saveId : String,favoriteDishes : [String],insiderTips : String,description : String,tags : [Int],completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: Any] = [
            "saveId": saveId,
            "favoriteDishes": favoriteDishes,
            "insiderTips": insiderTips,
            "description": description,
            "tags": tags
        ]
        
        AF.request(String.BackendBaseUrl + "/spot/save" , method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                completion(.success("Success"))
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
