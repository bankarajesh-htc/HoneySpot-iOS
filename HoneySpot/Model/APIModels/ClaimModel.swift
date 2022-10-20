//
//  ClaimModel.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 1.07.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import Foundation

class ClaimModel : NSObject {
	let id : String
	let createdat : Date
	let claimedBy : UserModel
	let isVerified : Bool
    let isPending : Bool
	let isDenied : Bool
	var spot : SpotModel
    
    init(id : String ,createdat : Date,claimedBy : UserModel , isVerified : Bool,isDenied : Bool , isPending : Bool, spot : SpotModel){
        self.id = id
        self.createdat = createdat
		self.claimedBy = claimedBy
		self.isVerified = isVerified
		self.isDenied = isDenied
        self.isPending = isPending
		self.spot = spot
    }
}
