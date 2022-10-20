//
//  ConsumerDetailImageTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 16/11/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class ConsumerDetailImageTableViewCell: UITableViewCell {

    @IBOutlet var img: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var imagesCollectionView: UICollectionView!
    @IBOutlet var shareCount: UILabel!
    @IBOutlet var commentCount: UILabel!
    @IBOutlet var likeCount: UILabel!
    @IBOutlet var friendsLabel: UILabel!
    @IBOutlet var friendsStackView: UIStackView!
    @IBOutlet var likeIcon: UIImageView!
    @IBOutlet var commentIcon: UIImageView!
    @IBOutlet var shareIcon: UIImageView!
    @IBOutlet var saveView: UIView!
    @IBOutlet var saveLabel: UILabel!
    @IBOutlet var savedTickIcon: UIImageView!
    @IBOutlet var saveIcon: UIImageView!
    @IBOutlet var savedIcon: UIImageView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet weak var friendsView: UIView!
    @IBOutlet weak var topView: UIView!
    var isInMyHonespot = false
    
    var delegate: FeedImageCellDelegate!
    var feedModel: FeedModel!
    var spotSaveModel : SpotSaveModel!
    var isAdmin = false
    var imagesCount = 0
    var galleryImages = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func prepareCell(spotSavemodel:SpotSaveModel){
        self.spotSaveModel = spotSavemodel
        img.kf.setImage(with: URL(string: spotSavemodel.spot.photoUrl))
        name.text = spotSavemodel.spot.name
        
        imagesCount = 0
        
        if isAdmin {
            
        }
        else
        {
            var likeCountInt = 0
            if self.spotSaveModel != nil
            {
                if (self.spotSaveModel.likeCount == 0) || self.spotSaveModel.likeCount < 0 {
                    likeCountInt = 0
                }
                else
                {
                    likeCountInt = self.spotSaveModel.likeCount
                }
                let commentCount = self.spotSaveModel.commentCount
                self.commentCount.text = "\(commentCount)"
            }
            
            self.likeCount.text = "\(likeCountInt)"
            if(spotSaveModel != nil){
                if likeCountInt > 0 {
                    if spotSaveModel.spot.didILike {
                        self.likeIcon.image = UIImage(named: "feedLikeFilled")
                    } else {
                        self.likeIcon.image = UIImage(named: "feedLikeIcon")
                    }
                }
                else
                {
                    if spotSaveModel.spot.didILike {
                        self.likeIcon.image = UIImage(named: "feedLikeFilled")
                    } else {
                        self.likeIcon.image = UIImage(named: "feedLikeIcon")
                    }
                }
                
            }
            
            
            
            //spotSavemodel.commentCount.description
            self.shareCount.text = "0"
            
            self.getData()
            self.updateCommunityView(withSpot: spotSaveModel)
            
            if AppDelegate.originalDelegate.isGuestLogin
            {
                if(feedModel != nil){
                    img.kf.setImage(with: URL(string: feedModel.spotSave.spot.photoUrl))
                    name.text = feedModel.spotSave.spot.name
                }
                
            }
        }
        
        let totalCount = self.spotSaveModel.spot.customerPictures.count + self.spotSaveModel.spot.foodPictures.count
        if totalCount > 0 {
            self.imagesCollectionView.isHidden = false
            self.imagesCollectionView.reloadData()
        }
        else
        {
            self.imagesCollectionView.isHidden = true
        }
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapFunc))
        doubleTap.numberOfTapsRequired = 2
        topView.addGestureRecognizer(doubleTap)
        
        
        
    }
    @objc func doubleTapFunc()
    {
        self.delegate.didLikeSpot(sender : self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func getData()  {
        
        SpotDataSource().getSpotSaveOfMe(spotId: self.spotSaveModel.spot.id ) { (result) in
            switch(result){
            case .success(let saves):
                if(saves.count > 0 ){
                    self.isInMyHonespot = true
                    self.configureSaveButton()
                }else{
                    self.isInMyHonespot = false
                    self.configureSaveButton()
                }
            case .failure(let err):
                print(err.localizedDescription)
                self.isInMyHonespot = false
                self.configureSaveButton()
            }
        }
        
    }
    @IBAction func didClickBack(_ sender: Any) {
        self.delegate.didClickBack()
        
    }
    
    @IBAction func likeTapped(_ sender: Any) {
        self.delegate.didLikeSpot(sender : self)
    }
    
    @IBAction func commentTapped(_ sender: Any) {
        self.delegate.didTapComment(self, shouldKeyboardOpen: true)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        self.delegate.didSaveSpot(isInMySavedSpot: isInMyHonespot, spotSaveModel: self.spotSaveModel)
        
    }
    @IBAction func shareTapped(_ sender: Any) {
        let text = "I Honeyspotted a restaurant in Honeyspot App!. You can see it from -> https://honeyspotapp.app.link/spot?$custom_data=\(self.spotSaveModel.id)"
        let image = self.img.image
        self.delegate.didTapShareSpot(text: text, image: image!)

    }
    func configureSaveButton(){
        if(isInMyHonespot){
            saveButton.isUserInteractionEnabled = false
            savedTickIcon.isHidden = false
            saveIcon.isHidden = true
        }else{
            savedTickIcon.isHidden = true
            saveIcon.isHidden = false
            saveButton.isUserInteractionEnabled = true
            
        }
    }
    func updateCommunityView(withSpot spotSaveModel: SpotSaveModel?) {
        
        FeedDataSource().getSpotFriends(spotId: self.spotSaveModel.spot.id) { (result) in
            switch(result){
            case .success(let users):
                for v in self.friendsStackView.arrangedSubviews {
                    v.removeFromSuperview()
                }
                
                self.friendsStackView.distribution = .equalCentering
                self.friendsStackView.translatesAutoresizingMaskIntoConstraints = false
                self.friendsStackView.spacing = -10
                
                for user in users {
                    let imgV = UIImageView()
                    let hAnchor = imgV.heightAnchor.constraint(equalToConstant: 20.0)
                    hAnchor.isActive = true
                    let wAnchor = imgV.widthAnchor.constraint(equalToConstant: 20.0)
                    wAnchor.isActive = true
                    if user.pictureUrl == "" {
                        imgV.image = UIImage(named: "AvatarPlaceHolder")
                    }
                    else
                    {
                        imgV.kf.setImage(with: URL(string: user.pictureUrl ?? ""))
                    }
                    
                    imgV.layer.cornerRadius = 10
                    imgV.layer.borderWidth = 1
                    imgV.layer.borderColor = UIColor.white.cgColor
                    imgV.clipsToBounds = true
                    imgV.contentMode = .scaleAspectFill
                    self.friendsStackView.addArrangedSubview(imgV)
                }
                
                var vCount = 0
                for v in self.friendsStackView.arrangedSubviews {
                    if(vCount == 3){
                        let orangeView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                        orangeView.backgroundColor = .ORANGE_COLOR
                        orangeView.alpha = 0.8
                        orangeView.layer.cornerRadius = 10
                        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                        if(users.count > 4){
                            label.text = "+4"
                        }else{
                            label.text = "4"
                        }
                        label.textAlignment = .center
                        label.textColor = UIColor.white
                        label.font = UIFont(name: "Avenir-Heavy", size: 11.0)!
                        v.addSubview(orangeView)
                        v.addSubview(label)
                    }else if(vCount > 4){
                        v.removeFromSuperview()
                    }
                    else
                    {
                        vCount += 1
                    }
                    
                }
                if(users.count > 1){
                    self.friendsLabel.isHidden = false
                    if(users.count > 1 && users.count <= 4){
                        self.friendsLabel.text = " Friends saved this honeyspot"
                    }
                    else
                    {
                        self.friendsLabel.text = "Friends saved this honeyspot"
                    }
                    self.friendsView.isHidden = false
                }else if(users.count == 1){
                    self.friendsLabel.isHidden = false
                    self.friendsLabel.text = "Friend saved this honeyspot"
                    self.friendsView.isHidden = false
                }
                else
                {
                    self.friendsView.isHidden = true
                }
                
                self.friendsStackView.setNeedsLayout()
                self.friendsStackView.layoutIfNeeded()
            case .failure(let err):
                print(err.errorMessage)
                
            }
        }
        
    }

}

extension ConsumerDetailImageTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(spotSaveModel != nil){
            let totalCount = self.spotSaveModel.spot.customerPictures.count + self.spotSaveModel.spot.foodPictures.count
            if totalCount == 0 {
                return 0
            }
            return totalCount
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedDetailImageCellId", for: indexPath) as! FeedDetailImageCollectionViewCell
        let imageData = self.spotSaveModel.spot.customerPictures + self.spotSaveModel.spot.foodPictures
        if imageData.count > 0 {
            if imageData[indexPath.row] == "" {
                cell.feedDetailImageView.image = UIImage(named: "ImagePlaceholder")
            }
            else if imageData[indexPath.row].contains("https") {
                cell.feedDetailImageView.kf.setImage(with: URL(string: imageData[indexPath.row]))
            }
            else
            {
            }
        }
        else
        {
            cell.feedDetailImageView.image = UIImage(named: "ImagePlaceholder")
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 95.0, height: 95.0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Index..\(indexPath.row)")
        let imageData = self.spotSaveModel.spot.customerPictures + self.spotSaveModel.spot.foodPictures
        let imageURL = imageData[indexPath.row]
        ImageView.instance.showAlert(imageString: imageURL) { (aa) in
            if(aa == .actionTapped){
                
            }
        }
        
        
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//            return 2
//        }
    
}
