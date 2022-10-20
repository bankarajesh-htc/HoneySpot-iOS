//
//  Feed.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 19.12.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation

class FeedModel : NSObject {
    let user : UserModel
    var spotSave : SpotSaveModel
    var didILike : Bool = false
    
    init(user : UserModel ,spotSave : SpotSaveModel){
        self.user = user
        self.spotSave = spotSave
    }
}
