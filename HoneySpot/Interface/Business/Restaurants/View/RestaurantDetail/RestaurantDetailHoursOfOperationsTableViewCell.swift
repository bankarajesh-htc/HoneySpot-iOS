//
//  RestaurantDetailHoursOfOperationsTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 20.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class RestaurantDetailHoursOfOperationsTableViewCell: UITableViewCell {

    @IBOutlet var hoursTableView: UITableView!
	@IBOutlet var hoursStackView: UIStackView!
    @IBOutlet weak var dayHourStackView: UIStackView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var hoursView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    var superVc : BusinessRestaurantEditViewController!
    var spotModel:SpotModel!
    var days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
	func prepareCell(model : SpotModel){
		
        spotModel = model
        if spotModel.operationhours.count == 0 {
            print("Count zero")
            noDataLabel.isHidden = false
            //hoursTableView.reloadData()
            hoursTableView.isHidden = true
        }
        else
        {
            hoursTableView.isHidden = false
            noDataLabel.isHidden = true
            hoursTableView.reloadData()
        }
        
	}

	@IBAction func editTapped(_ sender: Any) {
		self.superVc.editUpdateHours()
	}
	
}

extension RestaurantDetailHoursOfOperationsTableViewCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        spotModel.operationhours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hoursOfOperationCellId") as! HoursOfOperationTableViewCell
        let data = spotModel.operationhours[indexPath.row].split(separator: "|")
        cell.dayNameLabel.text = days[indexPath.row]
        cell.hoursLabel.textColor = UIColor(rgb: 0x000000)
        if(data[0].description == "open"){
            var txt = (data[1].description) + (" - ")
            txt += (data[2].description)
            cell.hoursLabel.text = txt
        }else{
            cell.hoursLabel.text = "Closed"
            cell.hoursLabel.textColor = UIColor(rgb: 0xEC0000)
        }
        
        return cell
    }
    
    
}
