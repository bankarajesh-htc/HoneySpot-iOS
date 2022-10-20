//
//  AnnouncementDetailViewController.swift
//  HoneySpot
//
//  Created by htcuser on 01/10/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class AnnouncementDetailViewController: UIViewController {

    @IBOutlet weak var announcementScrollView: UIScrollView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var mainDecription: UITextView!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var announcementButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var reachCountView: UIView!
    
    var spotModel : SpotModel!
    var announcementModel: AnnouncementListModel!
    var announcementListModel: [AnnouncementListModel] = []
    var rowSelected : Int?
    var isNewAnnouncement:Bool = false
    var isFromNotification:Bool = false
    var endDate = Date()
    var todayDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isNewAnnouncement = false
        self.navigationController?.isNavigationBarHidden = true
//        print(spotModel.id)
//        print(rowSelected!)
//        print(announcementListModel[rowSelected!])
        setUpViews()

        // Do any additional setup after loading the view.
    }
    //MARK: - Set Up Initial Views
    func setUpViews()  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d,yyyy"
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter1.string(from: todayDate)
        
        if isFromNotification {
            
            notificationButton.isHidden = false
            announcementButton.isHidden = true
            
            self.showLoadingHud()
            let announcementData = announcementModel
            mainDecription.text = announcementData?.description
            descriptionLabel.text = announcementData?.title
            if announcementData?.end_date != "" {
                endDateLabel.text = "Offer ends on \(getEndDate(announcementData: announcementData!))"
            }
            
            if announcementData?.create_date != "" {
                startDateLabel.text = getStartDate(announcementData: announcementData!)
            }
            
            print(announcementData!.end_date)
            endDate = dateFormatter.date(from: announcementData!.end_date) ?? Date()
            todayDate = dateFormatter1.date(from: today)!
            print(todayDate)
            print(endDate)
            resendButton.isHidden = true
            deleteButton.isHidden = true
            editButton.isHidden = true
            reachCountView.isHidden = true
            
            if announcementData!.imageurl == "" {
                
            }
            else
            {
                self.backgroundImage.kf.setImage(with: URL(string: announcementData!.imageurl))
            }
            
            
            self.hideAllHuds()
            
        }
        else
        {
            notificationButton.isHidden = true
            announcementButton.isHidden = false
            
            self.showLoadingHud()
            let announcementData = announcementListModel[rowSelected!]
            mainDecription.text = announcementData.description
            descriptionLabel.text = announcementData.title
            endDateLabel.text = "Offer ends on \(announcementData.end_date)"
            startDateLabel.text = getStartDate(announcementData: announcementData)
            endDate = dateFormatter.date(from: announcementData.end_date)!
            todayDate = dateFormatter1.date(from: today)!
            print(todayDate)
            print(endDate)
            let isCurrentDate = checkDate(currentDate: todayDate, endDate: endDate)
            print(isCurrentDate)
            deleteButton.isHidden = false
            editButton.isHidden = false
            reachCountView.isHidden = false
            
            if isCurrentDate {
                
                resendButton.isHidden = true
            }
            else
            {
                resendButton.isHidden = false
            }
            if announcementData.imageurl == "" {
                
            }
            else
            {
                self.backgroundImage.kf.setImage(with: URL(string: announcementData.imageurl))
            }
            
            
            self.hideAllHuds()
            
        }
        
        
      
    }
    //MARK: - Check Date Validations
    func checkDate(currentDate: Date, endDate: Date) -> Bool{
        
        if currentDate > endDate  {
            
            return true
        }
        else
        {
            return false
        }
    }
    //MARK: - Get Start Date
    func getStartDate(announcementData: AnnouncementListModel) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let endDate = dateFormatter.date(from: announcementData.create_date)!
        let startDate = AnnouncementDataSource().convertDateToString(date: endDate, format: "MMM dd, yyyy")
        return startDate
    }
    //MARK: - Get End Date
    func getEndDate(announcementData: AnnouncementListModel) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let endDate = dateFormatter.date(from: announcementData.end_date)!
        let startDate = AnnouncementDataSource().convertDateToString(date: endDate, format: "MMM dd, yyyy")
        return startDate
    }
    //MARK: - Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //self.hidesBottomBarWhenPushed = true
        if segue.identifier == "editAnnouncement" {
            let destinationController = segue.destination as! NewAnnouncementViewController
            destinationController.spotModel = self.spotModel
            destinationController.announcementListModel = announcementListModel
            destinationController.rowSelected = rowSelected
            destinationController.isNewAnnouncement = false
           }
         
    }
    
    
    @IBAction func didClickBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Delete Announcement
    @IBAction func didClickDelete(_ sender: Any) {
        
        let announcementData = announcementListModel[rowSelected!]
        let alert: UIAlertController = UIAlertController(
            title: "Delete Feed",
            message: "Are you sure you want to delete this feed?",
            preferredStyle: .alert)
        
        //Add Buttons
        let yesButton: UIAlertAction = UIAlertAction(
            title: "Delete",
            style: .default) { (action: UIAlertAction) in
                self.showLoadingHud()
           
            AnnouncementDataSource().deleteAnnouncement(announcementId: "\(announcementData.announcementId)", spotId: "\(announcementData.spotid)") { (result) in
                
                switch(result){
                case .success(let result):
                    print(result)
                    self.navigationController?.popViewController(animated: true)
                    HSAlertView.showAlert(withTitle: "HoneySpot", message: result)
                case .failure(let err):
                    print(err)
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
    @IBAction func didClickEdit(_ sender: Any) {
        isNewAnnouncement = false
        //self.performSegue(withIdentifier: "editAnnouncement", sender: self)
    }
    //MARK: - Resend the Annoucements
    @IBAction func didClickResend(_ sender: Any) {
        self.showLoadingHud()
        let announcementData = announcementListModel[rowSelected!]
        
        let alert: UIAlertController = UIAlertController(
            title: "Resend Feed",
            message: "Are you sure you want to resend this feed without any modification?",
            preferredStyle: .alert)
        
        //Add Buttons
        let yesButton: UIAlertAction = UIAlertAction(
            title: "Resend",
            style: .default) { (action: UIAlertAction) in
                self.showLoadingHud()
           
            AnnouncementDataSource().updateAnnouncement(announcementListModel: announcementData) { (result) in
                switch(result){
                case .success(let result):
                    print(result)
                    self.hideAllHuds()
                    self.navigationController?.popViewController(animated: true)
                    HSAlertView.showAlert(withTitle: "HoneySpot", message: "Feed Updated")
                case .failure(let err):
                    self.hideAllHuds()
                    print(err)
                }
            }
                
        }
        
        let noButton: UIAlertAction = UIAlertAction(
            title: "Cancel",
            style: .cancel) { (action: UIAlertAction) in
            self.hideAllHuds()
        }
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
        
        
        
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
