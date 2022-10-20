//
//  AddSpotTagContainerCollectionViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 10.12.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit

class AddSpotTagContainerCollectionViewCell: UICollectionViewCell {
    
	
	@IBOutlet var tagCollectionView: UICollectionView!
	
	var tags = [Tag]()
	var superVc : Any!
	
	func prepareCell(){
		self.tagCollectionView.reloadData()
	}
	
	
}

extension AddSpotTagContainerCollectionViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.tags.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let data = tags[indexPath.row]
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCellId", for: indexPath) as! AddSpotTagNewCollectionViewCell
		
		cell.tagLabel.adjustsFontSizeToFitWidth = true
		
		cell.tagLabel.text = data.name
		cell.layer.borderWidth = 1.0
		
		if(superVc is EditSpotViewController){
			let sVc = superVc as! EditSpotViewController
			if(sVc.selectedTags.contains(data.id)){
				cell.tagLabel.textColor = UIColor.ORANGE_COLOR
				cell.tagImage.image = data.image
				cell.layer.borderColor = UIColor.ORANGE_COLOR.cgColor
			}else{
				cell.tagLabel.textColor = UIColor.black
				cell.tagImage.image = data.grayImage
				cell.layer.borderColor = UIColor(rgb: 0xE4E4E4).cgColor
			}
		}else if(superVc is MapBottomFilterViewController){
			let sVc = superVc as! MapBottomFilterViewController
			if(sVc.filterArray.contains(data.id)){
				cell.tagLabel.textColor = UIColor.ORANGE_COLOR
				cell.tagImage.image = data.image
				cell.layer.borderColor = UIColor.ORANGE_COLOR.cgColor
			}else{
				cell.tagLabel.textColor = UIColor.black
				cell.tagImage.image = data.grayImage
				cell.layer.borderColor = UIColor(rgb: 0xE4E4E4).cgColor
			}
		}else if(superVc is BusinessRestaurantEditUpdateCategoriesViewController){
			let sVc = superVc as! BusinessRestaurantEditUpdateCategoriesViewController
			if(sVc.filterArray.contains(data.id)){
				cell.tagLabel.textColor = UIColor.ORANGE_COLOR
				cell.tagImage.image = data.image
                cell.selectedIcon.isHidden = false
				cell.layer.borderColor = UIColor.ORANGE_COLOR.cgColor
			}else{
				cell.tagLabel.textColor = UIColor.black
				cell.tagImage.image = data.grayImage
				cell.layer.borderColor = UIColor(rgb: 0xE4E4E4).cgColor
                cell.selectedIcon.isHidden = true
			}
		}
		
		
		cell.layer.maskedCorners = []
		cell.layer.cornerRadius = 0.0
//		if(indexPath.row == 0){
//			cell.layer.maskedCorners = [.layerMinXMinYCorner]
//			cell.layer.cornerRadius = 10.0
//		}else if(indexPath.row == 3){
//			cell.layer.maskedCorners = [.layerMaxXMinYCorner]
//			cell.layer.cornerRadius = 10.0
//		}else if(indexPath.row == 8){
//			cell.layer.maskedCorners = [.layerMinXMaxYCorner]
//			cell.layer.cornerRadius = 10.0
//		}else if(indexPath.row == 11){
//			cell.layer.maskedCorners = [.layerMaxXMaxYCorner]
//			cell.layer.cornerRadius = 10.0
//		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let tagData = tags[indexPath.row]
		if(superVc is EditSpotViewController){
			let sVc = superVc as! EditSpotViewController
			if(!sVc.selectedTags.contains(tagData.id)){
				sVc.selectedTags.append(tagData.id)
			}else{
				var count = 0
				for tagId in sVc.selectedTags {
					if (tagId == tagData.id){
						sVc.selectedTags.remove(at: count)
					}
					count = count + 1
				}
			}
		}else if(superVc is MapBottomFilterViewController){
			let sVc = superVc as! MapBottomFilterViewController
			if(!sVc.filterArray.contains(tagData.id)){
				sVc.filterArray.append(tagData.id)
			}else{
				var count = 0
				for tagId in sVc.filterArray {
					if (tagId == tagData.id){
						sVc.filterArray.remove(at: count)
					}
					count = count + 1
				}
			}
			sVc.filterChanged()
		}else if(superVc is BusinessRestaurantEditUpdateCategoriesViewController){
			let sVc = superVc as! BusinessRestaurantEditUpdateCategoriesViewController
			if(!sVc.filterArray.contains(tagData.id)){
                if sVc.filterArray.count > 4 {
                    print("You cannot choose more than 5 categories")
                    HSAlertView.showAlert(withTitle: "HoneySpot", message: "You can select up to five from the categories")
                }
                else
                {
                    sVc.filterArray.append(tagData.id)
                }
				
			}else{
				var count = 0
				for tagId in sVc.filterArray {
					if (tagId == tagData.id){
						sVc.filterArray.remove(at: count)
					}
					count = count + 1
				}
			}
			sVc.filterChanged()
		}
		
		self.tagCollectionView.reloadData()
		
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width/4.0, height: collectionView.frame.height/3.0)
	}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
        }
    // Cell Margin
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 2
        }
	
}
