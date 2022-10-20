//
//  RestaurantDetailServiceOfferedTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 20.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class RestaurantDetailServiceOfferedTableViewCell: UITableViewCell {

    @IBOutlet var serviceOfferedCollectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
	
	var superVc : BusinessRestaurantEditViewController!
	var spotModel : SpotModel!
	
	
	func prepareCell(model : SpotModel){
		self.spotModel = model
        if self.spotModel.deliveryOptions?.count == 0 {
            noDataLabel.isHidden = false
            serviceOfferedCollectionView.isHidden = true
        }
        else
        {
            noDataLabel.isHidden = true
            serviceOfferedCollectionView.isHidden = false
            
            self.spotModel.deliveryOptions?.sort(by: { (s1, s2) -> Bool in
                if(s1 == "delivery"){
                    return s1 < s2
                }else{
                    return s1 > s2
                }
            })
            DispatchQueue.main.async {
                self.serviceOfferedCollectionView.reloadData()
                self.serviceOfferedCollectionView.collectionViewLayout = self.createLeftAlignedLayoutTag()
            }
            
        }
        
	}
	
	@IBAction func editTapped(_ sender: Any) {
		self.superVc.editServicesTapped()
	}
	
}

extension RestaurantDetailServiceOfferedTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.spotModel.deliveryOptions?.filter({ (s) -> Bool in
            return s == "dine-in" || s == "take-out" || s == "catering" || s == "delivery"
        }).count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceOfferCellId", for: indexPath) as! ServiceOfferedCollectionViewCell
        let data = self.spotModel.deliveryOptions?.filter({ (s) -> Bool in
            return s == "dine-in" || s == "take-out" || s == "catering" || s == "delivery"
        })[indexPath.row]
        if(data == "dine-in"){
            cell.image.image = UIImage(named: "dineIn")
            cell.label.text = "Dine In"
        }else if(data == "take-out"){
            cell.image.image = UIImage(named: "takeOut")
            cell.label.text = "Take out"
        }else if(data == "catering"){
            cell.image.image = UIImage(named: "catering")
            cell.label.text = "Catering"
        }
        else if(data == "delivery"){
            cell.image.image = UIImage(named: "delivery")
            cell.label.text = "Delivery"
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 2
        }
    
}

extension RestaurantDetailServiceOfferedTableViewCell {
    
    private func createLeftAlignedLayoutTag() -> UICollectionViewLayout {
      let item = NSCollectionLayoutItem(          // this is your cell
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .estimated(110),         // variable width
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
      group.interItemSpacing = .fixed(16)         // horizontal spacing between cells

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

