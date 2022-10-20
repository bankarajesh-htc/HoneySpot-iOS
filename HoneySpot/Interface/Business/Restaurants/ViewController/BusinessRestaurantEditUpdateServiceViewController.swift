//
//  BusinessRestaurantEditUpdateServiceViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 25.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class BusinessRestaurantEditUpdateServiceViewController: UIViewController {

	
    
    @IBOutlet weak var dineInSwitch: UISwitch!
    @IBOutlet weak var takeOutSwitch: UISwitch!
    @IBOutlet weak var cateringSwitch: UISwitch!
    @IBOutlet weak var deliverySwitch: UISwitch!
    
    @IBOutlet var grubhubImage: UIImageView!
    @IBOutlet weak var grubHubSelectedImage: UIImageView!
    @IBOutlet var doordashImage: UIImageView!
    @IBOutlet weak var doordashSelectedImage: UIImageView!
    @IBOutlet var ubereatsImage: UIImageView!
    @IBOutlet weak var uberEatsSelectedImage: UIImageView!
    @IBOutlet var postmatesImage: UIImageView!
    @IBOutlet weak var postmatesSelectedImage: UIImageView!
    
	@IBOutlet var dineInCheckImage: UIImageView!
	@IBOutlet var takeoutCheckImage: UIImageView!
	@IBOutlet var cateringCheckImage: UIImageView!
	@IBOutlet var deliveryCheckImage: UIImageView!
    
	
	var spotModel : SpotModel!
	var selectedServices = [String]()
	var selectedDeliveryServices = [String]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
		selectedServices = spotModel.deliveryOptions?.filter({ $0 != "uber-eats" && $0 != "grubhub" && $0 != "doordash" && $0 != "postmates" }) ?? []
		selectedDeliveryServices = spotModel.deliveryOptions?.filter({ $0 != "dine-in" && $0 != "take-out" && $0 != "catering" && $0 != "delivery" }) ?? []
		
		configureDeliveryImages()
		configureServices()
    }
	
	func configureServices(){
        
        dineInSwitch.thumbTintColor = dineInSwitch.isOn ? UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        takeOutSwitch.thumbTintColor = takeOutSwitch.isOn ? UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        cateringSwitch.thumbTintColor = cateringSwitch.isOn ? UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        deliverySwitch.thumbTintColor = deliverySwitch.isOn ? UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        
		if(selectedServices.contains("dine-in")){
            dineInSwitch.setOn(true, animated: true)
		}else{
            dineInSwitch.setOn(false, animated: true)
            dineInSwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            dineInSwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
		}
		if(selectedServices.contains("take-out")){
            takeOutSwitch.setOn(true, animated: true)
		}else{
            takeOutSwitch.setOn(false, animated: true)
            takeOutSwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            takeOutSwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
		}
		if(selectedServices.contains("catering")){
            cateringSwitch.setOn(true, animated: true)
		}else{
            cateringSwitch.setOn(false, animated: true)
            cateringSwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            cateringSwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
		}
		if(selectedServices.contains("delivery")){
            deliverySwitch.setOn(true, animated: true)
		}else{
            deliverySwitch.setOn(false, animated: true)
            deliverySwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            deliverySwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
		}
	}
	
	func configureDeliveryImages(){
		if(selectedDeliveryServices.contains("uber-eats")){
			ubereatsImage.image = UIImage(named: "ubereats-selected")
            uberEatsSelectedImage.isHidden = false
		}else{
			ubereatsImage.image = UIImage(named: "ubereats-unselected")
            uberEatsSelectedImage.isHidden = true
		}
		if(selectedDeliveryServices.contains("grubhub")){
			grubhubImage.image = UIImage(named: "grubhub-selected")
            grubHubSelectedImage.isHidden = false
		}else{
			grubhubImage.image = UIImage(named: "grubhub-unselected")
            grubHubSelectedImage.isHidden = true
		}
		if(selectedDeliveryServices.contains("doordash")){
			doordashImage.image = UIImage(named: "doordash-selected")
            doordashSelectedImage.isHidden = false
		}else{
			doordashImage.image = UIImage(named: "doordash-unselected")
            doordashSelectedImage.isHidden = true
		}
		if(selectedDeliveryServices.contains("postmates")){
			postmatesImage.image = UIImage(named: "postmates-selected")
            postmatesSelectedImage.isHidden = false
		}else{
			postmatesImage.image = UIImage(named: "postmates-unselected")
            postmatesSelectedImage.isHidden = true
		}
	}
    
	@IBAction func closeTapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func updateTapped(_ sender: Any) {
		var services = [String]()
		for d in self.selectedServices {
			if(!services.contains(d)){
				services.append(d)
			}
		}
        if deliverySwitch.isOn
        {
            if selectedDeliveryServices.count > 0 {
                for d in self.selectedDeliveryServices {
                    if(!services.contains(d)){
                        services.append(d)
                    }
                }
                spotModel.deliveryOptions = services
                self.callSaveSpot(spotModel: spotModel)
                
            }
            else
            {
                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Kindly select the appropriate delivery option")
            }
        }
        else
        {
            spotModel.deliveryOptions = services
            self.callSaveSpot(spotModel: spotModel)
            
        }
	}
    func callSaveSpot(spotModel:SpotModel)  {
        showLoadingHud()
        BusinessRestaurantDataSource().saveSpot(spotModel: spotModel) { (result) in
            self.hideAllHuds()
            switch(result){
            case .success(let str):
                print(str)
                NotificationCenter.default.post(name: NSNotification.Name.init("dataChanged"), object: nil)
                self.dismiss(animated: true, completion: nil)
            case .failure(let err):
                print(err.localizedDescription)
                self.showErrorHud(message: err.localizedDescription)
            }
        }
    }
	
	@IBAction func dineInTapped(_ sender: Any) {
		if(selectedServices.contains("dine-in")){
			selectedServices = selectedServices.filter({ $0 != "dine-in" })
		}else{
			selectedServices.append("dine-in")
		}
		configureServices()
	}
	
	@IBAction func takeoutTapped(_ sender: Any) {
		if(selectedServices.contains("take-out")){
			selectedServices = selectedServices.filter({ $0 != "take-out" })
		}else{
			selectedServices.append("take-out")
		}
		configureServices()
	}
	
	@IBAction func cateringTapped(_ sender: Any) {
		if(selectedServices.contains("catering")){
			selectedServices = selectedServices.filter({ $0 != "catering" })
		}else{
			selectedServices.append("catering")
		}
		configureServices()
	}
	
	@IBAction func deliveryTapped(_ sender: Any) {
		if(selectedServices.contains("delivery")){
			selectedServices = selectedServices.filter({ $0 != "delivery" })
		}else{
			selectedServices.append("delivery")
		}
		configureServices()
	}
	
	
	
	@IBAction func grubhubTapped(_ sender: Any) {
        if deliverySwitch.isOn {
            if(selectedDeliveryServices.contains("grubhub")){
                selectedDeliveryServices = selectedDeliveryServices.filter({ $0 != "grubhub" })
            }else{
                selectedDeliveryServices.append("grubhub")
            }
            configureDeliveryImages()
        }
        else
        {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Kindly select the delivery option to proceed further")
        }
		
	}
	
	@IBAction func doordashTapped(_ sender: Any) {
        if deliverySwitch.isOn {
            if(selectedDeliveryServices.contains("doordash")){
                selectedDeliveryServices = selectedDeliveryServices.filter({ $0 != "doordash" })
            }else{
                selectedDeliveryServices.append("doordash")
            }
            configureDeliveryImages()
            
        }
        else
        {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Kindly select the delivery option to proceed further")
        }
		
	}
	
	@IBAction func ubereatsTapped(_ sender: Any) {
        if deliverySwitch.isOn {
            if(selectedDeliveryServices.contains("uber-eats")){
                selectedDeliveryServices = selectedDeliveryServices.filter({ $0 != "uber-eats" })
            }else{
                selectedDeliveryServices.append("uber-eats")
            }
            configureDeliveryImages()
        }
        else
        {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Kindly select the delivery option to proceed further")
        }
		
	}
	
	@IBAction func postmatesTapped(_ sender: Any) {
        if deliverySwitch.isOn {
            if(selectedDeliveryServices.contains("postmates")){
                selectedDeliveryServices = selectedDeliveryServices.filter({ $0 != "postmates" })
            }else{
                selectedDeliveryServices.append("postmates")
            }
            configureDeliveryImages()
        }
        else
        {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Kindly select the delivery option to proceed further")
        }
		
	}
    
    
    @IBAction func didChangeDineIn(_ sender: UISwitch) {
        
        if sender.tag == 1 {
            dineInSwitch.thumbTintColor = dineInSwitch.isOn ? UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            if sender.isOn {
                selectedServices.append("dine-in")
            }
            else
            {
                selectedServices = selectedServices.filter({ $0 != "dine-in" })
            }
            configureServices()
        }
        else if sender.tag == 2 {
            takeOutSwitch.thumbTintColor = takeOutSwitch.isOn ? UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            if sender.isOn {
                selectedServices.append("take-out")
            }
            else
            {
                selectedServices = selectedServices.filter({ $0 != "take-out" })
                takeOutSwitch.thumbTintColor = UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                takeOutSwitch.tintColor = UIColor.init(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
            }
            configureServices()
         }
        else if sender.tag == 3 {
            cateringSwitch.thumbTintColor = cateringSwitch.isOn ? UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            if sender.isOn {
                selectedServices.append("catering")
            }
            else
            {
                selectedServices = selectedServices.filter({ $0 != "catering" })
            }
            configureServices()
        }
        else if sender.tag == 4 {
            deliverySwitch.thumbTintColor = deliverySwitch.isOn ? UIColor.init(red: 255.0/255.0, green: 125.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            if sender.isOn {
                selectedServices.append("delivery")
            }
            else
            {
                selectedServices = selectedServices.filter({ $0 != "delivery" })
                selectedDeliveryServices.removeAll()
                configureDeliveryImages()
            }
            configureServices()
        }
        
    }
    
}
