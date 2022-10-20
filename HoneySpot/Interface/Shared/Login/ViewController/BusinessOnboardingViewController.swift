//
//  BusinessOnboardingViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 16.02.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class BusinessOnboardingViewController: UIViewController {

	@IBOutlet var pageControl: UIPageControl!
	@IBOutlet var onboardingCollectionView: UICollectionView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
			self.onboardingCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
		}
	}
	
	@IBAction func createAccountTapped(_ sender: Any) {
		
	}
	
	@IBAction func consumerLoginTapped(_ sender: Any) {
		//UserDefaults.standard.setValue(true, forKey: "isBusinessOnboardingShown")
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func signInTapped(_ sender: Any) {
		//UserDefaults.standard.setValue(true, forKey: "isBusinessOnboardingShown")
		self.performSegue(withIdentifier: "businessLogin", sender: nil)
	}
	
}

extension BusinessOnboardingViewController : UIScrollViewDelegate {
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
		if let ip = self.onboardingCollectionView.indexPathForItem(at: center) {
			self.pageControl.currentPage = ip.row
		}
	}
	
}


extension BusinessOnboardingViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCellId", for: indexPath) as! BusinessOnboardingCollectionViewCell
		if(indexPath.row == 0){
			cell.descriptionLabel.text = "Customize your Honeyspot page"
			cell.img.image = UIImage(named: "business-preview-3")
		}else if(indexPath.row == 1){
			cell.descriptionLabel.text = "Showcase your business & reach new customers"
			cell.img.image = UIImage(named: "business-preview-2")
		}else if(indexPath.row == 2){
			cell.descriptionLabel.text = "Monitor how your customers engage with your business"
			cell.img.image = UIImage(named: "business-preview-1")
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width * (2/3) , height: collectionView.frame.height )
	}
	
}
