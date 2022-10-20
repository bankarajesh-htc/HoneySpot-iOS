//
//  LoginDataSource.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 19.12.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import Alamofire

class LoginDataSource {
    
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
                        UserDefaults.standard.set(JSON["authToken"] as! String, forKey: "authToken")
                        UserDefaults.standard.set((JSON["userId"] as! Int).description, forKey: "userId")
                        UserDefaults.standard.set(JSON["username"] as! String, forKey: "username")
                        UserDefaults.standard.set(JSON["pictureurl"] as! String, forKey: "pictureurl")
                        UserDefaults.standard.set(JSON["isLogin"] as! Bool, forKey: "isLogin")
                        completion(.success("Success"))
                    }
                }
            }else{
                print(response.response?.statusCode as Any)
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
    
    func loginWithForeign(foreignUserId :String,username :String,password :String,foreignUsername :String,fullName : String,userImageUrl :String,foreignToken :String,completion: @escaping (Result<Bool,CustomError>) -> ()){
        let parameters: [String: String] = [
            "foreignUserId" : foreignUserId,
            "username" : username,
            "password" : "",
            "foreignUsername" : foreignUsername,
            "fullName" : fullName,
            "userImageURL" : userImageUrl,
            "foreignToken" : foreignToken
        ]
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json"
        ]
        AF.request(String.BackendBaseUrl + "/login-foreign", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if(JSON["message"] != nil){
                        completion(.failure(CustomError(errorMessage: JSON["message"] as! String)))
                    }else{
                        UserDefaults.standard.set(JSON["authToken"] as! String, forKey: "authToken")
                        UserDefaults.standard.set((JSON["userId"] as! Int).description, forKey: "userId")
                        UserDefaults.standard.set(JSON["username"] as! String, forKey: "username")
                        UserDefaults.standard.set(JSON["pictureurl"] as! String, forKey: "pictureurl")
                        let isNew = JSON["isNew"] as! Bool
                        completion(.success(isNew))
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
        AF.request(String.BackendBaseUrl + "/signup", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if(JSON["message"] != nil){
                        completion(.failure(CustomError(errorMessage: JSON["message"] as! String)))
                    }else{
                        UserDefaults.standard.set(JSON["authToken"] as! String, forKey: "authToken")
                        UserDefaults.standard.set((JSON["userId"] as! Int).description, forKey: "userId")
                        UserDefaults.standard.set(JSON["username"] as! String, forKey: "username")
                        UserDefaults.standard.set(JSON["pictureurl"] as! String, forKey: "pictureurl")
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

struct CustomError : Error{
    let errorMessage : String
}
