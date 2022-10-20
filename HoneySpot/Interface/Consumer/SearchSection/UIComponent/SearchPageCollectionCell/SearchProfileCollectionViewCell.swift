//
//  SearchProfileCollectionViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 24.12.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit

class SearchProfileCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var profileCollectionView: UICollectionView!
	
	var users = [UserModel]()
	var delegate : ExploreSearchDelegate!
	
	func prepareCell(users : [UserModel]){
		self.users = users
		DispatchQueue.main.async {
			self.profileCollectionView.reloadData()
		}
	}
	
}

extension SearchProfileCollectionViewCell : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.users.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topUserCellId", for: indexPath) as! TopUsersCollectionViewCell
        cell.name.text = users[indexPath.row].fullname ?? "".uppercased()
        cell.nickname.text = users[indexPath.row].username?.capitalizingFirstLetter()
		cell.img.kf.setImage(with: URL(string: users[indexPath.row].pictureUrl ?? ""), placeholder: UIImage(named: "AvatarPlaceHolder"), options: nil)
		let spotCountStr = (users[indexPath.row].spotCount?.description ?? "0") + " " + "Honeyspots"
		let followerCountStr = (users[indexPath.row].followerCount?.description ?? "0") + " " + "Followers"
		cell.infoLabel.text = spotCountStr + " • " + followerCountStr
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("Selected")
		self.delegate!.personTapped(user: users[indexPath.row])
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 76.0)
	}
	
}
