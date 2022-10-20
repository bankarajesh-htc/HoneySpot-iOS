//
//  ConsumerDetailMediaTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 18/11/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit
import MapKit

class ConsumerDetailMediaTableViewCell: UITableViewCell {

    @IBOutlet var locationView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapViewAddressLabel: UILabel!
    @IBOutlet var viewAllButton: UIButton!
    @IBOutlet var directionsButton: UIButton!
    @IBOutlet var callButton: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet var menuImagesCollectionView: UICollectionView!
    @IBOutlet var announcementFeedTableView: UITableView!
    
    @IBOutlet var tabBackView: UIView!
    @IBOutlet var tabIndicatorView: UIView!
    @IBOutlet var coverPhotoButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var imagesButton: UIButton!
    var feedModel: FeedModel!
    var delegate: MediaCellDelegate!
    var spotSaveModel : SpotSaveModel!
    var isAdmin = false
    
    
    var phoneNumber = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func prepareCell(spotSavemodel:SpotSaveModel){
        self.spotSaveModel = spotSavemodel
        self.phoneNumber = spotSavemodel.spot.phoneNumber ?? ""
        callButton.setTitle(self.phoneNumber, for: .normal)
        self.mapViewAddressLabel.text = spotSavemodel.spot.address
        if(spotSavemodel.spot.operationhours.count == 7){
            self.mapViewAddressLabel.text = (self.mapViewAddressLabel.text ?? "") + "\n"
            let hours = spotSavemodel.spot.operationhours[Calendar.current.component(.weekday, from: Date()) - 1].split(separator: "|")
            if(hours[0] == "close"){
                self.mapViewAddressLabel.text = (self.mapViewAddressLabel.text ?? "") + "Closed"
            }else{
                self.mapViewAddressLabel.text = (self.mapViewAddressLabel.text ?? "") + "Open Hours :  " + hours[1] + " - " + hours[2]
            }
        }
        
        var annotationsToAdd: [SpotAnnotation] = []
        let sa: SpotAnnotation = SpotAnnotation(spotSaveModel: spotSavemodel)
        
        let v = SpotAnnotationView(annotation: sa, reuseIdentifier: SpotAnnotationView.SPOT_ANNOTATION_VIEW_REUSE_IDENTIFICATION)
        v.annotation = sa
        
        annotationsToAdd.append(sa)
        self.mapView.addAnnotations(annotationsToAdd)
        
        let mapRegion: MKCoordinateRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: spotSavemodel.spot.lat, longitude: spotSavemodel.spot.lon),
            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        )
        self.mapView.setRegion(mapRegion, animated: true)
        if spotSaveModel.spot.otherlocations.count > 0 {
            self.viewAllButton.isHidden = false
            
        }
        else
        {
            self.viewAllButton.isHidden = true
        }
    
    }
    @IBAction func directionsTapped(_ sender: Any) {
        self.delegate.onDirectionsButtonTap(spotSaveModel: self.spotSaveModel)
        
        
    }
    
    @IBAction func callTapped(_ sender: Any) {
        self.delegate.onCallTapped(phoneNumber: self.phoneNumber)
        
    }
    
    @IBAction func tabOneTapped(_ sender: Any) {
        configureTab(index: 0)
    }
    
    @IBAction func tabTwoTapped(_ sender: Any) {
        configureTab(index: 1)
    }
    
    @IBAction func tabThreeTapped(_ sender: Any) {
        configureTab(index: 2)
    }
    @IBAction func viewAllLocationsTapped(_ sender: Any) {
        if spotSaveModel.spot.otherlocations.count > 0 {
            self.delegate.onLocationTap(spotSaveModel: self.spotSaveModel)
            
        }
        
    }
    
    
    func configureTab(index : Int){
        if(index == 0){
            tabIndicatorView.frame = CGRect(x: 0 , y: 0, width: tabIndicatorView.frame.width, height: tabIndicatorView.frame.height)
            coverPhotoButton.setTitleColor(UIColor.black, for: .normal)
            menuButton.setTitleColor(UIColor.black, for: .normal)
            
            
            coverPhotoButton.titleLabel?.font = UIFont.fontHelveticaBold(withSize: 16)
            menuButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
           
            self.noDataLabel.isHidden = true
            locationView.isHidden = false
            menuImagesCollectionView.isHidden = true
            
            if isAdmin {
                
            }
            else
            {
                imagesButton.setTitleColor(UIColor.black, for: .normal)
                imagesButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
                announcementFeedTableView.isHidden = true
            }
            
            self.contentView.layoutIfNeeded()
        }else if(index == 1){
            tabIndicatorView.frame = CGRect(x: 1 * (tabBackView.frame.width  / 3.0), y: 0, width: tabIndicatorView.frame.width, height: tabIndicatorView.frame.height)
            coverPhotoButton.setTitleColor(UIColor.black, for: .normal)
            menuButton.setTitleColor(UIColor.black, for: .normal)
            //imagesButton.setTitleColor(UIColor.black, for: .normal)
            
            coverPhotoButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            menuButton.titleLabel?.font = UIFont.fontHelveticaBold(withSize: 16)
            //imagesButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            
            locationView.isHidden = true
            if self.spotSaveModel.spot.menuPictures.count > 0
            {
                self.noDataLabel.isHidden = true
                menuImagesCollectionView.isHidden = false
                menuImagesCollectionView.reloadData()
            }
            else
            {
                self.noDataLabel.isHidden = false
                self.noDataLabel.text = "No Menu Images Available"
            }
            
            if isAdmin {
                
            }
            else
            {
                imagesButton.setTitleColor(UIColor.black, for: .normal)
                imagesButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
                announcementFeedTableView.isHidden = true
            }
            self.contentView.layoutIfNeeded()
        }else if(index == 2){
            
            
            tabIndicatorView.frame = CGRect(x: 2 * (tabBackView.frame.width  / 3.0), y: 0, width: tabIndicatorView.frame.width, height: tabIndicatorView.frame.height)
            coverPhotoButton.setTitleColor(UIColor.black, for: .normal)
            menuButton.setTitleColor(UIColor.black, for: .normal)
            imagesButton.setTitleColor(UIColor.black, for: .normal)
            
            coverPhotoButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            menuButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            imagesButton.titleLabel?.font = UIFont.fontHelveticaBold(withSize: 16)
            
            locationView.isHidden = true
            menuImagesCollectionView.isHidden = true
            
            if spotSaveModel.spot.feedId.count > 0 {
                announcementFeedTableView.isHidden = false
                announcementFeedTableView.reloadData()
                self.noDataLabel.isHidden = true
            }
            else
            {
                announcementFeedTableView.isHidden = true
                self.noDataLabel.text = "No Feed Data Available"
                self.noDataLabel.isHidden = false
            }
            
            
            self.contentView.layoutIfNeeded()
        }
    }
    
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
    //MARK: - Get End Date
    func getEndDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let endDate = dateFormatter.date(from: date)!
        let startDate = AnnouncementDataSource().convertDateToString(date: endDate, format: "MMM dd, yyyy")
        return startDate
    }

}
extension ConsumerDetailMediaTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let totalCount = self.spotSaveModel.spot.menuPictures.count
        if totalCount == 0 {
            return 0
        }
        else
        {
            return totalCount
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coverCellId", for: indexPath) as! RestaurantDetailMediaCoverPhotoCollectionViewCell
        if self.spotSaveModel.spot.menuPictures.count > 0 {
             cell.img.kf.setImage(with: URL(string:self.spotSaveModel.spot.menuPictures[indexPath.row]))
        }
        else
        {
            cell.img.image = UIImage(named: "ImagePlaceholder")
        }
           
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 200.0)
    }
    
    
}
extension ConsumerDetailMediaTableViewCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(spotSaveModel != nil){
            return spotSaveModel.spot.feedId.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "announcementCellId") as! AnnouncementTableViewCell
        let data = self.spotSaveModel.spot.feedDescription[indexPath.row] as? String ?? ""
        cell.mainDescription.text = data
        
        let endDate = getEndDate(date: (self.spotSaveModel.spot.endDate[indexPath.row]) as? String ?? "")
        cell.subDescription.text = "Offer ends on \(endDate)"
        
        
        
        let date =  self.spotSaveModel.spot.createDate[indexPath.row] as? String ?? ""
        
        if date == "" {
            
            cell.daysLabel.text = ""
            cell.dateLabel.text = ""
            cell.monthLabel.text = ""
        }
        else
        {
            let startDate = convertDateToString(date: self.spotSaveModel.spot.createDate[indexPath.row] as? String ?? "")
            cell.daysLabel.text = startDate.0
            cell.dateLabel.text = startDate.1
            cell.monthLabel.text = startDate.2
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // self.performSegue(withIdentifier: "detailAnnouncement", sender: self)
//        let notificationModel = notifications[indexPath.row]
//        let announcementModel = AnnouncementListModel(create_date: notificationModel.create_date, description: notificationModel.feeddescription, end_date: notificationModel.end_date, announcementId: 0, imageurl: notificationModel.imageurl, postedby: notificationModel.postedby ?? 0, spotid: Int(notificationModel.spotSaveModel.spot.id) ?? 0, title: notificationModel.feedtitle)
//
//        let viewController = self.AnnouncementViewControllerInstance()
//        viewController.announcementModel = announcementModel
//        viewController.isFromNotification = true
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
}
extension ConsumerDetailMediaTableViewCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var v: SpotAnnotationView? = self.mapView.dequeueReusableAnnotationView(withIdentifier: SpotAnnotationView.SPOT_ANNOTATION_VIEW_REUSE_IDENTIFICATION) as? SpotAnnotationView
        
        if v == nil {
            v = SpotAnnotationView.init(annotation: annotation, reuseIdentifier: SpotAnnotationView.SPOT_ANNOTATION_VIEW_REUSE_IDENTIFICATION)
        } else {
            v!.annotation = annotation
        }
        
        return v
    }
}
