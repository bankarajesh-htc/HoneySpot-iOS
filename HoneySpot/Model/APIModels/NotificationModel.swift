//
//  NotificationModel.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 20.12.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation

struct NotificationModel {
    let feedid : String
    let feedtitle : String
    let feeddescription : String
    let create_date : String
    let end_date : String
    let imageurl : String
    let userpictureurl : String
    let postedby : Int?
    let claimid : Int?
    let spotSaveModel : SpotSaveModel
    let isRead : Bool
    let user : UserModel
}
