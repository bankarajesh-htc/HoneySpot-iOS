//
//  BusinessVerificationViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 18.02.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class BusinessVerificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
    }

	@IBAction func checkVerification(_ sender: Any) {
		showLoadingHud()
		BusinessRestaurantDataSource().getClaims { (result) in
			self.hideAllHuds()
			switch(result){
			case .success(let claims):
				if(claims.count > 0){
					var isVerified = false
					for c in claims{
						if(c.isVerified){
							
						}
                        isVerified = true
					}
					
					if(isVerified){
						self.performSegue(withIdentifier: "businessMain", sender: nil)
					}else{
						self.showErrorHud(message: "Your verification is still under review.")
					}
					
				}else{
					self.showErrorHud(message: "Your verification is still under review.")
				}
			case .failure(let err):
				print(err.localizedDescription)
				self.showErrorHud(message: "Your verification is still under review.")
			}
		}
	}
	
}
