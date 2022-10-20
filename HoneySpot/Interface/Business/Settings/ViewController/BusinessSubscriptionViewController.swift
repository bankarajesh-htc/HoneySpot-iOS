//
//  BusinessSubscriptionViewController.swift
//  HoneySpot
//
//  Created by htcuser on 09/11/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit
import StoreKit

class BusinessSubscriptionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var isSelected = true
    
    @IBOutlet weak var subcriptionTableView: UITableView!
    @IBOutlet weak var upgradeButton: UIButton!
    var plans:String!
    var price = 9.99
    var selectedRow: Int?
    var subscriptionName = ["Free","Gold"]
    var rate = ["$0","$10"]
    var freeFeature = ["Analytics Dashbaord","Edit Detail Page"]
    var goldFeature = ["All of Free","Send Announcements to Honeyspotters","Link to Reservations"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setUpViews()
        // Do any additional setup after loading the view.
    }
    
    func setUpViews() {
        if AppDelegate.originalDelegate.isFree {
            
            upgradeButton.backgroundColor = UIColor(rgb: 0xF96332)
            upgradeButton.isUserInteractionEnabled = false
            selectedRow = 0
            
        }
        else
        {
            upgradeButton.backgroundColor = UIColor(rgb: 0xF96332)
            upgradeButton.isUserInteractionEnabled = true
            selectedRow = 1
            
        }
    }
    
    @IBAction func didClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClickUpgrade(_ sender: Any) {
        //API Call
        
        let alert: UIAlertController = UIAlertController(
            title: "Upgrade Now",
            message: "Are you sure you want to upgrade your account?",
            preferredStyle: .alert)
        
        //Add Buttons
        let yesButton: UIAlertAction = UIAlertAction(
            title: "Upgrade",
            style: .default) { (action: UIAlertAction) in
            if self.plans == "premium" {
                
//                let viewController = self.AdminViewControllerInstance()
//                self.navigationController?.pushViewController(viewController, animated: true)
                self.performSegue(withIdentifier: "showPayment", sender: nil)
            }
            else
            {
                
            }
            ProfileDataSource().subscription(plans: self.plans, price: self.price) { (result) in
                self.hideAllHuds()
                switch(result){
                case .success(let plan):
                    DispatchQueue.main.async {
                    }
                    self.showAlert(title: "HoneySpot", message: "Upgraded Successfully")
                case .failure(let err):
                    print(err.localizedDescription)
                    HSAlertView.showAlert(withTitle: "HoneySpot", message: err.errorMessage)
                }
            }
            

        }
        
        let noButton: UIAlertAction = UIAlertAction(
            title: "Cancel",
            style: .cancel) { (action: UIAlertAction) in
        }
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
        
        
    }
    func showAlert(title:String,message:String) {
        let alert: UIAlertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        //Add Buttons
        let yesButton: UIAlertAction = UIAlertAction(
            title: "Ok",
            style: .default) { (action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)

        }
        
        let noButton: UIAlertAction = UIAlertAction(
            title: "Cancel",
            style: .cancel) { (action: UIAlertAction) in
        }
        
        alert.addAction(yesButton)
        //alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subcriptionCellId") as! BusinessSubscriptionTableViewCell
        cell.subcriptionNameLabel.text = subscriptionName[indexPath.row]
        cell.subcriptionPayment.text = rate[indexPath.row]
        if indexPath.row == 0 {
            cell.featureLabel1.text = freeFeature[0]
            cell.featureLabel2.text = freeFeature[1]
            cell.subcriptionMonthlyLabel.text = "/ yearly"
            cell.featureLabel3.isHidden = true
            cell.descriptionView.isHidden = true
        }
        else if indexPath.row == 1
        {
            cell.featureLabel1.text = goldFeature[0]
            cell.featureLabel2.text = goldFeature[1]
            cell.featureLabel3.text = goldFeature[2]
            cell.subcriptionMonthlyLabel.text = "/ monthly"
            cell.featureLabel3.isHidden = false
            cell.descriptionView.isHidden = false
        }
        
        cell.layer.masksToBounds = true
        cell.layer.masksToBounds = false
        cell.layer.shadowOpacity = 0.23
        cell.layer.shadowRadius = 4
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        if indexPath.row == selectedRow {
            cell.selectionImage.isHidden = false
            cell.subcriptionOuterView.borderWidth = 1.0
            cell.subcriptionOuterView.borderColor = UIColor(rgb: 0x049A22)
        }
        else
        {
            cell.selectionImage.isHidden = true
            cell.subcriptionOuterView.borderWidth = 0.0
            cell.subcriptionOuterView.borderColor = UIColor.clear
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0  {
           plans = "free"
            isSelected = true
            upgradeButton.backgroundColor = UIColor(rgb: 0xF96332) //UIColor(rgb: 0xD1D1D1)
            upgradeButton.isUserInteractionEnabled = true
        }
        else
        {
            plans = "premium"
            upgradeButton.backgroundColor = UIColor(rgb: 0xF96332)
            upgradeButton.isUserInteractionEnabled = true
            
        }
        selectedRow = indexPath.row
        subcriptionTableView.reloadData()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
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


