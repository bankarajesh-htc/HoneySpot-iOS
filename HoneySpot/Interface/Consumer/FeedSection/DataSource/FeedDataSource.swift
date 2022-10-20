//
//  FeedDataSource.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 19.12.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import Alamofire
import MapKit

class FeedDataSource {
    
    func getFeed(pageId : Int,completion: @escaping (Result<[FeedModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        AF.request(String.BackendBaseUrl + "/feed?pageId=" + pageId.description, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    
                    if(JSON["message"] != nil){
                        completion(.failure(CustomError(errorMessage: JSON["message"] as! String)))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        print("Records\(records)")
                        var results = [FeedModel]()
                        for item in records {
                            print(item)
                            let user = UserModel(id: (item["userid"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: nil, pictureUrl: (item["userpictureurl"] as? String ?? ""), userBio: nil, spotCount: nil, followerCount: nil, followingCount: nil)
                            var spotModel = SpotModel(id: (item["spotid"] as! Int).description, name: item["spotname"] as! String, photoUrl: item["spotpictureurl"] as? String ?? "", address: item["spotaddress"] as? String ?? "", lat: 0, lon: 0, phoneNumber: "", googlePlaceId: "", city: "")
                            spotModel.logoUrl = item["spotlogo"] as? String ?? ""
                            spotModel.email = item["spotemail"] as? String ?? ""
                            spotModel.website = item["spotwebsite"] as? String ?? ""
                            spotModel.owners = item["spotowners"] as? String ?? ""
                            
                            let mPics = item["spotmenupic"] as? [String:[String]] ?? [:]
                            spotModel.menuPictures = mPics["stringValues"] ?? []
                            
                            let fPics = item["spotfoodpic"] as? [String:[String]] ?? [:]
                            spotModel.foodPictures = fPics["stringValues"] ?? []
                            
                            let cPics = item["spotcustomerpic"] as? [String:[String]] ?? [:]
                            spotModel.customerPictures = cPics["stringValues"] ?? []
                            
                            let sDelivery = item["spotdelivery"] as? [String:[String]] ?? [:]
                            spotModel.deliveryOptions = sDelivery["stringValues"] ?? []
                            
                            spotModel.spotDescription = item["spotdescription"] as? String ?? ""

                            let sCategories = item["spotcategories"] as? [String:[String]] ?? [:]
                            spotModel.categories = (sCategories["stringValues"] ?? []).map({Int($0) ?? 0})
                            
                            let oLocations = item["spototherlocations"] as? [String:[String]] ?? [:]
                            spotModel.otherlocations = oLocations["stringValues"] ?? []
                            
                            let oHours = item["spotoperationhours"] as? [String:[String]] ?? [:]
                            spotModel.operationhours = oHours["stringValues"] ?? []
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                            let spotSaveModel = SpotSaveModel(id: (item["saveid"] as? Int ?? 0).description, createdAt: dateFormatter.date(from:item["createdat"] as? String ?? ""), user: user, spot: spotModel, description: item["savedescription"] as? String ?? "", tags: [], commentCount: item["commentcount"] as? Int ?? 0, likeCount: item["likecount"] as? Int ?? 0,favoriteDishes: [])
                            let feed = FeedModel(user: user, spotSave: spotSaveModel)
                            feed.didILike = (item["doilike"] as! Int) != 0
                            results.append(feed)
                        }
                        print("Results\(results)")
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
                    completion(.failure(CustomError(errorMessage: errorMessage)))
                }
            }
        }
    }
    func getGuestLoginFeed(pageId : Int,completion: @escaping (Result<[FeedModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        AF.request(String.BackendBaseUrl + "/user/guest-login?pageId=1&spotname=Rest", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    
                    if(JSON["message"] != nil){
                        completion(.failure(CustomError(errorMessage: JSON["message"] as! String)))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        print("Records\(records)")
                        var results = [FeedModel]()
                        for item in records {
                            let user = UserModel(id: (item["userid"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: nil, pictureUrl: (item["userpictureurl"] as? String ?? ""), userBio: nil, spotCount: nil, followerCount: nil, followingCount: nil)
                            var spotModel = SpotModel(id: (item["spotid"] as! Int).description, name: item["spotname"] as! String, photoUrl: item["spotpictureurl"] as! String, address: item["spotaddress"] as! String, lat: 0, lon: 0, phoneNumber: "", googlePlaceId: "", city: "")
                            spotModel.logoUrl = item["spotlogo"] as? String ?? ""
                            spotModel.email = item["spotemail"] as? String ?? ""
                            spotModel.website = item["spotwebsite"] as? String ?? ""
                            spotModel.owners = item["spotowners"] as? String ?? ""
                            
                            let mPics = item["spotmenupic"] as? [String:[String]] ?? [:]
                            spotModel.menuPictures = mPics["stringValues"] ?? []
                            
                            let fPics = item["spotfoodpic"] as? [String:[String]] ?? [:]
                            spotModel.foodPictures = fPics["stringValues"] ?? []
                            
                            let cPics = item["spotcustomerpic"] as? [String:[String]] ?? [:]
                            spotModel.customerPictures = cPics["stringValues"] ?? []
                            
                            let sDelivery = item["spotdelivery"] as? [String:[String]] ?? [:]
                            spotModel.deliveryOptions = sDelivery["stringValues"] ?? []
                            
                            spotModel.spotDescription = item["spotdescription"] as? String ?? ""

                            let sCategories = item["spotcategories"] as? [String:[String]] ?? [:]
                            spotModel.categories = (sCategories["stringValues"] ?? []).map({Int($0) ?? 0})
                            
                            let oLocations = item["spototherlocations"] as? [String:[String]] ?? [:]
                            spotModel.otherlocations = oLocations["stringValues"] ?? []
                            
                            let oHours = item["spotoperationhours"] as? [String:[String]] ?? [:]
                            spotModel.operationhours = oHours["stringValues"] ?? []
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                            let spotSaveModel = SpotSaveModel(id: (item["saveid"] as? Int ?? 0).description, createdAt: dateFormatter.date(from:item["createdat"] as? String ?? ""), user: user, spot: spotModel, description: item["savedescription"] as? String ?? "", tags: [], commentCount: item["commentcount"] as? Int ?? 0, likeCount: item["likecount"] as? Int ?? 0,favoriteDishes: [])
                            let feed = FeedModel(user: user, spotSave: spotSaveModel)
                            feed.didILike = (item["doilike"] as? Int ?? 0) != 0
                            results.append(feed)
                        }
                        print("Results\(results.count)")
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
                    completion(.failure(CustomError(errorMessage: errorMessage)))
                }
            }
        }
    }
    func getSavetoTryFeed(pageId : Int,completion: @escaping (Result<[FeedModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "authToken" : authToken
        ]
        
        AF.request(String.BackendBaseUrl + "/user/save-and-try", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    
                    if(JSON["message"] != nil){
                        completion(.failure(CustomError(errorMessage: JSON["message"] as! String)))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        print("Records\(records)")
                        var results = [FeedModel]()
                        for item in records {
                            let user = UserModel(id: (item["userid"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: nil, pictureUrl: (item["userpictureurl"] as? String ?? ""), userBio: nil, spotCount: nil, followerCount: nil, followingCount: nil)
                            var spotModel = SpotModel(id: (item["spotid"] as? Int ?? 0).description, name: item["spotname"] as? String ?? "", photoUrl: item["spotpictureurl"] as? String ?? "", address: item["spotaddress"] as? String ?? "", lat: 0, lon: 0, phoneNumber: "", googlePlaceId: "", city: "")
                            //spotModel.
                            spotModel.wishListId = item["wishlistid"] as? String ?? ""
                            spotModel.wishListCreateDate = item["wishlistcreatedat"] as? String ?? ""
                            spotModel.logoUrl = item["spotlogo"] as? String ?? ""
                            spotModel.email = item["spotemail"] as? String ?? ""
                            spotModel.website = item["spotwebsite"] as? String ?? ""
                            spotModel.owners = item["spotowners"] as? String ?? ""
                            
                            let mPics = item["spotmenupic"] as? [String:[String]] ?? [:]
                            spotModel.menuPictures = mPics["stringValues"] ?? []
                            
                            let fPics = item["spotfoodpic"] as? [String:[String]] ?? [:]
                            spotModel.foodPictures = fPics["stringValues"] ?? []
                            
                            let cPics = item["spotcustomerpic"] as? [String:[String]] ?? [:]
                            spotModel.customerPictures = cPics["stringValues"] ?? []
                            
                            let sDelivery = item["spotdelivery"] as? [String:[String]] ?? [:]
                            spotModel.deliveryOptions = sDelivery["stringValues"] ?? []
                            
                            spotModel.spotDescription = item["spotdescription"] as? String ?? ""

                            let sCategories = item["spotcategories"] as? [String:[String]] ?? [:]
                            spotModel.categories = (sCategories["stringValues"] ?? []).map({Int($0) ?? 0})
                            
                            let oLocations = item["spototherlocations"] as? [String:[String]] ?? [:]
                            spotModel.otherlocations = oLocations["stringValues"] ?? []
                            
                            let oHours = item["spotoperationhours"] as? [String:[String]] ?? [:]
                            spotModel.operationhours = oHours["stringValues"] ?? []
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                            let spotSaveModel = SpotSaveModel(id: (item["saveid"] as? Int ?? 0).description, createdAt: dateFormatter.date(from:item["createdat"] as? String ?? ""), user: user, spot: spotModel, description: item["savedescription"] as? String ?? "", tags: [], commentCount: item["commentcount"] as? Int ?? 0, likeCount: item["likecount"] as? Int ?? 0,favoriteDishes: [])
                            let feed = FeedModel(user: user, spotSave: spotSaveModel)
                            feed.didILike = (item["doilike"] as? Int ?? 0) != 0
                            results.append(feed)
                        }
                        results.reverse()
                        print("Results\(results)")
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
                    completion(.failure(CustomError(errorMessage: errorMessage)))
                }
            }
        }
    }
    
    func getGuestSpotSave(saveId : String ,completion: @escaping (Result<[SpotSaveModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/user/spot-details-guest?" + "spotId=" + saveId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        print(message)
                        completion(.failure(CustomError(errorMessage: message as! String)))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        var results = [SpotSaveModel]()
                        for item in records {
                            print(item)
                            let user = UserModel(id: (item["userid"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: (item["userfullname"] as? String ?? ""), pictureUrl: (item["userpictureurl"] as? String ?? ""), userBio: nil, spotCount: nil, followerCount: nil, followingCount: nil)
                            var spotModel = SpotModel(id: (item["spotid"] as? Int ?? 0).description, name: item["spotname"] as? String ?? "", photoUrl: item["spotpictureurl"] as? String ?? "", address: item["spotaddress"] as? String ?? "", lat: Double(item["spotlatitude"] as! String) ?? 0.0, lon: Double(item["spotlongtitude"] as! String) ?? 0.0, phoneNumber: item["spotphonenumber"] as? String ?? "", googlePlaceId: "", city: "")
                            spotModel.logoUrl = item["spotlogo"] as? String ?? ""
                            spotModel.email = item["spotemail"] as? String ?? ""
                            spotModel.website = item["spotwebsite"] as? String ?? ""
                            spotModel.owners = item["spotowners"] as? String ?? ""
                            
                            let mPics = item["spotmenupic"] as? [String:[String]] ?? [:]
                            spotModel.menuPictures = mPics["stringValues"] ?? []
                            
                            let fPics = item["spotfoodpic"] as? [String:[String]] ?? [:]
                            spotModel.foodPictures = fPics["stringValues"] ?? []
                            
                            let cPics = item["spotcustomerpic"] as? [String:[String]] ?? [:]
                            spotModel.customerPictures = cPics["stringValues"] ?? []
                            
                            let sDelivery = item["spotdelivery"] as? [String:[String]] ?? [:]
                            spotModel.deliveryOptions = sDelivery["stringValues"] ?? []
                            
                            spotModel.spotDescription = item["spotdescription"] as? String ?? ""

                            let sCategories = item["spotcategories"] as? [String:[String]] ?? [:]
                            spotModel.categories = (sCategories["stringValues"] ?? []).map({Int($0) ?? 0})
                            
                            let oLocations = item["spototherlocations"] as? [String:[String]] ?? [:]
                            spotModel.otherlocations = oLocations["stringValues"] ?? []
                            
                            let tagsDic = item["tags"] as? [String : [Int]?] ?? [:]
                            let tagsArr = tagsDic["longValues"] ?? []
                            let favoriteDishesDic = item["favoritedishes"] as? [String : [String]?] ?? [:]
                            let favDishesArr = favoriteDishesDic["stringValues"] ?? []
                            
                            let oHours = item["spotoperationhours"] as? [String:[String]] ?? [:]
                            spotModel.operationhours = oHours["stringValues"] ?? []
                            
                            let spotSaveModel = SpotSaveModel(id: (item["saveid"] as? Int ?? 0).description, createdAt: nil, user: user, spot: spotModel, description: item["description"] as? String ?? "", tags: tagsArr ?? [], commentCount: 0, likeCount: 0,favoriteDishes: favDishesArr ?? [])
                            results.append(spotSaveModel)
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
                    completion(.failure(CustomError(errorMessage: errorMessage)))
                }
                
            }
        }
    }
    
    func getSpotId(spotId : String ,completion: @escaping (Result<[SpotSaveModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/spot/save/byspotid" + "?spotId=" + spotId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        print(message)
                        completion(.failure(CustomError(errorMessage: message as! String)))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        var results = [SpotSaveModel]()
                        for item in records {
                            print(item)
                            let user = UserModel(id: (item["userid"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: (item["userfullname"] as? String ?? ""), pictureUrl: (item["userpictureurl"] as? String ?? ""), userBio: nil, spotCount: nil, followerCount: nil, followingCount: nil)
                            var spotModel = SpotModel(id: (item["spotid"] as! Int).description, name: item["spotname"] as? String ?? "", photoUrl: item["spotpictureurl"] as? String ?? "", address: item["spotaddress"] as? String ?? "", lat: Double(item["spotlatitude"] as! String) ?? 0.0, lon: Double(item["spotlongtitude"] as! String) ?? 0.0, phoneNumber: item["spotphonenumber"] as? String ?? "", googlePlaceId: "", city: "")
                            spotModel.logoUrl = item["spotlogo"] as? String ?? ""
                            spotModel.email = item["spotemail"] as? String ?? ""
                            spotModel.website = item["spotwebsite"] as? String ?? ""
                            spotModel.owners = item["spotowners"] as? String ?? ""
                            spotModel.didILike = (item["doilike"] as? Int ?? 0) != 0
                            
                            let mPics = item["spotmenupic"] as? [String:[String]] ?? [:]
                            spotModel.menuPictures = mPics["stringValues"] ?? []
                            
                            let fPics = item["spotfoodpic"] as? [String:[String]] ?? [:]
                            spotModel.foodPictures = fPics["stringValues"] ?? []
                            
                            let cPics = item["spotcustomerpic"] as? [String:[String]] ?? [:]
                            spotModel.customerPictures = cPics["stringValues"] ?? []
                            
                            let sDelivery = item["spotdelivery"] as? [String:[String]] ?? [:]
                            spotModel.deliveryOptions = sDelivery["stringValues"] ?? []
                            
                            spotModel.spotDescription = item["spotdescription"] as? String ?? ""
                            spotModel.spotreservationlink = item["spotreservationlink"] as? String ?? ""
                            spotModel.spotreservationdescription = item["spotreservationdescription"] as? String ?? ""

                            let sCategories = item["spotcategories"] as? [String:[String]] ?? [:]
                            spotModel.categories = (sCategories["stringValues"] ?? []).map({Int($0) ?? 0})
                            
                            let oLocations = item["spototherlocations"] as? [String:[String]] ?? [:]
                            spotModel.otherlocations = oLocations["stringValues"] ?? []
                            
                            let tagsDic = item["tags"] as? [String : [Int]?] ?? [:]
                            let tagsArr = tagsDic["longValues"] ?? []
                            let favoriteDishesDic = item["favoritedishes"] as? [String : [String]?] ?? [:]
                            let favDishesArr = favoriteDishesDic["stringValues"] ?? []
                            
                            let oHours = item["spotoperationhours"] as? [String:[String]] ?? [:]
                            spotModel.operationhours = oHours["stringValues"] ?? []
                            
                            //Feed
                            let feedTitle = item["title"] as? [String:[String]] ?? [:]
                            spotModel.feedTitle = feedTitle["stringValues"] ?? []
                            
                            let feedId = item["feedid"] as? [String:[Int]] ?? [:]
                            spotModel.feedId = feedId["longValues"] ?? []
                            
                            let feedPostedBy = item["feedpostedby"] as? [String:[Int]] ?? [:]
                            spotModel.feedPostedBy = feedPostedBy["longValues"] ?? []
                            
                            let feedDescription = item["feeddescription"] as? [String:[Any]] ?? [:]
                            spotModel.feedDescription = feedDescription["stringValues"] ?? []
                            
                            let feedImageUrl = item["feedimageurl"] as? [String:[Any]] ?? [:]
                            spotModel.feedImageUrl = feedImageUrl["stringValues"] ?? []
                            
                            let createDate = item["create_date"] as? [String:[Any]] ?? [:]
                            spotModel.createDate = createDate["stringValues"] ?? []
                            
                            let endDate = item["end_date"] as? [String:[Any]] ?? [:]
                            spotModel.endDate = endDate["stringValues"] ?? []
                            
                            
                            let spotSaveModel = SpotSaveModel(id: (item["saveid"] as? Int ?? 0).description, createdAt: nil, user: user, spot: spotModel, description: item["description"] as? String ?? "", tags: tagsArr ?? [], commentCount: (item["commentcount"] as? Int ?? 0), likeCount: (item["likecount"] as? Int ?? 0),favoriteDishes: favDishesArr ?? [])
                            results.append(spotSaveModel)
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
                    completion(.failure(CustomError(errorMessage: errorMessage)))
                }
                
            }
        }
    }
    
    func getSpotSave(saveId : String ,completion: @escaping (Result<[SpotSaveModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
		  "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/spot/save" + "?saveId=" + saveId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        print(message)
                        completion(.failure(CustomError(errorMessage: message as! String)))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        var results = [SpotSaveModel]()
                        for item in records {
                            print(item)
                            let user = UserModel(id: (item["userid"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: (item["userfullname"] as? String ?? ""), pictureUrl: (item["userpictureurl"] as? String ?? ""), userBio: nil, spotCount: nil, followerCount: nil, followingCount: nil)
                            var spotModel = SpotModel(id: (item["spotid"] as! Int).description, name: item["spotname"] as? String ?? "", photoUrl: item["spotpictureurl"] as? String ?? "", address: item["spotaddress"] as? String ?? "", lat: Double(item["spotlatitude"] as! String) ?? 0.0, lon: Double(item["spotlongtitude"] as! String) ?? 0.0, phoneNumber: item["spotphonenumber"] as? String ?? "", googlePlaceId: "", city: "")
                            spotModel.logoUrl = item["spotlogo"] as? String ?? ""
                            spotModel.email = item["spotemail"] as? String ?? ""
                            spotModel.website = item["spotwebsite"] as? String ?? ""
                            spotModel.owners = item["spotowners"] as? String ?? ""
                            spotModel.didILike = (item["doilike"] as? Int ?? 0) != 0
                            
                            let mPics = item["spotmenupic"] as? [String:[String]] ?? [:]
                            spotModel.menuPictures = mPics["stringValues"] ?? []
                            
                            let fPics = item["spotfoodpic"] as? [String:[String]] ?? [:]
                            spotModel.foodPictures = fPics["stringValues"] ?? []
                            
                            let cPics = item["spotcustomerpic"] as? [String:[String]] ?? [:]
                            spotModel.customerPictures = cPics["stringValues"] ?? []
                            
                            let sDelivery = item["spotdelivery"] as? [String:[String]] ?? [:]
                            spotModel.deliveryOptions = sDelivery["stringValues"] ?? []
                            
                            spotModel.spotDescription = item["spotdescription"] as? String ?? ""
                            spotModel.spotreservationlink = item["spotreservationlink"] as? String ?? ""
                            spotModel.spotreservationdescription = item["spotreservationdescription"] as? String ?? ""

                            let sCategories = item["spotcategories"] as? [String:[String]] ?? [:]
                            spotModel.categories = (sCategories["stringValues"] ?? []).map({Int($0) ?? 0})
                            
                            let oLocations = item["spototherlocations"] as? [String:[String]] ?? [:]
                            spotModel.otherlocations = oLocations["stringValues"] ?? []
                            
                            let tagsDic = item["tags"] as? [String : [Int]?] ?? [:]
                            let tagsArr = tagsDic["longValues"] ?? []
                            let favoriteDishesDic = item["favoritedishes"] as? [String : [String]?] ?? [:]
                            let favDishesArr = favoriteDishesDic["stringValues"] ?? []
                            
                            let oHours = item["spotoperationhours"] as? [String:[String]] ?? [:]
                            spotModel.operationhours = oHours["stringValues"] ?? []
                            
                            //Feed
                            let feedTitle = item["title"] as? [String:[String]] ?? [:]
                            spotModel.feedTitle = feedTitle["stringValues"] ?? []
                            
                            let feedId = item["feedid"] as? [String:[Int]] ?? [:]
                            spotModel.feedId = feedId["longValues"] ?? []
                            
                            let feedPostedBy = item["feedpostedby"] as? [String:[Int]] ?? [:]
                            spotModel.feedPostedBy = feedPostedBy["longValues"] ?? []
                            
                            let feedDescription = item["feeddescription"] as? [String:[Any]] ?? [:]
                            spotModel.feedDescription = feedDescription["stringValues"] ?? []
                            
                            let feedImageUrl = item["feedimageurl"] as? [String:[Any]] ?? [:]
                            spotModel.feedImageUrl = feedImageUrl["stringValues"] ?? []
                            
                            let createDate = item["create_date"] as? [String:[Any]] ?? [:]
                            spotModel.createDate = createDate["stringValues"] ?? []
                            
                            let endDate = item["end_date"] as? [String:[Any]] ?? [:]
                            spotModel.endDate = endDate["stringValues"] ?? []
                            
                            
                            let spotSaveModel = SpotSaveModel(id: (item["saveid"] as? Int ?? 0).description, createdAt: nil, user: user, spot: spotModel, description: item["description"] as? String ?? "", tags: tagsArr ?? [], commentCount: (item["commentcount"] as? Int ?? 0), likeCount: (item["likecount"] as? Int ?? 0),favoriteDishes: favDishesArr ?? [])
                            results.append(spotSaveModel)
                        }
                        results.reverse()
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
                    completion(.failure(CustomError(errorMessage: errorMessage)))
                }
                
            }
        }
    }
    
    func getSpotSaveLikes(saveId : String ,completion: @escaping (Result<[LikeModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/spot/save/like" + "?saveId=" + saveId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    let records = JSON["records"] as! [[String:Any]]
                    var results = [LikeModel]()
                    for item in records {
                        let userModel = UserModel(id: item["userid"] as? String ?? "", username: (item["username"] as? String ?? ""), fullname: (item["fullname"] as? String ?? ""), pictureUrl: (item["pictureurl"] as? String ?? ""), userBio: "", spotCount: 0, followerCount: 0, followingCount: 0)
                        let likeModel = LikeModel(id: item["id"] as? String ?? "", user: userModel)
                        results.append(likeModel)
                    }
                    completion(.success(results))
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
    
    func getSpotFriends(spotId: String,completion: @escaping (Result<[UserModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/spot/friends?" + "spotId=" + spotId 
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let json = JSON["records"] as? [[String:Any]]{
                        let records = json
                        var result = [UserModel]()
                        for item in records {
                            let user = UserModel(id: (item["id"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: (item["fullname"] as? String ?? ""), pictureUrl: (item["pictureurl"] as? String ?? ""), userBio: "", spotCount: 0, followerCount: 0, followingCount: 0)
                            result.append(user)
                        }
                        completion(.success(result))
                    }else{
                        completion(.success([UserModel]()))
                    }
                }
            case .failure(let error):
                print(error)
                completion(.success([UserModel]()))
                //let error = response.value as! NSDictionary
                //let errorMessage = error["message"] as! String
                //completion(.failure(CustomError(errorMessage: errorMessage)))
            }
        }
    }
	
	func postAnalyticsData(spotId : String,eventName : String){
		let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
		let headers: HTTPHeaders = [
		  "Accept-Encoding": "gzip",
		  "Accept": "application/json",
		  "Cache-Control": "max-age=0",
		  "AuthToken" : authToken
		]
		
		var city = ""
		var lat = 0.0
		var lon = 0.0
		
		if (CLLocationManager.locationServicesEnabled())
        {
			let locManager = CLLocationManager()
			lat = locManager.location?.coordinate.latitude ?? 0.0
			lon = locManager.location?.coordinate.longitude ?? 0.0
			let location: CLLocation = CLLocation(latitude: lat, longitude: lon)
			let geoCoder = CLGeocoder()
			geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) in
				if let placemarks = placemarks {
					let p: CLPlacemark = placemarks[0]
					city = p.locality ?? ""
					let country = p.country ?? Locale.current.regionCode
					
					let parameters: [String: String] = [
						"city" : city,
						"country" : country?.description ?? "",
						"lat" : lat.description,
						"lon" : lon.description,
						"spotId" : spotId,
						"event" : eventName
					]
					
					_ = AF.request(String.BackendBaseUrl + "/spot/analytics" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
					
				} else {
					print("Reverse geocoding failed\(error!)")
				}
			})
			
		}else{
			let parameters: [String: String] = [
				"city" : city,
				"country" : Locale.current.regionCode?.description ?? "",
				"lat" : lat.description,
				"lon" : lon.description,
				"spotId" : spotId,
				"event" : eventName
			]
			
			_ = AF.request(String.BackendBaseUrl + "/spot/analytics" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
		}
		
		
	}
    
}

class Connectivity {

    class var isConnectedToInternet:Bool {

        return NetworkReachabilityManager()!.isReachable

    }

}
