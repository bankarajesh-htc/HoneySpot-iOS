//
//  ConsumerDetailHoursOf OperationTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 18/11/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class ConsumerDetailHoursOfOperationTableViewCell: UITableViewCell {

    @IBOutlet var hoursTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    var spotModel:SpotModel!
    var days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var spotSaveModel : SpotSaveModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func prepareCell(spotSavemodel:SpotSaveModel){
        
        spotModel = spotSavemodel.spot
        if spotModel.operationhours.count == 0 {
            noDataLabel.isHidden = false
            hoursTableView.isHidden = true
        }
        else
        {
            noDataLabel.isHidden = true
            hoursTableView.isHidden = false
            hoursTableView.reloadData()
        }
        
    }

}
extension ConsumerDetailHoursOfOperationTableViewCell : UITableViewDelegate, UITableViewDataSource {
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
