//
//  FeedFriendsHoneyspotCollectionViewCell.swift
//  HoneySpot
//
//  Created by Max on 2/23/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class FeedFriendsHoneyspotCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var realName: UILabel!
    
    static let CELL_IDENTIFIER = "FeedFriendsHoneyspotCollectionViewCell"
    
    func configureData(_ user: UserModel?) {
        avatarView.userModel = user
        userName.text = user?.fullname
        realName.text = user?.fullname
    }
}
