//
//  UserModel.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 19.12.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation

struct UserModel {
    var id : String
    var username : String?
    let fullname : String?
    var pictureUrl : String?
    let userBio : String?
    let spotCount : Int?
    var followerCount : Int?
    var followingCount : Int?
    var amIFollow : Bool? = false
	var email : String = ""
	
	var createdAt : Date = Date()
}

extension UserModel {
    func doIFollow() -> Bool {
        return amIFollow ?? false
    }
}
