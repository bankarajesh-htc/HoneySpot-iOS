//
//  DeliveryPartnerViewController.swift
//  HoneySpot
//
//  Created by htcuser on 22/10/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class DeliveryPartnerViewController: UIViewController {
    
    @IBOutlet var grubhubImage: UIImageView!
    @IBOutlet weak var grubHubSelectedImage: UIImageView!
    @IBOutlet var doordashImage: UIImageView!
    @IBOutlet weak var doordashSelectedImage: UIImageView!
    @IBOutlet var ubereatsImage: UIImageView!
    @IBOutlet weak var uberEatsSelectedImage: UIImageView!
    @IBOutlet var postmatesImage: UIImageView!
    @IBOutlet weak var postmatesSelectedImage: UIImageView!
    
    var spotModel : SpotModel!
    var selectedServices = [String]()
    var selectedDeliveryServices = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
//        selectedServices = spotModel.deliveryOptions?.filter({ $0 != "uber-eats" && $0 != "grubhub" && $0 != "doordash" && $0 != "postmates" }) ?? []
        selectedDeliveryServices = spotModel.deliveryOptions?.filter({ $0 != "dine-in" && $0 != "take-out" && $0 != "catering" && $0 != "delivery" }) ?? []
        
        configureDeliveryImages()

        // Do any additional setup after loading the view.
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
        showLoadingHud()
        var services = [String]()

        for d in self.selectedDeliveryServices {
            if(!services.contains(d)){
                services.append(d)
            }
        }
        spotModel.deliveryOptions = services
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
    
    
    @IBAction func grubhubTapped(_ sender: Any) {
        if(selectedDeliveryServices.contains("grubhub")){
            selectedDeliveryServices = selectedDeliveryServices.filter({ $0 != "grubhub" })
        }else{
            selectedDeliveryServices.append("grubhub")
        }
        configureDeliveryImages()
    }
    
    @IBAction func doordashTapped(_ sender: Any) {
        if(selectedDeliveryServices.contains("doordash")){
            selectedDeliveryServices = selectedDeliveryServices.filter({ $0 != "doordash" })
        }else{
            selectedDeliveryServices.append("doordash")
        }
        configureDeliveryImages()
    }
    
    @IBAction func ubereatsTapped(_ sender: Any) {
        if(selectedDeliveryServices.contains("uber-eats")){
            selectedDeliveryServices = selectedDeliveryServices.filter({ $0 != "uber-eats" })
        }else{
            selectedDeliveryServices.append("uber-eats")
        }
        configureDeliveryImages()
    }
    
    @IBAction func postmatesTapped(_ sender: Any) {
        if(selectedDeliveryServices.contains("postmates")){
            selectedDeliveryServices = selectedDeliveryServices.filter({ $0 != "postmates" })
        }else{
            selectedDeliveryServices.append("postmates")
        }
        configureDeliveryImages()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
