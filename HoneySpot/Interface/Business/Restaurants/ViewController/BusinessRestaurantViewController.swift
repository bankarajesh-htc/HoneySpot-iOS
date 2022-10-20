//
//  BusinessRestaurantViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 30.06.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit


enum THEME_STYLE: Int {
	case STYLE1 = 0
	case STYLE2 = 1
	case STYLE3 = 2
}

class BusinessRestaurantViewController: UIViewController {

	@IBOutlet var restaurantsTableView: UITableView!
	
	var claims = [ClaimModel]()
	var selectedSpotModel : SpotModel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		getData()
	}
	
	func getData(){
		showLoadingHud()
		BusinessRestaurantDataSource().getClaims { (result) in
			self.hideAllHuds()
			switch(result){
			case .success(let claims):
				self.claims = claims
				self.restaurantsTableView.reloadData()
			case .failure(let err):
				print(err.errorMessage)
			}
		}
	}

	
	
	func setupViews(){
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
		
		self.navigationItem.titleView = navTitleLabel(withStyle: .STYLE2)
		self.navigationController?.navigationBar.prefersLargeTitles = false
		
        let shareButton = UIButton(type: UIButton.ButtonType.custom)
		shareButton.tintColor = .black
		shareButton.setTitleColor(.black, for: .normal)
		shareButton.setTitle("Claim", for: .normal)
		shareButton.addTarget(self, action:#selector(claimTapped), for: .touchUpInside)
        shareButton.frame = CGRect(x: 0, y: 0, width: 50, height: 500)
        let shareBarButton = UIBarButtonItem(customView: shareButton)
		shareBarButton.tintColor = .black
        self.navigationItem.rightBarButtonItems = [shareBarButton]
	}
	
	func navTitleLabel(withStyle style: THEME_STYLE) -> UILabel {
		let navLabel = UILabel()
		var navTitle: NSMutableAttributedString = NSMutableAttributedString(string: "HoneySpot")
		switch style {
		case .STYLE1, .STYLE2:
			navTitle = NSMutableAttributedString(string: "Honey", attributes:[
				NSAttributedString.Key.font: UIFont.fontMonsterratBold(withSize: 24),
				NSAttributedString.Key.foregroundColor: UIColor.ORANGE_COLOR])
			navTitle.append(NSMutableAttributedString(string: "Spot", attributes:[
				NSAttributedString.Key.font: UIFont.fontMonsterratBold(withSize: 24),
				NSAttributedString.Key.foregroundColor: UIColor.YELLOW_COLOR]))
			navigationController?.navigationBar.barTintColor = .WHITE_COLOR
			break
		case .STYLE3:
			navTitle = NSMutableAttributedString(string: "HoneySpot", attributes:[
				NSAttributedString.Key.font: UIFont.fontMonsterratBold(withSize: 25),
				NSAttributedString.Key.foregroundColor: UIColor.WHITE_COLOR])
			navigationController?.navigationBar.barTintColor = .ORANGE_COLOR
			break
		}
		navLabel.attributedText = navTitle
		
		return navLabel
	}
	

	
	@objc func claimTapped(){
		self.performSegue(withIdentifier: "search", sender: nil)
	}
	
	func editTapped(spotModel : SpotModel){
		self.selectedSpotModel = spotModel
		self.performSegue(withIdentifier: "edit", sender: nil)
	}
	
	func analyticsTapped(spotModel : SpotModel){
		self.selectedSpotModel = spotModel
		self.performSegue(withIdentifier: "analytics", sender: nil)
	}
    
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if(segue.identifier == "search"){
			let dest = segue.destination as! BusinessRestaurantSearchViewController
			dest.superVc = self
		}else if(segue.identifier == "edit"){
			let dest = segue.destination as! BusinessRestaurantEditViewController
			dest.spotModel = self.selectedSpotModel
		}else if(segue.identifier == "analytics"){
			let dest = segue.destination as! BusinessRestaurantAnalyticsViewController
			dest.spotModel = self.selectedSpotModel
		}
	}
}

extension BusinessRestaurantViewController : UITableViewDelegate , UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.claims.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! BusinessRestaurantTableViewCell
		cell.img.kf.setImage(with: URL(string: self.claims[indexPath.row].spot.photoUrl))
		cell.img.layer.cornerRadius = cell.img.frame.width / 2
		cell.name.text = self.claims[indexPath.row].spot.name
		cell.name.adjustsFontSizeToFitWidth = true
		cell.subtitle.adjustsFontSizeToFitWidth = true
		cell.superVc = self
		cell.spotModel = self.claims[indexPath.row].spot
		if(self.claims[indexPath.row].isVerified){
			cell.subtitle.text = self.claims[indexPath.row].spot.address
			cell.editButton.isHidden = false
			cell.analyticsButton.isHidden = false
			cell.reviewLabel.isHidden = true
		}else{
			cell.subtitle.text = self.claims[indexPath.row].spot.address
			cell.editButton.isHidden = true
			cell.analyticsButton.isHidden = true
			cell.reviewLabel.isHidden = false
			cell.reviewLabel.text = "Claim In Review"
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 130
	}
	
}
