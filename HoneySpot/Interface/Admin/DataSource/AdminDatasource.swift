//
//  AdminDatasource.swift
//  HoneySpot
//
//  Created by htcuser on 10/12/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import Foundation

import Alamofire

class AdminDatasource {
    
    func login(usernameOrEmail : String,password : String,completion: @escaping (Result<String?,CustomError>) -> ()){
        let parameters: [String: String] = [
            "usernameOrEmail" : usernameOrEmail,
            "password" : password
        ]
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json"
        ]
        AF.request(String.BackendBaseUrl + "/login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            if response.response?.statusCode == 200 {
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if(JSON["message"] != nil){
                        completion(.failure(CustomError(errorMessage: JSON["message"] as! String)))
                    }else{
                        UserDefaults.standard.set(JSON["authToken"] as! String, forKey: "adminauthToken")
                        UserDefaults.standard.set((JSON["userId"] as! Int).description, forKey: "adminuserId")
                        UserDefaults.standard.set(JSON["username"] as! String, forKey: "adminusername")
                        UserDefaults.standard.set(JSON["pictureurl"] as! String, forKey: "adminpictureurl")
                        completion(.success("Success"))
                    }
                }
            }else{
                if response.value == nil {
                    completion(.failure(CustomError(errorMessage: "Please Check Your Internet Connection")))
                }
                else
                {
                    print(response.response?.statusCode as Any)
                    let error = response.value as? NSDictionary
                    let errorMessage = error?["message"] as? String
                    completion(.failure(CustomError(errorMessage: errorMessage ?? "Error")))
                }
                
            }
        }
    }
    
    func getClaimList(isPending:Bool,isVerified:Bool,isDenied:Bool,completion: @escaping (Result<[AdminModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "adminauthToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        let parameters: [String: Any] = [
            "ispending" : isPending,
            "isverified" : isVerified,
            "isdenied" : isDenied
        ]
        
        let originalUrl = String.BackendBaseUrl + "/spots-claim-list"
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        print(message)
                        if message as! String == "Forbidden" {
                            completion(.failure(CustomError(errorMessage: "Please Check Your Internet Connection")))
                        }
                        else
                        {
                            completion(.success(message as! [AdminModel]))
                        }
                        
                    }
                    else
                    {
                        let overViewrecords = JSON["overviewData"] as! NSDictionary
                        let totalrecords = overViewrecords["records"] as! [[String:Any]]
                        var results: [AdminModel] = []
                        for total in totalrecords {
                            AppDelegate.originalDelegate.honeyspots = (total["honeyspots"] as? Int ?? 0)
                            AppDelegate.originalDelegate.newrequests = (total["newrequests"] as? Int ?? 0)
                            AppDelegate.originalDelegate.approved = (total["approved"] as? Int ?? 0)
                            AppDelegate.originalDelegate.rejected = (total["rejected"] as? Int ?? 0)
                            print("\(total["honeyspots"] as! Int)")
                        }
                        
                        let records = JSON["records"] as! [[String:Any]]
                        print("Record \(records)")
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        
                        
                        for item in records {
                            var spotModel = SpotModel(id: (item["spotid"] as? Int ?? 0).description, name: item["spotname"] as? String ?? "", photoUrl: item["spotpictureurl"] as? String ?? "", address: item["spotaddress"] as? String ?? "", lat: Double(item["spotlatitude"] as! String) ?? 0.0, lon: Double(item["spotlongtitude"] as! String) ?? 0.0, phoneNumber: item["spotphonenumber"] as? String ?? "", googlePlaceId: "", city: "")
                            let adminModel = AdminModel(website: "", email: "", isVerified: (item["isverified"] as? Bool ?? false), isPending: (item["ispending"] as? Bool ?? false), isDenied: (item["isdenied"] as? Bool ?? false), createdat: Date(), claimedbyid: item["claimedbyid"] as? Int ?? 0, claimid: item["claimid"] as? Int ?? 0, claimedbyname: item["claimedbyname"] as? String ?? "", claimedbypictureurl: item["claimedbypictureurl"] as? String ?? "", spot: spotModel)
                            
                            results.append(adminModel)
                            
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
                    let error = response.value as? NSDictionary
                    let errorMessage = error?["message"] as? String
                    completion(.failure(CustomError(errorMessage: errorMessage ?? "Error")))
                }
                
            }
        }
    }
    func updateClaimStatus(spotId:[String],isVerified:Bool,isDenied:Bool,completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "adminauthToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: Any] = [
            
            "spotIds" : spotId,
            "isVerified" : isVerified,
            "isDenied" : isDenied
        ]
        
        AF.request(String.BackendBaseUrl + "/business/update-claim-status" , method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
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
                    completion(.failure(CustomError(errorMessage: errorMessage)))
                }
            }
        }
    }
    
    func getAdminDetails(saveId : String ,completion: @escaping (Result<[SpotSaveModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "adminauthToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/admin/spot-details-admin" + "?spotId=" + saveId
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
                            var spotModel = SpotModel(id: (item["spotid"] as? Int ?? 0).description, name: item["spotname"] as! String, photoUrl: item["spotpictureurl"] as? String ?? "", address: item["spotaddress"] as? String ?? "", lat: Double(item["spotlatitude"] as! String) ?? 0.0, lon: Double(item["spotlongtitude"] as! String) ?? 0.0, phoneNumber: item["spotphonenumber"] as? String ?? "", googlePlaceId: "", city: "")
                            spotModel.logoUrl = item["spotlogo"] as? String ?? ""
                            spotModel.email = item["spotemail"] as? String ?? ""
                            spotModel.website = item["spotwebsite"] as? String ?? ""
                            spotModel.owners = item["spotowners"] as? String ?? ""
                            spotModel.comment = item["comment"] as? String ?? ""
                            
                            
                            
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
    
    
    
}
