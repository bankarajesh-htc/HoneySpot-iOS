////
////  SocialAccountFriendTableViewCell.swift
////  HoneySpot
////
////  Created by Max on 3/1/19.
////  Copyright © 2019 HoneySpot. All rights reserved.
////
//
//import UIKit
//
//class SocialAccountFriendTableViewCell: UITableViewCell {
//
//    // UIComponents
//    @IBOutlet weak var avatarView: AvatarView!
//    @IBOutlet weak var userTitleLabel: UILabel!
//    @IBOutlet weak var userSubTitleLabel: UILabel!
//    @IBOutlet weak var followingButton: UIButton!
//    
//    // Variables
//    static let CELL_IDENTIFIER = "SocialAccountFriendTableViewCell"
//    var user: User? {
//        didSet {
//            guard let newUser = user else {
//                avatarView.user = nil
//                userTitleLabel.text = ""
//                userSubTitleLabel.text = ""
//                return
//            }
//            avatarView.user = newUser
//            userTitleLabel.text = newUser.username
//            userSubTitleLabel.text = newUser.fullName
//        }
//    }
//    
//    var shouldFollow: Bool = false {
//        didSet {
//            followingButton.setTitle(shouldFollow ? "Following" : "Follow", for: .normal)
//            followingButton.backgroundColor = shouldFollow ? .ORANGE_COLOR : .lightGray
//        }
//    }
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        // Configure the view for the selected state
//    }
//
//}
