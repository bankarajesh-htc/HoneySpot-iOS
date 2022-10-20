//
//  BusinessRestaurantEditUpdateHoursViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 31.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class BusinessRestaurantEditUpdateHoursViewController: UIViewController {

	
	@IBOutlet var mondayOpenOrCloseLabel: UILabel!
    @IBOutlet weak var hoursScrollView: UIScrollView!
    
    @IBOutlet weak var mondaySwitch: UISwitch!
    @IBOutlet var mondayOpenLabel: UILabel!
    @IBOutlet var mondayOpenHourLabel: UILabel!
    @IBOutlet var mondayCloseLabel: UILabel!
	@IBOutlet var mondayCloseHourLabel: UILabel!
    @IBOutlet var mondayEditButton: UIButton!
    @IBOutlet weak var mondayImage: UIImageView!
	
	@IBOutlet var tuesdayOpenOrCloseLabel: UILabel!
    @IBOutlet weak var tuesdaySwitch: UISwitch!
    @IBOutlet var tuesdayOpenLabel: UILabel!
    @IBOutlet var tuesdayCloseLabel: UILabel!
    @IBOutlet var tuesdayOpenHourLabel: UILabel!
	@IBOutlet var tuesdayCloseHourLabel: UILabel!
    @IBOutlet var tuesdayEditButton: UIButton!
    @IBOutlet weak var tuesdayImage: UIImageView!
	
	@IBOutlet var wednesdayOpenOrCloseLabel: UILabel!
    
    @IBOutlet weak var wednesdaySwitch: UISwitch!
    @IBOutlet var wednesdayOpenLabel: UILabel!
    @IBOutlet var wednesdayCloseLabel: UILabel!
    @IBOutlet var wednesdayOpenHourLabel: UILabel!
	@IBOutlet var wednesdayCloseHourLabel: UILabel!
    @IBOutlet var wednesdayEditButton: UIButton!
    @IBOutlet weak var wednesdayImage: UIImageView!
	
	@IBOutlet var thursdayOpenOrCloseLabel: UILabel!
    @IBOutlet weak var thursdaySwitch: UISwitch!
    @IBOutlet var thursdayOpenLabel: UILabel!
    @IBOutlet var thursdayCloseLabel: UILabel!
    @IBOutlet var thursdayOpenHourLabel: UILabel!
	@IBOutlet var thursdayCloseHourLabel: UILabel!
    @IBOutlet var thursdayEditButton: UIButton!
    @IBOutlet weak var thursdayImage: UIImageView!
	
	@IBOutlet var fridayOpenOrCloseLabel: UILabel!
    @IBOutlet weak var fridaySwitch: UISwitch!
    @IBOutlet var fridayOpenLabel: UILabel!
    @IBOutlet var fridayCloseLabel: UILabel!
    @IBOutlet var fridayOpenHourLabel: UILabel!
	@IBOutlet var fridayCloseHourLabel: UILabel!
    @IBOutlet var fridayEditButton: UIButton!
    @IBOutlet weak var fridayImage: UIImageView!

	@IBOutlet var saturdayOpenOrCloseLabel: UILabel!
    @IBOutlet weak var saturdaySwitch: UISwitch!
    @IBOutlet var saturdayOpenLabel: UILabel!
    @IBOutlet var saturdayCloseLabel: UILabel!
    @IBOutlet var saturdayOpenHourLabel: UILabel!
	@IBOutlet var saturdayCloseHourLabel: UILabel!
    @IBOutlet var saturdayEditButton: UIButton!
    @IBOutlet weak var saturdayImage: UIImageView!
	
	@IBOutlet var sundayOpenOrCloseLabel: UILabel!
    @IBOutlet weak var sundaySwitch: UISwitch!
    @IBOutlet var sundayOpenLabel: UILabel!
    @IBOutlet var sundayCloseLabel: UILabel!
    @IBOutlet var sundayOpenHourLabel: UILabel!
	@IBOutlet var sundayCloseHourLabel: UILabel!
    @IBOutlet var sundayEditButton: UIButton!
    @IBOutlet weak var sundayImage: UIImageView!
    
    var isMondayTimeGreater:Bool = false
    var isTuesdayTimeGreater:Bool = false
    var isWednesdayTimeGreater:Bool = false
    var isThursdayTimeGreater:Bool = false
    var isFridayTimeGreater:Bool = false
    var isSaturdayTimeGreater:Bool = false
    var isSundayTimeGreater:Bool = false
	
	var superVc : BusinessRestaurantEditViewController!
	
	var toolBar = UIToolbar()
	var datePicker  = UIDatePicker()
	var dateBackgroundView = UIView()
	
	var spotModel : SpotModel!
	var selectedTime = 0
	var openOrClose = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
		self.setupVariables(isPicker: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        datePicker.removeFromSuperview()
        toolBar.removeFromSuperview()
        dateBackgroundView.removeFromSuperview()
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        hoursScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 900)
    }
	
	@IBAction func closeTapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func updateTapped(_ sender: Any) {
        if isMondayTimeGreater{
            
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please select the appropriate Monday time")
        }
        else if isTuesdayTimeGreater
        {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please select the appropriate Tuesday time")
        }
        else if isWednesdayTimeGreater
        {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please select the appropriate Wednesday time")
        }
        else if isThursdayTimeGreater
        {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please select the appropriate Thursday time")
        }
        else if isFridayTimeGreater
        {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please select the appropriate Friday time")
        }
        else if isSaturdayTimeGreater
        {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please select the appropriate Saturday time")
        }
        else if isSundayTimeGreater
        {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please select the appropriate Sunday time")
        }
        else
        {
            self.showLoadingHud()
            BusinessRestaurantDataSource().saveSpot(spotModel: self.spotModel) { (result) in
                switch(result){
                case .success(let str):
                    self.changeSuperVc()
                    self.hideAllHuds()
                    self.dismiss(animated: true, completion: nil)
                case .failure(let err):
                    self.showErrorHud(message: "Problem occured please try again")
                    self.hideAllHuds()
                }
            }
        }
        
	}
	
	func changeSuperVc(){
		self.superVc.spotModel = self.spotModel
		self.superVc.infoTableView.reloadData()
	}
	
    func setupVariables(isPicker:Bool){
		if(spotModel.operationhours.count < 7){
			spotModel.operationhours = [
				"open|09:00|17:00",
				"open|09:00|17:00",
				"open|09:00|17:00",
				"open|09:00|17:00",
				"open|09:00|17:00",
				"open|09:00|17:00",
				"open|09:00|17:00"
			]
		}
		
		let mondayHours = spotModel.operationhours[0].split(separator: "|")
		let tuesdayHours = spotModel.operationhours[1].split(separator: "|")
		let wednesdayHours = spotModel.operationhours[2].split(separator: "|")
		let thursdayHours = spotModel.operationhours[3].split(separator: "|")
		let fridayHours = spotModel.operationhours[4].split(separator: "|")
		let saturdayHours = spotModel.operationhours[5].split(separator: "|")
		let sundayHours = spotModel.operationhours[6].split(separator: "|")
		
		if(mondayHours[0] == "open"){
			
            mondayOpenLabel.textColor = UIColor(rgb: 0x797D8F)
            mondayCloseLabel.textColor = UIColor(rgb: 0x797D8F)
			mondayOpenHourLabel.textColor = UIColor(rgb: 0x000000)
			mondayCloseHourLabel.textColor = UIColor(rgb: 0x000000)
            mondayEditButton.setTitleColor(UIColor(rgb: 0xE76C42), for: .normal)
            mondayEditButton.layer.borderColor = UIColor(rgb: 0xE76C42).cgColor
            mondayImage.image = UIImage(named: "imageSeparator")
            mondayOpenHourLabel.text = mondayHours[1].description + " hrs"
            mondayCloseHourLabel.text = mondayHours[2].description + " hrs"
            if isPicker {
                
                if mondayHours[1] < mondayHours[2]{
                    isMondayTimeGreater = false
                }
                else if mondayHours[1] >= mondayHours[2]
                {
                    isMondayTimeGreater = true
                }
            }
            else
            {
                if mondayHours[1] < mondayHours[2]{
                    isMondayTimeGreater = false
                }
                else if mondayHours[1] >= mondayHours[2]
                {
                    isMondayTimeGreater = true
                }
            }
            
		}else{
			
            isMondayTimeGreater = false
            mondayOpenHourLabel.text = mondayHours[1].description + " hrs"
            mondayCloseHourLabel.text = mondayHours[2].description + " hrs"
            mondayOpenLabel.textColor = UIColor(rgb: 0xBEBEBE)
            mondayCloseLabel.textColor = UIColor(rgb: 0xBEBEBE)
			mondayOpenHourLabel.textColor = UIColor(rgb: 0xBEBEBE)
			mondayCloseHourLabel.textColor = UIColor(rgb: 0xBEBEBE)
            mondaySwitch.setOn(false, animated: true)
            mondaySwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            mondaySwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
            mondayEditButton.setTitleColor(UIColor(rgb: 0xBEBEBE), for: .normal)
            mondayEditButton.layer.borderColor = UIColor(rgb: 0xBEBEBE).cgColor
            mondayImage.image = UIImage(named: "imageUnSeparator")
		}
		
		if(tuesdayHours[0] == "open"){
			
            tuesdayOpenLabel.textColor = UIColor(rgb: 0x797D8F)
            tuesdayCloseLabel.textColor = UIColor(rgb: 0x797D8F)
			tuesdayOpenHourLabel.textColor = UIColor(rgb: 0x000000)
			tuesdayCloseHourLabel.textColor = UIColor(rgb: 0x000000)
            tuesdayEditButton.setTitleColor(UIColor(rgb: 0xE76C42), for: .normal)
            tuesdayEditButton.layer.borderColor = UIColor(rgb: 0xE76C42).cgColor
            tuesdayImage.image = UIImage(named: "imageSeparator")
            tuesdayOpenHourLabel.text = tuesdayHours[1].description + " hrs"
            tuesdayCloseHourLabel.text = tuesdayHours[2].description + " hrs"
            if isPicker {
                if tuesdayHours[1] < tuesdayHours[2]{
                    isTuesdayTimeGreater = false
                    
                }
                else if tuesdayHours[1] >= tuesdayHours[2]
                {
                    isTuesdayTimeGreater = true
                }
            }
            else
            {
                if tuesdayHours[1] < tuesdayHours[2]{
                    isTuesdayTimeGreater = false
                    
                }
                else if tuesdayHours[1] >= tuesdayHours[2]
                {
                    isTuesdayTimeGreater = true
                }
            }
		}else{
            
            isTuesdayTimeGreater = false
            tuesdayOpenHourLabel.text = tuesdayHours[1].description + " hrs"
            tuesdayCloseHourLabel.text = tuesdayHours[2].description + " hrs"
            tuesdayOpenLabel.textColor = UIColor(rgb: 0xBEBEBE)
            tuesdayCloseLabel.textColor = UIColor(rgb: 0xBEBEBE)
			tuesdayOpenHourLabel.textColor = UIColor(rgb: 0xBEBEBE)
			tuesdayCloseHourLabel.textColor = UIColor(rgb: 0xBEBEBE)
            tuesdaySwitch.setOn(false, animated: true)
            tuesdaySwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            tuesdaySwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
            tuesdayEditButton.setTitleColor(UIColor(rgb: 0xBEBEBE), for: .normal)
            tuesdayEditButton.layer.borderColor = UIColor(rgb: 0xBEBEBE).cgColor
            tuesdayImage.image = UIImage(named: "imageUnSeparator")
		}
		
		if(wednesdayHours[0] == "open"){
			
            wednesdayOpenLabel.textColor = UIColor(rgb: 0x797D8F)
            wednesdayCloseLabel.textColor = UIColor(rgb: 0x797D8F)
			wednesdayOpenHourLabel.textColor = UIColor(rgb: 0x000000)
			wednesdayCloseHourLabel.textColor = UIColor(rgb: 0x000000)
            wednesdayEditButton.setTitleColor(UIColor(rgb: 0xE76C42), for: .normal)
            wednesdayEditButton.layer.borderColor = UIColor(rgb: 0xE76C42).cgColor
            wednesdayImage.image = UIImage(named: "imageSeparator")
            wednesdayOpenHourLabel.text = wednesdayHours[1].description + " hrs"
            wednesdayCloseHourLabel.text = wednesdayHours[2].description + " hrs"
            if isPicker {
                if wednesdayHours[1] < wednesdayHours[2]{
                    isWednesdayTimeGreater = false
                    
                }
                else if wednesdayHours[1] >= wednesdayHours[2]
                {
                    isWednesdayTimeGreater = true
                }
            }
            else
            {
                if wednesdayHours[1] < wednesdayHours[2]{
                    isWednesdayTimeGreater = false
                    
                }
                else if wednesdayHours[1] >= wednesdayHours[2]
                {
                    isWednesdayTimeGreater = true
                }
            }
            
		}else{
			
            isWednesdayTimeGreater = false
            wednesdayOpenHourLabel.text = wednesdayHours[1].description + " hrs"
            wednesdayCloseHourLabel.text = wednesdayHours[2].description + " hrs"
            wednesdayOpenLabel.textColor = UIColor(rgb: 0xBEBEBE)
            wednesdayCloseLabel.textColor = UIColor(rgb: 0xBEBEBE)
			wednesdayOpenHourLabel.textColor = UIColor(rgb: 0xBEBEBE)
			wednesdayCloseHourLabel.textColor = UIColor(rgb: 0xBEBEBE)
            wednesdaySwitch.setOn(false, animated: true)
            wednesdaySwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            wednesdaySwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
            wednesdayEditButton.setTitleColor(UIColor(rgb: 0xBEBEBE), for: .normal)
            wednesdayEditButton.layer.borderColor = UIColor(rgb: 0xBEBEBE).cgColor
            wednesdayImage.image = UIImage(named: "imageUnSeparator")
		}
		
		if(thursdayHours[0] == "open"){
			
            thursdayOpenLabel.textColor = UIColor(rgb: 0x797D8F)
            thursdayCloseLabel.textColor = UIColor(rgb: 0x797D8F)
			thursdayOpenHourLabel.textColor = UIColor(rgb: 0x000000)
			thursdayCloseHourLabel.textColor = UIColor(rgb: 0x000000)
            thursdayEditButton.setTitleColor(UIColor(rgb: 0xE76C42), for: .normal)
            thursdayEditButton.layer.borderColor = UIColor(rgb: 0xE76C42).cgColor
            thursdayImage.image = UIImage(named: "imageSeparator")
            thursdayOpenHourLabel.text = thursdayHours[1].description + " hrs"
            thursdayCloseHourLabel.text = thursdayHours[2].description + " hrs"
            if isPicker {
                if thursdayHours[1] < thursdayHours[2]{
                    isThursdayTimeGreater = false
                    
                }
                else if thursdayHours[1] >= thursdayHours[2]
                {
                    isThursdayTimeGreater = true
                }
            }
            else
            {
                if thursdayHours[1] < thursdayHours[2]{
                    isThursdayTimeGreater = false
                    
                }
                else if thursdayHours[1] >= thursdayHours[2]
                {
                    isThursdayTimeGreater = true
                }
            }
            
		}else{
			
            isThursdayTimeGreater = false
            thursdayOpenHourLabel.text = thursdayHours[1].description + " hrs"
            thursdayCloseHourLabel.text = thursdayHours[2].description + " hrs"
            thursdayOpenLabel.textColor = UIColor(rgb: 0xBEBEBE)
            thursdayCloseLabel.textColor = UIColor(rgb: 0xBEBEBE)
			thursdayOpenHourLabel.textColor = UIColor(rgb: 0xBEBEBE)
			thursdayCloseHourLabel.textColor = UIColor(rgb: 0xBEBEBE)
            thursdaySwitch.setOn(false, animated: true)
            thursdaySwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            thursdaySwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
            thursdayEditButton.setTitleColor(UIColor(rgb: 0xBEBEBE), for: .normal)
            thursdayEditButton.layer.borderColor = UIColor(rgb: 0xBEBEBE).cgColor
            thursdayImage.image = UIImage(named: "imageUnSeparator")
		}
		
		if(fridayHours[0] == "open"){
			
            fridayOpenLabel.textColor = UIColor(rgb: 0x797D8F)
            fridayCloseLabel.textColor = UIColor(rgb: 0x797D8F)
			fridayOpenHourLabel.textColor = UIColor(rgb: 0x000000)
			fridayCloseHourLabel.textColor = UIColor(rgb: 0x000000)
            fridayEditButton.setTitleColor(UIColor(rgb: 0xE76C42), for: .normal)
            fridayEditButton.layer.borderColor = UIColor(rgb: 0xE76C42).cgColor
            fridayImage.image = UIImage(named: "imageSeparator")
            fridayOpenHourLabel.text = fridayHours[1].description + " hrs"
            fridayCloseHourLabel.text = fridayHours[2].description + " hrs"
            if isPicker {
                if fridayHours[1] < fridayHours[2]{
                    isFridayTimeGreater = false
                }
                else if fridayHours[1] >= fridayHours[2]
                {
                    isFridayTimeGreater = true
                }
            }
            else
            {
                if fridayHours[1] < fridayHours[2]{
                    isFridayTimeGreater = false
                }
                else if fridayHours[1] >= fridayHours[2]
                {
                    isFridayTimeGreater = true
                }
            }
		}else{
			
            isFridayTimeGreater = false
            fridayOpenHourLabel.text = fridayHours[1].description + " hrs"
            fridayCloseHourLabel.text = fridayHours[2].description + " hrs"
            fridayOpenLabel.textColor = UIColor(rgb: 0xBEBEBE)
            fridayCloseLabel.textColor = UIColor(rgb: 0xBEBEBE)
			fridayOpenHourLabel.textColor = UIColor(rgb: 0xBEBEBE)
			fridayCloseHourLabel.textColor = UIColor(rgb: 0xBEBEBE)
            fridaySwitch.setOn(false, animated: true)
            fridaySwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            fridaySwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
            fridayEditButton.setTitleColor(UIColor(rgb: 0xBEBEBE), for: .normal)
            fridayEditButton.layer.borderColor = UIColor(rgb: 0xBEBEBE).cgColor
            fridayImage.image = UIImage(named: "imageUnSeparator")
		}
		
		if(saturdayHours[0] == "open"){
			
            saturdayOpenLabel.textColor = UIColor(rgb: 0x797D8F)
            saturdayCloseLabel.textColor = UIColor(rgb: 0x797D8F)
			saturdayOpenHourLabel.textColor = UIColor(rgb: 0x000000)
			saturdayCloseHourLabel.textColor = UIColor(rgb: 0x000000)
            saturdayEditButton.setTitleColor(UIColor(rgb: 0xE76C42), for: .normal)
            saturdayEditButton.layer.borderColor = UIColor(rgb: 0xE76C42).cgColor
            saturdayImage.image = UIImage(named: "imageSeparator")
            saturdayOpenHourLabel.text = saturdayHours[1].description + " hrs"
            saturdayCloseHourLabel.text = saturdayHours[2].description + " hrs"
            if isPicker {
                if saturdayHours[1] < saturdayHours[2]{
                    isSaturdayTimeGreater = false
                    
                }
                else if saturdayHours[1] >= saturdayHours[2]
                {
                    isSaturdayTimeGreater = true
                }
            }
            else
            {
                if saturdayHours[1] < saturdayHours[2]{
                    isSaturdayTimeGreater = false
                    
                }
                else if saturdayHours[1] >= saturdayHours[2]
                {
                    isSaturdayTimeGreater = true
                }
            }
		}else{
			
            isSaturdayTimeGreater = false
            saturdayOpenHourLabel.text = saturdayHours[1].description + " hrs"
            saturdayCloseHourLabel.text = saturdayHours[2].description + " hrs"
            saturdayOpenLabel.textColor = UIColor(rgb: 0xBEBEBE)
            saturdayCloseLabel.textColor = UIColor(rgb: 0xBEBEBE)
			saturdayOpenHourLabel.textColor = UIColor(rgb: 0xBEBEBE)
			saturdayCloseHourLabel.textColor = UIColor(rgb: 0xBEBEBE)
            saturdaySwitch.setOn(false, animated: true)
            saturdaySwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            saturdaySwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
            saturdayEditButton.setTitleColor(UIColor(rgb: 0xBEBEBE), for: .normal)
            saturdayEditButton.layer.borderColor = UIColor(rgb: 0xBEBEBE).cgColor
            saturdayImage.image = UIImage(named: "imageUnSeparator")
		}
		
		if(sundayHours[0] == "open"){
			
            
            sundayOpenLabel.textColor = UIColor(rgb: 0x797D8F)
            sundayCloseLabel.textColor = UIColor(rgb: 0x797D8F)
			sundayOpenHourLabel.textColor = UIColor(rgb: 0x000000)
			sundayCloseHourLabel.textColor = UIColor(rgb: 0x000000)
            sundayEditButton.setTitleColor(UIColor(rgb: 0xE76C42), for: .normal)
            sundayEditButton.layer.borderColor = UIColor(rgb: 0xE76C42).cgColor
            sundayImage.image = UIImage(named: "imageSeparator")
            sundayOpenHourLabel.text = sundayHours[1].description + " hrs"
            sundayCloseHourLabel.text = sundayHours[2].description + " hrs"
            if isPicker {
                if sundayHours[1] < sundayHours[2]{
                    isSundayTimeGreater = false
                }
                else if sundayHours[1] >= sundayHours[2]
                {
                    isSundayTimeGreater = true
                }
            }
            else
            {
                if sundayHours[1] < sundayHours[2]{
                    isSundayTimeGreater = false
                }
                else if sundayHours[1] >= sundayHours[2]
                {
                    isSundayTimeGreater = true
                }
            }
		}else{
			
            isSundayTimeGreater = false
            sundayOpenHourLabel.text = sundayHours[1].description + " hrs"
            sundayCloseHourLabel.text = sundayHours[2].description + " hrs"
            sundayOpenLabel.textColor = UIColor(rgb: 0xBEBEBE)
            sundayCloseLabel.textColor = UIColor(rgb: 0xBEBEBE)
			sundayOpenHourLabel.textColor = UIColor(rgb: 0xBEBEBE)
			sundayCloseHourLabel.textColor = UIColor(rgb: 0xBEBEBE)
            sundaySwitch.setOn(false, animated: true)
            sundaySwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            sundaySwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
            sundayEditButton.setTitleColor(UIColor(rgb: 0xBEBEBE), for: .normal)
            sundayEditButton.layer.borderColor = UIColor(rgb: 0xBEBEBE).cgColor
            sundayImage.image = UIImage(named: "imageUnSeparator")
		}
    		
	}
	
	
	@IBAction func mondayOpenOrCloseTapped(_ sender: Any) {
		selectedTime = 0
		showOpenOrCloseAlert()
	}
	
	@IBAction func mondayCloseTapped(_ sender: Any) {
        if mondaySwitch.isOn {
            selectedTime = 0
            openOrClose = 0
            openTimePicker()
        }
	}
	
	@IBAction func mondayOpenTapped(_ sender: Any) {
        if mondaySwitch.isOn {
            selectedTime = 0
            openOrClose = 1
            openTimePicker()
        }
	}
	

	
	@IBAction func tuesdayOpenOrCloseTapped(_ sender: Any) {
		selectedTime = 1
		showOpenOrCloseAlert()
	}
	
	
	@IBAction func tuesdayCloseTapped(_ sender: Any) {
        if tuesdaySwitch.isOn {
            selectedTime = 1
            openOrClose = 0
            openTimePicker()
        }
	}
	
	@IBAction func tuesdayOpenTapped(_ sender: Any) {
        if tuesdaySwitch.isOn {
            selectedTime = 1
            openOrClose = 1
            openTimePicker()
        }
	}
	
	
	
	@IBAction func wednesdayOpenOrCloseTapped(_ sender: Any) {
		selectedTime = 2
		showOpenOrCloseAlert()
	}
	
	@IBAction func wednesdayCloseTapped(_ sender: Any) {
        if wednesdaySwitch.isOn {
            selectedTime = 2
            openOrClose = 0
            openTimePicker()
        }
	}
	
	@IBAction func wednesdayOpenHourTapped(_ sender: Any) {
        if wednesdaySwitch.isOn {
            selectedTime = 2
            openOrClose = 1
            openTimePicker()
        }
	}
	@IBAction func thursdayOpenOrClosedTapped(_ sender: Any) {
		selectedTime = 3
		showOpenOrCloseAlert()
	}
	
	@IBAction func thursdayOpenTapped(_ sender: Any) {
        if thursdaySwitch.isOn {
            selectedTime = 3
            openOrClose = 1
            openTimePicker()
        }
	}
	
	@IBAction func thursdayCloseTapped(_ sender: Any) {
        if thursdaySwitch.isOn {
            selectedTime = 3
            openOrClose = 0
            openTimePicker()
        }
	}
	
	@IBAction func fridayOpenOrCloseTapped(_ sender: Any) {
		selectedTime = 4
		showOpenOrCloseAlert()
	}
	
	@IBAction func fridayOpenTapped(_ sender: Any) {
        if fridaySwitch.isOn {
            selectedTime = 4
            openOrClose = 1
            openTimePicker()
        }
	}
	
	@IBAction func fridayCloseTapped(_ sender: Any) {
        if fridaySwitch.isOn {
            selectedTime = 4
            openOrClose = 0
            openTimePicker()
        }
	}
	
	@IBAction func saturdayOpenOrCloseTapped(_ sender: Any) {
		selectedTime = 5
		showOpenOrCloseAlert()
	}
	
	@IBAction func saturdayOpenTapped(_ sender: Any) {
        if saturdaySwitch.isOn {
            selectedTime = 5
            openOrClose = 1
            openTimePicker()
        }
		
	}
	
	@IBAction func saturdayCloseTapped(_ sender: Any) {
        if saturdaySwitch.isOn {
            selectedTime = 5
            openOrClose = 0
            openTimePicker()
        }
	}
	
	
	@IBAction func sundayOpenOrCloseTapped(_ sender: Any) {
		selectedTime = 6
		showOpenOrCloseAlert()
	}
	
	@IBAction func sundayOpenHoursTapped(_ sender: Any) {
        if sundaySwitch.isOn {
            selectedTime = 6
            openOrClose = 1
            openTimePicker()
        }
	}
	
	@IBAction func sundayCloseHoursTapped(_ sender: Any) {
        if sundaySwitch.isOn {
            selectedTime = 6
            openOrClose = 0
            openTimePicker()
        }
	}
	
	func openTimePicker() {
		self.onDoneButtonClick()
		toolBar.removeFromSuperview()
		datePicker.removeFromSuperview()
		
		datePicker.backgroundColor = UIColor.white
		
		var keyWindow : UIWindow!
		if #available(iOS 13.0, *) {
			keyWindow = UIApplication.shared.connectedScenes
				.filter({$0.activationState == .foregroundActive})
				.map({$0 as? UIWindowScene})
				.compactMap({$0})
				.first?.windows
				.filter({$0.isKeyWindow}).first
		} else {
			// Fallback on earlier versions
			keyWindow = UIApplication.shared.keyWindow!
		}
		
		keyWindow.overrideUserInterfaceStyle = .light
		
		datePicker = UIDatePicker.init()
		datePicker.backgroundColor = UIColor.white
		datePicker.tintColor = UIColor.black
		
		datePicker.setValue(UIColor.label, forKeyPath: "textColor")
		datePicker.autoresizingMask = .flexibleWidth
		
		if #available(iOS 13.4, *) {
			datePicker.preferredDatePickerStyle = .wheels
		}
		
		let label = UILabel(frame: .zero)
		
		datePicker.datePickerMode = .time

		datePicker.addTarget(self, action: #selector(self.timeChanged(_:)), for: .valueChanged)
		datePicker.frame = CGRect(x: 0.0, y: 0, width: UIScreen.main.bounds.size.width, height: 300)
		dateBackgroundView = UIView(frame: CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300))
		dateBackgroundView.backgroundColor = UIColor.white
		dateBackgroundView.addSubview(datePicker)
		keyWindow!.addSubview(dateBackgroundView)

		toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))

		if(selectedTime == 0){
            if openOrClose == 0{
                label.text = "Monday Closes at"
            }
            else if openOrClose == 1
            {
                label.text = "Monday Opens at"
            }
			
		}else if(selectedTime == 1){
            if openOrClose == 0{
                label.text = "Tuesday Closes at"
            }
            else if openOrClose == 1
            {
                label.text = "Tuesday Opens at"
            }
		}else if(selectedTime == 2){
            if openOrClose == 0{
                label.text = "Wednesday Closes at"
            }
            else if openOrClose == 1
            {
                label.text = "Wednesday Opens at"
            }
		}else if(selectedTime == 3){
            if openOrClose == 0{
                label.text = "Thursday Closes at"
            }
            else if openOrClose == 1
            {
                label.text = "Thursday Opens at"
            }
		}else if(selectedTime == 4){
            if openOrClose == 0{
                label.text = "Friday Closes at"
            }
            else if openOrClose == 1
            {
                label.text = "Friday Opens at"
            }
		}else if(selectedTime == 5){
            if openOrClose == 0{
                label.text = "Saturday Closes at"
            }
            else if openOrClose == 1
            {
                label.text = "Saturday Opens at"
            }
		}else if(selectedTime == 6){
            if openOrClose == 0{
                label.text = "Sunday Closes at"
            }
            else if openOrClose == 1
            {
                label.text = "Sunday Opens at"
            }
		}
		label.textAlignment = .center
		label.textColor = UIColor.black
		let customBarButton = UIBarButtonItem(customView: label)
		let rightSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		
		toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), customBarButton, rightSpace, UIBarButtonItem(title: "   " + "Done" + "  ", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
		
		toolBar.sizeToFit()
		toolBar.barTintColor = UIColor.white
		keyWindow!.addSubview(toolBar)
	}
	
	@objc func onDoneButtonClick() {
		toolBar.removeFromSuperview()
		dateBackgroundView.removeFromSuperview()
	}
	
	@objc func timeChanged(_ sender: UIDatePicker?) {
		if(self.openOrClose == 0){
			let dateFormatterPrint = DateFormatter()
			dateFormatterPrint.dateFormat = "HH:mm"
			let splited = spotModel.operationhours[self.selectedTime].split(separator: "|")
			let combinedTime = splited[0].description + "|" + splited[1].description + "|" + dateFormatterPrint.string(from: sender!.date)
			spotModel.operationhours[self.selectedTime] = combinedTime
		}else if(self.openOrClose == 1){
			let dateFormatterPrint = DateFormatter()
			dateFormatterPrint.dateFormat = "HH:mm"
			let splited = spotModel.operationhours[self.selectedTime].split(separator: "|")
			let combinedTime = splited[0].description + "|" + dateFormatterPrint.string(from: sender!.date) + "|" + splited[2].description
			spotModel.operationhours[self.selectedTime] = combinedTime
		}
		setupVariables(isPicker: true)
	}
	
	func showOpenOrCloseAlert(){
		let alert = UIAlertController(title: "Open Or Close", message: nil, preferredStyle: .actionSheet)
		
		alert.addAction(UIAlertAction(title: "Open", style: .default , handler:{ (UIAlertAction)in
			let splited = self.spotModel.operationhours[self.selectedTime].split(separator: "|")
			let combinedTime = "open" + "|" + splited[1].description + "|" + splited[2].description
			self.spotModel.operationhours[self.selectedTime] = combinedTime
			self.setupVariables(isPicker: false)
		}))
		
		alert.addAction(UIAlertAction(title: "Close", style: .default , handler:{ (UIAlertAction)in
			let splited = self.spotModel.operationhours[self.selectedTime].split(separator: "|")
			let combinedTime = "close" + "|" + splited[1].description + "|" + splited[2].description
			self.spotModel.operationhours[self.selectedTime] = combinedTime
			self.setupVariables(isPicker: false)
		}))
		//uncomment for iPad Support
		alert.popoverPresentationController?.sourceView = self.view

		self.present(alert, animated: true, completion: {
			print("completion block")
		})
	}
    func openRestaurant()  {
        
        let splited = self.spotModel.operationhours[self.selectedTime].split(separator: "|")
        let combinedTime = "open" + "|" + splited[1].description + "|" + splited[2].description
        self.spotModel.operationhours[self.selectedTime] = combinedTime
        self.setupVariables(isPicker: false)
    }
    func closeRestaurant()  {
        
        let splited = self.spotModel.operationhours[self.selectedTime].split(separator: "|")
        let combinedTime = "close" + "|" + splited[1].description + "|" + splited[2].description
        self.spotModel.operationhours[self.selectedTime] = combinedTime
        self.setupVariables(isPicker: false)
    }
    
    @IBAction func didClickEdit(_ sender: UIButton) {
        
        if sender.tag == 1 {
            if mondaySwitch.isOn {
                mondayOpenTapped(1)
            }
            
        }
        else if sender.tag == 2 {
            if tuesdaySwitch.isOn {
                tuesdayOpenTapped(2)
            }
           
        }
        else if sender.tag == 3 {
            if wednesdaySwitch.isOn {
                wednesdayOpenHourTapped(3)
            }
            
        }
        else if sender.tag == 4 {
            if thursdaySwitch.isOn {
                thursdayOpenTapped(4)
            }
            
        }
        else if sender.tag == 5 {
            if fridaySwitch.isOn {
                fridayOpenTapped(5)
            }
            
        }
        else if sender.tag == 6 {
            if saturdaySwitch.isOn {
                saturdayOpenTapped(6)
            }
            
        }
        else if sender.tag == 7 {
            if sundaySwitch.isOn {
                sundayOpenHoursTapped(7)
            }
            
        }
    }
    @IBAction func openOrCloseSwitch(_ sender: UISwitch) {
        if sender.tag == 1 {
            selectedTime = 0
            if mondaySwitch.isOn {
                mondaySwitch.thumbTintColor = mondaySwitch.isOn ? UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                openRestaurant()
            }
            else
            {
                mondaySwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                mondaySwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
                closeRestaurant()
            }
            
        }
        else if sender.tag == 2 {
            selectedTime = 1
            if tuesdaySwitch.isOn {
                tuesdaySwitch.thumbTintColor = tuesdaySwitch.isOn ? UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                openRestaurant()
            }
            else
            {
                tuesdaySwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                tuesdaySwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
                closeRestaurant()
            }
            
        }
        else if sender.tag == 3 {
            selectedTime = 2
            if wednesdaySwitch.isOn {
                wednesdaySwitch.thumbTintColor = wednesdaySwitch.isOn ? UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                openRestaurant()
            }
            else
            {
                wednesdaySwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                wednesdaySwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
                closeRestaurant()
            }
        }
        else if sender.tag == 4 {
            selectedTime = 3
            if thursdaySwitch.isOn {
                thursdaySwitch.thumbTintColor = thursdaySwitch.isOn ? UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                openRestaurant()
            }
            else
            {
                thursdaySwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                thursdaySwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
                closeRestaurant()
            }
        }
        else if sender.tag == 5 {
            selectedTime = 4
            if fridaySwitch.isOn {
                fridaySwitch.thumbTintColor = fridaySwitch.isOn ? UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                openRestaurant()
            }
            else
            {
                fridaySwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                fridaySwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
                closeRestaurant()
            }
        }
        else if sender.tag == 6 {
            selectedTime = 5
            if saturdaySwitch.isOn {
                saturdaySwitch.thumbTintColor = saturdaySwitch.isOn ? UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                openRestaurant()
            }
            else
            {
                saturdaySwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                saturdaySwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
                closeRestaurant()
            }
        }
        else if sender.tag == 7 {
            selectedTime = 6
            if sundaySwitch.isOn {
                sundaySwitch.thumbTintColor = sundaySwitch.isOn ? UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                openRestaurant()
            }
            else
            {
                sundaySwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                sundaySwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
                closeRestaurant()
            }
        }
    }
    
	
}
