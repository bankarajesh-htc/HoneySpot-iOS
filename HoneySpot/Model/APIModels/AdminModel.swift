//
//  AdminModel.swift
//  HoneySpot
//
//  Created by htcuser on 13/12/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import Foundation

struct AdminModel {
   
    var website : String?
    var email : String?

    var isVerified : Bool
    var isPending : Bool
    var isDenied : Bool
    let createdat : Date
    
    let claimedbyid : Int
    let claimid : Int
    let claimedbyname : String
    let claimedbypictureurl : String
    
    /*let honeyspots : Int
    let newrequests : Int
    let approved : Int
    let rejected : Int*/
    
    var spot : SpotModel
   
    
}

