//
//  DetailAdminViewController.swift
//  HoneySpot
//
//  Created by htcuser on 29/11/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class DetailAdminViewController: UIViewController, FeedImageCellDelegate, MediaCellDelegate, CommentCellDelegate {
   
    
    
    
    
    var phoneNumber = ""

    @IBOutlet var feedTableView: UITableView!
    @IBOutlet weak var approveView: UIView!
    @IBOutlet var approveViewHeight: NSLayoutConstraint!
    var visibleCells : [CellTypes] = []
    private var sections = [Section]()
    var spotSaveId = ""
    var spotSaveModel : SpotSaveModel!
    var spotModel : SpotModel!
    var adminModel : AdminModel!
    var selectedType:String!
    var selectedID = [Int]()
    var selectedRestaurant = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if selectedType == "newrequest" {
            approveView.isHidden = false
            approveView.backgroundColor = UIColor.white
            approveViewHeight.constant = 68
        }
        else
        {
            approveView.isHidden = true
            approveView.backgroundColor = UIColor.clear
            approveViewHeight.constant = 0
        }
        selectedRestaurant.append(self.adminModel.spot.id)
        // Do any additional setup after loading the view.
        getFeedData()
    }
    //MARK: - Did Click Approve
    @IBAction func approveButtonPressed(_ sender: UIButton) {
        didTapStatus("Approve")
    }
    //MARK: - Did Click Reject
    @IBAction func rejectButtonPressed(_ sender: UIButton) {
        didTapStatus("Reject")
    }
    
    //MARK: - Delegate Methods
    func didAddComment(_ sender: ConsumerDetailCommentsTableViewCell, shouldKeyboardOpen: Bool) {
        
    }
    
    func didViewAllComment(_ sender: ConsumerDetailCommentsTableViewCell, shouldKeyboardOpen: Bool) {
        
    }
    
    func onDirectionsButtonTap(spotSaveModel: SpotSaveModel) {
        
        let spot = spotSaveModel.spot
        let urlString: String = String(format: .APPLE_MAP_URL, spot.address.addingPercentEncoding(withAllowedCharacters: String.ENCODING_ALLOWED_CHARACTERS)!)
        UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
    }
    
    func onCallTapped(phoneNumber: String) {
        self.phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        if(self.phoneNumber != ""){
            let phoneUrl = URL(string: "tel://\(self.phoneNumber)")!
            if(UIApplication.shared.canOpenURL(phoneUrl)){
                UIApplication.shared.open(phoneUrl, options: [:], completionHandler: nil)
            }
        }
    }
    
    func onLocationTap(spotSaveModel: SpotSaveModel) {
        
    }
    
    //MARK: - Web Service Call For Approval / Rejected
    func didTapStatus(_ approvalStatus: String) {
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
        AdminDatasource().updateClaimStatus(spotId: selectedRestaurant, isVerified: isVerified, isDenied: isDenied) { (result) in
            switch(result)
            {
            case .success(let claimList):
                self.hideAllHuds()
                print(claimList)
                self.navigationController?.popViewController(animated: true)
                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Updated Succuessfully")
            case .failure(let error):
                self.hideAllHuds()
                print(error)
                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please try again")
            }
        }
    }
    
    //MARK: - Web Service Call For Restaurant Detail
    func getFeedData()  {
        self.showLoadingHud()
        AdminDatasource().getAdminDetails(saveId: adminModel.spot.id) { (result) in
            switch(result){
            case .success(let spotSaveArr):
                if spotSaveArr.count > 0 {
                    self.hideAllHuds()
                    self.spotSaveModel = spotSaveArr.first
                    let delivery = self.spotSaveModel.spot.deliveryOptions?.contains("delivery")
                    let totalCount = self.spotSaveModel.spot.customerPictures.count + self.spotSaveModel.spot.foodPictures.count
                    if totalCount > 0 {
                        
                        //self.visibleCells.append(CellTypes.imageCell)
                    }
                    self.visibleCells.append(CellTypes.detailImageCell)
                    self.visibleCells.append(CellTypes.detailGeneralCell)
                    
                    self.visibleCells.append(CellTypes.claimCommentCell)
                    if self.spotSaveModel.spot.lat != 0.0 || self.spotSaveModel.spot.lat != 0.0
                    {
                        
                        
                    }
                    
                    if self.spotSaveModel.spot.categories.count > 0  {
                        
                        self.sections.append(Section(type: .Mandatory, items: [.categoryCell]))
                        self.visibleCells.append(CellTypes.categoryCell)
                    }
                    if(self.spotSaveModel.spot.website != "" || self.spotSaveModel.spot.website != nil ) && (self.spotSaveModel.spot.phoneNumber != "" || self.spotSaveModel.spot.phoneNumber != nil) && (self.spotSaveModel.spot.email != "" || self.spotSaveModel.spot.email != nil)
                    {
                        if(self.spotSaveModel.spot.website == "" || self.spotSaveModel.spot.website == nil ) && (self.spotSaveModel.spot.phoneNumber == "" || self.spotSaveModel.spot.phoneNumber == nil) && (self.spotSaveModel.spot.email == "" || self.spotSaveModel.spot.email == nil){
                            print("Web")
                        }
                        else
                        {
                            self.sections.append(Section(type: .Mandatory, items: [.contactCell]))
                            self.visibleCells.append(CellTypes.contactCell)
                        }
                        
                    }
                    if self.spotSaveModel.spot.lat != 0.0
                    {
                        self.visibleCells.append(CellTypes.detailMediaCell)
                    }
                    if self.spotSaveModel.spot.operationhours.count > 0
                    {
                        self.sections.append(Section(type: .Mandatory, items: [.detailHoursCell]))
                        self.visibleCells.append(CellTypes.detailHoursCell)
                    }
                    
                    if self.spotSaveModel.spot.deliveryOptions!.count > 0
                    {
                        self.sections.append(Section(type: .Mandatory, items: [.serviceCell]))
                        self.visibleCells.append(CellTypes.serviceCell)
                    }
                    if delivery! {
                        
                        self.sections.append(Section(type: .Mandatory, items: [.deliveryPartnerCell]))
                        self.visibleCells.append(CellTypes.deliveryPartnerCell)
                    }
                    if self.spotSaveModel.spot.spotreservationlink != "" {
                        
                        self.sections.append(Section(type: .Mandatory, items: [.reservationCell]))
                        self.visibleCells.append(CellTypes.reservationCell)
                    }
                    
                    self.feedTableView.reloadData()
                }
                else
                {
                    self.hideAllHuds()
                    print("No Data Available")
                }
                
            case .failure(let err):
                print(err.errorMessage)
                self.hideAllHuds()
                HSAlertView.showAlert(withTitle: "Error", message: err.errorMessage)
            }
        }
    }
    //MARK: - Back Navigation
    func didClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    func didLikeSpot(sender: ConsumerDetailImageTableViewCell) {
        
    }
    
    func didTapComment(_ sender: ConsumerDetailImageTableViewCell, shouldKeyboardOpen: Bool) {
        
    }
    
    func didTapShareSpot(text: String, image: UIImage) {
        
    }
    
    func didSaveSpot(isInMySavedSpot: Bool, spotSaveModel: SpotSaveModel) {
        
    }
    func didLikeSpot(sender: ConsumerImageTableViewCell) {
        
    }
    
    func didTapComment(_ sender: ConsumerImageTableViewCell, shouldKeyboardOpen: Bool) {
        
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
extension DetailAdminViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(spotSaveModel != nil){
            return visibleCells.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch visibleCells[indexPath.row] {
    
        case .detailImageCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailImageCellId") as! ConsumerImageTableViewCell
            cell.isAdmin = true
            cell.delegate = self
            
            cell.prepareCell(spotSavemodel: self.spotSaveModel)
            return cell
        case .detailGeneralCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "consumerDetailGeneralCellId") as! ConsumerDetailGeneralTableViewCell
                //cell.superVc = self
             cell.prepareCell(spotSavemodel: self.spotSaveModel)
            return cell
        case .claimCommentCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "claimCommentCellId") as! ClaimCommentTableViewCell
                //cell.superVc = self
            cell.prepareCell(model: self.spotSaveModel.spot)
            return cell
        case .categoryCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "consumerDetailCategoryCellId") as! ConsumerDetailCategoriesTableViewCell
            //cell.superVc = self
            cell.prepareCell(spotSavemodel: self.spotSaveModel)
            return cell
        case .contactCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "consumerDetailContactCellId") as! ConsumerDetailContactInfoTableViewCell
           // cell.superVc = self
            cell.prepareCell(spotSavemodel: self.spotSaveModel)
            return cell
        case .detailHoursCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "consumerDetailHoursCellId") as! ConsumerDetailHoursOfOperationTableViewCell
            //cell.superVc = self
            cell.prepareCell(spotSavemodel: self.spotSaveModel)
            return cell
        case .detailMediaCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "consumerDetailmediaCellId") as! ConsumerDetailMediaTableViewCell
            //cell.superVc = self
            cell.delegate = self
            cell.isAdmin = false
            cell.prepareCell(spotSavemodel: self.spotSaveModel)
            return cell
        case .commentsCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCellId") as! ConsumerDetailCommentsTableViewCell
            //cell.superVc = self
            cell.delegate = self
            cell.prepareCell(spotSavemodel: self.spotSaveModel)
            return cell
        case .serviceCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "consumerDetailServiceCellId") as! ConsumerDetailServicesOfferedTableViewCell
            //cell.superVc = self
            cell.prepareCell(spotSavemodel: self.spotSaveModel)
            return cell
        case .deliveryPartnerCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "consumerDetailDeliveryCellId") as! ConsumerDetailDeliveyTableViewCell
            //cell.superVc = self
            //cell.delegate = self
            cell.prepareCell(spotSavemodel: self.spotSaveModel)
            return cell
        case .reservationCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "reservationCellId") as! RestaurantDetailReservationTableViewCell
            cell.prepareCell(model : self.spotSaveModel.spot)
            return cell
        default:
            print("Hi")
            
            
        }
        return UITableViewCell()
        
        /*else if(indexPath.row == 1){
         let cell = tableView.dequeueReusableCell(withIdentifier: "consumerDetailGeneralCellId") as! ConsumerDetailGeneralTableViewCell
         //cell.superVc = self
         cell.prepareCell(spotSavemodel: self.spotSaveModel)
         return cell
     }*/
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch visibleCells[indexPath.row] {
        case .imageCell:
            return 325  //325
        case .detailImageCell:
            return 200
        case .detailGeneralCell:
            return UITableView.automaticDimension
        case .claimCommentCell:
            return 110
        case .categoryCell:
             return UITableView.automaticDimension
        case .contactCell:
            return 145
        case .detailHoursCell:
            return 310
        case .detailMediaCell:
            return 580
        case .commentsCell:
            return 170
        case .serviceCell:
            return 160
        case .deliveryPartnerCell:
            return 180
        case .reservationCell:
            return 120
            
        default:
            print("Hi")
            
        }
        
        /* else if(indexPath.row == 1){
         return 110
     }*/
        return 110
    }
    
}

private struct Section {
  var type: SectionType
  var items: [CellTypes]
}
private enum SectionType {
  case Mandatory
  case NotMandatory
}

