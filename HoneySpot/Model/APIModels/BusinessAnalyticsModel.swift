//
//  BusinessAnalyticsModel.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 4.10.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import Foundation

class BusinessAnalyticsModel : NSObject {
	let id : String
	let createdat : Date
	let city : String
	let country : String
	var event : String
	
	init(id : String ,createdat : Date,city : String , country : String,event : String){
		self.id = id
		self.createdat = createdat
		self.city = city
		self.country = country
		self.event = event
	}
	
}
