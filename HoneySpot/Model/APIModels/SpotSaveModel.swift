//
//  SpotSaveModel.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 19.12.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation

struct SpotSaveModel {
    let id : String
	let createdAt : Date?
    let user : UserModel
    var spot : SpotModel
    //let feed : FeedModel
    let description : String
    let tags : [Int]
    var commentCount : Int
    var likeCount : Int
    var favoriteDishes : [String]
    let insiderTips = ""
    var didILike : Bool = false
}
