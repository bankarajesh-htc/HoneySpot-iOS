//
//  HoneyspotMoreViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 12.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class HoneyspotMoreViewController: UIViewController {

	@IBOutlet var backView: UIView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
    }
	
	static func instantiate() -> HoneyspotMoreViewController {
		return UIStoryboard(name: "HoneyspotMore", bundle: nil).instantiateViewController(withIdentifier: "HoneyspotMore") as! HoneyspotMoreViewController
	}
	
	func setupViews(){
		backView.layer.applySketchShadow(color: UIColor(rgb: 0x706868), alpha: 0.5, x: 0, y: 2, blur: 9, spread: 0)
	}
    
	@IBAction func saveTapped(_ sender: Any) {
	}
	
	@IBAction func likeTapped(_ sender: Any) {
	}
	
	@IBAction func shareTapped(_ sender: Any) {
	}
	
	@IBAction func commentTapped(_ sender: Any) {
	}
	
	@IBAction func unfollowTapped(_ sender: Any) {
	}
	
}
