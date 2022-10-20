//
//  AnnouncementViewController.swift
//  HoneySpot
//
//  Created by htcuser on 28/09/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class AnnouncementViewController: UIViewController {

    @IBOutlet weak var announcementTableView: UITableView!
    @IBOutlet weak var bottomBackgroundView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet var createButton: UIButton!
    
    var spotModel :SpotModel!
    var announcementListModel: [AnnouncementListModel] = []
    var passAnnouncementListModel: AnnouncementListModel!
    var selectedRow: Int?
    var isNewAnnouncement:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isNewAnnouncement = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.restaurantChanged), name: NSNotification.Name.init("restaurantChanged"), object: nil)
        setupViews()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        getData()
        
        //self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func restaurantChanged(){
        self.spotModel = selectedBusiness.spot
        print(spotModel.id)
    }
    
    //MARK: - Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //self.hidesBottomBarWhenPushed = true
        if segue.identifier == "newAnnouncement" {
            let destinationController = segue.destination as! NewAnnouncementViewController
            destinationController.spotModel = self.spotModel
            destinationController.announcementListModel = announcementListModel
            destinationController.rowSelected = selectedRow
            destinationController.isNewAnnouncement = true
           }
         else if(segue.identifier == "detailAnnouncement"){
            let destinationController = segue.destination as! AnnouncementDetailViewController
            destinationController.spotModel = self.spotModel
            
            destinationController.isFromNotification = false
            destinationController.announcementListModel = announcementListModel
            destinationController.rowSelected = selectedRow
            destinationController.isNewAnnouncement = false
        }
    }
    //MARK: - SetUp Initial Views
    func setupViews(){
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }

        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
       
        
        let normalFont = UIFont(name: "Helvetica Neue", size: CGFloat(22))!
        let boldFont = UIFont(descriptor: normalFont.fontDescriptor.withSymbolicTraits(.traitBold)!, size: normalFont.pointSize)
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: boldFont]
        self.navigationItem.title = "Announcement Feed"
        
        bottomBackgroundView.addBlurToView()
        
    }
    //MARK: - Get Restaurant
    func getData(){
        if AppDelegate.originalDelegate.isFree  {
            
            self.announcementTableView.isHidden = true
            self.noDataLabel.isHidden = false
            self.createButton.isHidden = true
            self.noDataLabel.text = "Kindly upgrade to Premium Account to unlock this feature"
        }
        else
        {
            self.createButton.isHidden = false
            showLoadingHud()
            BusinessRestaurantDataSource().getClaims { (result) in
                self.hideAllHuds()
                switch(result){
                case .success(let claims):
                    if(claims.count > 0){
                        if(selectedBusiness == nil){
                            self.spotModel = claims[0].spot
                        }else{
                            self.spotModel = claims.filter({ $0.spot.id == selectedBusiness.spot.id }).first?.spot ?? claims[0].spot
                        }
                        print(self.spotModel.id)
                        self.getAnnouncement()
                    }else{
                        self.showErrorHud(message: "Your verification is still under review.")
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                    self.showErrorHud(message: "Your verification is still under review.")
                }
            }

        }
        
    }
    //MARK: - Web Service Call For Announcement List
    func getAnnouncement()  {
        
        showLoadingHud()
        self.view.isUserInteractionEnabled = false
        DispatchQueue.global().async {
            AnnouncementDataSource().getAnnouncementList(spotId: self.spotModel.id) { (result) in
                switch(result)
                {
                case .success(let announcementList):
                    self.announcementListModel = announcementList
                    print(announcementList)
                case .failure(let error):
                    print(error)
                }
                DispatchQueue.main.async {
                    if self.announcementListModel.count > 0
                    {
                        self.announcementTableView.isHidden = false
                        self.noDataLabel.isHidden = true
                        self.createButton.isHidden = false
                        self.announcementTableView.reloadData()
                        self.view.isUserInteractionEnabled = true
                    }
                    else
                    {
                        self.announcementTableView.isHidden = true
                        self.noDataLabel.isHidden = false
                        if AppDelegate.originalDelegate.isFree  {
                            
                            self.createButton.isHidden = true
                            self.noDataLabel.text = "Kindly upgrade to Premium Account to unlock this feature"
                        }
                        else
                        {
                            self.createButton.isHidden = false
                            self.noDataLabel.text = "Create New Announcement to engage with your customers"
                        }
                        self.view.isUserInteractionEnabled = true
                        
                    }
                    
                    self.hideAllHuds()
                }
                
            }
        }
        
    }
    
    //MARK: - Move to Create Announcement Screen
    @IBAction func didClickCreateNewAnnouncement(_ sender: Any) {
        self.performSegue(withIdentifier: "newAnnouncement", sender: self)
        
//        let objNewAnnounce = NewAnnouncementViewController()
//        objNewAnnounce.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(objNewAnnounce, animated: false)
//
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.noDataLabel.text = ""
        //self.tabBarController?.tabBar.isHidden = true
    }
    //MARK: - Date to String Conversion
    func convertDateToString(date: String) -> (String, String, String) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
         let myDate = formatter.date(from: date)
//        let yourDate: Date? = formatter.date(from: myString)
//        formatter.dateFormat = "MMMM dd, yyyy"
//        let updatedString = formatter.string(from: yourDate!)
        formatter.dateFormat = "yyyy"
         let year = formatter.string(from: myDate!)
            formatter.dateFormat = "MMM"
            let month = formatter.string(from: myDate!)
            formatter.dateFormat = "dd"
            let day = formatter.string(from: myDate!)
          formatter.dateFormat = "EE"
          let days = formatter.string(from: myDate!)
            print(year, month, day,days) // 2018 12 24
        
        return (days,day,month)
        
    }
    

}

extension AnnouncementViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcementListModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if announcementListModel.count > 0 {
            let cell = self.announcementTableView.dequeueReusableCell(withIdentifier: "announcementCellId", for: indexPath) as! AnnouncementTableViewCell
            //cell.textLabel?.text = "Welcocone to feed"
            cell.selectionStyle = .none
            cell.layer.masksToBounds = true
            cell.layer.masksToBounds = false
            cell.layer.shadowOpacity = 0.23
            cell.layer.shadowRadius = 4
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
            let announcementData = self.announcementListModel[indexPath.row]
            passAnnouncementListModel = announcementData
            cell.mainDescription.text = announcementData.title
            cell.subDescription.text = "Offer ends on \(announcementData.end_date)"
            let startDate = convertDateToString(date: announcementData.create_date)
            cell.daysLabel.text = startDate.0
            cell.dateLabel.text = startDate.1
            cell.monthLabel.text = startDate.2
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "detailAnnouncement", sender: self)
//        let viewController: AnnouncementDetailViewController = AnnouncementDetailViewController()
//        self.present(viewController, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}

extension UIView
{
    func addBlurToView()  {
        var blurEffect:UIBlurEffect!
        
        if #available(iOS 10.0, *) {
            blurEffect = UIBlurEffect(style: .light)
        }
        else
        {
            blurEffect = UIBlurEffect(style: .extraLight)
        }
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.alpha = 0.5
        blurEffectView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.addSubview(blurEffectView)
        
    }
}
