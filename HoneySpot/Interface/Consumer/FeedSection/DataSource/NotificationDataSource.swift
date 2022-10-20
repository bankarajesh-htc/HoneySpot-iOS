//
//  FeedDataSource.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 19.12.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import Alamofire

class NotificationDataSource {
    func getUnreadNotificationCount(completion: @escaping (Result<Int,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        AF.request(String.BackendBaseUrl + "/user/notification-count", method: .get , parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    let records = JSON["records"] as! [[String:Any]]
                    for item in records {
                        completion(.success(item["count"] as! Int))
                    }
                }
            case .failure(let error):
                print(error)
               // let error = response.value as! NSDictionary
                if response.value == nil {
                    completion(.failure(CustomError(errorMessage: "Please Check Your Internet Connection")))
                }
                else
                {
                    let errorMessage = "Error. Retry again"//error["message"] as! String
                    completion(.failure(CustomError(errorMessage: errorMessage)))
                }
                
            }
        }
    }
    
    func getNotifications(completion: @escaping (Result<[NotificationModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        AF.request(String.BackendBaseUrl + "/user/notifications", method: .get , parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    let records = JSON["records"] as! [[String:Any]]
                    print(records)
                    var results = [NotificationModel]()
                    for item in records {
                        let userModel = UserModel(id: (item["fromuser"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: (item["fullname"] as? String ?? ""), pictureUrl: (item["userpictureurl"] as? String ?? ""), userBio: nil, spotCount: nil, followerCount: nil, followingCount: nil)
                       let spotmodel = SpotModel(id: (item["spotid"] as? Int ?? 0).description, name: (item["spotname"] as? String ?? ""), photoUrl: "", address: "", lat: 0.0, lon: 0.0, phoneNumber: "", googlePlaceId: "", city: "")
                        let spotSaveModel = SpotSaveModel(id: (item["spotsaveid"] as? Int ?? 0).description, createdAt: (item["createdat"]) as? Date, user: userModel, spot: spotmodel, description: "", tags: [], commentCount: 0, likeCount: 0, favoriteDishes: [])
//                        let notification = NotificationModel(id: (item["id"] as! Int).description, title: (item["title"] as! String), descriptionStr: (item["description"] as! String), type: (item["type"] as! String), spotSaveModel: spotSaveModel, isRead: (item["isread"] as! Bool), user: userModel)
                        let notification  =  NotificationModel(feedid: (item["feedid"] as? String ?? ""), feedtitle: (item["feedtitle"] as? String ?? ""), feeddescription: (item["feeddescription"] as? String ?? ""), create_date: (item["create_date"] as? String ?? ""), end_date: (item["end_date"] as? String ?? ""), imageurl: (item["imageurl"] as? String ?? ""), userpictureurl: (item["userpictureurl"] as? String ?? ""), postedby: (item["postedby"] as? Int ?? 0), claimid: (item["claimid"] as? Int ?? 0), spotSaveModel: spotSaveModel, isRead: false, user: userModel)
                        
                        results.append(notification)
                    }
                    //results.reverse()
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
    
    func updateNotifications(){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        AF.request(String.BackendBaseUrl + "/user/notifications", method: .patch, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                print("Success")
            case .failure(let error):
                print(error)
                if response.value == nil {
                    
                    print(error.errorDescription as Any)
                }
                else
                {
                    let error = response.value as! NSDictionary
                    let errorMessage = error["message"] as! String
                    print(errorMessage)
                }
                
            }
        }
    }
    
    func deleteNotification(id:String){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        AF.request(String.BackendBaseUrl + "/user/notifications?notificationId="+id, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                print("Success")
            case .failure(let error):
                print(error)
                if response.value == nil {
                    
                    print(error.errorDescription as Any)
                }
                else
                {
                    let error = response.value as! NSDictionary
                    let errorMessage = error["message"] as! String
                    print(errorMessage)
                }
            }
        }
    }
    
}
