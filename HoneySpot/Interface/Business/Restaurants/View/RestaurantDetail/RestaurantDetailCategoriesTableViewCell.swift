//
//  RestaurantDetailCategoriesTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 20.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class RestaurantDetailCategoriesTableViewCell: UITableViewCell {

	@IBOutlet var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
	
	var superVc : BusinessRestaurantEditViewController!
	var tags = [Int]()
	
	func prepareCell(model : SpotModel){
		let tags = model.categories
        if tags.count == 0 {
            noDataLabel.isHidden = false
            self.categoriesCollectionView.isHidden = true
        }
        else
        {
            noDataLabel.isHidden = true
            self.categoriesCollectionView.isHidden = false
            self.categoriesCollectionView.collectionViewLayout = createLeftAlignedLayoutTag()
            self.tags = tags.sorted { (s1, s2) -> Bool in
                return s1 < s2
            }
            self.categoriesCollectionView.reloadData()
        }
		
	}
	
	@IBAction func editTapped(_ sender: Any) {
		self.superVc.editCategoriesTapped()
	}
	
}

extension RestaurantDetailCategoriesTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource{
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.tags.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCellId", for: indexPath) as! FeedTagCollectionViewCell
		let tag = getTagFromInt(id: self.tags[indexPath.row] )
		if(tag != nil){
			cell.img.image = tag!.image
			cell.label.text = tag!.name
			cell.bView.layer.cornerRadius = 15
			cell.bView.clipsToBounds = true
		}
		
		return cell
	}
	
}

extension RestaurantDetailCategoriesTableViewCell {
	
	private func createLeftAlignedLayoutTag() -> UICollectionViewLayout {
	  let item = NSCollectionLayoutItem(          // this is your cell
		layoutSize: NSCollectionLayoutSize(
		  widthDimension: .estimated(40),         // variable width
		  heightDimension: .absolute(40)          // fixed height
		)
	  )
	  
	  let group = NSCollectionLayoutGroup.horizontal(
		layoutSize: .init(
		  widthDimension: .fractionalWidth(1.0),  // 100% width as inset by its Section
		  heightDimension: .estimated(40)         // variable height; allows for multiple rows of items
		),
		subitems: [item]
	  )
	  group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
	  group.interItemSpacing = .fixed(8)         // horizontal spacing between cells

	  return UICollectionViewCompositionalLayout(section: .init(group: group))
	}
	
	private func createLeftAlignedLayoutFavorite() -> UICollectionViewLayout {
	  let item = NSCollectionLayoutItem(          // this is your cell
		layoutSize: NSCollectionLayoutSize(
		  widthDimension: .estimated(40),         // variable width
		  heightDimension: .absolute(20)          // fixed height
		)
	  )
	  
	  let group = NSCollectionLayoutGroup.horizontal(
		layoutSize: .init(
		  widthDimension: .fractionalWidth(1.0),  // 100% width as inset by its Section
		  heightDimension: .estimated(20)         // variable height; allows for multiple rows of items
		),
		subitems: [item]
	  )
	  group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
	  group.interItemSpacing = .fixed(4)         // horizontal spacing between cells

	  return UICollectionViewCompositionalLayout(section: .init(group: group))
	}
	
}

