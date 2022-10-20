//
//  CommentDataSource.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 20.12.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import Alamofire

class CommentDataSource {
    
    func getSpotSaveComments(spotId : String ,completion: @escaping (Result<[CommentModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/spot/save/comment" + "?spotId=" + spotId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    let records = JSON["records"] as! [[String:Any]]
                    var results = [CommentModel]()
                    for item in records {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                        let userModel = UserModel(id: (item["userid"] as? Int ?? 0).description, username: (item["username"] as? String ?? ""), fullname: (item["fullname"] as? String ?? ""), pictureUrl: (item["pictureurl"] as? String ?? ""), userBio: "", spotCount: 0, followerCount: 0, followingCount: 0)
                        let ssModel = CommentModel(id: (item["id"] as? Int ?? 0).description, createdAt: dateFormatter.date(from:item["createdat"] as? String ?? "") ?? Date(), comment: item["comment"] as? String ?? "", user: userModel)
                        results.append(ssModel)
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
                    completion(.failure(CustomError(errorMessage: errorMessage )))
                }
                
            }
        }
    }
    
    func postComment(spotId: String,saveId : String,comment : String,completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: String] = [
            "saveId" : saveId,
            "spotId" : spotId,
            "comment" : comment
        ]
        
        AF.request(String.BackendBaseUrl + "/spot/save/comment" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
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
                    completion(.failure(CustomError(errorMessage: errorMessage )))
                }
            }
        }
    }
    
}

