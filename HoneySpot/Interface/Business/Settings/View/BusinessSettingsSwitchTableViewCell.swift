//
//  BusinessSettingsSwitchTableViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 23.02.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class BusinessSettingsSwitchTableViewCell: UITableViewCell {


	@IBOutlet var img: UIImageView!
	@IBOutlet var notfSwitch: UISwitch!
	@IBOutlet var titleLabel: UILabel!
    @IBOutlet var switchButton: UIButton!
    var delegate: SettingsDelegate!
	
    @IBAction func didClickSwitch(_ sender: Any){
        self.delegate.onToggleSwitch()
    
    }
	@IBAction func switchChanged(_ sender: Any) {
        if AppDelegate.originalDelegate.isGuestLogin {
            
           
            //notfSwitch.isOn = false
            if notfSwitch.isOn {
                notfSwitch.isOn = false
            }
            else
            {
                notfSwitch.isOn = false
            }
        }
        else
        {
           
            
            if notfSwitch.isOn {
                notfSwitch.thumbTintColor = UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0)
                notfSwitch.tintColor = UIColor.init(red: 255.0/255.0, green: 223.0/255.0, blue: 208.0/255.0, alpha: 1.0)
            }
            else
            {
                notfSwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                notfSwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
            }
            
            postNotificationStatus()
        }
        
	}
    func postNotificationStatus()  {
        self.isUserInteractionEnabled = false
        ProfileDataSource().notificationPostStatus(staus: notfSwitch.isOn) { (result) in
            switch(result){
            case .success(let notificationStatus):
                print("Status \(notificationStatus) ")
                self.getNotificationStatus()
                //AppDelegate.originalDelegate.isConsumerSwitch = notificationStatus
            case .failure(let err):
                self.isUserInteractionEnabled = true
                print(err)
            }
        }
        
    }
    func getNotificationStatus()  {
        self.isUserInteractionEnabled = false
        ProfileDataSource().notificationGetStatus { (result) in
            switch(result){
            case .success(let notificationStatus):
                print("Status \(notificationStatus) ")
                AppDelegate.originalDelegate.isConsumerSwitch = notificationStatus
                self.isUserInteractionEnabled = true
            case .failure(let err):
                self.isUserInteractionEnabled = true
                print(err)
            }
        }
        
    }
    func getSwitchColor()  {
        if notfSwitch.isOn {
            notfSwitch.thumbTintColor = UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0)
            notfSwitch.tintColor = UIColor.init(red: 255.0/255.0, green: 223.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        }
        else
        {
            notfSwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            notfSwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
        }
    }
    func prepareCell(){
        
        
        if AppDelegate.originalDelegate.isGuestLogin {
            
            switchButton.isHidden = false
            notfSwitch.isUserInteractionEnabled = false
            
            if notfSwitch.isOn {
                notfSwitch.isOn = false
            }
            else
            {
                notfSwitch.isOn = false
            }
            getSwitchColor()
        }
        else
        {
            switchButton.isHidden = true
            notfSwitch.isUserInteractionEnabled = true
            if AppDelegate.originalDelegate.isConsumerSwitch {
                notfSwitch.isOn = true
            }
            else
            {
                notfSwitch.isOn = false
            }
            getSwitchColor()
            
        }
    }
    
	
}
