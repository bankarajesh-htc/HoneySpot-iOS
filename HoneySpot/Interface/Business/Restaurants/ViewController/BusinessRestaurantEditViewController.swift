//
//  BusinessRestaurantEditViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 2.07.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit
import AWSS3
import CZPhotoPickerController

protocol BusinessEditDelegate {
	func coverPhotoEditTapped()
	func menuPhotoEditTapped()
	func imagePhotoEditTapped()
}

class BusinessRestaurantEditViewController: UIViewController {

	@IBOutlet var infoTableView: UITableView!
	
	@IBOutlet var editButton: UIButton!
	@IBOutlet var backImage: UIImageView!
	@IBOutlet var logoImage: UIImageView!
	
	@IBOutlet var nameField: UITextField!
	@IBOutlet var ownersField: UITextField!
	@IBOutlet var photosSegmentedControl: UISegmentedControl!
	@IBOutlet var addressField: UITextField!
	@IBOutlet var websiteField: UITextField!
	@IBOutlet var phoneField: UITextField!
	@IBOutlet var emailField: UITextField!
	
	@IBOutlet var dineInOptionImage: UIImageView!
	@IBOutlet var takeoutOptionImage: UIImageView!
    
	@IBOutlet var deliveryOptionImage: UIImageView!
	@IBOutlet var cateringOptionImage: UIImageView!
	
	@IBOutlet var menuPicturesCollectionView: UICollectionView!
	
	var spotModel :SpotModel!
	var photoPicker : CZPhotoPickerController!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
		NotificationCenter.default.addObserver(self, selector: #selector(self.restaurantChanged), name: NSNotification.Name.init("restaurantChanged"), object: nil)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		getData()
	}
	
	@objc func restaurantChanged(){
		self.spotModel = selectedBusiness.spot
		self.setupViews()
		self.infoTableView.reloadData()
	}
	
	func getData(){
		showLoadingHud()
        self.view.isUserInteractionEnabled = false
        DispatchQueue.global().async {
            BusinessRestaurantDataSource().getClaims { (result) in
                self.hideAllHuds()
                switch(result){
                case .success(let claims):
                    DispatchQueue.main.async
                    {
                        if(claims.count > 0){
                            if(selectedBusiness == nil){
                                self.spotModel = claims[0].spot
                            }else{
                                self.spotModel = claims.filter({ $0.spot.id == selectedBusiness.spot.id }).first?.spot ?? claims[0].spot
                            }
                            self.setupViews()
                            self.infoTableView.reloadData()
                            self.scrollToTop()
                            self.view.isUserInteractionEnabled = true
                        }else{
                            self.showErrorHud(message: "Your verification is still under review.")
                            self.view.isUserInteractionEnabled = true
                        }
                    }
                case .failure(let err):
                    DispatchQueue.main.async
                    {
                        self.view.isUserInteractionEnabled = true
                        print(err.localizedDescription)
                        self.showErrorHud(message: "Your verification is still under review.")
                    }
                    
                }
            }
        }

	}
	
	func navTitleLabel(withStyle style: THEME_STYLE) -> UILabel {
		let navLabel = UILabel()
		var navTitle: NSMutableAttributedString = NSMutableAttributedString(string: "HoneySpot")
		switch style {
		case .STYLE1, .STYLE2:
			navTitle = NSMutableAttributedString(string: "Honey", attributes:[
				NSAttributedString.Key.font: UIFont.fontMonsterratBold(withSize: 24),
				NSAttributedString.Key.foregroundColor: UIColor.ORANGE_COLOR])
			navTitle.append(NSMutableAttributedString(string: "Spot", attributes:[
				NSAttributedString.Key.font: UIFont.fontMonsterratBold(withSize: 24),
				NSAttributedString.Key.foregroundColor: UIColor.YELLOW_COLOR]))
			navigationController?.navigationBar.barTintColor = .WHITE_COLOR
			break
		case .STYLE3:
			navTitle = NSMutableAttributedString(string: "HoneySpot", attributes:[
				NSAttributedString.Key.font: UIFont.fontMonsterratBold(withSize: 25),
				NSAttributedString.Key.foregroundColor: UIColor.WHITE_COLOR])
			navigationController?.navigationBar.barTintColor = .ORANGE_COLOR
			break
		}
		navLabel.attributedText = navTitle
		
		return navLabel
	}
	
	func setupViews(){
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }

		

        self.navigationItem.titleView = navTitleLabel(withStyle: .STYLE2)
		self.navigationController?.navigationBar.prefersLargeTitles = false
		self.navigationController?.isNavigationBarHidden = true

		
	}
	
	func configureServices(){
		self.dineInOptionImage.image = UIImage(named: "business_tick_empty")
		self.takeoutOptionImage.image = UIImage(named: "business_tick_empty")
		self.deliveryOptionImage.image = UIImage(named: "business_tick_empty")
		self.cateringOptionImage.image = UIImage(named: "business_tick_empty")
		
		for option in spotModel.deliveryOptions ?? [] {
			if(option == "Dine In"){
				dineInOptionImage.image = UIImage(named: "business_tick_filled")
			}else if(option == "Take Out"){
				takeoutOptionImage.image = UIImage(named: "business_tick_filled")
			}else if(option == "Delivery"){
				deliveryOptionImage.image = UIImage(named: "business_tick_filled")
			}else if(option == "Catering"){
				cateringOptionImage.image = UIImage(named: "business_tick_filled")
			}
		}
	}
	
	func save(){
		DispatchQueue.global().async {
			self.showLoadingHud()
			BusinessRestaurantDataSource().saveSpot(spotModel: self.spotModel) { (result) in
				self.hideAllHuds()
				switch(result){
				case .success(let message):
					print(message)
					DispatchQueue.main.async {
						self.infoTableView.reloadData()
					}
				case .failure(let err):
					print(err.localizedDescription)
					HSAlertView.showAlert(withTitle: "Problem", message: "There is a problem saving data please try again")
				}
			}
		}
	}
	
	@IBAction func nameChanged(_ sender: Any) {
		if(nameField.text != ""){
			spotModel.name = nameField.text!
		}
	}
	
	@IBAction func ownersChanged(_ sender: Any) {
		if(ownersField.text != ""){
			spotModel.owners = ownersField.text!
		}
	}
	
	@IBAction func addressChanged(_ sender: Any) {
		if(addressField.text != ""){
			spotModel.address = addressField.text!
		}
	}
	
	@IBAction func phoneChanged(_ sender: Any) {
		if(phoneField.text != ""){
			spotModel.phoneNumber = phoneField.text!
		}
	}
	
	@IBAction func websiteChanged(_ sender: Any) {
		if(websiteField.text != ""){
			spotModel.website = websiteField.text!
		}
	}
	
	@IBAction func emailChanged(_ sender: Any) {
		if(emailField.text != ""){
			spotModel.email = emailField.text!
		}
	}
	
	
	@IBAction func dineInTapped(_ sender: Any) {
		if((spotModel.deliveryOptions ?? []).contains("Dine In")){
			spotModel.deliveryOptions = spotModel.deliveryOptions?.filter({ $0 != "Dine In" })
		}else{
			spotModel.deliveryOptions?.append("Dine In")
		}
		self.configureServices()
	}
	
	@IBAction func takeoutTapped(_ sender: Any) {
		if((spotModel.deliveryOptions ?? []).contains("Take Out")){
			spotModel.deliveryOptions = spotModel.deliveryOptions?.filter({ $0 != "Take Out" })
		}else{
			spotModel.deliveryOptions?.append("Take Out")
		}
		self.configureServices()
	}
	
	@IBAction func deliveryTapped(_ sender: Any) {
		if((spotModel.deliveryOptions ?? []).contains("Delivery")){
			spotModel.deliveryOptions = spotModel.deliveryOptions?.filter({ $0 != "Delivery" })
		}else{
			spotModel.deliveryOptions?.append("Delivery")
		}
		self.configureServices()
	}
	
	@IBAction func cateringTapped(_ sender: Any) {
		if((spotModel.deliveryOptions ?? []).contains("Catering")){
			spotModel.deliveryOptions = spotModel.deliveryOptions?.filter({ $0 != "Catering" })
		}else{
			spotModel.deliveryOptions?.append("Catering")
		}
		self.configureServices()
	}
	
	@IBAction func logoImageTapped(_ sender: Any) {
		self.photoPicker = CZPhotoPickerController(completionBlock: { (imagePickerController: UIImagePickerController?, imageInfoDict: [AnyHashable : Any]?) in
			
			guard let imageInfo = imageInfoDict else {
				return
			}
			var img: UIImage? = imageInfo[UIImagePickerController.InfoKey.editedImage] as? UIImage
			if img == nil {
				img = imageInfo[UIImagePickerController.InfoKey.originalImage] as? UIImage
			}
			guard let image = img else {
				return
			}
			self.dismiss(animated: true, completion: nil)
			let pictureData: Data = image.jpegData(compressionQuality: 0.9)!
			self.uploadImage(bucketName: "honeyspot-business-images", data: pictureData) { (result) in
				switch(result){
				case .success(let link):
					DispatchQueue.main.async {
						self.spotModel.logoUrl = link
						self.logoImage.kf.setImage(with: URL(string: link))
					}
				case .failure(let err):
					print(err.localizedDescription)
					HSAlertView.showAlert(withTitle: "Problem", message: "There is a problem uploading your image to our server")
				}
			}
		})
		self.photoPicker?.allowsEditing = true
		self.photoPicker?.present(from: self)
	}
	
	@IBAction func segmentedChanged(_ sender: Any) {
		self.menuPicturesCollectionView.reloadData()
	}
	
	@IBAction func editImageTapped(_ sender: Any) {
        self.photoPicker = CZPhotoPickerController(completionBlock: { (imagePickerController: UIImagePickerController?, imageInfoDict: [AnyHashable : Any]?) in
            
            guard let imageInfo = imageInfoDict else {
                return
            }
            var img: UIImage? = imageInfo[UIImagePickerController.InfoKey.editedImage] as? UIImage
            if img == nil {
                img = imageInfo[UIImagePickerController.InfoKey.originalImage] as? UIImage
            }
            guard let image = img else {
                return
            }
            self.dismiss(animated: true, completion: nil)
            let pictureData: Data = image.jpegData(compressionQuality: 0.9)!
			self.uploadImage(bucketName: "honeyspot-business-images", data: pictureData) { (result) in
				switch(result){
				case .success(let link):
					DispatchQueue.main.async {
						self.spotModel.photoUrl = link
						self.backImage.kf.setImage(with: URL(string: link))
                        self.logoImage.kf.setImage(with: URL(string: link))
					}
				case .failure(let err):
					print(err.localizedDescription)
					HSAlertView.showAlert(withTitle: "Problem", message: "There is a problem uploading your image to our server")
				}
			}
        })
        self.photoPicker?.allowsEditing = true
        self.photoPicker?.present(from: self)
	}
	
	
    
	func uploadImage(bucketName : String,data : Data,completion: @escaping (Result<String,Error>) -> ()){
        
        DispatchQueue.main.async {
            self.showLoadingHud()
        }
    
        let remoteName = UUID().uuidString + ".jpg"
        let S3BucketName = bucketName

        let accessKey = "AKIAZBDUQHBVB6XBABEZ"
        let secretKey = "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"
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration

        let expression = AWSS3TransferUtilityUploadExpression()
        expression.setValue("public-read", forRequestHeader: "x-amz-acl")
        
        let transferManager = AWSS3TransferUtility.default()
        transferManager.uploadData(data, bucket: S3BucketName, key: remoteName, contentType: "image/jpeg", expression: expression) { (task, err) in
            if err != nil {
                print("Upload failed with error: (\(err!.localizedDescription))")
				completion(.failure(err!))
            }
            if let HTTPResponse = task.response {
                DispatchQueue.main.async {
                    self.hideAllHuds()
                }
                print(HTTPResponse)
                let link = "https://" + bucketName + ".s3.us-east-2.amazonaws.com/" + remoteName
				completion(.success(link))
            }
        }
        
    }
    func scrollToTop() {
        // 1
        let topRow = IndexPath(row: 0,
                               section: 0)
                               
        // 2
        self.infoTableView.scrollToRow(at: topRow,
                                   at: .top,
                                   animated: true)
    }

}

extension BusinessRestaurantEditViewController : UICollectionViewDelegate , UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if(photosSegmentedControl.selectedSegmentIndex == 0){
			//Menu
			return self.spotModel.menuPictures.count + 1
		}else if(photosSegmentedControl.selectedSegmentIndex == 0){
			//Food
			return self.spotModel.foodPictures.count + 1
		}else{
			//Customers
			return self.spotModel.customerPictures.count + 1
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! BusinessRestaurantEditImageCollectionViewCell
		if(photosSegmentedControl.selectedSegmentIndex == 0){
			//Menu
			if(indexPath.row == collectionView.numberOfItems(inSection: 0) - 1){
				cell.plusIcon.isHidden = false
				cell.img.layer.cornerRadius = 6
				cell.img.clipsToBounds = true
			}else{
				cell.img.kf.setImage(with: URL(string: self.spotModel.menuPictures[indexPath.row]))
				cell.plusIcon.isHidden = true
				cell.img.layer.cornerRadius = 6
				cell.img.clipsToBounds = true
			}
		}else if(photosSegmentedControl.selectedSegmentIndex == 0){
			//Food
			if(indexPath.row == collectionView.numberOfItems(inSection: 0) - 1){
				cell.plusIcon.isHidden = false
				cell.img.layer.cornerRadius = 6
				cell.img.clipsToBounds = true
			}else{
				cell.img.kf.setImage(with: URL(string: self.spotModel.foodPictures[indexPath.row]))
				cell.plusIcon.isHidden = true
				cell.img.layer.cornerRadius = 6
				cell.img.clipsToBounds = true
			}
		}else{
			//Customers
			if(indexPath.row == collectionView.numberOfItems(inSection: 0) - 1){
				cell.plusIcon.isHidden = false
				cell.img.layer.cornerRadius = 6
				cell.img.clipsToBounds = true
			}else{
				cell.img.kf.setImage(with: URL(string: self.spotModel.customerPictures[indexPath.row]))
				cell.plusIcon.isHidden = true
				cell.img.layer.cornerRadius = 6
				cell.img.clipsToBounds = true
			}
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if(indexPath.row == collectionView.numberOfItems(inSection: 0) - 1){
			self.photoPicker = CZPhotoPickerController(completionBlock: { (imagePickerController: UIImagePickerController?, imageInfoDict: [AnyHashable : Any]?) in
				
				guard let imageInfo = imageInfoDict else {
					return
				}
				var img: UIImage? = imageInfo[UIImagePickerController.InfoKey.editedImage] as? UIImage
				if img == nil {
					img = imageInfo[UIImagePickerController.InfoKey.originalImage] as? UIImage
				}
				guard let image = img else {
					return
				}
				self.dismiss(animated: true, completion: nil)
				let pictureData: Data = image.jpegData(compressionQuality: 0.9)!
				self.uploadImage(bucketName: "honeyspot-business-images", data: pictureData) { (result) in
					switch(result){
					case .success(let link):
						DispatchQueue.main.async {
							if(self.photosSegmentedControl.selectedSegmentIndex == 0){
								//Menu
								self.spotModel.menuPictures.append(link)
								self.menuPicturesCollectionView.reloadData()
							}else if(self.photosSegmentedControl.selectedSegmentIndex == 0){
								//Food
								self.spotModel.foodPictures.append(link)
								self.menuPicturesCollectionView.reloadData()
							}else{
								//Customers
								self.spotModel.customerPictures.append(link)
								self.menuPicturesCollectionView.reloadData()
							}
							
						}
					case .failure(let err):
						print(err.localizedDescription)
						HSAlertView.showAlert(withTitle: "Problem", message: "There is a problem uploading your image to our server")
					}
				}
			})
			self.photoPicker?.allowsEditing = true
			self.photoPicker?.present(from: self)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if(segue.identifier == "editCategories"){
			let dest = segue.destination as! BusinessRestaurantEditUpdateCategoriesViewController
			dest.spotModel = self.spotModel
		}else if(segue.identifier == "updateContactInfo"){
			let dest = segue.destination as! BusinessRestaurantEditUpdateContactInfoViewController
			dest.spotModel = self.spotModel
		}else if(segue.identifier == "editGeneralInfo"){
			let dest = segue.destination as! BusinessRestaurantEditUpdateGeneralInfoViewController
			dest.spotModel = self.spotModel
		}else if(segue.identifier == "editLocations"){
			let dest = segue.destination as! BusinessRestaurantEditManageLocationsViewController
			dest.spotModel = self.spotModel
		}else if(segue.identifier == "updateHours"){
			let dest = segue.destination as! BusinessRestaurantEditUpdateHoursViewController
			dest.spotModel = self.spotModel
			dest.superVc = self
		}else if(segue.identifier == "editService"){
			let dest = segue.destination as! BusinessRestaurantEditUpdateServiceViewController
			dest.spotModel = self.spotModel
		}
        else if(segue.identifier == "editDelivery"){
            let dest = segue.destination as! DeliveryPartnerViewController
            dest.spotModel = self.spotModel
        }
        else if(segue.identifier == "updateMedia"){
            let dest = segue.destination as! MediaEditViewController
            dest.spotModel = self.spotModel
        }
        else if(segue.identifier == "editReservation"){
            let dest = segue.destination as! BusinessRestaurantEditUpdateReservationViewController
            dest.spotModel = self.spotModel
        }
	}
	
}

extension BusinessRestaurantEditViewController : BusinessEditDelegate {
	
	func coverPhotoEditTapped() {
		self.photoPicker = CZPhotoPickerController(completionBlock: { (imagePickerController: UIImagePickerController?, imageInfoDict: [AnyHashable : Any]?) in
			
			guard let imageInfo = imageInfoDict else {
				return
			}
			var img: UIImage? = imageInfo[UIImagePickerController.InfoKey.editedImage] as? UIImage
			if img == nil {
				img = imageInfo[UIImagePickerController.InfoKey.originalImage] as? UIImage
			}
			guard let image = img else {
				return
			}
			self.dismiss(animated: true, completion: nil)
			let pictureData: Data = image.jpegData(compressionQuality: 0.9)!
			self.uploadImage(bucketName: "honeyspot-business-images", data: pictureData) { (result) in
				switch(result){
				case .success(let link):
					DispatchQueue.main.async {
						self.spotModel.photoUrl =  link
						self.infoTableView.reloadData()
						self.save()
					}
				case .failure(let err):
					print(err.localizedDescription)
					HSAlertView.showAlert(withTitle: "Problem", message: "There is a problem uploading your image to our server")
				}
			}
		})
		self.photoPicker?.allowsEditing = true
		self.photoPicker?.present(from: self)
	}
	
	func menuPhotoEditTapped() {
		self.photoPicker = CZPhotoPickerController(completionBlock: { (imagePickerController: UIImagePickerController?, imageInfoDict: [AnyHashable : Any]?) in
			
			guard let imageInfo = imageInfoDict else {
				return
			}
			var img: UIImage? = imageInfo[UIImagePickerController.InfoKey.editedImage] as? UIImage
			if img == nil {
				img = imageInfo[UIImagePickerController.InfoKey.originalImage] as? UIImage
			}
			guard let image = img else {
				return
			}
			self.dismiss(animated: true, completion: nil)
			let pictureData: Data = image.jpegData(compressionQuality: 0.9)!
			self.uploadImage(bucketName: "honeyspot-business-images", data: pictureData) { (result) in
				switch(result){
				case .success(let link):
					DispatchQueue.main.async {
						self.spotModel.menuPictures.append(link)
						self.infoTableView.reloadData()
						self.save()
					}
				case .failure(let err):
					print(err.localizedDescription)
					HSAlertView.showAlert(withTitle: "Problem", message: "There is a problem uploading your image to our server")
				}
			}
		})
		self.photoPicker?.allowsEditing = true
		self.photoPicker?.present(from: self)
	}
	
	func imagePhotoEditTapped() {
		self.photoPicker = CZPhotoPickerController(completionBlock: { (imagePickerController: UIImagePickerController?, imageInfoDict: [AnyHashable : Any]?) in
			
			guard let imageInfo = imageInfoDict else {
				return
			}
			var img: UIImage? = imageInfo[UIImagePickerController.InfoKey.editedImage] as? UIImage
			if img == nil {
				img = imageInfo[UIImagePickerController.InfoKey.originalImage] as? UIImage
			}
			guard let image = img else {
				return
			}
			self.dismiss(animated: true, completion: nil)
			let pictureData: Data = image.jpegData(compressionQuality: 0.9)!
			self.uploadImage(bucketName: "honeyspot-business-images", data: pictureData) { (result) in
				switch(result){
				case .success(let link):
					DispatchQueue.main.async {
						self.spotModel.foodPictures.append(link)
						self.infoTableView.reloadData()
						self.save()
					}
				case .failure(let err):
					print(err.localizedDescription)
					HSAlertView.showAlert(withTitle: "Problem", message: "There is a problem uploading your image to our server")
				}
			}
		})
		self.photoPicker?.allowsEditing = true
		self.photoPicker?.present(from: self)
	}
	
	
	
	
}

extension BusinessRestaurantEditViewController {
	
	func editServicesTapped(){
		self.performSegue(withIdentifier: "editService", sender: nil)
	}
    func editDeliveryPartnersTapped(){
        self.performSegue(withIdentifier: "editDelivery", sender: nil)
    }
	
	func editCategoriesTapped(){
		self.performSegue(withIdentifier: "editCategories", sender: nil)
	}
	
	func editUpdateContactTapped(){
		self.performSegue(withIdentifier: "updateContactInfo", sender: nil)
	}
	
	func editUpdateGeneralInfoTapped(){
		self.performSegue(withIdentifier: "editGeneralInfo", sender: nil)
	}
	
	func editLocations(){
		self.performSegue(withIdentifier: "editLocations", sender: nil)
	}
	
	func editUpdateHours(){
		self.performSegue(withIdentifier: "updateHours", sender: nil)
	}
    func editMedia(){
        self.performSegue(withIdentifier: "updateMedia", sender: nil)
    }
    func editReservation(){
        self.performSegue(withIdentifier: "editReservation", sender: nil)
    }
}

extension BusinessRestaurantEditViewController : UITableViewDelegate,UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if(spotModel != nil){
            if AppDelegate.originalDelegate.isFree {
                return 9
            }
            else
            {
                return 10
            }
			
		}else{
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if(indexPath.row == 0){
			let cell = tableView.dequeueReusableCell(withIdentifier: "imageCellId") as! RestaurantDetailImageTableViewCell
			cell.prepareCell(model : spotModel)
			return cell
		}else if(indexPath.row == 1){
			let cell = tableView.dequeueReusableCell(withIdentifier: "generalCellId") as! RestaurantDetailGeneralTableViewCell
			cell.superVc = self
			cell.prepareCell(model : spotModel)
			return cell
		}else if(indexPath.row == 2){
			let cell = tableView.dequeueReusableCell(withIdentifier: "locationCellId") as! RestaurantDetailLocationsTableViewCell
			cell.superVc = self
			cell.prepareCell(model : spotModel)
			return cell
		}else if(indexPath.row == 3){
			let cell = tableView.dequeueReusableCell(withIdentifier: "hoursCellId") as! RestaurantDetailHoursOfOperationsTableViewCell
			cell.superVc = self
			cell.prepareCell(model : spotModel)
			return cell
		}else if(indexPath.row == 4){
			let cell = tableView.dequeueReusableCell(withIdentifier: "contactCellId") as! RestaurantDetailContactInfoTableViewCell
			cell.superVc = self
			cell.prepareCell(model : spotModel)
			return cell
		}else if(indexPath.row == 5){
			let cell = tableView.dequeueReusableCell(withIdentifier: "serviceCellId") as! RestaurantDetailServiceOfferedTableViewCell
			cell.superVc = self
			cell.prepareCell(model : spotModel)
			return cell
        }
		else if(indexPath.row == 6){
            let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryCellId") as! DeliveryPartnerTableViewCell
            cell.superVc = self
            cell.prepareCell(model : spotModel)
            return cell
        }
        else if(indexPath.row == 7){
			let cell = tableView.dequeueReusableCell(withIdentifier: "mediaCellId") as! RestaurantDetailMediaTableViewCell
			cell.superVc = self
			cell.delegate = self
			cell.prepareCell(model : spotModel)
			return cell
		}else if(indexPath.row == 8){
			let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCellId") as! RestaurantDetailCategoriesTableViewCell
			cell.superVc = self
			cell.prepareCell(model : spotModel)
			return cell
		}
        else if(indexPath.row == 9){
            let cell = tableView.dequeueReusableCell(withIdentifier: "reservationCellId") as! RestaurantDetailReservationTableViewCell
            cell.superVc = self
            cell.prepareCell(model : spotModel)
            return cell
        }
        else{
			return UITableViewCell()
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if(indexPath.row == 0){
			return 128
		}else if(indexPath.row == 1){
			return UITableView.automaticDimension
		}else if(indexPath.row == 2){
			return UITableView.automaticDimension
		}else if(indexPath.row == 3){
			return 315 //UITableView.automaticDimension
		}else if(indexPath.row == 4){
			return 150
		}else if(indexPath.row == 5){
			return 160     //UITableView.automaticDimension
		}else if(indexPath.row == 6){
			return 180
		}else if(indexPath.row == 7){
            return 320
		}else if(indexPath.row == 8){
            return UITableView.automaticDimension
        }
        else if(indexPath.row == 9){
            return 120
        }
        else{
			return 20
		}
	}
	
}
									
