//
//  ConsumerDetailContactInfoTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 18/11/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class ConsumerDetailContactInfoTableViewCell: UITableViewCell {

    @IBOutlet var websiteLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
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
        print(spotSavemodel.spot.website)
        
        if(spotSavemodel.spot.website == "" || spotSavemodel.spot.website == nil ){
            websiteLabel.text = "Not Available"
        }else{
            websiteLabel.text = spotSavemodel.spot.website
        }
        
        if(spotSavemodel.spot.phoneNumber == "" || spotSavemodel.spot.phoneNumber == nil){
            phoneLabel.text = "Not Available"
        }else{
            phoneLabel.text = spotSavemodel.spot.phoneNumber
        }
        
        if(spotSavemodel.spot.email == "" || spotSavemodel.spot.email == nil){
            emailLabel.text = "Not Available"
        }else{
            emailLabel.text = spotSavemodel.spot.email
        }
    }

}
