//
//  NotificationTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 19.06.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationReadView: UIView!
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var avatarImage: UIImageView!
    
    var index : Int!
    var superVc : NotificationViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        notificationReadView.layer.cornerRadius = 4
//        notificationReadView.clipsToBounds = true
        // Initialization code
    }
    
    func configureTaps(){
        avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        avatarView.isUserInteractionEnabled = true
        topLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        topLabel.isUserInteractionEnabled = true
        descriptionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        descriptionLabel.isUserInteractionEnabled = true
    }
    
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        let tag = gestureRecognizer.view?.tag
        switch tag! {
        case 1 :
            if(superVc != nil){
                superVc.imageTapped(index: index ?? 0)
            }
        case 2 :
            if(superVc != nil){
                superVc.nameTapped(index: index ?? 0)
            }
        case 3 :
            if(superVc != nil){
                superVc.detailTapped(index: index ?? 0)
            }
        default:
            print("default")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
