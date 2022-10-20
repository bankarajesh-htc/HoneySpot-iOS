//
//  BusinessRestaurantEditManageLocationsViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 31.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class BusinessRestaurantEditManageLocationsViewController: UIViewController {

	@IBOutlet var locationTableView: UITableView!
	
	var spotModel : SpotModel!
	var type = ""
	var index = -1
	
	override func viewDidLoad() {
        super.viewDidLoad()
		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
		locationTableView.reloadData()
    }
	
	@IBAction func backTapped(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
    
    @IBAction func didAddLocation(_ sender: Any) {
        self.type = "addLocation"
        self.performSegue(withIdentifier: "updateLocation", sender: nil)
    }
    
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if(segue.identifier == "updateLocation"){
			let dest = segue.destination as! BusinessRestaurantEditUpdateLocationViewController
			dest.type = self.type
			dest.spotModel = self.spotModel
			dest.index = self.index
			dest.superVc = self
		}
	}
    func deleteLocation(index : Int)  {
        
        let alert: UIAlertController = UIAlertController(
            title: "Remove",
            message: "Are you sure you want to remove the Location?",
            preferredStyle: .alert)
        
        //Add Buttons
        let yesButton: UIAlertAction = UIAlertAction(
            title: "Remove",
            style: .default) { (action: UIAlertAction) in
            self.showLoadingHud()
            self.spotModel.otherlocations.remove(at: index - 1)
            BusinessRestaurantDataSource().saveSpot(spotModel: self.spotModel) { (result) in
                switch(result){
                case .success(let str):
                    self.hideAllHuds()
                    self.locationTableView.reloadData()
                case .failure(let err):
                    self.hideAllHuds()
                    self.showErrorHud(message: err.errorMessage)
                }
            }

        }
        
        let noButton: UIAlertAction = UIAlertAction(
            title: "Cancel",
            style: .cancel) { (action: UIAlertAction) in
        }
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
        
    }
    func setTextWithLineSpacing(text:String,lineSpacing:CGFloat) -> NSMutableAttributedString
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

        return attrString
        
    }

}

extension BusinessRestaurantEditManageLocationsViewController : UITableViewDelegate,UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return spotModel.otherlocations.count + 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if(indexPath.row == 0){
			let cell = tableView.dequeueReusableCell(withIdentifier: "locationCellId") as! BusinessRestaurantManageLocationTableViewCell
			var addresses =  spotModel.address.split(separator: ",")
			
			if(addresses.count > 0){
				cell.street.text = addresses[0].description
				addresses.removeFirst()
                let cityAddress = addresses.joined(separator: ",").removeWhitespace()
				
                let attrString:NSMutableAttributedString = setTextWithLineSpacing(text: cityAddress, lineSpacing: 2.0)
                cell.cityAndPostal.text = attrString.string
                
			}else{
				cell.street.text = ""
				cell.cityAndPostal.text = ""
			}
			
			cell.editButton.isHidden = true
            cell.deleteButton.isHidden = true
			return cell
		}
        else{
            print(indexPath.row)
			let cell = tableView.dequeueReusableCell(withIdentifier: "locationCellId") as! BusinessRestaurantManageLocationTableViewCell
			let addresses =  spotModel.otherlocations[indexPath.row - 1].split(separator: "|")
            if addresses.count == 0 {
                print("No Data")
                cell.street.text = ""
                cell.cityAndPostal.text = ""
            }
            else
            {
                cell.street.text = addresses[0].description
                cell.cityAndPostal.text = (addresses[1]).description + "," + (addresses[2]).description + "," + (addresses[3]).description
                cell.street.adjustsFontSizeToFitWidth = true
                cell.cityAndPostal.adjustsFontSizeToFitWidth = true
            }
            cell.superVc = self
            cell.index = indexPath.row
			
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if(indexPath.row == 0){
			//Normal
		}else{
			//OtherLocation
			//self.index = indexPath.row - 1
		}
	}
    
    
	
	func updateLocation(index : Int){
		self.index = index - 1
		self.type = "updateLocation"
		self.performSegue(withIdentifier: "updateLocation", sender: nil)
	}
	
}
