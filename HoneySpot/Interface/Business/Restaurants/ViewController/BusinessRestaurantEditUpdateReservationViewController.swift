//
//  BusinessRestaurantEditUpdateReservationViewController.swift
//  HoneySpot
//
//  Created by Chandramouli on 23/12/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class BusinessRestaurantEditUpdateReservationViewController: UIViewController {
    @IBOutlet var descriptionTextField: UITextView!
    @IBOutlet var restaurantTextfield: UITextField!
    
    var spotModel :SpotModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        // Do any additional setup after loading the view.
    }
    
    func setupViews(){
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        restaurantTextfield.text = spotModel.spotreservationlink
        descriptionTextField.text = spotModel.spotreservationdescription
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateTapped(_ sender: Any) {
        showLoadingHud()
        spotModel.spotreservationlink = restaurantTextfield.text ?? ""
        spotModel.spotreservationdescription = descriptionTextField.text ?? ""
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
