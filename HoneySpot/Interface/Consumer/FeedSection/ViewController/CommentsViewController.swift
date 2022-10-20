//
//  CommentsViewController.swift
//  HoneySpot
//
//  Created by Max on 3/19/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import InputBarAccessoryView
import OneSignal
 

class CommentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var comments : [CommentModel] = []
    var spotSaveModel : SpotSaveModel!
    let inputBar: InputBarAccessoryView = InputBarAccessoryView()
    private var keyboardManager = KeyboardManager()
    var feedModel : FeedModel!
	var shouldKeyboardOpen = false
	
    override func viewDidLoad() {
       super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        // Do any additional setup after loading the view.
        tableView.keyboardDismissMode = .interactive
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
        
        inputBar.delegate = self
        inputBar.inputTextView.keyboardType = .twitter
		inputBar.inputTextView.font = UIFont(name: "Avenir-Medium", size: 16.0)
        inputBar.inputTextView.placeholder = "Add a comment..."
		inputBar.inputTextView.layer.borderWidth = 1.0
		inputBar.inputTextView.layer.borderColor = UIColor(rgb: 0xE4E4E4).cgColor
		inputBar.inputTextView.layer.cornerRadius = 18
		inputBar.inputTextView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
		//inputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
		
		
		inputBar.sendButton.layer.cornerRadius = 18
		inputBar.sendButton.backgroundColor = UIColor.ORANGE_COLOR
		inputBar.sendButton.setTitle("Post", for: .normal)
		inputBar.sendButton.titleLabel!.font =  UIFont(name: "Avenir-Black", size: 16.0)
		inputBar.sendButton.titleLabel!.textColor = UIColor.white
		inputBar.sendButton.setTitleColor(UIColor.white, for: .normal)
		inputBar.sendButton.setTitleShadowColor(nil, for: .normal)
		inputBar.sendButton.setTitleColor(UIColor.white, for: .selected)
		inputBar.sendButton.setTitleShadowColor(nil, for: .selected)
		inputBar.sendButton.setTitleColor(UIColor.white, for: .disabled)
		inputBar.sendButton.setTitleShadowColor(nil, for: .disabled)
		inputBar.sendButton.isEnabled = true
		inputBar.layer.borderWidth = 0.0
		
		inputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 4.0, bottom: 0.0, right: 4.0)
		
        view.addSubview(inputBar)
//        // Binding the inputBar will set the needed callback actions to position the inputBar on top of the keyboard
        keyboardManager.bind(inputAccessoryView: inputBar)
//        // Binding to the tableView will enabled interactive dismissal
        keyboardManager.bind(to: tableView)
//        // Add some extra handling to manage content inset
        keyboardManager.on(event: .didChangeFrame) { [weak self] (notification) in
            let barHeight = self?.inputBar.bounds.height ?? 0
            self?.tableView.contentInset.bottom = barHeight + notification.endFrame.height
            self?.tableView.scrollIndicatorInsets.bottom = barHeight + notification.endFrame.height
            }.on(event: .didHide) { [weak self] _ in
                let barHeight = self?.inputBar.bounds.height ?? 0
                self?.tableView.contentInset.bottom = barHeight
                self?.tableView.scrollIndicatorInsets.bottom = barHeight
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadSpotComments()
        
        if(spotSaveModel != nil){
            if spotSaveModel!.id == "" {
                return
            }
            self.showLoadingHud()
            CommentDataSource().getSpotSaveComments(spotId: spotSaveModel!.spot.id) { (result) in
                self.hideAllHuds()
                switch(result){
                case .success(let comments):
                    self.comments = comments
                    self.reloadSpotComments()
                case .failure(let err):
                    print(err.errorMessage)
                }
            }
        }
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if(shouldKeyboardOpen){
			self.inputBar.inputTextView.becomeFirstResponder()
		}
	}
    
    func reloadSpotComments() {
        self.tableView.reloadData()
    }

    @IBAction func onBackButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CommentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if(feedModel != nil){
			return self.comments.count + 1
		}else{
			return self.comments.count
		}
    }
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if(self.feedModel != nil){
			if(indexPath.row == 0){
				let cell: CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: COMMENT_TABLEVIEWCELL_IDENTIFER, for: indexPath) as! CommentTableViewCell
				cell.comment = CommentModel(id : "11",createdAt : Date(),comment : self.feedModel.spotSave.description,user : self.feedModel.spotSave.user )
				return cell
			}else{
				let cell: CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: COMMENT_TABLEVIEWCELL_IDENTIFER, for: indexPath) as! CommentTableViewCell
				cell.comment = self.comments[indexPath.row - 1]
				return cell
			}
		}else{
			let cell: CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: COMMENT_TABLEVIEWCELL_IDENTIFER, for: indexPath) as! CommentTableViewCell
			cell.comment = self.comments[indexPath.row]
			return cell
		}
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        let comment = spotSave?.comments[indexPath.row]
//        if comment?.author.objectId == AppManager.sharedInstance.currentUser?.objectId || comment?.author.objectId == spotSave?.user.objectId {
//            return .delete
//        }
        return .none
    }
}

extension CommentsViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        // Here we can parse for which substrings were autocompleted
        if text == "" {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Enter some comments")
            return
        }
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (attributes, range, stop) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        
        if self.spotSaveModel != nil
        {
            CommentDataSource().postComment(spotId : self.spotSaveModel!.spot.id,saveId: self.spotSaveModel!.id, comment: text) { (result) in
                switch(result){
                case .success(_):
                    FeedDataSource().postAnalyticsData(spotId: self.spotSaveModel.spot.id, eventName: "comment")
                    if(self.feedModel != nil){
                        self.feedModel.spotSave.commentCount += 1
                    }
                    print("Successfully commentted")
                    UserDefaults.standard.set(text, forKey: self.spotSaveModel!.id)
                    self.viewWillAppear(true)
                case .failure(let error):
                    print(error)
                    print("Error comment")
                }
            }
            
            inputBar.sendButton.stopAnimating()
            inputBar.inputTextView.placeholder = "Your comments here..."
            }
            
    }
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        // Adjust content insets
        print(size)
        tableView.contentInset.bottom = size.height
    }
}
