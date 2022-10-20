//
//  LikeDataSource.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 20.12.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import Alamofire

class LikeDataSource {
    

    func likePost(spotId :String,saveId : String,completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: String] = [
            "saveId" : saveId,
            "spotId": spotId
        ]
        
        AF.request(String.BackendBaseUrl + "/spot/save/like" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
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
    
    func deleteLike(spotId : String ,completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/spot/save/like" + "?spotId=" + spotId
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
    
    
}
