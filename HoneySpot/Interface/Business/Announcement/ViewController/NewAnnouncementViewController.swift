//
//  NewAnnouncementViewController.swift
//  HoneySpot
//
//  Created by htcuser on 01/10/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit
import CZPhotoPickerController
import AWSS3

enum PickerType {
    case startDate, endDate
}

class NewAnnouncementViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var announcementScrollView: UIScrollView!
    @IBOutlet weak var announcementTitle: TextField!
    @IBOutlet weak var announcementStartDate: TextField!
    @IBOutlet weak var announcementEndDate: TextField!
    @IBOutlet weak var announcementDescription: UITextView!
    @IBOutlet weak var announcementRecipients: TextField!
    @IBOutlet weak var announcementImageView: UIImageView!
    @IBOutlet weak var announcementSenderButton: UIButton!
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var deleteImage: UIButton!
    @IBOutlet weak var addImageView: UIView!
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    var dateBackgroundView = UIView()
    var selectedDate = PickerType.startDate
    var announcementModel : AnnouncementModel!
    var updateAnnouncementLitModel:AnnouncementListModel!
    var announcementListModel: [AnnouncementListModel] = []
    var rowSelected : Int?
    var spotModel : SpotModel!
    var announcementImageUrl = ""
    var isNewAnnouncement:Bool = true
    var isStartValueChanged:Bool = false
    var isEndValueChanged:Bool = false
    
    
    var startDate = Date()
    var endDate = Date()
    
    var photoPicker : CZPhotoPickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.restaurantChanged), name: NSNotification.Name.init("restaurantChanged"), object: nil)
        imagePicker.delegate = self
        setupViews()
        print(isNewAnnouncement)
        if !isNewAnnouncement {
            setUpEditView()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(spotModel.id)
    }
    
    //MARK: - Set Up Intial Views
    func setupViews(){
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.navigationController?.isNavigationBarHidden = true
        announcementDescription.text = "Enter Description"
        announcementDescription.textColor = UIColor.lightGray
        announcementRecipients.text = "HoneySpotters"
    }
    @objc func restaurantChanged(){
        self.spotModel = selectedBusiness.spot
        print(spotModel.id)
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
//        for aViewController in viewControllers {
//            if aViewController is AnnouncementViewController {
//                self.navigationController!.popToViewController(aViewController, animated: true)
//            }
//        }
    }
    //MARK: - Set Up Edit Announcement View
    func setUpEditView()  {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        let announcementData = announcementListModel[rowSelected!]
        announcementTitle.text = announcementData.title
        announcementStartDate.text = self.convertDateFormat(dateString: announcementData.create_date)
        announcementEndDate.text = announcementData.end_date
        announcementRecipients.text = "HoneySpotters"
        announcementDescription.text = announcementData.description
        announcementDescription.textColor = UIColor.black
        
        startDate = dateFormatter.date(from: announcementStartDate.text!)!
        endDate = dateFormatter.date(from: announcementEndDate.text!)!
        
        announcementImageUrl = announcementData.imageurl
        if announcementImageUrl == "" {
            
            self.announcementImageView.image = UIImage(named: "loginBackImage")
        }
        else
        {
            self.announcementImageView.kf.setImage(with: URL(string: announcementImageUrl))
        }
        
        self.addImageView.isHidden = true
        self.deleteImage.isHidden = false
        
        
    }

    @IBAction func didClickSendToRecepients(_ sender: Any) {
        
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//            alert.addAction(UIAlertAction(title: "HoneySpotters", style: .default , handler:{ (UIAlertAction)in
//                print("User click Approve button")
//                self.announcementRecipients.text = "HoneySpotters"
//            }))
//
//            alert.addAction(UIAlertAction(title: "Send to all Users", style: .default , handler:{ (UIAlertAction)in
//                print("Send to all Users")
//                self.announcementRecipients.text = "Send to all Users"
//            }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
//                print("User click Dismiss button")
//            }))
//
//
//            self.present(alert, animated: true, completion: {
//                print("completion block")
//            })
        
    }
    
    
    
    @IBAction func didClickAnnouncementImage(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func didClickStartDate(_ sender: Any) {
        selectedDate = PickerType.startDate
        toolBar.removeFromSuperview()
        dateBackgroundView.removeFromSuperview()
        openDatePicker()
    }
    
    @IBAction func didClickEndDate(_ sender: Any) {
        selectedDate = PickerType.endDate
        toolBar.removeFromSuperview()
        dateBackgroundView.removeFromSuperview()
        openDatePicker()
    }
    
    
    
    func openDatePicker() {
        announcementTitle.resignFirstResponder()
        announcementDescription.resignFirstResponder()
       // self.onDoneButtonClick()
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
        
        datePicker.backgroundColor = UIColor.white
        
        var keyWindow : UIWindow!
        if #available(iOS 13.0, *) {
            keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        } else {
            // Fallback on earlier versions
            keyWindow = UIApplication.shared.keyWindow!
        }
        
        keyWindow.overrideUserInterfaceStyle = .light
        
        datePicker = UIDatePicker.init()
        datePicker.backgroundColor = UIColor.white
        datePicker.tintColor = UIColor.black
        
        //Set minimum and Maximum Dates
        let calendar = Calendar(identifier: .gregorian)
        var comps = DateComponents()
        comps.month = 6
        let maxDate = calendar.date(byAdding: comps, to: Date())
        comps.month = 0
        comps.day = 0
        let minDate = calendar.date(byAdding: comps, to: Date())
        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
        
        
        datePicker.setValue(UIColor.label, forKeyPath: "textColor")
        datePicker.autoresizingMask = .flexibleWidth
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        let label = UILabel(frame: .zero)
        
        datePicker.datePickerMode = .date

        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        datePicker.frame = CGRect(x: 0.0, y: 0, width: UIScreen.main.bounds.size.width, height: 300)
        dateBackgroundView = UIView(frame: CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300))
        dateBackgroundView.backgroundColor = UIColor.white
        dateBackgroundView.addSubview(datePicker)
        keyWindow!.addSubview(dateBackgroundView)

        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))

        if(selectedDate == .startDate){
            label.text = "Starts at"
        }else if(selectedDate == .endDate){
            label.text = "Ends at"
        }
        label.textAlignment = .center
        label.textColor = UIColor.black
        let customBarButton = UIBarButtonItem(customView: label)
        let rightSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), customBarButton, rightSpace, UIBarButtonItem(title: "   " + "Done" + "  ", style: .done, target: self, action: #selector(self.onDoneButtonClick(_:)))]
        
        toolBar.sizeToFit()
        toolBar.barTintColor = UIColor.white
        keyWindow!.addSubview(toolBar)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        
        if(selectedDate == .startDate){
            announcementStartDate.text = dateFormatter.string(from: sender!.date)
        }else if(selectedDate == .endDate){
            announcementEndDate.text = dateFormatter.string(from: sender!.date)
        }
        
        if announcementStartDate.text != "" {
            startDate = dateFormatter.date(from: announcementStartDate.text!)!
        }
        if announcementEndDate.text != "" {
            endDate = dateFormatter.date(from: announcementEndDate.text!)!
        }
            
    }
    
    
    @objc func onDoneButtonClick(_ button: UIBarButtonItem?) {
        
        toolBar.removeFromSuperview()
        dateBackgroundView.removeFromSuperview()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        
        if(selectedDate == .startDate){
            announcementStartDate.text = dateFormatter.string(from: datePicker.date)
            startDate = dateFormatter.date(from: announcementStartDate.text!)!
            
        }else if(selectedDate == .endDate){
            announcementEndDate.text = dateFormatter.string(from: datePicker.date)
            endDate = dateFormatter.date(from: announcementEndDate.text!)!
        }

//        if(selectedDate == .startDate){
//            if startDate > endDate {
//                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please select appropriate date")
//            }
//        }else if(selectedDate == .endDate){
//            if startDate > endDate {
//                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please select appropriate date")
//            }
//
//        }
        
        
    }
    func uploadImage(bucketName : String,data : Data,completion: @escaping (Result<String,Error>) -> ()){
        
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
                print(HTTPResponse)
                DispatchQueue.main.async {
                    self.hideAllHuds()
                }
                let link = "https://" + bucketName + ".s3.us-east-2.amazonaws.com/" + remoteName
                completion(.success(link))
                
            }
        }
        
    }
    
    //MARK: - Create / Update Announcement
    @IBAction func didClickSendNow(_ sender: Any) {
        
                //Check condition before sending
                if announcementTitle.text == "" && announcementStartDate.text == "" && announcementEndDate.text == "" && (announcementDescription.text == "" || announcementDescription.text == "Enter Description") && announcementImageUrl == ""
                {
                    HSAlertView.showAlert(withTitle: "HoneySpot", message: "Enter all the required details")
                }
                else
                {
                    if announcementTitle.text == ""
                    {
                        HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter title")
                    }
                    else if announcementStartDate.text == ""
                    {
                        HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please select start date")
                    }
                    else if announcementEndDate.text == ""
                    {
                        HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please select end date")
                    }
                    else if announcementDescription.text == "" || announcementDescription.text == "Enter Description"
                    {
                        HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please enter description")
                    }
                    else if startDate > endDate
                    {
                        HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please select appropriate date")
                    }
                    else if announcementImageUrl == ""
                    {
                        HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please upload the image")
                        
                    }
                    
                    else
                    {
                        //Web service call
                        print("Call Webservice")
                        if isNewAnnouncement {
                            
                            self.showLoadingHud()
                            announcementModel = AnnouncementModel(id: spotModel.id, imageurl: self.announcementImageUrl, title: announcementTitle.text!, description: announcementDescription.text, create_date: announcementStartDate.text!, end_date: announcementEndDate.text!)
                            if announcementModel != nil {
                                AnnouncementDataSource().createAnnouncement(announcementModel: announcementModel) { (result) in
                                    
                                switch(result){
                                case .success(let str):
                                    print(str)
                                    self.hideAllHuds()
                                    self.navigationController?.popViewController(animated: true)
                                    HSAlertView.showAlert(withTitle: "HoneySpot", message: "New Announcement Feed is created")
                                    
                                case .failure(let err):
                                    print(err)
                                    self.hideAllHuds()
                                    self.showErrorHud(message: err.errorMessage)
                                   }
                                }
                                
                            }
                            else
                            {
                                self.hideAllHuds()
                                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Error")
                            }
                            
                        }
                        else
                        {
                            self.showLoadingHud()
                            let announcementData = announcementListModel[rowSelected!]
                            updateAnnouncementLitModel = AnnouncementListModel(create_date: announcementStartDate.text!, description: announcementDescription.text, end_date: announcementEndDate.text!, announcementId: announcementData.announcementId, imageurl: self.announcementImageUrl, postedby: announcementData.postedby, spotid: announcementData.spotid, title: announcementTitle.text!)
                          //  announcementModel = AnnouncementModel(id: spotModel.id, imageurl: self.announcementImageUrl, title: announcementTitle.text!, description: announcementDescription.text, create_date: announcementStartDate.text!, end_date: announcementEndDate.text!)
                                AnnouncementDataSource().updateAnnouncement(announcementListModel: updateAnnouncementLitModel) { (result) in
                                    switch(result){
                                    case .success(let result):
                                        print(result)
                                       //self.navigationController?.popViewController(animated: true)
                                        self.hideAllHuds()
                                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                                        for aViewController in viewControllers {
                                            if aViewController is AnnouncementViewController {
                                                self.navigationController!.popToViewController(aViewController, animated: true)
                                            }
                                        }
                                        HSAlertView.showAlert(withTitle: "HoneySpot", message: "Announcement Feed has been updated")
                                    case .failure(let err):
                                        self.hideAllHuds()
                                        print(err)
                                    }
                                    
                                }
                         }
                    }
                    
                }
                
            }
    
    @IBAction func didClickDeleteImage(_ sender: Any) {
        announcementImageUrl = ""
        self.announcementImageView.image = UIImage(named: "announcementBackground")
        self.addImageView.isHidden = false
        self.deleteImage.isHidden = true
    }
    
    
    @IBAction func didClickBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func convertDateFormat(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        print(date as Any)
        let convertedDate = AnnouncementDataSource().convertDateToString(date: date!, format: "MMMM dd, yyyy")
        print(convertedDate)
        
        return convertedDate
    }
    
    func resize(textView: UITextView) {
           var newFrame = textView.frame
           let width = newFrame.size.width
           let newSize = textView.sizeThatFits(CGSize(width: width,
                                                      height: CGFloat.greatestFiniteMagnitude))
           newFrame.size = CGSize(width: width, height: newSize.height)
           textView.frame = newFrame
       }
    
    func checkDate(currentDate: Date, endDate: Date) -> Bool{
        
        if currentDate > endDate  {
            
            return true
        }
        else
        {
            return false
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        var img: UIImage? = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if img == nil {
            img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        guard let image = img else {
            return
        }
        let pictureData: Data = image.jpegData(compressionQuality: 0.9)!
        let newImage:UIImage = UIImage(data: pictureData)!
        
        
        let imageBase64String:String = pictureData.base64EncodedString()
        print(imageBase64String)
        
        
        self.announcementImageView.image = newImage
        self.addImageView.isHidden = true
        self.deleteImage.isHidden = false
        
        self.showLoadingHud()
        
        BusinessRestaurantDataSource().uploadImage(imageBase64:imageBase64String) { (result) in
            switch(result){
            case .success(let imageModel):
                print(imageModel.ImageURL)
                self.hideAllHuds()
                self.announcementImageUrl = imageModel.ImageURL
            case .failure(let err):
                self.hideAllHuds()
                self.showErrorHud(message: "Problem occured please try again")
            }
        }
            
//        DispatchQueue.background(background: {
//            // do something in background
//            self.uploadImage(bucketName: "honeyspot-business-images", data: pictureData) { (result) in
//                switch(result){
//                case .success(let link):
//                    DispatchQueue.main.async {
//                        self.hideAllHuds()
//                        print(link)
//                        self.announcementImageUrl = link
//                       // self.announcementImageView.kf.setImage(with: URL(string: link))
//
//
//                    }
//                case .failure(let err):
//                    print(err.localizedDescription)
//                    HSAlertView.showAlert(withTitle: "Problem", message: "There is a problem uploading your image to our server")
//                }
//                self.hideAllHuds()
//            }
//        }, completion:{
//            // when background job finished, do something in main thread
//        })

        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
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
extension DispatchQueue {

    static func background(delay: Double = 2.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}

extension NewAnnouncementViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if announcementDescription.textColor == UIColor.lightGray {
            announcementDescription.text = nil
            announcementDescription.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if announcementDescription.text.isEmpty {
            announcementDescription.text = "Enter Description"
            announcementDescription.textColor = UIColor.lightGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        //textView.resizeForHeight()
        //resize(textView: textView)
    }
    
    
}

extension UITextView {
    func resizeForHeight(){
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}
