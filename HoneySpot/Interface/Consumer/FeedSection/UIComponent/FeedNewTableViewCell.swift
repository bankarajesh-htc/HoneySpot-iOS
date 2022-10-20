//
//  FeedNewTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 17.04.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate: class {
    func singleTapDetected(in cell: FeedNewTableViewCell)
    func doubleTapDetected(in cell: FeedNewTableViewCell)
}

protocol FeedNewTableViewCellDelegate {
    func didLikeSpot(sender: FeedNewTableViewCell,indexPath :IndexPath)
    func didTapComment(_ sender: FeedNewTableViewCell,shouldKeyboardOpen : Bool)
    func didTapSpotSave(_ sender: FeedNewTableViewCell)
	func didTapShareSpot(text : String , image : UIImage)
	func didTapUser(sender: FeedNewTableViewCell,indexPath :IndexPath)
	func didTapMore(indexPath: IndexPath)
}

class FeedNewTableViewCell: UITableViewCell,MultiTappable {
    
    weak var multiTapDelegate: MultiTappableDelegate?
    lazy var tapCounter = ThreadSafeValue(value: 0)
    weak var celldelegate: TableViewCellDelegate?
    
    @IBOutlet var spotView: UIView!
    @IBOutlet var spotButton: UIButton!
	@IBOutlet var saveView: UIView!
	@IBOutlet var saveSaveLabel: UILabel!
	@IBOutlet var saveTickIcon: UIImageView!
	@IBOutlet var saveButton: UIButton!
	
	@IBOutlet var spotImage: UIImageView!
    
    @IBOutlet var likeIcon: UIImageView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
	@IBOutlet var timeLabel: UILabel!
	
    @IBOutlet var spotCount: UILabel!
    @IBOutlet var commentCount: UILabel!
    @IBOutlet var likeCount: UILabel!
    
    @IBOutlet var spotName: UILabel!
    @IBOutlet var spotLocation: UILabel!
    
    @IBOutlet var friendsStackView: UIStackView!
    @IBOutlet var spotDescription: UILabel!
    @IBOutlet var viewAllCommentsLabel: UILabel!
    
    @IBOutlet var friendsSavedThisHoneyspotLabel: UILabel!
    var messageText = ""
    
    static let CELL_IDENTIFIER = "FeedNewTableViewCell"
    var delegate: FeedNewTableViewCellDelegate!
    var indexPath: IndexPath!
	var isInMyHonespot = false
    var tapCount = 0
    
    var feedModel : FeedModel? {
        didSet {
            //saveView.isHidden = true
            self.spotImage.kf.setImage(with: URL(string: (self.feedModel?.spotSave.spot.photoUrl) ?? ""))
            self.spotImage.clipsToBounds = true
            self.spotImage.contentMode = .scaleAspectFill
            
            if self.feedModel?.user.pictureUrl == "" {
                self.userImage.image = UIImage(named: "AvatarPlaceHolder")
            }
            else
            {
                self.userImage.kf.setImage(with: URL(string: (self.feedModel?.user.pictureUrl) ?? ""))
            }
            
            self.userImage.contentMode = .scaleAspectFill
            self.userImage.layer.cornerRadius = 20
            self.userImage.layer.borderWidth = 1.0
            self.userImage.layer.borderColor = UIColor.white.cgColor
            
            self.userName.text = self.feedModel?.user.username ?? ""
            self.spotName.text = self.feedModel?.spotSave.spot.name
            self.spotName.adjustsFontSizeToFitWidth = true
            
            if feedModel!.didILike {
                self.likeIcon.image = UIImage(named: "feedLikeFilled")
            } else {
                self.likeIcon.image = UIImage(named: "feedLikeIcon")
            }
			
			self.saveView.layer.cornerRadius = 13
			if(UserDefaults.standard.string(forKey: "userId") == self.feedModel?.spotSave.user.id){
				isInMyHonespot = true
				configureSaveButton()
			}else{
                if AppDelegate.originalDelegate.isGuestLogin
                {
                    //self.timeLabel.isHidden = true
                }
                else
                {
                    self.timeLabel.isHidden = false
                    SpotDataSource().getSpotSaveOfMe(spotId: self.feedModel?.spotSave.spot.id ?? "") { (result) in
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
                            self.isInMyHonespot = false
                            self.configureSaveButton()
                        }
                    }
                }
				
			}
            
            let addresses = self.feedModel?.spotSave.spot.address.split(separator: ",")
            var addressStr = ""
            var addressCount = 0
            for a in addresses! {
				var newStr = a
				if(newStr.hasPrefix(" ")){
					newStr.removeFirst()
				}
                if(addressCount != 0 && (a.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil)){
                    addressStr = addressStr + newStr + ", "
                }
                addressCount += 1
            }
			
			if(addressCount > 2){
				//addressStr.removeLast()
				//addressStr.removeLast()
			}
            
            self.spotLocation.text = addressStr
            self.spotLocation.adjustsFontSizeToFitWidth = true
            
			var likeCountInt = Int(self.feedModel?.spotSave.likeCount.description ?? "0") ?? 0
			if(likeCountInt < 0){
				self.likeCount.text = "0"
			}else{
                if ((feedModel!.didILike) && (self.feedModel?.spotSave.likeCount == 0)) {
                    likeCountInt = 1
                }
				self.likeCount.text = likeCountInt.description
			}
			
			self.commentCount.text = self.feedModel?.spotSave.commentCount.description
			
			if(self.feedModel?.spotSave.createdAt != nil){
				let diffComponents = Calendar.current.dateComponents([.day,.hour, .minute], from: (self.feedModel?.spotSave.createdAt)!, to: Date())
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
            }else if let dateString = feedModel?.spotSave.spot.wishListCreateDate, !dateString.isEmpty {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                if let date = formatter.date(from: dateString) {
                    let diffComponents = Calendar.current.dateComponents([.day], from: date, to: Date())
                    
                    let days = diffComponents.day
                    if(days ?? 0 > 0) {
                        if(days == 1){
                            self.timeLabel.text = days!.description + " day ago"
                        }else{
                            self.timeLabel.text = days!.description + " days ago"
                        }
                    } else {
                        self.timeLabel.text = "Today"
                    }
                } else {
                    self.timeLabel.text = ""
                }
            } else {
				self.timeLabel.text = "5 days ago"
			}
			
            
            if !(self.feedModel?.spotSave.description.isEmpty ?? true) {
                self.spotDescription.text =  (self.feedModel?.user.username  ?? "") + " " + (self.feedModel?.spotSave.description ?? "")
                let userNameCharacterCount = ((self.feedModel?.user.username ?? "") as NSString).length
                let attText = NSMutableAttributedString(string: self.spotDescription.text!)
				attText.setAttributes([NSAttributedString.Key.font:UIFont(name: "Avenir-Heavy", size: 14.0)!,NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x2A2A2A)], range: NSRange(location: 0, length: userNameCharacterCount))
                attText.setAttributes([NSAttributedString.Key.font:UIFont(name: "Avenir-Medium", size: 14.0)!,NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x7F7F7F)], range: NSRange(location: userNameCharacterCount, length: (self.spotDescription.text! as NSString).length - userNameCharacterCount))
                self.spotDescription.text = ""
                self.spotDescription.attributedText = attText
            }else{
                self.spotDescription.text = ""
            }
			
            messageText = "I Honeyspotted a restaurant in Honeyspot App!. You can see it from -> https://honeyspotapp.app.link/spot?$custom_data=\(self.feedModel!.spotSave.id)"
            //print(text)
            self.spotCount.isHidden = false
            self.spotCount.text = "0"
            
            configureComments()
           
            
            self.sizeToFit()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initMultiTap()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            print("touchesBegan")
        }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            print("touchesEnded")
            let aTouch = touches.first
            tapCount = aTouch!.tapCount
            print(tapCount)
            print("Double Tap")
            
            super.touchesEnded(touches, with: event)
    }
    
    private func addSingleAndDoubleTapGesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(singleTapGesture)

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(doubleTapGesture)

        singleTapGesture.require(toFail: doubleTapGesture)
    }
    @objc private func handleSingleTap(_ tapGesture: UITapGestureRecognizer) {
        print("Single Tap")
        tapCount = 1

    }

    @objc private func handleDoubleTap(_ tapGesture: UITapGestureRecognizer) {
        print("Double Tap")
        tapCount = 2
        self.delegate.didLikeSpot(sender : self , indexPath : self.indexPath)

    }
     
    @objc func doubleTapped() {
        // do something here
        self.delegate.didLikeSpot(sender : self , indexPath : self.indexPath)
        
        
    }
	func configureSaveButton(){
        if AppDelegate.originalDelegate.isWishlist
        {
            saveView.isHidden = false
        }
        else
        {
            if(isInMyHonespot){
                saveView.isHidden = false
                saveTickIcon.isHidden = false
                saveSaveLabel.text = "   "
                saveButton.isUserInteractionEnabled = false
            }else{
                saveView.isHidden = false
                saveTickIcon.isHidden = true
                saveSaveLabel.text = "Save"
                saveButton.isUserInteractionEnabled = true
            }
        }
        
        
		
	}
    
    func configureFriends(){
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        self.friendsStackView.addArrangedSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        FeedDataSource().getSpotFriends(spotId: self.feedModel?.spotSave.spot.id ?? "") { (result) in
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
                    let hAnchor = imgV.heightAnchor.constraint(equalToConstant: 16)
                    hAnchor.isActive = true
                    let wAnchor = imgV.widthAnchor.constraint(equalToConstant: 16)
                    wAnchor.isActive = true
                    imgV.kf.setImage(with: URL(string: user.pictureUrl ?? ""))
                    imgV.layer.cornerRadius = 8
                    imgV.layer.borderWidth = 1
                    imgV.layer.borderColor = UIColor.white.cgColor
                    imgV.clipsToBounds = true
                    imgV.contentMode = .scaleAspectFill
                    self.friendsStackView.addArrangedSubview(imgV)
                }
                
                var vCount = 0
                for v in self.friendsStackView.arrangedSubviews {
                    if(vCount == 3){
                        let orangeView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
                        orangeView.backgroundColor = .ORANGE_COLOR
                        orangeView.alpha = 0.8
                        orangeView.layer.cornerRadius = 8
                        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
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
                    vCount += 1
                }
                
                if(users.count > 1){
                    self.friendsSavedThisHoneyspotLabel.text = "Friends saved this honeyspot"
                }else{
                    self.friendsSavedThisHoneyspotLabel.text = "Friend saved this honeyspot"
                }
                
                self.friendsStackView.setNeedsLayout()
                self.friendsStackView.layoutIfNeeded()
                
            case .failure(let err):
                print(err.errorMessage)
            }
        }
    }
    
    func configureComments(){
        if(self.feedModel?.spotSave.commentCount ?? 0 > 2){
			self.viewAllCommentsLabel.text = "View all " + (self.feedModel?.spotSave.commentCount.description)! + " comments"
        }else{
            self.viewAllCommentsLabel.text = "Add a comment"
        }
    }
    

    @IBAction func likeTapped(_ sender: Any) {
        self.delegate.didLikeSpot(sender : self , indexPath : self.indexPath)
    }
    
    @IBAction func commentTapped(_ sender: Any) {
		self.delegate.didTapComment(self, shouldKeyboardOpen: false)
    }
    
	@IBAction func viewAllCommentsTapped(_ sender: Any) {
		self.delegate.didTapComment(self, shouldKeyboardOpen: true)
	}
	
	@IBAction func moreTapped(_ sender: Any) {
		self.delegate.didTapMore(indexPath : self.indexPath)
	}
	
	@IBAction func saveTapped(_ sender: Any) {
        self.delegate.didTapSpotSave(self)
    }
    
	@IBAction func shareTapped(_ sender: Any) {
        
		let image = self.spotImage.image
		self.delegate.didTapShareSpot(text: messageText, image: image!)
		FeedDataSource().postAnalyticsData(spotId: (self.feedModel?.spotSave.spot.id ?? ""), eventName: "share")
	}
	
	@IBAction func userTapped(_ sender: Any) {
		self.delegate.didTapUser(sender : self , indexPath : self.indexPath)
	}
	
    override func prepareForReuse() {
        super.prepareForReuse()
        userImage.image = nil
        spotImage.image = nil
        userName.text = ""
        spotCount.text = ""
        commentCount.text = ""
        likeCount.text = ""
        spotName.text = ""
        spotLocation.text = ""
        spotDescription.text = ""
//        for v in friendsStackView.arrangedSubviews {
//            v.removeFromSuperview()
//        }
		saveTickIcon.isHidden = true
		saveSaveLabel.text = "Save"
		
    }
    
}

extension FeedNewTableViewCell: MultiTappableDelegate {
    func singleTapDetected(in view: MultiTappable) { self.celldelegate?.singleTapDetected(in: self) }
    func doubleTapDetected(in view: MultiTappable) { self.celldelegate?.doubleTapDetected(in: self) }
}

protocol MultiTappableDelegate: class {
    func singleTapDetected(in view: MultiTappable)
    func doubleTapDetected(in view: MultiTappable)
}

class ThreadSafeValue<T> {
    private var _value: T
    private lazy var semaphore = DispatchSemaphore(value: 1)
    init(value: T) { _value = value }
    var value: T {
        get {
            semaphore.signal(); defer { semaphore.wait() }
            return _value
        }
        set(value) {
            semaphore.signal(); defer { semaphore.wait() }
            _value = value
        }
    }
}

protocol MultiTappable: UIView {
    var multiTapDelegate: MultiTappableDelegate? { get set }
    var tapCounter: ThreadSafeValue<Int> { get set }
}

extension MultiTappable {
    func initMultiTap() {
        if let delegate = self as? MultiTappableDelegate { multiTapDelegate = delegate }
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.multitapActionHandler))
        addGestureRecognizer(tap)
    }

    func multitapAction() {
        if tapCounter.value == 0 {
            DispatchQueue.global(qos: .utility).async {
                usleep(250_000)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if self.tapCounter.value > 1 {
                        self.multiTapDelegate?.doubleTapDetected(in: self)
                    } else {
                        self.multiTapDelegate?.singleTapDetected(in: self)
                    }
                    self.tapCounter.value = 0
                }
            }
        }
        tapCounter.value += 1
    }
}

private extension UIView {
    @objc func multitapActionHandler() {
        if let tappable = self as? MultiTappable { tappable.multitapAction() }
    }
}
