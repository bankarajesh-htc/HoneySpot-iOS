//
//  CommentTableViewCell.swift
//  HoneySpot
//
//  Created by Max on 3/19/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit


let COMMENT_TABLEVIEWCELL_IDENTIFER = "CommentTableViewCell"

class CommentTableViewCell: UITableViewCell {

	@IBOutlet var userImage: UIImageView!
	@IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var commentLabel: UILabel!
	@IBOutlet var usernameLabel: UILabel!
	@IBOutlet var timeLabel: UILabel!
	@IBOutlet var seperatorView: UIView!
	
    var comment: CommentModel? {
        didSet {
            self.avatarView.userModel = self.comment!.user
			
			self.userImage.kf.setImage(with: URL(string: self.comment!.user.pictureUrl ?? ""), placeholder: UIImage(named: "AvatarPlaceHolder")!, options: nil, progressBlock: nil) {  result in
				// result is either a .success(RetrieveImageResult) or a .failure(KingfisherError)
				switch result {
				case .success(let value):
					print(value.image)
					print(value.cacheType)
					print(value.source)
				case .failure(let error):
					print(error) // The error happens
				}
			}
			
			self.userImage.layer.cornerRadius = 18
			self.userImage.clipsToBounds = true
			self.usernameLabel.text = self.comment?.user.username
			
			if(self.comment?.createdAt != nil){
				let diffComponents = Calendar.current.dateComponents([.day,.hour, .minute], from: (self.comment?.createdAt)!, to: Date())
				let hours = diffComponents.hour
				let minutes = diffComponents.minute
				let days = diffComponents.day
				if(days ?? 0 > 0){
					if(days == 1){
						self.timeLabel.text = days!.description + " day ago"
					}else{
						self.timeLabel.text = days!.description + " days ago"
					}
				}else if(hours ?? 0 > 0){
					if(hours == 1){
						self.timeLabel.text = hours!.description + " hour ago"
					}else{
						self.timeLabel.text = hours!.description + " hours ago"
					}
				}else if(minutes ?? 0 > 0){
					if(minutes == 1){
						self.timeLabel.text = minutes!.description + " minute ago"
					}else{
						self.timeLabel.text = minutes!.description + " minutes ago"
					}
				}else{
					self.timeLabel.text = "now"
				}
			}else{
				self.timeLabel.text = ""
			}
			
            self.commentLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            self.commentLabel.numberOfLines = 0
            self.commentLabel.preferredMaxLayoutWidth = self.commentLabel.bounds.size.width
			self.commentLabel.text = self.comment?.comment
            self.commentLabel.sizeToFit()
            self.sizeToFit()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
