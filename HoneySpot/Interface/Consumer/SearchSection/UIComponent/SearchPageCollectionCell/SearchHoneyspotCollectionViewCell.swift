//
//  SearchHoneyspotCollectionViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 24.12.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit
import MapKit

class SearchHoneyspotCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var honeyspotCollectionView: UICollectionView!
	
	var honeyspots = [SpotModel]()
	var delegate : ExploreSearchDelegate!
	
	func prepareCell(honeyspots : [SpotModel]){
		self.honeyspots = honeyspots
		honeyspotCollectionView.reloadData()
	}
	
}

extension SearchHoneyspotCollectionViewCell : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
	
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return honeyspots.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "honeyspotCellId", for: indexPath) as! SearchHoneyspotSubCollectionViewCell
		cell.honeyspotCountLabel.isHidden = true
		cell.address.text = "Address loading..."
		cell.locationName.text = honeyspots[indexPath.row].name
		print(honeyspots[indexPath.row].photoUrl)
		cell.img.contentMode = .scaleAspectFill
		cell.img.kf.setImage(with: URL(string: honeyspots[indexPath.row].photoUrl), placeholder: UIImage(named: "ImagePlaceholder"), options: nil)
		
		let lat = honeyspots[indexPath.row].lat
		let lon = honeyspots[indexPath.row].lon
		let location: CLLocation = CLLocation(latitude: lat, longitude: lon)
		let geoCoder = CLGeocoder()
		geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) in
			if let placemarks = placemarks {
				let p: CLPlacemark = placemarks[0]
				let city = p.locality ?? ""
				let country = p.country ?? Locale.current.regionCode
				cell.address.text = city + "," + (country ?? "")
			} else {
				print("Reverse geocoding failed\(error!)")
				cell.address.text = "Address not found"
			}
		})
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("Honeyspot Selected")
		self.delegate!.spotTapped(spot: honeyspots[indexPath.row])
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 110.0)
	}
	
	
}
