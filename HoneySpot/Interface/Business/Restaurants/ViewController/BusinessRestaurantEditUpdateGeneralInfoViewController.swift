//
//  BusinessRestaurantEditUpdateGeneralInfoViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 28.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class BusinessRestaurantEditUpdateGeneralInfoViewController: UIViewController {

	@IBOutlet var descriptionTextField: UITextView!
	@IBOutlet var restaurantTextfield: UITextField!
	
	var spotModel :SpotModel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
    }
	
	func setupViews(){
		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
		
		restaurantTextfield.text = spotModel.name
		descriptionTextField.text = spotModel.spotDescription
	}
    
	@IBAction func closeTapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func updateTapped(_ sender: Any) {
		showLoadingHud()
		spotModel.name = restaurantTextfield.text ?? ""
		spotModel.spotDescription = descriptionTextField.text ?? ""
		BusinessRestaurantDataSource().saveSpot(spotModel: spotModel) { (result) in
			self.hideAllHuds()
			switch(result){
			case .success(let str):
				print(str)
				NotificationCenter.default.post(name: NSNotification.Name.init("dataChanged"), object: nil)
				self.dismiss(animated: true, completion: nil)
			case .failure(let err):
				print(err.localizedDescription)
				self.showErrorHud(message: err.localizedDescription)
			}
		}
	}
	
}
