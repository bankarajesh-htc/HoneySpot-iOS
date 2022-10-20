//
//  AdminOverViewTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 10/12/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

protocol AdminRequestTableViewCellDelegate : AnyObject {
    func didPressButton(_ tag: Int)
    func didSelect(sender: AdminRequestTableViewCell,indexPath :IndexPath)
}
class AdminOverViewTableViewCell: UITableViewCell,AdminRequestTableViewCellDelegate {
    
    
    func didSelect(sender: AdminRequestTableViewCell, indexPath: IndexPath) {
        
        print("Button \(sender)Row\(indexPath.row)")
//        if selectedID.contains(tag) {
//            selectedID.remove(at: tag)
//        }
//        else
//        {
//            selectedID.append(tag)
//        }
        if !selectedID.contains(indexPath.row)
        {
            selectedID.append(indexPath.row)
            
            self.adminModel[indexPath.row].isPending = false
        }
        else
        {
            
            self.adminModel[indexPath.row].isPending = true
            if let index = selectedID.firstIndex(of: indexPath.row) {
                selectedID.remove(at: index)
            }
        }
        self.adminOverviewTableView.reloadRows(at: [indexPath], with: .automatic)
        cellDelegate?.didPressButton(selectedID)
       // cellDelegate?.didPressButton(selectedID)
        //adminOverviewTableView.reloadData()
        
    }
    
    
    
    

    @IBOutlet var adminOverviewTableView: UITableView!
    @IBOutlet weak var newRequestSelectedView: UIView!
    @IBOutlet weak var approvedSelectedView: UIView!
    @IBOutlet weak var rejectedtedSelectedView: UIView!
    @IBOutlet var noDataLabel: UILabel!
    @IBOutlet var newRequest: UILabel!
    @IBOutlet var approved: UILabel!
    @IBOutlet var rejected: UILabel!
    @IBOutlet var selectedTypeLabel: UILabel!
    var cellDelegate: AdminTableViewCellDelegate?
    var selectedType = "newrequest"
    var selectedID = [Int]()
    var adminModel = [AdminModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func prepareCell()  {
        newRequest.text = "\(AppDelegate.originalDelegate.newrequests)"
        approved.text = "\(AppDelegate.originalDelegate.approved)"
        rejected.text = "\(AppDelegate.originalDelegate.rejected)"
        configureView()
        
    }
    @IBAction func newRequestTapped(_ sender: Any) {
        selectedID.removeAll()
        selectedType = "newrequest"
        cellDelegate?.didClickStatus(selectedType)
        configureView()
        
    }
    
    @IBAction func approvedTapped(_ sender: Any) {
        selectedID.removeAll()
        selectedType = "approved"
        cellDelegate?.didClickStatus(selectedType)
        configureView()
        
    }
    
    @IBAction func rejectedTapped(_ sender: Any) {
        selectedID.removeAll()
        selectedType = "rejected"
        cellDelegate?.didClickStatus(selectedType)
        configureView()
        
    }
    func configureView(){
        if(selectedType == "newrequest"){
            
            selectedTypeLabel.text = "New Request"
            newRequestSelectedView.isHidden = false
            approvedSelectedView.isHidden = true
            rejectedtedSelectedView.isHidden = true
            

        }else if(selectedType == "approved"){
            
            selectedTypeLabel.text = "Approved"
            newRequestSelectedView.isHidden = true
            approvedSelectedView.isHidden = false
            rejectedtedSelectedView.isHidden = true
            

        }else if(selectedType == "rejected"){
            
            selectedTypeLabel.text = "Rejected"
            newRequestSelectedView.isHidden = true
            approvedSelectedView.isHidden = true
            rejectedtedSelectedView.isHidden = false
            

        }
    }
    func didPressButton(_ tag: Int) {
        if let index = selectedID.firstIndex(of: tag) {
            selectedID.remove(at: index)
        }
        else
        {
            selectedID.append(tag)
        }
        
        adminOverviewTableView.reloadData()
        
        print("I have pressed a button with a tag: \(tag) \(selectedID)")
    }

}
extension AdminOverViewTableViewCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.adminModel.count > 0 {
            return self.adminModel.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminRequestCellId") as! AdminRequestTableViewCell
        cell.cellDelegate = self
        cell.indexPath = indexPath
        cell.selectionStyle = .none

        if self.adminModel.count > 0 {
            
            let dataSource = self.adminModel[indexPath.row]
            cell.selectionButton.tag = indexPath.row
            if(selectedType == "newrequest"){
                cell.selectionButton.isHidden = false
                
                if !selectedID.contains(indexPath.row)
                {
                    print("Indexpath\(indexPath.row)")
                    cell.selectionButton.setImage(UIImage(named: "unSelectedSpot"), for: .normal)
                    print("UnSelected")
                }
                else
                {
                    cell.selectionButton.setImage(UIImage(named: "selectedSpot"), for: .normal)//image = UIImage(named: "selectedSpot")
                    print("Selected")
                    
                }
                
            }
            else
            {
                cell.selectionButton.isHidden = true
                
            }
            
            cell.userImage.kf.setImage(with: URL(string: dataSource.spot.photoUrl))
            cell.spotName.text = "\(dataSource.spot.name)"
            cell.spotAddress.text = "\(dataSource.spot.address) \n\(dataSource.email ?? "")"
            cell.phoneNumber.text = "\(dataSource.spot.phoneNumber ?? "")"
            
        }
        else
        {
            
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataSource = self.adminModel[indexPath.row]
        cellDelegate?.didShowDetailPage(dataSource, selectedType: selectedType,selectedID: self.selectedID)
    }
    
}
