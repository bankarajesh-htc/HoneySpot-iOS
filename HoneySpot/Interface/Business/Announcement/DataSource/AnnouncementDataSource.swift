//
//  AnnouncementDataSource.swift
//  HoneySpot
//
//  Created by htcuser on 04/10/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import Foundation
import Alamofire

class AnnouncementDataSource {
    
    func createAnnouncement(announcementModel : AnnouncementModel,completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: String] = [
            "spotId" : announcementModel.id,
            "imageUrl" : announcementModel.imageurl,
            "title" : announcementModel.title ,
            "description" : announcementModel.description,
            "create_date" : announcementModel.create_date,
            "end_date" : announcementModel.end_date
        ]
        
        AF.request(String.BackendBaseUrl + "/business/announcement-feed" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
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
                    completion(.failure(CustomError(errorMessage: errorMessage )))
                }
            }
        }
    }
    func updateAnnouncement(announcementListModel : AnnouncementListModel,completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let parameters: [String: Any] = [
            "postId" : announcementListModel.announcementId,
            "spotId" : announcementListModel.spotid,
            "imageUrl" : announcementListModel.imageurl,
            "title" : announcementListModel.title ,
            "description" : announcementListModel.description,
            "create_date" : announcementListModel.create_date,
            "end_date" : announcementListModel.end_date
        ]
        
        AF.request(String.BackendBaseUrl + "/business/announcement-feed" , method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
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
                    completion(.failure(CustomError(errorMessage: errorMessage ?? "ERROR")))
                }
            }
        }
    }
    
    func getAnnouncementList(spotId : String,completion: @escaping (Result<[AnnouncementListModel],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/business/announcement-feed?" + "&spotId=" + spotId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    let records = JSON["records"] as! [[String:Any]]
                    if let message = JSON["message"]{
                        print(message)
                        completion(.success(result as! [AnnouncementListModel]))
                    }
                    else
                    {
                        print("Record \(records)")
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        
                        var result: [AnnouncementListModel] = []
                        for item in records {
                            let endDate = dateFormatter.date(from: item["end_date"] as? String ?? "")
                            print(endDate as Any)
                            let endDateString = self.convertDateToString(date: endDate!, format: "MMMM dd, yyyy")
                            print(endDateString)
                            let announcementListModel = AnnouncementListModel(create_date: item["create_date"] as? String ?? "", description:  item["description"] as? String ?? "", end_date:  endDateString as? String ?? "", announcementId:  item["id"] as? Int ?? 0, imageurl:  item["imageurl"] as? String ?? "", postedby:  item["postedby"] as? Int ?? 0, spotid:  item["spotid"] as? Int ?? 0, title:  item["title"] as? String ?? "")
                            result.append(announcementListModel)
                            print(result)
                        }
                        
                        completion(.success(result.reversed()))
                        
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
                    completion(.failure(CustomError(errorMessage: errorMessage ?? "ERROR")))
                }
            }
        }
    }
    func deleteAnnouncement(announcementId : String ,spotId : String, completion: @escaping (Result<String,CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "AuthToken" : authToken
        ]
        
        let originalUrl = String.BackendBaseUrl + "/business/announcement-feed?" + "&spotId=" + spotId + "&postId=" + announcementId
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    print(response.result)
                    let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        print(message)
                        completion(.success(message as! String))
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
                    completion(.failure(CustomError(errorMessage: errorMessage ?? "ERROR")))
                }
            }
        }
    }
    
    func convertDateToString(date: Date, format: String) -> String {
        
        let formatter = DateFormatter() //"yyyy-MM-dd"
        formatter.dateFormat = "yyyy-MM-dd"
        let myString = formatter.string(from: date)
        let yourDate: Date? = formatter.date(from: myString)
        formatter.dateFormat = format
        let updatedString = formatter.string(from: yourDate!)
        
        return updatedString
    }
    
}
