//
//  ConsumerDetailCommentsTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 18/11/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class ConsumerDetailCommentsTableViewCell: UITableViewCell {

    @IBOutlet var commentsTableView: UITableView!
    @IBOutlet var viewAllButton: UIButton!
    var delegate: CommentCellDelegate!
    var feedModel:FeedModel!
    var spotSaveModel : SpotSaveModel!
    var comments : [CommentModel] = []
    var days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var commentCount = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func prepareCell(spotSavemodel:SpotSaveModel){
        
        if spotSavemodel.spot.id == ""
        {
            print("No Spot Id")
        }
        else if !AppDelegate.originalDelegate.isGuestLogin
        {
            spotSaveModel = spotSavemodel
            getComments()
        }
        
        
    }
    
    @IBAction func addCommentTapped(_ sender: Any) {
        self.delegate.didAddComment(self, shouldKeyboardOpen: true)
    }
    @IBAction func viewAllCommentTapped(_ sender: Any) {
        self.delegate.didViewAllComment(self, shouldKeyboardOpen: false)
    }
    
    func getComments() {
        CommentDataSource().getSpotSaveComments(spotId: spotSaveModel!.spot.id) { (result) in
            switch(result){
            case .success(let comments):
                self.comments = comments
                let commentCount = comments.count
                self.commentCount = commentCount
                if commentCount > 0 {
                    DispatchQueue.main.async {
                        if(commentCount >= 2){
                            self.viewAllButton.isHidden = false
                            self.commentCount = 2
                        }else{
                            self.viewAllButton.isHidden = true
                            self.commentCount = commentCount
                        }
                        self.commentsTableView.reloadData()
                    }
                }else{
                    
                    self.viewAllButton.isHidden = true
                    self.commentCount = 0
                }
            case .failure(let err):
                print(err.errorMessage)
            }
        }
    }

}
extension ConsumerDetailCommentsTableViewCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.comments.count > 0 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell: CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: COMMENT_TABLEVIEWCELL_IDENTIFER, for: indexPath) as! CommentTableViewCell
//        cell.comment = self.comments[indexPath.row]
//        return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "consumerCommentsCellId") as! ConsumerCommentsTableViewCell
        let commentData = self.comments[indexPath.row]
        let user = spotSaveModel.user
        
        if commentData.user.pictureUrl == "" {
            cell.userImage.image = UIImage(named: "AvatarPlaceHolder")
        }
        else
        {
            cell.userImage.kf.setImage(with: URL(string: commentData.user.pictureUrl ?? ""))
        }
        
        
        cell.usernameLabel.text = commentData.user.username
        cell.commentLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.commentLabel.numberOfLines = 0
        cell.commentLabel.text = commentData.comment
        cell.commentLabel.sizeToFit()
        //cell.commentLabel.text = spotSaveModel.description
        
        if(spotSaveModel.createdAt != nil){
            let diffComponents = Calendar.current.dateComponents([.day,.hour, .minute], from: (spotSaveModel.createdAt)!, to: Date())
            let hours = diffComponents.hour
            let minutes = diffComponents.minute
            let days = diffComponents.day
            if(days ?? 0 > 0){
                if(days == 1){
                    cell.timeLabel.text = days!.description + " day ago"
                }else{
                    cell.timeLabel.text = days!.description + " days ago"
                }
            }else if(hours ?? 0 > 0){
                if(hours == 1){
                    cell.timeLabel.text = hours!.description + " hour ago"
                }else{
                    cell.timeLabel.text = hours!.description + " hours ago"
                }
            }else if(minutes ?? 0 > 0){
                if(minutes == 1){
                    cell.timeLabel.text = minutes!.description + " minute ago"
                }else{
                    cell.timeLabel.text = minutes!.description + " minutes ago"
                }
            }else{
                cell.timeLabel.text = "now"
            }
        }else{
            cell.timeLabel.text = ""
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    
}
