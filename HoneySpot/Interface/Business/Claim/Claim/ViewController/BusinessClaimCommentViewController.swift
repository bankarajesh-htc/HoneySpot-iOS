//
//  BusinessClaimCommentViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 20.02.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit


class BusinessClaimCommentViewController: UIViewController {

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var commentTextView: UITextView!
	
	var spot : SpotModel!
	var isComingFromTabbar = true
	
    override func viewDidLoad() {
        super.viewDidLoad()
		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
		setupLabels()
    }
	
	func setupLabels(){
		titleLabel.text = "Restaurant Verification"
	}
	
	@IBAction func backTapped(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func continueTapped(_ sender: Any) {
		claim()
	}
	
	func claim(){
		if(commentTextView.text == ""){
			return
		}
		self.showLoadingHud()
		SpotDataSource().getSpot(googlePlaceId: self.spot.googlePlaceId) { (result) in
			switch(result){
			case .success(let str):
				print(str)
			case .failure(let err):
				print(err)
			}
			BusinessRestaurantDataSource().claimRestaurant(spotId: self.spot.googlePlaceId,comment : self.commentTextView.text ?? "") { (result) in
				self.hideAllHuds()
				switch(result){
				case .success(let str):
					print(str)
					if (self.navigationController!.viewControllers.count == 2) {
						self.dismiss(animated: true, completion: nil)
					}else{
						self.performSegue(withIdentifier: "start", sender: nil)
					}
				case .failure(let err):
					print(err)
					self.showErrorHud(message: err.errorMessage)
				}
			}
		}
	}

}
