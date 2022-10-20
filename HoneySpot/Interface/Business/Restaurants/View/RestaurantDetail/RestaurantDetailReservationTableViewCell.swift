//
//  RestaurantDetailReservationTableViewCell.swift
//  HoneySpot
//
//  Created by Chandramouli on 23/12/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class RestaurantDetailReservationTableViewCell: UITableViewCell {

    @IBOutlet var reservationLink: UILabel!
    @IBOutlet var reservationDescriptionLink: UITextView!
    var superVc : BusinessRestaurantEditViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editTapped(_ sender: Any) {
        self.superVc.editReservation()
    }
    func prepareCell(model : SpotModel){
        reservationDescriptionLink.text = model.spotreservationlink
        
    }

}
