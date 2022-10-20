//
//  AdminRequestTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 11/12/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class AdminRequestTableViewCell: UITableViewCell {

    
    var cellDelegate: AdminRequestTableViewCellDelegate?
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var spotName: UILabel!
    @IBOutlet weak var spotAddress: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    var indexPath: IndexPath!
    
       // connect the button from your cell with this method
   @IBAction func buttonPressed(_ sender: UIButton) {
       
//    if let button = sender as? UIButton {
//        if button.isSelected {
//                // set deselected
//            button.isSelected = false
//            } else {
//                // set selected
//                button.isSelected = true
//
//            }
//        }
       //cellDelegate?.didPressButton(sender.tag)
       cellDelegate?.didSelect(sender: self, indexPath: self.indexPath)
       
   }
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor.clear

        //self.backView.layer.borderWidth = 1
        self.backView.layer.cornerRadius = 10
        //self.backView.layer.borderColor = UIColor.clear.cgColor
        self.backView.layer.masksToBounds = true

        self.backView.layer.shadowOpacity = 0.2
        self.backView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backView.layer.shadowRadius = 4
        self.backView.layer.shadowColor = UIColor.black.cgColor
        self.backView.layer.masksToBounds = false
        //backView.layer.shadowPath = UIBezierPath(rect: backView.bounds).cgPath
       // backView.layer.shouldRasterize = true
       // backView.layer.rasterizationScale = UIScreen.main.scale
    }
    override func layoutSubviews() {
//        backView.backgroundColor = UIColor.white
//        backView.layer.cornerRadius = 15
//        backView.layer.shadowOffset = CGSize(width: 1, height: 0)
//        backView.layer.shadowColor = UIColor.black.cgColor
//        backView.layer.shadowRadius = 5
//        backView.layer.shadowOpacity = 0.25
//        let shadowFrame = backView.layer.bounds
//        let shadowPath = UIBezierPath(rect: shadowFrame).cgPath
//        backView.layer.shadowPath = shadowPath
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
