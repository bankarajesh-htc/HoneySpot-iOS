//
//  AdminViewController.swift
//  HoneySpot
//
//  Created by htcuser on 23/11/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

protocol AdminTableViewCellDelegate : AnyObject {
    func didPressButton(_ tag: [Int])
    func didClickStatus(_ selectedType: String)
    func didShowDetailPage(_ adminModel: AdminModel,selectedType: String,selectedID:[Int])
}
protocol AdminApprovalStatusTableViewCellDelegate : AnyObject {
    func didTapStatus(_ approvalStatus: String)
}
class AdminViewController: UIViewController, AdminTableViewCellDelegate, AdminApprovalStatusTableViewCellDelegate {
    
    
    
    
    var selectedRestaurant = [String]()
    var adminModel = [AdminModel]()
    var selectedType = "newrequest"
    
    @IBOutlet var adminTableView: UITableView!
    @IBOutlet var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        var navTitle: NSMutableAttributedString = NSMutableAttributedString(string: "HoneySpot For Admin")
        navTitle = NSMutableAttributedString(string: "Honey", attributes:[
            NSAttributedString.Key.font: UIFont.fontMonsterratBold(withSize: 24),
            NSAttributedString.Key.foregroundColor: UIColor.ORANGE_COLOR])
        navTitle.append(NSMutableAttributedString(string: "Spot", attributes:[
            NSAttributedString.Key.font: UIFont.fontMonsterratBold(withSize: 24),
            NSAttributedString.Key.foregroundColor: UIColor.YELLOW_COLOR]))
        navTitle.append(NSMutableAttributedString(string: " For Admin", attributes:[
            NSAttributedString.Key.font: UIFont.fontMonsterratRegular(withSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.BLACK_COLOR]))
        titleLabel.attributedText = navTitle

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedType = "newrequest"
        didClickStatus(selectedType)
        //1. Get New Claims
       // getClaims(isPending: true, isVerified: false, isDenied: false)
    }
    //MARK: - Web Service Call For Fetching All Status 
    func getClaims(isPending: Bool, isVerified: Bool, isDenied: Bool)  {
        self.showLoadingHud()
        AdminDatasource().getClaimList(isPending: isPending, isVerified: isVerified, isDenied: isDenied, completion: { (result) in
            switch(result)
            {
            case .success(let adminModel):
                
                self.adminModel = adminModel
                self.hideAllHuds()
                if self.selectedType == "newrequest" {
                    
                }
                else if self.selectedType == "newrequest" {
                    
                }
                else if self.selectedType == "newrequest" {
                    
                }
                
                self.adminTableView.reloadData()
                
                print(adminModel)
            case .failure(let error):
                self.hideAllHuds()
                print(error)
            }
            
        })
    }
    
    func scrollToTop() {
        // 1
        let topRow = IndexPath(row: 0,
                               section: 0)
                               
        // 2
        self.adminTableView.scrollToRow(at: topRow,
                                   at: .top,
                                   animated: true)
    }
    
    //MARK: - Web Service Call For Approval / Rejected
    func didTapStatus(_ approvalStatus: String) {
        if selectedRestaurant.count > 0
        {
            var isVerified = false
            var isDenied = false
            if approvalStatus == "Approve" {
                
                isVerified = true
                isDenied = false
            }
            else
            {
                isVerified = false
                isDenied = true
            }
            self.showLoadingHud()
            AdminDatasource().updateClaimStatus(spotId: selectedRestaurant, isVerified: isVerified, isDenied: isDenied) { [weak self] (result) in
                guard let self = self else { return }
                self.selectedRestaurant.removeAll()
                switch(result)
                {
                case .success(let claimList):
                    self.hideAllHuds()
                    print(claimList)
                    HSAlertView.showAlert(withTitle: "HoneySpot", message: "Updated Succuessfully")
                    self.scrollToTop()
                    self.getClaims(isPending: true, isVerified: false, isDenied: false)
                case .failure(let error):
                    self.hideAllHuds()
                    print(error)
                    HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please try again")
                }
            }
        }
        else
        {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please select atleast any one restaurant to proceed further")
        }
        
    }
    
    //MARK: - Select Restaurant for Status
    func didPressButton(_ tag: [Int]) {
        selectedRestaurant.removeAll()
        for i in tag {
           let spotId = self.adminModel[i]
            print(spotId.spot.id)
            selectedRestaurant.append(spotId.spot.id)
        }

        
        print("Tag\(tag)")
    }
    //MARK: - Click Status
    func didClickStatus(_ selectedType: String) {
        self.selectedType = selectedType
        selectedRestaurant.removeAll()
        if selectedType == "newrequest" {
            getClaims(isPending: true, isVerified: false, isDenied: false)
        }
        else if selectedType == "approved" {
            getClaims(isPending: false, isVerified: true, isDenied: false)
        }
        else if selectedType == "rejected" {
            getClaims(isPending: false, isVerified: false, isDenied: true)
        }
    }
    //MARK: - Show Detail Page of Admin
    func didShowDetailPage(_ adminModel: AdminModel, selectedType: String, selectedID: [Int]) {
        let viewController = self.DetailAdminViewControllerInstance()
        viewController.adminModel = adminModel
        viewController.selectedID = selectedID
        viewController.selectedType = selectedType
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func logoutAdmin(_ sender: Any) {
        
        UIViewController.LOGIN_NAVIGATIONCONTROLLER.popToRootViewController(animated: false)
        UIViewController.APP_DELEGATE_INSTANCE.window?.rootViewController = .LOGIN_NAVIGATIONCONTROLLER
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
extension AdminViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedType == "newrequest" {
            return 3
        }
        else
        {
            return 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "honeyspottedCellId") as! HoneySpottedRestaurantTableViewCell
            cell.honeySpottedRestaurantLabel.text = "\(AppDelegate.originalDelegate.honeyspots)"
            return cell
        }else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "overviewCellId") as! AdminOverViewTableViewCell
            cell.adminModel = self.adminModel
            if selectedRestaurant.count == 0 {
                cell.selectedID.removeAll()
            }
            if self.adminModel.count > 0 {
                cell.noDataLabel.isHidden = true
                cell.adminOverviewTableView.isHidden = false
                cell.adminOverviewTableView.reloadData()
            }
            else
            {
                cell.noDataLabel.isHidden = false
                cell.adminOverviewTableView.isHidden = true
                if self.selectedType == "newrequest"{
                    cell.noDataLabel.text = "No New Data Available"
                }
                else if self.selectedType == "approved"
                {
                    cell.noDataLabel.text = "No Approved Data Available"
                }
                else
                {
                    cell.noDataLabel.text = "No Rejected Data Available"
                }
                
            }
            cell.selectedType = selectedType
            cell.prepareCell()
            cell.cellDelegate = self
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "approvalCellId") as! ApprovalTableViewCell
            cell.cellDelegate = self
            if self.selectedType == "newrequest"{
                if self.adminModel.count > 0 {
                    cell.approveButton.isHidden = false
                    cell.rejectedButton.isHidden = false
                }
                else
                {
                    cell.approveButton.isHidden = true
                    cell.rejectedButton.isHidden = true
                }
            }
             return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 130
        }
        else if(indexPath.row == 1){
            if self.selectedType == "newrequest" {
                return 500
            }
            else
            {
                return 600
            }
            //return 500
        }else if(indexPath.row == 2){
            return 100
        }else{
            return 450
        }
    }
}
