//
//  ProfileEditViewController.swift
//  HoneySpot
//
//  Created by Max on 2/18/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import CZPhotoPickerController
import OneSignal
import AWSS3
import AWSCore

class ProfileEditViewController: UIViewController {

//    @IBOutlet weak var userNameTextField: EditTextField!
//    @IBOutlet weak var emailTextField: EditTextField!
//    @IBOutlet weak var bioTextField: EditTextField!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var avatarView: AvatarView!
    var photoPicker: CZPhotoPickerController?
    
    var userModel : UserModel!
    var textValueChanged = false
    
    static let STORYBOARD_IDENTIFIER = "ProfileEditViewController"
    enum THEME_STYLE: Int {
        case STYLE1 = 0
        case STYLE2 = 1
        case STYLE3 = 2
        case STYLE4 = 3
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        self.saveButton.backgroundColor = UIColor.init(red: 229.0/255.0, green: 229.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        saveButton.isUserInteractionEnabled = false
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationItem.titleView = navTitleLabel(withStyle: .STYLE4)
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "backIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(self.backButtonTapped), for: .touchUpInside)
        
        let rightBarItem = UIBarButtonItem(customView: button)
        rightBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        rightBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        rightBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        rightBarItem.tintColor = UIColor.black
        
        self.navigationItem.leftBarButtonItem = rightBarItem
        
        userNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        bioTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
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
        case .STYLE4:
            navTitle = NSMutableAttributedString(string: "Edit Profile", attributes:[
                NSAttributedString.Key.font: UIFont.fontHelveticaBold(withSize: 23),
                NSAttributedString.Key.foregroundColor: UIColor.BLACK_COLOR])
            navigationController?.navigationBar.barTintColor = .WHITE_COLOR
            break
        }
        navLabel.attributedText = navTitle
        
        return navLabel
    }
    
    @objc func backButtonTapped(){
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func onBackButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        avatarView.delegate = self
        avatarView.userModel = userModel
        self.avatarView.editMode = true
        super.viewWillAppear(animated)
        
//        let parentVC: ProfileViewController = self.parent as! ProfileViewController
//        parentVC.enterEditMode()
        
        userNameTextField.text = userModel.username
        emailTextField.text = userModel.email
        bioTextField.text = userModel.userBio

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //let parentVC: ProfileViewController = self.parent as! ProfileViewController
       // parentVC.exitEditMode()
        super.viewWillDisappear(animated)
    }
    @IBAction func onCancelButtonTap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == userNameTextField {

            if textField.text == userModel.username {

                print("Same username")
                if emailTextField.text == userModel.email && bioTextField.text == userModel.userBio{
                    textValueChanged = false
                }
                else
                {
                    textValueChanged = true
                }

            }
            else{

                textValueChanged = true
            }
        }
        else if textField == emailTextField
        {
            if textField.text == userModel.email {
                print("Same email")
                if userNameTextField.text == userModel.username && bioTextField.text == userModel.userBio{
                    textValueChanged = false
                }
                else
                {
                    textValueChanged = true
                }

            }
            else{
                textValueChanged = true
            }
        }
        else if textField == bioTextField
        {
            if textField.text == userModel.userBio {
                print("Same bio")
                if userNameTextField.text == userModel.username && emailTextField.text == userModel.email{
                    textValueChanged = false
                }
                else
                {
                    textValueChanged = true
                }

            }
            else{
                textValueChanged = true
            }
        }
        
        if textValueChanged
        {
            saveButton.isUserInteractionEnabled = true
            saveButton.backgroundColor = UIColor.init(red: 249.0/255.0, green: 99.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        }
        else
        {
            saveButton.isUserInteractionEnabled = false
            self.saveButton.backgroundColor = UIColor.init(red: 229.0/255.0, green: 229.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        }

    }

    @IBAction func onSaveButtonTap(_ sender: Any) {
        var email: String = emailTextField.text?.lowercased().trimmingCharacters(in: .whitespaces) ?? ""
        email = String(email.filter { !" \n\t\r".contains($0) })
        var userName: String = userNameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        userName = String(userName.filter { !" \n\t\r".contains($0) })
        
        if !email.isEmpty && !email.isValidEmail() {
            showErrorHud(message: "Please type valid email address")
            return
        }
        
        if userName.isEmpty || !userName.isValidUserName() {
            showErrorHud(message: "Please type valid username")
            return
        }
        
        showLoadingHud()
        ProfileDataSource().updateUser(username: userName, email: email, bio: bioTextField.text ?? "" , pictureUrl : userModel.pictureUrl ?? "") { (result) in
            self.hideAllHuds()
            switch(result){
            case .success(let successStr):
                AppDelegate.originalDelegate.isSameProfile = true
                print(successStr)
                self.navigationController?.popToRootViewController(animated: true)
            case .failure(let err):
                print(err)
            }
        }
        
    }
}
extension ProfileEditViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userNameTextField {
            
        }
        else if textField == emailTextField
        {
            
        }
        else if textField == bioTextField
        {
            
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userNameTextField {

            if textField.text == userModel.username {

                print("Same username")
                if emailTextField.text == userModel.email && bioTextField.text == userModel.userBio{
                    textValueChanged = false
                }
                else
                {
                    textValueChanged = true
                }

            }
            else{

                textValueChanged = true
            }
        }
        else if textField == emailTextField
        {
            if textField.text == userModel.email {
                print("Same email")
                if userNameTextField.text == userModel.username && bioTextField.text == userModel.userBio{
                    textValueChanged = false
                }
                else
                {
                    textValueChanged = true
                }

            }
            else{
                textValueChanged = true
            }
        }
        else if textField == bioTextField
        {
            if textField.text == userModel.userBio {
                print("Same bio")
                if userNameTextField.text == userModel.username && emailTextField.text == userModel.email{
                    textValueChanged = false
                }
                else
                {
                    textValueChanged = true
                }

            }
            else{
                textValueChanged = true
            }
        }
        
        if textValueChanged
        {
            saveButton.isUserInteractionEnabled = true
            saveButton.backgroundColor = UIColor.init(red: 249.0/255.0, green: 99.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        }
        else
        {
            saveButton.isUserInteractionEnabled = false
            self.saveButton.backgroundColor = UIColor.init(red: 229.0/255.0, green: 229.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        }
        
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {

            if textField.text == userModel.username {

                print("Same username")
                if emailTextField.text == userModel.email && bioTextField.text == userModel.userBio{
                    textValueChanged = false
                }
                else
                {
                    textValueChanged = true
                }

            }
            else{

                textValueChanged = true
            }
        }
        else if textField == emailTextField
        {
            if textField.text == userModel.email {
                print("Same email")
                if userNameTextField.text == userModel.username && bioTextField.text == userModel.userBio{
                    textValueChanged = false
                }
                else
                {
                    textValueChanged = true
                }

            }
            else{
                textValueChanged = true
            }
        }
        else if textField == bioTextField
        {
            if textField.text == userModel.userBio {
                print("Same bio")
                if userNameTextField.text == userModel.username && emailTextField.text == userModel.email{
                    textValueChanged = false
                }
                else
                {
                    textValueChanged = true
                }

            }
            else{
                textValueChanged = true
            }
        }
        
        if textValueChanged
        {
            saveButton.isUserInteractionEnabled = true
            saveButton.backgroundColor = UIColor.init(red: 249.0/255.0, green: 99.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        }
        else
        {
            saveButton.isUserInteractionEnabled = false
            self.saveButton.backgroundColor = UIColor.init(red: 229.0/255.0, green: 229.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        }
        textField.resignFirstResponder()
        
        return true
    }
    
}
extension ProfileEditViewController: AvatarViewDelegate {
    func didTapAvatarView(_ sender: AvatarView) {
        if !self.avatarView.editMode {
            return
        }
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
            
            let imageBase64String:String = pictureData.base64EncodedString()
            print(imageBase64String)
            self.showLoadingHud()
            BusinessRestaurantDataSource().uploadImage(imageBase64:imageBase64String) { (result) in
                switch(result){
                case .success(let imageModel):
                    print(imageModel.ImageURL)
                    self.avatarView.imageView.image = UIImage(data: pictureData)
                    self.userModel.pictureUrl = imageModel.ImageURL
                    //currentUser = self.userModel
                    self.avatarView.userModel = self.userModel
                    self.textValueChanged = true
                    self.saveButton.isUserInteractionEnabled = true
                    self.saveButton.backgroundColor = UIColor.init(red: 249.0/255.0, green: 99.0/255.0, blue: 50.0/255.0, alpha: 1.0)
                    self.hideAllHuds()
                    
                case .failure(let err):
                    self.hideAllHuds()
                    self.showErrorHud(message: "Problem occured please try again")
                }
            }
            
            
            //self.uploadImage(data: pictureData)
        })
        self.photoPicker?.allowsEditing = true
        self.photoPicker?.present(from: self)
    }
    
    func uploadImage(data : Data){
        
        DispatchQueue.main.async {
            self.showLoadingHud()
        }
    
        let remoteName = UUID().uuidString + ".jpg"
        let S3BucketName = "honeyspot-user-images"

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
            }
            if let HTTPResponse = task.response {
                DispatchQueue.main.async {
                    self.hideAllHuds()
                }
                print(HTTPResponse)
                let link = "https://honeyspot-user-images.s3.us-east-2.amazonaws.com/" + remoteName
                DispatchQueue.main.async {
                    self.avatarView.imageView.image = UIImage(data: data)
                    self.userModel.pictureUrl = link
                    currentUser = self.userModel
                    self.avatarView.userModel = self.userModel
                }
            }
        }
        
    }
}
