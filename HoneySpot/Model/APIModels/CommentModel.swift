//
//  CommentModel.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 20.12.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation

struct CommentModel {
    let id : String
    let createdAt : Date
    let comment : String
    let user : UserModel
}
