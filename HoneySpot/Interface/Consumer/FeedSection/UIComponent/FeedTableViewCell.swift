//
//  FeedTableViewCell.swift
//  HoneySpot
//
//  Created by Max on 2/14/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
 
import Kingfisher

protocol FeedTableViewCellDelegate {
    func didLikeSpot(sender: FeedTableViewCell,indexPath :IndexPath)
    func didTapComment(_ sender: FeedTableViewCell)
    func didTapSpotSave(_ sender: FeedTableViewCell)
}

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var spotImageView: UIImageView!
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var spotNameLabel: UILabel!
    @IBOutlet weak var spotAddressLabel: UILabel!
    
    @IBOutlet weak var spotCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var numHoneyspotsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var commentsContainer: UIView!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var likeIcon: UIImageView!
    
    
    
    static let CELL_IDENTIFIER = "FeedTableViewCell"
    var delegate: FeedTableViewCellDelegate?
    var indexPath: IndexPath!
    
    var feedModel : FeedModel? {
        didSet {
            self.spotImageView.kf.setImage(with: URL(string: (self.feedModel?.spotSave.spot.photoUrl) ?? ""))
            self.avatarView.userModel = self.feedModel?.user
            self.usernameLabel.text = self.feedModel?.user.username ?? ""
            self.spotNameLabel.text = self.feedModel?.spotSave.spot.name
            self.spotAddressLabel.text = self.feedModel?.spotSave.spot.address
            self.spotCountLabel.isHidden = true
            
            self.commentCountLabel.text = self.feedModel?.spotSave.commentCount.description
           
            if(self.feedModel?.spotSave.likeCount ?? 0 > 0){
                self.likeCountLabel.isHidden = false
                self.likeCountLabel.text = self.feedModel?.spotSave.likeCount.description
            }else{
                self.likeCountLabel.isHidden = true
            }
            
            if(self.feedModel?.spotSave.commentCount ?? 0 > 0){
                self.commentCountLabel.isHidden = false
                self.commentCountLabel.text = self.feedModel?.spotSave.commentCount.description
            }else{
                self.commentCountLabel.isHidden = true
            }
            
            
            self.numHoneyspotsLabel.text = "0"
            self.descriptionLabel.text = ""
            if !(self.feedModel?.spotSave.description.isEmpty ?? true) {
                self.descriptionLabel.text = "\"" + (self.feedModel?.spotSave.description ?? "") + "\""
            }
            self.commentsLabel.text = ""
            self.commentsLabel.sizeToFit()
            self.commentsContainer.sizeToFit()
            self.sizeToFit()
        }
    }
    
//    var spotSave: SpotSave? {
//        didSet {
//            guard let spotSave = spotSave else {
//                return
//            }
//            
//            guard let _ = spotSave.spot.objectId else {
//                return
//            }
//            guard let _ = spotSave.user.objectId else {
//                return
//            }
//            let spot = spotSave.spot
//            let user = spotSave.user
//            
//            spotSave.getCommentTotalCount { (success: Bool, count: Int) in
//                self.commentCountLabel.isHidden = count <= 0
//                self.commentCountLabel.text = String(format: "%lu", UInt(count))
//            }
//            
//            spotSave.getLikeTotalCount { (success: Bool, count: Int) in
//                self.likeCountLabel.isHidden = (count <= 0)
//                self.likeCountLabel.text = String(format: "%lu", UInt(count))
//            }
//            
////            user.fetchIfNeededInBackground { (object: PFObject?, error: Error?) in
////                if let error = error {
////                    print("Failed to fetch user info from feed tableview cell \(error)")
////                    return
////                }
////                let user = object as! User
////                self.avatarView.user = user
////                self.usernameLabel.text = user.username
////            }
//            self.avatarView.user = user
//            self.usernameLabel.text = user.username
//            
//            self.descriptionLabel.text = ""
//            if !spotSave.desc.isEmpty {
//                self.descriptionLabel.text = "\"" + spotSave.desc + "\""
//            }
//            
//            if let currentUser = AppManager.sharedInstance.currentUser {
//                spotCountLabel.isHidden = currentUser.hasSpotSave(spotSave)
//            }
//            
//            spotNameLabel.text = spot.name
//            spotAddressLabel.text = spot.readableAddress
//            
//            spot.loadSavedByFriendsCountInBackground { (count: Int) in
//                self.numHoneyspotsLabel.text = String(format: "%lu", UInt(count))
//            }
//            
//            spot.photo.getDataInBackground { (data: Data?, error: Error?) in
//                guard let data = data else {
//                    self.spotImageView.image = nil
//                    return
//                }
//                let image = UIImage(data: data)
//                DispatchQueue.main.async {
//                    self.spotImageView.image = image
//                }
//            }
//            
//            // Comments
//            var arr: [SpotComment] = []
//            let commentsCount = spotSave.comments.count
//            if commentsCount > 0 {
//                arr += spotSave.comments[0...((commentsCount > 3) ? 2 : commentsCount - 1)]
//            }
//            
//            if arr.count == 0 {
//                self.commentsLabel.text = ""
//                self.commentsLabel.sizeToFit()
//                self.commentsContainer.sizeToFit()
//                self.sizeToFit()
//                return
//            }
//            
//            let attrs: NSMutableAttributedString = NSMutableAttributedString()
//            let boldFont: UIFont = UIFont(name: "Montserrat-Bold", size: 13)!
//            let regularFont: UIFont = UIFont(name: "Montserrat-Regular", size: 13)!
//            let color: UIColor = UIColor(white: 0.3, alpha: 1.0)
//            for (index, c) in zip(arr.indices, arr) {
//                do {
//                    try c.fetchIfNeeded()
//                    try c.author.fetchIfNeeded()
//                    
//                    let displayUserName = NSAttributedString(
//                        string: c.author.username! + " ",
//                        attributes: [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: color]
//                    )
//                    
//                    let comment = NSAttributedString(
//                        string: c.comment + (index == arr.count - 1 ? "\n" : "\n\n"),
//                        attributes: [NSAttributedString.Key.font: regularFont, NSAttributedString.Key.foregroundColor: color]
//                    )
//                    
//                    attrs.append(displayUserName)
//                    attrs.append(comment)
//                } catch {
//                    print(error)
//                }
//            }
//            
//            self.commentsLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
//            self.commentsLabel.numberOfLines = 0
//            self.commentsLabel.preferredMaxLayoutWidth = self.commentsLabel.bounds.size.width
//            
//            self.commentsLabel.attributedText = attrs
//            self.commentsLabel.sizeToFit()
//            self.commentsContainer.sizeToFit()
//            self.sizeToFit()
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        spotImageView.image = nil
        avatarView.imageView.image = nil
        usernameLabel.text = ""
        spotNameLabel.text = ""
        spotAddressLabel.text = ""
        spotCountLabel.text = ""
        commentCountLabel.text = ""
        likeCountLabel.text = ""
        numHoneyspotsLabel.text = ""
        descriptionLabel.text = ""
        commentsLabel.text = ""
    }

    @IBAction func spotButtonTapped(_ sender: Any) {
        delegate?.didTapSpotSave(self)
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        delegate?.didTapComment(self)
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        self.delegate?.didLikeSpot(sender : self , indexPath : self.indexPath)
    }
}
