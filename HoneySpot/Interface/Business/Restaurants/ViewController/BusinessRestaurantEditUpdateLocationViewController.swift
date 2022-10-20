//
//  BusinessRestaurantEditUpdateLocationViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 31.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class BusinessRestaurantEditUpdateLocationViewController: UIViewController {

	@IBOutlet var titleLabel: UILabel!
	
	@IBOutlet var streetTextField: UITextField!
	@IBOutlet var stateTextField: UITextField!
	@IBOutlet var zipTextField: UITextField!
	@IBOutlet var cityTextField: UITextField!
	
	@IBOutlet var removeLocationButton: UIButton!
	@IBOutlet var updateButton: UIButton!
	
	var superVc : BusinessRestaurantEditManageLocationsViewController!
	
	var index = -1
	var type = ""
	var spotModel : SpotModel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
		setupViews()
    }
	
	func setupViews(){
		if(type == "addLocation"){
			titleLabel.text = "Add Location"
            updateButton.setTitle("Add", for: .normal)
		}else if(type == "updateLocation"){
            updateButton.setTitle("Update", for: .normal)
			let addresses =  spotModel.otherlocations[index].split(separator: "|")
			if(addresses.count > 0){
				streetTextField.text = addresses[0].description
				cityTextField.text = addresses[1].description
				stateTextField.text = addresses[2].description
				zipTextField.text = addresses[3].description
			}
		}
	}

	@IBAction func closeTapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func removeLocationTapped(_ sender: Any) {
		self.spotModel.otherlocations.remove(at: index)
		BusinessRestaurantDataSource().saveSpot(spotModel: self.spotModel) { (result) in
			switch(result){
			case .success(let str):
				self.changeSuperVc()
				self.dismiss(animated: true, completion: nil)
			case .failure(let err):
				self.showErrorHud(message: "Problem occured please try again")
			}
		}
	}
	
	@IBAction func updateTapped(_ sender: Any) {
        if streetTextField.text == "" &&  cityTextField.text == "" && stateTextField.text == "" && zipTextField.text == ""{
            HSAlertView.showAlert(withTitle: "Location", message: "Enter all the required details")
        }
        else
        {
            if streetTextField.text == "" {
                HSAlertView.showAlert(withTitle: "Location", message: "Enter street details")
            }
            else if cityTextField.text == "" {
                HSAlertView.showAlert(withTitle: "Location", message: "Enter city details")
            }
            else if stateTextField.text == "" {
                HSAlertView.showAlert(withTitle: "Location", message: "Enter state details")
            }
            else if zipTextField.text == "" {
                HSAlertView.showAlert(withTitle: "Location", message: "Enter zip code details")
            }
            else
            {
                if(type == "addLocation"){
                    self.showLoadingHud()
                    var address = (streetTextField.text ?? "") + "|"
                    address += (cityTextField.text ?? "") + "|"
                    address += (stateTextField.text ?? "") + "|"
                    address += (zipTextField.text ?? "")
                    self.spotModel.otherlocations.append(address)
                    BusinessRestaurantDataSource().saveSpot(spotModel: self.spotModel) { (result) in
                        switch(result){
                        case .success(let str):
                            self.hideAllHuds()
                            self.changeSuperVc()
                            self.showAlert(title: "Added", message: "Location has been added successfully for the restaurant")
                        case .failure(let err):
                            self.hideAllHuds()
                            self.showAlert(title: "Error", message: "Problem occured please try again")
                        }
                    }
                }else if(type == "updateLocation"){
                    self.showLoadingHud()
                    var address = (streetTextField.text ?? "") + "|"
                    address += (cityTextField.text ?? "") + "|"
                    address += (stateTextField.text ?? "") + "|"
                    address += (zipTextField.text ?? "")
                    self.spotModel.otherlocations[index] = address
                    BusinessRestaurantDataSource().saveSpot(spotModel: self.spotModel) { (result) in
                        switch(result){
                        case .success(let str):
                            self.hideAllHuds()
                            self.changeSuperVc()
                            self.showAlert(title: "Updated", message: "Location has been updated successfully for the restaurant")
                        case .failure(let err):
                            self.hideAllHuds()
                            self.showAlert(title: "Error", message: "Problem occured please try again")
                            
                        }
                    }
                }
            }
        }
        
        
		

	}
	
    func changeSuperVc(){
		self.superVc.spotModel = self.spotModel
		self.superVc.locationTableView.reloadData()
	}
    func showAlert(title:String,message:String) {
        let alert: UIAlertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        //Add Buttons
        let yesButton: UIAlertAction = UIAlertAction(
            title: "Ok",
            style: .default) { (action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)

        }
        
        let noButton: UIAlertAction = UIAlertAction(
            title: "Cancel",
            style: .cancel) { (action: UIAlertAction) in
        }
        
        alert.addAction(yesButton)
        //alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
    }
	
}
