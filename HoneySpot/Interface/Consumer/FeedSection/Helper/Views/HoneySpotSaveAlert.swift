//
//  HoneySpotSaveAlert.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 30.12.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import Foundation
import UIKit

class HoneySpotSaveAlert : UIView {
	
	static var instance = HoneySpotSaveAlert()
	
    
    @IBOutlet var honeySpotSave: UILabel!
	@IBOutlet var backBlackView: UIView!
	@IBOutlet var parentView: UIView!
	@IBOutlet var alertView: UIView!
	
	var actionCompletion:((AlertActionType)->())?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		Bundle.main.loadNibNamed("HoneySpotSaveAlert", owner: self, options: nil)
		commonInit()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func commonInit(){
		alertView.clipsToBounds = true
		parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
		parentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
	}
	
    func showAlert(honeySpotString:String,actionButtonCompletion : ((AlertActionType)->())?) {
        honeySpotSave.text = honeySpotString
		self.actionCompletion = actionButtonCompletion
		
		UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(parentView)
	}
	
	@IBAction func actionTapped(_ sender: Any) {
		DispatchQueue.main.async {
			self.parentView.removeFromSuperview()
			self.actionCompletion!(AlertActionType.actionTapped)
		}
	}
	
	@IBAction func dismissTapped(_ sender: Any) {
		DispatchQueue.main.async {
			self.parentView.removeFromSuperview()
			self.actionCompletion!(.dismissTapped)
		}
	}
	
	@IBAction func closeTapped(_ sender: Any) {
		DispatchQueue.main.async {
			self.parentView.removeFromSuperview()
		}
	}
	
	
}

enum AlertActionType {
	case actionTapped , dismissTapped
}
