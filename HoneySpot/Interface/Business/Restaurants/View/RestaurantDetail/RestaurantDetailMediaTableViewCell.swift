//
//  RestaurantDetailMediaTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 20.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class RestaurantDetailMediaTableViewCell: UITableViewCell {

	@IBOutlet var tabBackView: UIView!
	@IBOutlet var tabIndicatorView: UIView!
	@IBOutlet var mediaCollectionView: UICollectionView!
	
	@IBOutlet var coverPhotoButton: UIButton!
	@IBOutlet var menuButton: UIButton!
	@IBOutlet var imagesButton: UIButton!
    var commonIndex = 0
	
	var delegate : BusinessEditDelegate!
	
	var superVc : BusinessRestaurantEditViewController!
	var spotModel : SpotModel!
	
	func prepareCell(model : SpotModel){
		self.spotModel = model
        //configureTab(index: 0)
		self.mediaCollectionView.reloadData()
	}
	
	@IBAction func tabOneTapped(_ sender: Any) {
        commonIndex = 0
		configureTab(index: 0)
		mediaCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredVertically, animated: true)
	}
	
	@IBAction func tabTwoTapped(_ sender: Any) {
        commonIndex = 1
		configureTab(index: 1)
		mediaCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredVertically, animated: true)
	}
	
	@IBAction func tabThreeTapped(_ sender: Any) {
        commonIndex = 2
		configureTab(index: 2)
		mediaCollectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredVertically, animated: true)
	}
	
	func configureTab(index : Int){
		if(index == 0){
            
			tabIndicatorView.frame = CGRect(x: 0 , y: 0, width: tabIndicatorView.frame.width, height: tabIndicatorView.frame.height)
			coverPhotoButton.setTitleColor(UIColor.black, for: .normal)
			menuButton.setTitleColor(UIColor.black, for: .normal)
			imagesButton.setTitleColor(UIColor.black, for: .normal)
            
            coverPhotoButton.titleLabel?.font = UIFont.fontHelveticaBold(withSize: 16)
            menuButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            imagesButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
			self.contentView.layoutIfNeeded()
		}else if(index == 1){
			tabIndicatorView.frame = CGRect(x: 1 * (tabBackView.frame.width  / 3.0), y: 0, width: tabIndicatorView.frame.width, height: tabIndicatorView.frame.height)
			coverPhotoButton.setTitleColor(UIColor.black, for: .normal)
			menuButton.setTitleColor(UIColor.black, for: .normal)
			imagesButton.setTitleColor(UIColor.black, for: .normal)
            
            coverPhotoButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            menuButton.titleLabel?.font = UIFont.fontHelveticaBold(withSize: 16)
            imagesButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            
			self.contentView.layoutIfNeeded()
		}else if(index == 2){
			tabIndicatorView.frame = CGRect(x: 2 * (tabBackView.frame.width  / 3.0), y: 0, width: tabIndicatorView.frame.width, height: tabIndicatorView.frame.height)
			coverPhotoButton.setTitleColor(UIColor.black, for: .normal)
			menuButton.setTitleColor(UIColor.black, for: .normal)
			imagesButton.setTitleColor(UIColor.black, for: .normal)
            
            coverPhotoButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            menuButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            imagesButton.titleLabel?.font = UIFont.fontHelveticaBold(withSize: 16)
			self.contentView.layoutIfNeeded()
		}
	}
	
	@IBAction func editTapped(_ sender: Any) {
        self.superVc.editMedia()
	}
	
}

extension RestaurantDetailMediaTableViewCell : UIScrollViewDelegate {
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		configureTab(index: scrollView.currentPage)
	}
	
}

extension RestaurantDetailMediaTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row  == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coverCellId", for: indexPath) as! RestaurantDetailMediaCoverPhotoCollectionViewCell
            cell.delegate = self.delegate
            if(spotModel.customerPictures.count > 0){
                if spotModel.customerPictures[0].contains("https") {
                        cell.img.kf.setImage(with: URL(string:spotModel.customerPictures[0]))
                    }
                else
                {
                    cell.img.image = UIImage(named: "NoCoverPhoto")
                }
                
            }else{
                cell.img.image = UIImage(named: "NoCoverPhoto")
            }
            return cell
        }else if(indexPath.row  == 1){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCellId", for: indexPath) as! RestaurantMediaMenuCollectionViewCell
            cell.delegate = self.delegate
            if(spotModel.menuPictures.count > 0){
                
                    if spotModel.menuPictures[0].contains("https") {
                        cell.img.kf.setImage(with: URL(string:spotModel.menuPictures[0]))
                    }
                    else
                    {
                        cell.img.image = UIImage(named: "NoMenuImage")
                    }
            }else{
                cell.img.image = UIImage(named: "NoMenuImage")
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCellId", for: indexPath) as! RestaurantDetailMediaImagesCollectionViewCell
            cell.delegate = self.delegate
            if(spotModel.foodPictures.count > 0){
                    if spotModel.foodPictures[0].contains("https") {
                        cell.img.kf.setImage(with: URL(string:spotModel.foodPictures[0]))
                    }
                    else
                    {
                        cell.img.image = UIImage(named: "NoImage")
                    }
            }else{
                cell.img.image = UIImage(named: "NoImage")
            }
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Row\(indexPath.row)")
    }
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: UIScreen.main.bounds.width, height: 200.0)
	}
	
	
}
