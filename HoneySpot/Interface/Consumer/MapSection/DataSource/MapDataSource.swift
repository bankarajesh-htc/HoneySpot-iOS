//
//  FeedDataSource.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 19.12.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import Alamofire

class MapDataSource {
    
    func searchMapPlaces(northEastLatitude : Double,northEastLongtitude : Double,southWestLatitude : Double,southWestLongtitude : Double,tags:[Int],completion: @escaping (Result<[SpotSaveModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: Any] = [
            "northEastLatitude": northEastLatitude,
            "northEastLongtitude": northEastLongtitude,
            "southWestLatitude": southWestLatitude,
            "southWestLongtitude": southWestLongtitude,
            "tags": tags
        ]
        
        AF.request(String.BackendBaseUrl + "/search/map" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    let records = JSON["records"] as! [[String:Any]]
                    print(records)
                    var results = [SpotSaveModel]()
                    for item in records {
                        let user = UserModel(id: "", username: "", fullname: nil, pictureUrl: "", userBio: nil, spotCount: nil, followerCount: nil, followingCount: nil)
                        let spotModel = SpotModel(id: "", name: item["spotname"] as? String ?? "", photoUrl: item["spotpictureurl"] as? String ?? "", address: item["spotaddress"] as? String ?? "", lat: Double(item["latitude"] as! String) ?? 0.0, lon: Double(item["longtitude"] as! String) ?? 0.0, phoneNumber: "", googlePlaceId: "",city : "")
                        let tagsDic = item["tags"] as? [String : [Int]?] ?? [:]
                        let tagsArr = tagsDic["longValues"] ?? []
						let spotSaveModel = SpotSaveModel(id: (item["saveid"] as? Int ?? 0).description, createdAt: nil, user: user, spot: spotModel, description: "", tags: tagsArr ?? [], commentCount: 0, likeCount: 0,favoriteDishes: [])
                        results.append(spotSaveModel)
                    }
                    var filterArray = results.filterDuplicates { $0.spot.lat == $1.spot.lat }
                    //filterArray.reverse()
                    completion(.success(filterArray))
                    //completion(.success(results))
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
    func searchGuestMapPlaces(northEastLatitude : Double,northEastLongtitude : Double,southWestLatitude : Double,southWestLongtitude : Double,tags:[Int],completion: @escaping (Result<[SpotSaveModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: Any] = [
            "northEastLatitude": northEastLatitude,
            "northEastLongtitude": northEastLongtitude,
            "southWestLatitude": southWestLatitude,
            "southWestLongtitude": southWestLongtitude,
            "tags": tags
        ]
        
        AF.request(String.BackendBaseUrl + "/guest/search/map" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if(JSON["message"] != nil){
                        let result = [SpotSaveModel]()
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        print(records)
                        var results = [SpotSaveModel]()
                        for item in records {
                            let user = UserModel(id: "", username: "", fullname: nil, pictureUrl: "", userBio: nil, spotCount: nil, followerCount: nil, followingCount: nil)
                            let spotModel = SpotModel(id: (item["spotid"] as? Int ?? 0).description, name: item["spotname"] as? String ?? "", photoUrl: item["spotpictureurl"] as? String ?? "", address: item["spotaddress"] as? String ?? "", lat: Double(item["latitude"] as! String) ?? 0.0, lon: Double(item["longtitude"] as! String) ?? 0.0, phoneNumber: "", googlePlaceId: "",city : "")
                            let tagsDic = item["tags"] as? [String : [Int]?] ?? [:]
                            let tagsArr = tagsDic["longValues"] ?? []
                            let spotSaveModel = SpotSaveModel(id: (item["saveid"] as? Int ?? 0).description, createdAt: nil, user: user, spot: spotModel, description: "", tags: tagsArr ?? [], commentCount: 0, likeCount: 0,favoriteDishes: [])
                            results.append(spotSaveModel)
                        }
                        var filterArray = results.filterDuplicates { $0.spot.lat == $1.spot.lat }
                       // filterArray.reverse()
                        completion(.success(filterArray))
                        //completion(.success(results))
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
    
}
