//
//  CLPlacemark+Constants.swift
//  HoneySpot
//
//  Created by Max on 5/15/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import CoreLocation
 

extension CLPlacemark {
//    func getCityNameAndAddress() -> (cityName: String, address: String) {
//        var cityFound: City?
//        var cityName: String = locality ?? ""
//        let cityNameInAddress: String = locality ?? ""
//        if !cityName.isEmpty {
//            // Convert detailed city name to general city name
//            let cityMappingQuery = CityMapping.query()
//            cityMappingQuery?.whereKey("realName", equalTo: cityName.lowercased())
//            do {
//                let cityMapping = try cityMappingQuery?.getFirstObject() as? CityMapping
//                if let name = cityMapping?.newName {
//                    cityName = name
//                }
//            } catch {
//                print("detailed city name not found\(error)")
//            }
////            if let index = AppManager.sharedInstance.cityNames.firstIndex(where: { $0.0 == cityName.lowercased() }) {
////                cityName = AppManager.sharedInstance.cityNames[index].1
////            }
//            // Find city object matches with city name
//            let q: PFQuery? = City.query()
//            q?.whereKey("name", equalTo: cityName.lowercased())
//            do {
//                cityFound = try q?.getFirstObject() as? City
//                //                            try cityFound?.fetchIfNeeded()
//            } catch {
//                print("Failed to find city\(error)")
//                // If not found, create a new city object
//                cityFound = City()
//                cityFound?.name = cityName.lowercased()
//                cityFound?.photoURL = ""
//                cityFound?.saveInBackground()
//            }
//        }
//        
//        let address: String = "\(name ?? ""), \(cityNameInAddress), \(postalCode ?? ""), \(country ?? "")"
//        if cityName.isEmpty {
//            cityName = country ?? address
//        }
//        return (cityName, address)
//    }
}
