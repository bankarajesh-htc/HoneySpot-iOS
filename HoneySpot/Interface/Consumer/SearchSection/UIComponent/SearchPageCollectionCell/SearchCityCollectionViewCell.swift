//
//  SearchCityCollectionViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 24.12.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit

class SearchCityCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var cityCollectionView: UICollectionView!
	
	var cities = [CityModel]()
	var delegate : ExploreSearchDelegate!
	
	func prepareCell(cities : [CityModel]){
		self.cities = cities
		DispatchQueue.main.async {
			self.cityCollectionView.reloadData()
		}
	}
	
}

extension SearchCityCollectionViewCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.cities.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCellId", for: indexPath) as! SearchCitySubCollectionViewCell
		cell.img.kf.setImage(with: URL(string: cities[indexPath.row].photoUrl), placeholder: UIImage(named: "ImagePlaceholder"), options: nil)
		cell.name.text = cities[indexPath.row].city
		cell.honeyspotCountLabel.text = cities[indexPath.row].honeyspotCount.description + " " + "Honeyspots"
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("City Selected")
		self.delegate!.cityTapped(city: cities[indexPath.row])
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = UIScreen.main.bounds.width - 32
		let calculatedWidth = (width - 17.0) / 2.0
		return CGSize(width: calculatedWidth, height: 150.0)
	}
	
}
