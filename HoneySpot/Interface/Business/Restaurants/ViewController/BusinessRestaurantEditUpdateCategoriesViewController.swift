//
//  BusınessRestaurantEditUpdateCategoriesViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 26.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//


import UIKit

class BusinessRestaurantEditUpdateCategoriesViewController: UIViewController{


	@IBOutlet var tagsCollectionView: UICollectionView!
	@IBOutlet weak var applyButton: UIButton!
	@IBOutlet var cuisinesButton: UIButton!
	@IBOutlet var vibesButton: UIButton!
	@IBOutlet var mealsButton: UIButton!
	@IBOutlet var dietsButton: UIButton!
	@IBOutlet var tagIndicatorBackView: UIView!
	@IBOutlet var tagIndicatorView: UIView!
	@IBOutlet var clearButton: UIButton!
	
	var filterArray = [Int]()
	var spotModel : SpotModel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
		
		self.filterArray = spotModel.categories
		applyButton.layer.cornerRadius = applyButton.frame.height / 2
		tagsCollectionView.reloadData()
	}

	@IBAction func clearAllTapped(_ sender: Any) {
		filterArray.removeAll()
		tagsCollectionView.reloadData()
		filterChanged()
	}
	
   
	func filterChanged(){
		if(filterArray.count > 0){
			clearButton.isHidden = false
			//clearButton.setTitle("Clear all " + filterArray.count.description, for: .normal)
		}
        else{
			clearButton.isHidden = true
		}
	}
	
	@IBAction func closeTapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func applyTapped(_ sender: Any) {
		showLoadingHud()
		spotModel.categories = self.filterArray
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
	
	@IBAction func cuisinesTapped(_ sender: Any) {
		configureTab(index: 0)
		tagsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
	}
	
	@IBAction func vibesTapped(_ sender: Any) {
		configureTab(index: 1)
		tagsCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
	}
	
	@IBAction func mealsTapped(_ sender: Any) {
		configureTab(index: 2)
		tagsCollectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredHorizontally, animated: true)
	}
    @IBAction func dietsTapped(_ sender: Any) {
        configureTab(index: 3)
        tagsCollectionView.scrollToItem(at: IndexPath(row: 3, section: 0), at: .centeredHorizontally, animated: true)
    }
	
	func configureTab(index : Int){
		if(index == 0){
			tagIndicatorView.frame = CGRect(x: 0 , y: 0, width: tagIndicatorView.frame.width, height: tagIndicatorView.frame.height)
			cuisinesButton.setTitleColor(UIColor.black, for: .normal)
			vibesButton.setTitleColor(UIColor.black, for: .normal)
			mealsButton.setTitleColor(UIColor.black, for: .normal)
			dietsButton.setTitleColor(UIColor.black, for: .normal)
            
            //Updating Fonts
            cuisinesButton.titleLabel?.font = UIFont.fontHelveticaBold(withSize: 16)
            vibesButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            mealsButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            dietsButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            
			self.view.layoutIfNeeded()
		}else if(index == 1){
			tagIndicatorView.frame = CGRect(x: 1 * (tagIndicatorBackView.frame.width  / 4.0), y: 0, width: tagIndicatorView.frame.width, height: tagIndicatorView.frame.height)
			cuisinesButton.setTitleColor(UIColor.black, for: .normal)
			vibesButton.setTitleColor(UIColor.black, for: .normal)
			mealsButton.setTitleColor(UIColor.black, for: .normal)
			dietsButton.setTitleColor(UIColor.black, for: .normal)
            
            //Updating Fonts
            cuisinesButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            vibesButton.titleLabel?.font = UIFont.fontHelveticaBold(withSize: 16)
            mealsButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            dietsButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            
			self.view.layoutIfNeeded()
		}else if(index == 2){
			tagIndicatorView.frame = CGRect(x: 2 * (tagIndicatorBackView.frame.width  / 4.0), y: 0, width: tagIndicatorView.frame.width, height: tagIndicatorView.frame.height)
			cuisinesButton.setTitleColor(UIColor.black, for: .normal)
			vibesButton.setTitleColor(UIColor.black, for: .normal)
			mealsButton.setTitleColor(UIColor.black, for: .normal)
			dietsButton.setTitleColor(UIColor.black, for: .normal)
            
            //Updating Fonts
            cuisinesButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            vibesButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            mealsButton.titleLabel?.font = UIFont.fontHelveticaBold(withSize: 16)
            dietsButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            
            
			self.view.layoutIfNeeded()
		}else if(index == 3){
			tagIndicatorView.frame = CGRect(x: 3 * (tagIndicatorBackView.frame.width  / 4.0), y: 0, width: tagIndicatorView.frame.width, height: tagIndicatorView.frame.height)
			cuisinesButton.setTitleColor(UIColor.black, for: .normal)
			vibesButton.setTitleColor(UIColor.black, for: .normal)
			mealsButton.setTitleColor(UIColor.black, for: .normal)
			dietsButton.setTitleColor(UIColor.black, for: .normal)
            
            //Updating Fonts
            cuisinesButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            vibesButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            mealsButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            dietsButton.titleLabel?.font = UIFont.fontHelveticaBold(withSize: 16)
            
			self.view.layoutIfNeeded()
		}
	}
	
}

extension BusinessRestaurantEditUpdateCategoriesViewController : UIScrollViewDelegate {
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		configureTab(index: scrollView.currentPage)
	}
	
}

extension BusinessRestaurantEditUpdateCategoriesViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagContainerCellId", for: indexPath) as! AddSpotTagContainerCollectionViewCell
		if(indexPath.row == 0){
			cell.tags = cusinesTags
		}else if(indexPath.row == 1){
			cell.tags = occasionsTags
		}else if(indexPath.row == 2){
			cell.tags = mealsTags
		}else if(indexPath.row == 3){
			cell.tags = dietsTags
		}
		cell.superVc = self
		cell.prepareCell()
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 30)
	}
	
}
