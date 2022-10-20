//
//  BusinessAnalyticsDataSource.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 4.10.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import Foundation
import Alamofire

class BusinessAnalyticsDataSource {
	
	func getEngagementDate(spotId : String,startDate : Date , endDate : Date,completion: @escaping (Result<[ActivityDate],CustomError>) -> ()){
		let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
		let headers: HTTPHeaders = [
		  "Accept-Encoding": "gzip",
		  "Accept": "application/json",
		  "Cache-Control": "max-age=0",
		  "AuthToken" : authToken
		]
		
		let dateFormatterPrint = DateFormatter()
		dateFormatterPrint.dateFormat = "yyyy-MM-dd"
		let startDateStr = dateFormatterPrint.string(from: startDate)
		let endDateStr = dateFormatterPrint.string(from: endDate)
		
		let originalUrl = String.BackendBaseUrl + "/spot/analytics/engagement?" + "spotId=" + spotId + "&beginDate=" + startDateStr + "&endDate=" + endDateStr + "&type=activityDate"
		let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
		AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
			switch response.result {
			case .success:
				if let result = response.value {
                    print(response.result)
					let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        print(message)
                        completion(.failure(CustomError(errorMessage: message as! String)))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        var results = [ActivityDate]()
                        for item in records {
                            let dateFormatterPrint = DateFormatter()
                            //dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
                            dateFormatterPrint.timeZone = TimeZone.current
                            dateFormatterPrint.locale = Locale.current
                            dateFormatterPrint.dateFormat = "yyyy-MM-dd"
                            let strDate = item["createdat"] as? String
                           
                            var date = dateFormatterPrint.date(from: strDate ?? "") ?? Date()
                            //date.changeDays(by: 1)
                            print(date)
                            let honeyspotCount = item["honeyspotcount"] as? Int ?? 0
                            let pageviewCount = item["pageviewcount"] as? Int ?? 0
                            let impressionCount = item["impressioncount"] as? Int ?? 0
                            results.append(ActivityDate(date: date, impressionCount: impressionCount, honeyspotCount: honeyspotCount, pageviewCount: pageviewCount))
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
                    let error = response.value as? NSDictionary
                    let errorMessage = error?["message"] as? String
                    completion(.failure(CustomError(errorMessage: errorMessage ?? "ERROR")))
                }
			}
		}
	}
	
	func getEngagementType(spotId : String,startDate : Date , endDate : Date,completion: @escaping (Result<[ActivityType],CustomError>) -> ()){
		let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
		let headers: HTTPHeaders = [
		  "Accept-Encoding": "gzip",
		  "Accept": "application/json",
		  "Cache-Control": "max-age=0",
		  "AuthToken" : authToken
		]
		
		let dateFormatterPrint = DateFormatter()
		dateFormatterPrint.dateFormat = "yyyy-MM-dd"
		let startDateStr = dateFormatterPrint.string(from: startDate)
		let endDateStr = dateFormatterPrint.string(from: endDate)
		
		let originalUrl = String.BackendBaseUrl + "/spot/analytics/engagement?" + "spotId=" + spotId + "&beginDate=" + startDateStr + "&endDate=" + endDateStr + "&type=activityType"
		let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
		AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
			switch response.result {
			case .success:
				if let result = response.value {
                    print(response.result)
					let JSON = result as! NSDictionary
                    if let message = JSON["message"]{
                        print(message)
                        completion(.failure(CustomError(errorMessage: message as! String)))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        var results = [ActivityType]()
                        for item in records {
                            let strDate = item["createdat"] as? String
                            let date = dateFormatterPrint.date(from: strDate ?? "") ?? Date()
                            let eventName = item["eventname"] as? String ?? ""
                            let count = item["count"] as? Int ?? 0
                            let userCount = item["usercount"] as? Int ?? 0
                            //var aT = ActivityType(eventName: eventName, userCount: userCount, eventCount: count)
                            var aT = ActivityType(date: date, eventName: eventName, userCount: userCount, eventCount: count)
                            aT.reachCount = item["reachcount"] as? Int ?? 0
                            results.append(aT)
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
                    let error = response.value as? NSDictionary
                    let errorMessage = error?["message"] as? String
                    completion(.failure(CustomError(errorMessage: errorMessage ?? "ERROR")))
                }
				
			}
		}
	}
    
    //Engagemet Spot
    
    func getEngagementData(spotId : String,startDate : Date , endDate : Date,completion: @escaping (Result<[EngagementType],CustomError>) -> ()){
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers: HTTPHeaders = [
          "Accept-Encoding": "gzip",
          "Accept": "application/json",
          "Cache-Control": "max-age=0",
          "AuthToken" : authToken
        ]
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        let startDateStr = dateFormatterPrint.string(from: startDate)
        let endDateStr = dateFormatterPrint.string(from: endDate)
        
        let originalUrl = String.BackendBaseUrl + "/spot/analytics/spot_activity_count?" + "spotId=" + spotId + "&beginDate=" + startDateStr + "&endDate=" + endDateStr
        let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    print(response.result)
                    let JSON = result as! NSDictionary
                    
                    if let message = JSON["message"]{
                        print(message)
                        completion(.failure(CustomError(errorMessage: message as! String)))
                    }
                    else
                    {
                        let records = JSON["records"] as! [[String:Any]]
                        var results = [ActivityType]()
                        var engageMentResults = [EngagementType]()
                        var honeySpot = 0
                        var like = 0
                        var share = 0
                        var comment = 0
                        for item in records {
                            let eventName = item["eventname"] as? String ?? ""
                            let count = item["count"] as? Int ?? 0
                            if eventName == "comment" {
                                comment = count
                            }
                            else if  eventName == "share"
                            {
                                share = count
                            }
                            else if  eventName == "like"
                            {
                                like = count
                            }
                            else if  eventName == "spotAdd"
                            {
                                honeySpot = count
                            }
                            var engagementType = EngagementType(eventName: eventName, honeySpotCount: honeySpot, likeCount: like, shareCount: share, commentCount: comment)
                           print(engagementType)
                            engageMentResults.append(engagementType)
                        }
                        completion(.success(engageMentResults))
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
                    completion(.failure(CustomError(errorMessage: errorMessage ?? "ERROR")))
                }
            }
        }
    }
    
	
	func getSaves(spotId : String,startDate : Date , endDate : Date,completion: @escaping (Result<[Date:Int],CustomError>) -> ()){
		let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
		let headers: HTTPHeaders = [
		  "Accept-Encoding": "gzip",
		  "Accept": "application/json",
		  "Cache-Control": "max-age=0",
		  "AuthToken" : authToken
		]
		
		let dateFormatterPrint = DateFormatter()
		dateFormatterPrint.dateFormat = "yyyy-MM-dd"
		let startDateStr = dateFormatterPrint.string(from: startDate)
		let endDateStr = dateFormatterPrint.string(from: endDate)
		
		let originalUrl = String.BackendBaseUrl + "/spot/analytics/saves?" + "spotId=" + spotId + "&beginDate=" + startDateStr + "&endDate=" + endDateStr
		let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
		AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
			switch response.result {
			case .success:
				if let result = response.value {
					let JSON = result as! NSDictionary
					let records = JSON["records"] as! [[String:Any]]
					var results = [Date:Int]()
					for item in records {
						let date = item["createdat"] as? Date ?? Date()
						let count = item["count"] as? Int ?? 0
						results[date] = count
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
                    let error = response.value as? NSDictionary
                    let errorMessage = error?["message"] as? String
                    completion(.failure(CustomError(errorMessage: errorMessage ?? "ERROR")))
                }
			}
		}
	}
	
	func getAudience(spotId : String,startDate : Date , endDate : Date,completion: @escaping (Result<[String:Int],CustomError>) -> ()){
		let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
		let headers: HTTPHeaders = [
		  "Accept-Encoding": "gzip",
		  "Accept": "application/json",
		  "Cache-Control": "max-age=0",
		  "AuthToken" : authToken
		]
		
		let dateFormatterPrint = DateFormatter()
		dateFormatterPrint.dateFormat = "yyyy-MM-dd"
		let startDateStr = dateFormatterPrint.string(from: startDate)
		let endDateStr = dateFormatterPrint.string(from: endDate)
		
		let originalUrl = String.BackendBaseUrl + "/spot/analytics/audience?" + "spotId=" + spotId + "&beginDate=" + startDateStr + "&endDate=" + endDateStr
		let escapedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
		AF.request(escapedUrl ?? "", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
			switch response.result {
			case .success:
				if let result = response.value {
					let JSON = result as! NSDictionary
					let records = JSON["records"] as! [[String:Any]]
					var results = [String:Int]()
					for item in records {
						let city = item["city"] as? String ?? ""
						let count = item["count"] as? Int ?? 0
						results[city] = count
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
                    let error = response.value as? NSDictionary
                    let errorMessage = error?["message"] as? String
                    completion(.failure(CustomError(errorMessage: errorMessage ?? "ERROR")))
                }
			}
		}
	}
	
}

struct ActivityType{
	
    let date : Date
	let eventName : String
	let userCount : Int
	let eventCount : Int
	var reachCount = 0
	
}

struct EngagementType{
    
    let eventName : String
    let honeySpotCount : Int
    let likeCount : Int
    let shareCount : Int
    let commentCount : Int
    
}

struct ActivityDate{
	let date : Date
	let impressionCount : Int
	let honeyspotCount : Int
	let pageviewCount : Int
}
