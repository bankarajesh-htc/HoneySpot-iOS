//
//  BusinessLoginDataSource.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 30.06.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import Foundation
import Alamofire


class BusinessLoginDataSource {
	
    func login(usernameOrEmail : String,password : String,completion: @escaping (Result<String?,CustomError>) -> ()){
        let parameters: [String: String] = [
            "usernameOrEmail" : usernameOrEmail,
            "password" : password
        ]
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json"
        ]
        AF.request(String.BackendBaseUrl + "/business/login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            if response.response?.statusCode == 200 {
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if(JSON["message"] != nil){
                        completion(.failure(CustomError(errorMessage: JSON["message"] as! String)))
                    }else{
						UserDefaults.standard.set(true, forKey: "isBusiness")
                        UserDefaults.standard.set(JSON["authToken"] as! String, forKey: "authToken")
                        UserDefaults.standard.set((JSON["userId"] as! Int).description, forKey: "userId")
                        UserDefaults.standard.set(JSON["username"] as! String, forKey: "username")
                        UserDefaults.standard.set(JSON["plan"] as! String, forKey: "userStatus")
                        if JSON["plan"] as! String == "free" {
                            
                            AppDelegate.originalDelegate.isFree = true
                        }
                        else
                        {
                            AppDelegate.originalDelegate.isFree = false
                            
                        }
                        
                        if JSON["isAdmin"] as! Bool{
                            AppDelegate.originalDelegate.isAdminLogin = true
                        }
                        else
                        {
                            AppDelegate.originalDelegate.isAdminLogin = false
                        }
                        completion(.success("Success"))
                    }
                }
            }else{
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
	
	func register(username :String,password : String,email :String,fullName :String,completion: @escaping (Result<String?,CustomError>) -> ()){
        let parameters: [String: String] = [
            "username" : username,
            "password" : password,
            "fullName" : fullName,
            "email" : email
        ]
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json"
        ]
        AF.request(String.BackendBaseUrl + "/business/signup", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if(JSON["message"] != nil){
                        completion(.failure(CustomError(errorMessage: JSON["message"] as! String)))
                    }else{
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
    
    func forgetPassword(email : String,completion: @escaping (Result<String?,CustomError>) -> ()){
        let parameters: [String: String] = [
            "email" : email
        ]
        
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json"
        ]
        
        AF.request(String.BackendBaseUrl + "/forget-password", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    if let res = result as? NSDictionary{
                        if(res["message"] != nil){
                            completion(.failure(CustomError(errorMessage: res["message"] as! String)))
                        }else{
                            completion(.success("Success"))
                        }
                    }else{
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
    
    func resetPassword(code: String,newPass : String, completion: @escaping (Result<String?,CustomError>) -> ()){
        let parameters: [String: String] = [
            "rToken" : code,
            "newPass" : newPass
        ]
        
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json"
        ]
        
        AF.request(String.BackendBaseUrl + "/reset-password", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    if let result = response.value {
                        if let res = result as? NSDictionary{
                            if(res["message"] != nil){
                                completion(.failure(CustomError(errorMessage: res["message"] as! String)))
                            }else{
                                completion(.success("Success"))
                            }
                        }else{
                            completion(.success("Success"))
                        }
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
