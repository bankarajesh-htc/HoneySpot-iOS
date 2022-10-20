//
//  ProfileContactTableViewCell.swift
//  HoneySpot
//
//  Created by Max on 2/19/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
 
import OneSignal

protocol ProfileContactTableViewCellDelegate {
    func didTapFollowButton(_ sender: ProfileContactTableViewCell)
    func didTapUnFollowButton(_ sender: ProfileContactTableViewCell)
    func didTapGuestFollow(_ sender: ProfileContactTableViewCell)
}

class ProfileContactTableViewCell: UITableViewCell {

    // UIComponents
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet weak var userSubTitleLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    // Variables
    var delegate: ProfileContactTableViewCellDelegate?
    var listType : ContactListType!
    var userModel : UserModel? {
        didSet {
            avatarView.userModel = self.userModel!
            userTitleLabel.text = self.userModel!.username
            userSubTitleLabel.text = self.userModel!.fullname
            
            followButton.borderColor = .ORANGE_COLOR
            followButton.borderWidth = 1
            let doIFollow = self.userModel?.doIFollow() ?? false
            let currentUserID = UserDefaults.standard.string(forKey: "userId") ?? ""
            if(doIFollow) {
                followButton.isHidden = false
                followButton.backgroundColor = .WHITE_COLOR
                followButton.setTitleColor(.ORANGE_COLOR, for: .normal)
                followButton.setTitle("Following", for: .normal)
            } else {
                followButton.isHidden = false
                followButton.backgroundColor = .ORANGE_COLOR
                followButton.setTitleColor(.WHITE_COLOR, for: .normal)
                followButton.setTitle("Follow", for: .normal)
            }
            if currentUserID == userModel?.id {
                followButton.isHidden = true
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarView.imageView.image = nil
        //avatarView.user = nil
        userTitleLabel.text = ""
        userSubTitleLabel.text = ""
    }
    
    func setupViews(){
        userTitleLabel.adjustsFontSizeToFitWidth = true
        userSubTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func followTapped(_ sender: Any) {
        
        if AppDelegate.originalDelegate.isGuestLogin {
            delegate?.didTapGuestFollow(self)
        }
        else
        {
            let doIFollow = self.userModel?.doIFollow() ?? false
            if(doIFollow){
                guard let delegate = self.delegate else {
                    return
                }
                delegate.didTapUnFollowButton(self)
                
            }else{
                
                
                DispatchQueue.global().async {
                    ProfileDataSource().followUser(userId: self.userModel!.id) { (result) in
                        switch(result){
                        case .success(let successStr):
                            DispatchQueue.main.async
                            {
                                //self.userModel!.followingCount! += 1
                                print(successStr)
    //                            guard let delegate = self.delegate else {
    //                                return
    //                            }
    //                            delegate.didTapFollowButton(self)
                                NotificationCenter.default.post(
                                    name: NSNotification.Name(.NOTIFICATION_FOLLOWER_CHANGED),
                                    object: nil,
                                    userInfo: ["LIST_TYPE": self.listType!]
                                )
                            }
                            
                        case .failure(let err):
                            print(err)
                        }
                    }
                }

            }
        }
        
        
       //
        
        
    }
    

}
