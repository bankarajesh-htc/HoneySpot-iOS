//
//  ProfileDataSource.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 24.12.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import Alamofire

class ProfileDataSource {
    
    func doIFollowUser(userId : String,completion: @escaping (Result<Bool,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/user/do-i-follow?" + "userId=" + userId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        var result = false
                        print(message)
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        var result = false
                        for item in records {
                            result = item["doifollow"] as! Bool
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
                    completion(.failure(CustomError(errorMessage:  error.errorDescription ?? "Error getting user")))
                }
                
            }
        }
    }
    
    func getDeepLinkUser(userId : String,completion: @escaping (Result<UserModel,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/guest?" + "userId=" + userId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        var result = emptyUserModel()
                        print(message)
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        print(records)
                        var result = emptyUserModel()
                        for item in records {
                            var user = UserModel(id: (item["id"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: (item["fullname"] as? String ?? ""), pictureUrl: (item["pictureurl"] as? String ?? ""), userBio: (item["userbio"] as? String ?? ""), spotCount: (item["spotcount"] as? Int ?? 0), followerCount: (item["followercount"] as? Int ?? 0), followingCount: (item["followingcount"] as? Int ?? 0))
                            if let email = item["email"] as? String {
                                user.email = email
                            }
                            if let cD = item["createdat"] as? Date {
                                user.createdAt = cD
                            }
                            result = user
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
                    completion(.failure(CustomError(errorMessage:  error.errorDescription ?? "Error getting user")))
                }
            }
        }
    }
    
    func getUser(userId : String,completion: @escaping (Result<UserModel,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/user?" + "userId=" + userId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        var result = emptyUserModel()
                        print(message)
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        print(records)
                        var result = emptyUserModel()
                        for item in records {
                            var user = UserModel(id: (item["id"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: (item["fullname"] as? String ?? ""), pictureUrl: (item["pictureurl"] as? String ?? ""), userBio: (item["userbio"] as? String ?? ""), spotCount: (item["spotcount"] as? Int ?? 0), followerCount: (item["followercount"] as? Int ?? 0), followingCount: (item["followingcount"] as? Int ?? 0))
                            if let email = item["email"] as? String {
                                user.email = email
                            }
                            if let cD = item["createdat"] as? Date {
                                user.createdAt = cD
                            }
                            result = user
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
                    completion(.failure(CustomError(errorMessage:  error.errorDescription ?? "Error getting user")))
                }
            }
        }
    }
    func getDeepLinkUserProfileSaves(userId: String,completion: @escaping (Result<[CitySaveModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/guest/profile-saves?" + "userId=" + userId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        var result = [CitySaveModel]()
                        print(message)
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        print(records)
                        var result = [CitySaveModel]()
                        for item in records {
                            let cSModel = CitySaveModel(city: (item["city"] as! String), saveCount: item["savecount"] as! Int, photoUrl: (item["photourl"] as? String) ?? "")
                            result.append(cSModel)
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
    
    func getUserProfileSaves(userId: String,completion: @escaping (Result<[CitySaveModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/user/profile-saves?" + "userId=" + userId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        var result = [CitySaveModel]()
                        print(message)
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        print(records)
                        var result = [CitySaveModel]()
                        for item in records {
                            let cSModel = CitySaveModel(city: (item["city"] as? String ?? ""), saveCount: item["savecount"] as? Int ?? 0, photoUrl: (item["photourl"] as? String) ?? "")
                            result.append(cSModel)
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
                    completion(.failure(CustomError(errorMessage: errorMessage )))
                }
            }
        }
    }
    func getProfileGuestCitySaves(userId : String,city : String,completion: @escaping (Result<[SpotSaveModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/guest/city-saves?" + "userId=" + userId + "&city=" + city
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        var result = [SpotSaveModel]()
                        var results = [FeedModel]()
                        print(message)
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        print(records)
                        var results = [FeedModel]()
                        var result = [SpotSaveModel]()
                        for item in records {
                            print(item)
                            var user = emptyUserModel()
                            user.id = UserDefaults.standard.string(forKey: "userId") ?? ""
                            let spot = SpotModel(id: (item["spotid"] as? Int ?? 0).description, name: item["spotname"] as? String ?? "", photoUrl: item["spotphotourl"] as? String ?? "", address: "", lat: Double(item["latitude"] as! String) ?? 0.0, lon: Double(item["longtitude"] as! String) ?? 0.0, phoneNumber: "", googlePlaceId: "", city: "")
                            var spotSaveModel = SpotSaveModel(id: (item["saveid"] as? Int ?? 0).description, createdAt: nil, user: user, spot: spot, description: "", tags: [], commentCount: item["commentcount"] as? Int ?? 0, likeCount: item["likecount"] as? Int ?? 0, favoriteDishes: [])
                            spotSaveModel.didILike = (item["doilike"] as! Int) != 0
                            let feed = FeedModel(user: user, spotSave: spotSaveModel)
                            feed.didILike = (item["doilike"] as! Int) != 0
                            print(feed)
                            result.append(spotSaveModel)
                        }
                        var filterArray = result.filterDuplicates { $0.spot.id == $1.spot.id }
                        filterArray.reverse()
                        completion(.success(filterArray))
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
                    completion(.failure(CustomError(errorMessage: errorMessage )))
                }
            }
        }
    }
    
    func getProfileCitySaves(userId : String,city : String,completion: @escaping (Result<[SpotSaveModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/user/city-saves?" + "userId=" + userId + "&city=" + city
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        var result = [SpotSaveModel]()
                        var results = [FeedModel]()
                        print(message)
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        print(records)
                        var results = [FeedModel]()
                        var result = [SpotSaveModel]()
                        for item in records {
                            print(item)
                            var user = emptyUserModel()
                            user.id = UserDefaults.standard.string(forKey: "userId") ?? ""
                            let spot = SpotModel(id: (item["spotid"] as? Int ?? 0).description, name: item["spotname"] as? String ?? "", photoUrl: item["spotphotourl"] as? String ?? "", address: "", lat: Double(item["latitude"] as! String) ?? 0.0, lon: Double(item["longtitude"] as! String) ?? 0.0, phoneNumber: "", googlePlaceId: "", city: "")
                            var spotSaveModel = SpotSaveModel(id: (item["saveid"] as? Int ?? 0).description, createdAt: nil, user: user, spot: spot, description: "", tags: [], commentCount: item["commentcount"] as? Int ?? 0, likeCount: item["likecount"] as? Int ?? 0, favoriteDishes: [])
                            spotSaveModel.didILike = (item["doilike"] as! Int) != 0
                            let feed = FeedModel(user: user, spotSave: spotSaveModel)
                            feed.didILike = (item["doilike"] as! Int) != 0
                            print(feed)
                            result.append(spotSaveModel)
                        }
                        var filterArray = result.filterDuplicates { $0.spot.id == $1.spot.id }
                        filterArray.reverse()
                        completion(.success(filterArray))
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
                    completion(.failure(CustomError(errorMessage: errorMessage )))
                }
            }
        }
    }
    func getGuestUserLastSaves(userId : String,completion: @escaping (Result<[SpotSaveModel],CustomError>) -> ()){
         let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
         let headers: HTTPHeaders = [
           "Accept-Encoding": "gzip",
           "Accept": "application/json",
           "Cache-Control": "max-age=0",
           "AuthToken" : authToken
         ]
         
         let originalUrl = String.BackendBaseUrl + "/guest/last-saves?" + "userId=" + userId
         let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
         AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { (response) in
             switch response.result {
             case .success:
                 if let result = response.value {
                     let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        var result = [SpotSaveModel]()
                        print(message)
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        var result = [SpotSaveModel]()
                        for item in records {
                            let user = emptyUserModel()
                            let spot = SpotModel(id: (item["spotid"] as? Int ?? 0).description, name: item["spotname"] as! String, photoUrl: item["spotphotourl"] as? String ?? "", address: "", lat: Double(item["latitude"] as! String) ?? 0.0, lon: Double(item["longtitude"] as! String) ?? 0.0, phoneNumber: "", googlePlaceId: "", city: "")
                           let spotSaveModel = SpotSaveModel(id: (item["saveid"] as? Int ?? 0).description, createdAt: nil, user: user, spot: spot, description: "", tags: [], commentCount: 0, likeCount: 0, favoriteDishes: [])
                            result.append(spotSaveModel)
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
                    completion(.failure(CustomError(errorMessage: errorMessage )))
                }
             }
         }
     }
    func getUserLastSaves(userId : String,completion: @escaping (Result<[SpotSaveModel],CustomError>) -> ()){
         let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
         let headers: HTTPHeaders = [
           "Accept-Encoding": "gzip",
           "Accept": "application/json",
           "Cache-Control": "max-age=0",
           "AuthToken" : authToken
         ]
         
         let originalUrl = String.BackendBaseUrl + "/user/last-saves?" + "userId=" + userId
         let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
         AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
             switch response.result {
             case .success:
                 if let result = response.value {
                     let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        var result = [SpotSaveModel]()
                        print(message)
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        var result = [SpotSaveModel]()
                        for item in records {
                            let user = emptyUserModel()
                            let spot = SpotModel(id: (item["spotid"] as? Int ?? 0).description, name: item["spotname"] as! String, photoUrl: item["spotphotourl"] as? String ?? "", address: "", lat: Double(item["latitude"] as! String) ?? 0.0, lon: Double(item["longtitude"] as! String) ?? 0.0, phoneNumber: "", googlePlaceId: "", city: "")
                           let spotSaveModel = SpotSaveModel(id: (item["saveid"] as? Int ?? 0).description, createdAt: nil, user: user, spot: spot, description: "", tags: [], commentCount: 0, likeCount: 0, favoriteDishes: [])
                            result.append(spotSaveModel)
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
                    completion(.failure(CustomError(errorMessage: errorMessage )))
                }
             }
         }
     }
    
    func getGuestFollower(userId : String,completion: @escaping (Result<[UserModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/guest/user-followers?" + "userId=" + userId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        var result = [UserModel]()
                        print(message)
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        var result = [UserModel]()
                        for item in records {
                            var user = UserModel(id: (item["id"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: (item["fullname"] as? String ?? ""), pictureUrl: (item["pictureurl"] as? String ?? ""), userBio: "", spotCount: 0, followerCount: 0, followingCount: 0)
                            user.amIFollow = (item["doifollow"] as? Bool ?? false)
                            result.append(user)
                        }
                        result.reverse()
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
                    completion(.failure(CustomError(errorMessage: errorMessage )))
                }
            }
        }
    }
    
    func getFollower(userId : String,completion: @escaping (Result<[UserModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/user/followers?" + "userId=" + userId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        var result = [UserModel]()
                        print(message)
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        var result = [UserModel]()
                        for item in records {
                            var user = UserModel(id: (item["id"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: (item["fullname"] as? String ?? ""), pictureUrl: (item["pictureurl"] as? String ?? ""), userBio: "", spotCount: 0, followerCount: 0, followingCount: 0)
                            user.amIFollow = (item["doifollow"] as? Bool ?? false)
                            result.append(user)
                        }
                        result.reverse()
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
                    completion(.failure(CustomError(errorMessage: errorMessage )))
                }
            }
        }
    }
    func getGuestFollowing(userId : String,completion: @escaping (Result<[UserModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/guest/user-followings?" + "userId=" + userId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        var result = [UserModel]()
                        print(message)
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        var result = [UserModel]()
                        for item in records {
                            var user = UserModel(id: (item["id"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: (item["fullname"] as? String ?? ""), pictureUrl: (item["pictureurl"] as? String ?? ""), userBio: "", spotCount: 0, followerCount: 0, followingCount: 0)
                            user.amIFollow = (item["doifollow"] as? Bool ?? false)
                            result.append(user)
                        }
                        result.reverse()
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
    func getFollowing(userId : String,completion: @escaping (Result<[UserModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/user/followings?" + "userId=" + userId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        var result = [UserModel]()
                        print(message)
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        var result = [UserModel]()
                        for item in records {
                            var user = UserModel(id: (item["id"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: (item["fullname"] as? String ?? ""), pictureUrl: (item["pictureurl"] as? String ?? ""), userBio: "", spotCount: 0, followerCount: 0, followingCount: 0)
                            user.amIFollow = (item["doifollow"] as? Bool ?? false)
                            result.append(user)
                        }
                        result.reverse()
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
    
    func updateUser(username : String , email : String , bio : String , pictureUrl : String ,completion: @escaping (Result<String,CustomError>) -> ()){
        
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: Any] = [
            "username": username,
            "email": email,
            "bio": bio,
            "pictureUrl" : pictureUrl
        ]
        
        AF.request(String.BackendBaseUrl + "/user" , method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
                let headers: HTTPHeaders = [
                  "Accept-Encoding": "gzip",
                  "Cache-Control": "max-age=0",
                  "Accept": "application/json",
                  "AuthToken" : authToken,
                ]
                
                let originalUrl = String.BackendBaseUrl + "/user?" + "userId=" + UserDefaults.standard.string(forKey: "userId")!
                let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
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
                    completion(.failure(CustomError(errorMessage: errorMessage)))
                }
            }
        }
    }
    func notificationGetStatus(completion: @escaping (Result<Bool,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
       
        let originalUrl = String.BackendBaseUrl + "/user/notification-status"
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if(JSON["message"] != nil){
                        var result = false
                        completion(.success(result))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        print(records)
                        var result = false
                        for item in records {
                            result = item["notificationstatus"] as! Bool
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
                    completion(.failure(CustomError(errorMessage: errorMessage )))
                }
            }
        }
    }
    func notificationPostStatus(staus: Bool,completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: Any] = [
            "notificationStatus": staus
        ]
        
        let originalUrl = String.BackendBaseUrl + "/user/notification-status"
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if(JSON["message"] != nil){
                        completion(.success(JSON["message"] as! String))
                        
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
                    completion(.failure(CustomError(errorMessage: errorMessage )))
                }
            }
        }
    }
    func signOutUser(completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/logout"
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if(JSON["message"] != nil){
                        completion(.success(JSON["message"] as! String))
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
                    completion(.failure(CustomError(errorMessage: errorMessage )))
                }
            }
        }
    }
    func deleteUser(completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/user"
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
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
    
    func followUser(userId : String,completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: Any] = [
            "toUserId": userId
        ]
        
        AF.request(String.BackendBaseUrl + "/user/follow" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
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
    
    func unfollowUser(userId : String,completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/user" + "/follow?" + "toUserId=" + userId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
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
    func subscriptionNew(plans : String,price : Double,status: Bool,completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: Any] = [
            "plans": plans,
            "price": price,
            "transactionStatus":status
        ]
        
        AF.request(String.BackendBaseUrl + "/business/subscriptions-new" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
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
    
    func subscription(plans : String,price : Double,completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: Any] = [
            "plans": plans,
            "price": price
        ]
        
        AF.request(String.BackendBaseUrl + "/business/subscriptions" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
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
    func getSubscritionExpiry(completion: @escaping (Result<[SubscriptionNewModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/business/notify-subscriptionexpiry"
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if(JSON["message"] != nil){
                        var result = [SubscriptionNewModel]()
                        completion(.success(result))
                        
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        print("Subcription...\(records)")
                        var result = [SubscriptionNewModel]()
                        for item in records {
                            let subscriptionNewModel = SubscriptionNewModel(id: (item["id"] as? Int ?? 0).description, plans: item["plans"] as? String ?? "", create_date: item["create_date"] as? String ?? "", expiry_date: item["expiry_date"] as? String ?? "", transactionstatus: item["transactionstatus"] as? Bool ?? false, userid: item["userid"] as? Int ?? 0, price: item["price"] as? Int ?? 0)
                            result.append(subscriptionNewModel)
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
    func getSubscritionNew(completion: @escaping (Result<[SubscriptionNewModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/business/subscriptions-new"
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    
                    let JSON = result as! NSDictionary
                    let records = JSON["records"] as! [[String:Any]]
                    print("Subcription...\(records)")
                    var result = [SubscriptionNewModel]()
                    for item in records {
                        let subscriptionNewModel = SubscriptionNewModel(id: (item["id"] as? Int ?? 0).description, plans: item["plans"] as? String ?? "", create_date: item["create_date"] as? String ?? "", expiry_date: item["expiry_date"] as? String ?? "", transactionstatus: item["transactionstatus"] as? Bool ?? false, userid: item["userid"] as? Int ?? 0, price: item["price"] as? Int ?? 0)
                        result.append(subscriptionNewModel)
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
    func getSubscrition(completion: @escaping (Result<[SubscriptionModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/business/subscriptions"
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    
                    let JSON = result as! NSDictionary
                    let records = JSON["records"] as! [[String:Any]]
                    print("Subcription...\(records)")
                    var result = [SubscriptionModel]()
                    for item in records {
                        
                        let subscriptionModel = SubscriptionModel(id:(item["id"] as? Int ?? 0).description, plans: item["plans"] as? String ?? "", create_date: item["create_date"] as? String ?? "", userid: item["userid"] as? Int ?? 0, price: (item["price"] as? Int ?? 0))
                        result.append(subscriptionModel)
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

extension Array {

    func filterDuplicates(includeElement: @escaping (_ lhs: Element, _ rhs: Element) -> Bool) -> [Element] {

        var results = [Element]()

        forEach { (element) in

            let existingElements = results.filter {
                return includeElement(element, $0)
            }

            if existingElements.count == 0 {
                results.append(element)
            }
        }
        return results
    }
}
