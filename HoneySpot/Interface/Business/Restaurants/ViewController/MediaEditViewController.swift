//
//  MediaEditViewController.swift
//  HoneySpot
//
//  Created by htcuser on 28/10/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit
import AWSS3

class MediaEditViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var coverPhotoView: UIView!
    //One
    @IBOutlet weak var coverPhotoViewOne: UIView!
    @IBOutlet weak var coverPhotoImageViewOne: UIImageView!
    @IBOutlet weak var coverPhotoInternalViewOne: UIView!
    @IBOutlet weak var deleteCoverPhotoOne: UIButton!
    
    //Two
    @IBOutlet weak var coverPhotoViewTwo: UIView!
    @IBOutlet weak var coverPhotoImageViewTwo: UIImageView!
    @IBOutlet weak var coverPhotoInternalViewTwo: UIView!
    @IBOutlet weak var deleteCoverPhotoTwo: UIButton!
    
    //Three
    @IBOutlet weak var coverPhotoViewThree: UIView!
    @IBOutlet weak var coverPhotoImageViewThree: UIImageView!
    @IBOutlet weak var coverPhotoInternalViewThree: UIView!
    @IBOutlet weak var deleteCoverPhotoThree: UIButton!
    
    //Four
    @IBOutlet weak var coverPhotoViewFour: UIView!
    @IBOutlet weak var coverPhotoImageViewFour: UIImageView!
    @IBOutlet weak var coverPhotoInternalViewFour: UIView!
    @IBOutlet weak var deleteCoverPhotoFour: UIButton!
    
    //Five
    
    @IBOutlet weak var coverPhotoViewFive: UIView!
    @IBOutlet weak var coverPhotoImageViewFive: UIImageView!
    @IBOutlet weak var coverPhotoInternalViewFive: UIView!
    @IBOutlet weak var deleteCoverPhotoFive: UIButton!
    
    
    
    @IBOutlet weak var menuView: UIView!
    //One
    @IBOutlet weak var menuViewOne: UIView!
    @IBOutlet weak var menuImageViewOne: UIImageView!
    @IBOutlet weak var menuInternalViewOne: UIView!
    @IBOutlet weak var deleteMenuOne: UIButton!
    
    //Two
    @IBOutlet weak var menuViewTwo: UIView!
    @IBOutlet weak var menuImageViewTwo: UIImageView!
    @IBOutlet weak var menuInternalViewTwo: UIView!
    @IBOutlet weak var deleteMenuTwo: UIButton!
    
    //Three
    @IBOutlet weak var menuViewThree: UIView!
    @IBOutlet weak var menuImageViewThree: UIImageView!
    @IBOutlet weak var menuInternalViewThree: UIView!
    @IBOutlet weak var deleteMenuThree: UIButton!
    
    //Four
    @IBOutlet weak var menuViewFour: UIView!
    @IBOutlet weak var menuImageViewFour: UIImageView!
    @IBOutlet weak var menuInternalViewFour: UIView!
    @IBOutlet weak var deleteMenuFour: UIButton!
    
    //Five
    
    @IBOutlet weak var menuViewFive: UIView!
    @IBOutlet weak var menuImageViewFive: UIImageView!
    @IBOutlet weak var menuInternalViewFive: UIView!
    @IBOutlet weak var deleteMenuFive: UIButton!
    
    
    
    @IBOutlet weak var imagesView: UIView!
    //One
    @IBOutlet weak var imagesViewOne: UIView!
    @IBOutlet weak var imagesImageViewOne: UIImageView!
    @IBOutlet weak var imagesInternalViewOne: UIView!
    @IBOutlet weak var deleteImagesOne: UIButton!
    
    //Two
    @IBOutlet weak var imagesViewTwo: UIView!
    @IBOutlet weak var imagesImageViewTwo: UIImageView!
    @IBOutlet weak var imagesInternalViewTwo: UIView!
    @IBOutlet weak var deleteImagesTwo: UIButton!
    
    //Three
    @IBOutlet weak var imagesViewThree: UIView!
    @IBOutlet weak var imagesImageViewThree: UIImageView!
    @IBOutlet weak var imagesInternalViewThree: UIView!
    @IBOutlet weak var deleteImagesThree: UIButton!
    
    //Four
    @IBOutlet weak var imagesViewFour: UIView!
    @IBOutlet weak var imagesImageViewFour: UIImageView!
    @IBOutlet weak var imagesInternalViewFour: UIView!
    @IBOutlet weak var deleteImagesFour: UIButton!
    
    //Five
    
    @IBOutlet weak var imagesViewFive: UIView!
    @IBOutlet weak var imagesImageViewFive: UIImageView!
    @IBOutlet weak var imagesInternalViewFive: UIView!
    @IBOutlet weak var deleteImagesFive: UIButton!
    
    
    
    
    @IBOutlet var mediaCollectionView: UICollectionView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet var coverPhotoButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var imagesButton: UIButton!
    @IBOutlet var mediaIndicatorBackView: UIView!
    @IBOutlet var mediaIndicatorView: UIView!
    let imagePicker = UIImagePickerController()
    
    var mediaImage = [UIImage]()
    var coverPhotoImageUrl = [String]()
    var uploadCoverPhotoImageUrl = [String]()
    var menuImageUrl = [String]()
    var uploadMenuImageUrl = [String]()
    var imagesUrl = [String]()
    var uploadImagesUrl = [String]()
    
    var coverPhotoArray = [Int]()
    var menuArray = [Int]()
    var imagesArray = [Int]()
    
    var imageLink = ""
    
    var currentIndex = 0
    
    var filterArray = [Int]()
    var spotModel : SpotModel!
    
    var selectedTag = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        
        coverPhotoImageUrl = ["0","1","2","3","4"]
        menuImageUrl = ["0","1","2","3","4"]
        imagesUrl = ["0","1","2","3","4"]

        print(spotModel as Any)
        self.filterArray = spotModel.categories
        applyButton.layer.cornerRadius = applyButton.frame.height / 2
        //mediaCollectionView.reloadData()
        addCoverPhotoGesture()
        addMenuGesture()
        addImagesGesture()
        updateCoverPhotos()
        updateMenus()
        updateImages()
        // Do any additional setup after loading the view.
    }
    func addCoverPhotoGesture()  {
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
                
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        coverPhotoView.addGestureRecognizer(leftSwipe)
        coverPhotoView.addGestureRecognizer(rightSwipe)
       
        
    }
    func addMenuGesture()  {
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
                
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        menuView.addGestureRecognizer(leftSwipe)
        menuView.addGestureRecognizer(rightSwipe)
        
    }
    func addImagesGesture()  {
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
                
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        imagesView.addGestureRecognizer(leftSwipe)
        imagesView.addGestureRecognizer(rightSwipe)
        
    }
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        if sender.view == coverPhotoView
        {
            print("CoverPhoto")
            if (sender.direction == .left) {
                print("Swipe Left")
                configureTab(index: 1)
            }
            else if (sender.direction == .right)
            {
                print("Swipe Right")
            }
        }
        else if sender.view == menuView
        {
            print("Menu")
            if (sender.direction == .left) {
                print("Swipe Left")
                configureTab(index: 2)
            }
            else if (sender.direction == .right)
            {
                print("Swipe Right")
                configureTab(index: 0)
            }
            
        }
        else if sender.view == imagesView
        {
            print("Menu")
            if (sender.direction == .left) {
                print("Swipe Left")
                //configureTab(index: 1)
            }
            else if (sender.direction == .right)
            {
                print("Swipe Right")
                configureTab(index: 1)
            }
            
        }
        
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func coverPhotoTapped(_ sender: Any) {
        configureTab(index: 0)
       // mediaCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        configureTab(index: 1)
       // mediaCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func imagesTapped(_ sender: Any) {
        configureTab(index: 2)
        //mediaCollectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func configureTab(index : Int){
        if(index == 0){
            currentIndex = 0
            mediaIndicatorView.frame = CGRect(x: 0 , y: 0, width: mediaIndicatorView.frame.width, height: mediaIndicatorView.frame.height)
            coverPhotoButton.setTitleColor(UIColor.black, for: .normal)
            menuButton.setTitleColor(UIColor.black, for: .normal)
            imagesButton.setTitleColor(UIColor.black, for: .normal)
            
            //Updating Fonts
            coverPhotoButton.titleLabel?.font = UIFont.fontHelveticaBold(withSize: 16)
            menuButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            imagesButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            
            coverPhotoView.isHidden = false
            menuView.isHidden = true
            imagesView.isHidden = true
            
            self.view.layoutIfNeeded()
        }else if(index == 1){
            currentIndex = 1
            mediaIndicatorView.frame = CGRect(x: 1 * (mediaIndicatorBackView.frame.width  / 3.0), y: 0, width: mediaIndicatorView.frame.width, height: mediaIndicatorView.frame.height)
            coverPhotoButton.setTitleColor(UIColor.black, for: .normal)
            menuButton.setTitleColor(UIColor.black, for: .normal)
            imagesButton.setTitleColor(UIColor.black, for: .normal)
            
            //Updating Fonts
            coverPhotoButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            menuButton.titleLabel?.font = UIFont.fontHelveticaBold(withSize: 16)
            imagesButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            
            coverPhotoView.isHidden = true
            menuView.isHidden = false
            imagesView.isHidden = true
            
            
            self.view.layoutIfNeeded()
        }else if(index == 2){
            currentIndex = 2
            mediaIndicatorView.frame = CGRect(x: 2 * (mediaIndicatorBackView.frame.width  / 3.0), y: 0, width: mediaIndicatorView.frame.width, height: mediaIndicatorView.frame.height)
            coverPhotoButton.setTitleColor(UIColor.black, for: .normal)
            menuButton.setTitleColor(UIColor.black, for: .normal)
            imagesButton.setTitleColor(UIColor.black, for: .normal)
            
            //Updating Fonts
            coverPhotoButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            menuButton.titleLabel?.font = UIFont.fontHelveticaRegular(withSize: 16)
            imagesButton.titleLabel?.font = UIFont.fontHelveticaBold(withSize: 16)
            
            coverPhotoView.isHidden = true
            menuView.isHidden = true
            imagesView.isHidden = false
            
            self.view.layoutIfNeeded()
        }
    }
    
    func updateCoverPhotos()  {
        
        if spotModel.customerPictures.count > 0 {
            for (index,element) in spotModel.customerPictures.enumerated() {
                if spotModel.customerPictures[index].contains("https") {
                    coverPhotoImageUrl.insert(element, at: index)
                    if index == 0 {
                        coverPhotoImageViewOne.kf.setImage(with: URL(string: coverPhotoImageUrl[index]))
                        deleteCoverPhotoOne.isHidden = false
                    }
                    else if index == 1 {
                        coverPhotoImageViewTwo.kf.setImage(with: URL(string: coverPhotoImageUrl[index]))
                        deleteCoverPhotoTwo.isHidden = false
                    }
                    else if index == 2 {
                        coverPhotoImageViewThree.kf.setImage(with: URL(string: coverPhotoImageUrl[index]))
                        deleteCoverPhotoThree.isHidden = false
                    }
                    else if index == 3 {
                        coverPhotoImageViewFour.kf.setImage(with: URL(string: coverPhotoImageUrl[index]))
                        deleteCoverPhotoFour.isHidden = false
                    }
                    else if index == 4 {
                        coverPhotoImageViewFive.kf.setImage(with: URL(string: coverPhotoImageUrl[index]))
                        deleteCoverPhotoFive.isHidden = false
                    }
                }
                else
                {
                }
            }

        }
        else
        {
           
            
        }
        
    }
    func updateMenus()  {
        
        if spotModel.menuPictures.count > 0 {
            for (index,element) in spotModel.menuPictures.enumerated() {
                if spotModel.menuPictures[index].contains("https") {
                    menuImageUrl.insert(element, at: index)
                    if index == 0 {
                        menuImageViewOne.kf.setImage(with: URL(string: menuImageUrl[index]))
                        deleteMenuOne.isHidden = false
                    }
                    else if index == 1 {
                        menuImageViewTwo.kf.setImage(with: URL(string: menuImageUrl[index]))
                        deleteMenuTwo.isHidden = false
                    }
                    else if index == 2 {
                        menuImageViewThree.kf.setImage(with: URL(string: menuImageUrl[index]))
                        deleteMenuThree.isHidden = false
                    }
                    else if index == 3 {
                        menuImageViewFour.kf.setImage(with: URL(string: menuImageUrl[index]))
                        deleteMenuFour.isHidden = false
                    }
                    else if index == 4 {
                        menuImageViewFive.kf.setImage(with: URL(string: menuImageUrl[index]))
                        deleteMenuFive.isHidden = false
                    }
                }
            }
  
        }
        else
        {
            
            
        }
        
    }
    
    func updateImages()  {
        
        if spotModel.foodPictures.count > 0 {
            for (index,element) in spotModel.foodPictures.enumerated() {
                if spotModel.foodPictures[index].contains("https") {
                    imagesUrl.insert(element, at: index)
                    if index == 0 {
                        imagesImageViewOne.kf.setImage(with: URL(string: imagesUrl[index]))
                        deleteImagesOne.isHidden = false
                    }
                    else if index == 1 {
                        imagesImageViewTwo.kf.setImage(with: URL(string: imagesUrl[index]))
                        deleteImagesTwo.isHidden = false
                    }
                    else if index == 2 {
                        imagesImageViewThree.kf.setImage(with: URL(string: imagesUrl[index]))
                        deleteImagesThree.isHidden = false
                    }
                    else if index == 3 {
                        imagesImageViewFour.kf.setImage(with: URL(string: imagesUrl[index]))
                        deleteImagesFour.isHidden = false
                    }
                    else if index == 4 {
                        imagesImageViewFive.kf.setImage(with: URL(string: imagesUrl[index]))
                        deleteImagesFive.isHidden = false
                    }
                }
            }
  
        }
        else
        {
            
            
        }
        
    }
    @IBAction func didClickDeleteCoverPhoto(_ sender: UIButton) {
        coverPhotoImageViewOne.image = UIImage(named: "updateMediaImage")
        deleteCoverPhotoOne.isHidden = true
        
        coverPhotoImageViewTwo.image = UIImage(named: "updateMediaImage")
        deleteCoverPhotoTwo.isHidden = true
        
        coverPhotoImageViewThree.image = UIImage(named: "updateMediaImage")
        deleteCoverPhotoThree.isHidden = true
        
        coverPhotoImageViewFour.image = UIImage(named: "updateMediaImage")
        deleteCoverPhotoFour.isHidden = true
        
        coverPhotoImageViewFive.image = UIImage(named: "updateMediaImage")
        deleteCoverPhotoFive.isHidden = true
        
        let index = sender.tag - 1
        if coverPhotoImageUrl[index].contains("https") {
            coverPhotoImageUrl.remove(at: index)
            coverPhotoImageUrl.insert("\(index)", at: index)
        }
        
        
       /* if sender.tag == 1 {
            
            coverPhotoArray.append(sender.tag)
            if coverPhotoImageUrl[index].contains("https") {
                coverPhotoImageUrl.remove(at: index)
                coverPhotoImageUrl.insert("\(index)", at: index)
            }
        }
        else if sender.tag == 2 {
            
            coverPhotoArray.append(sender.tag)
            coverPhotoImageUrl.remove(at: sender.tag - 1)
        }
        else if sender.tag == 3 {
            
            coverPhotoArray.append(sender.tag)
            coverPhotoImageUrl.remove(at: sender.tag - 1)
        }
        else if sender.tag == 4 {
            
            coverPhotoArray.append(sender.tag)
            coverPhotoImageUrl.remove(at: sender.tag - 1)
        }
        else if sender.tag == 5 {
            
            coverPhotoArray.append(sender.tag)
            coverPhotoImageUrl.remove(at: sender.tag - 1)
        }*/
        
        
        for (index,element) in coverPhotoImageUrl.enumerated() {
            if coverPhotoImageUrl[index].contains("https") {
                if index == 0 {
                    coverPhotoImageViewOne.kf.setImage(with: URL(string: coverPhotoImageUrl[index]))
                    deleteCoverPhotoOne.isHidden = false
                }
                else if index == 1 {
                    coverPhotoImageViewTwo.kf.setImage(with: URL(string: coverPhotoImageUrl[index]))
                    deleteCoverPhotoTwo.isHidden = false
                }
                else if index == 2 {
                    coverPhotoImageViewThree.kf.setImage(with: URL(string: coverPhotoImageUrl[index]))
                    deleteCoverPhotoThree.isHidden = false
                }
                else if index == 3 {
                    coverPhotoImageViewFour.kf.setImage(with: URL(string: coverPhotoImageUrl[index]))
                    deleteCoverPhotoFour.isHidden = false
                }
                else if index == 4 {
                    coverPhotoImageViewFive.kf.setImage(with: URL(string: coverPhotoImageUrl[index]))
                    deleteCoverPhotoFive.isHidden = false
                }
            }
            else
            {
                print("Load items")
            }
        }
        
    }
    @IBAction func didClickDeleteMenu(_ sender: UIButton) {
        
        menuImageViewOne.image = UIImage(named: "updateMediaImage")
        deleteMenuOne.isHidden = true
        
        menuImageViewTwo.image = UIImage(named: "updateMediaImage")
        deleteMenuTwo.isHidden = true
        
        menuImageViewThree.image = UIImage(named: "updateMediaImage")
        deleteMenuThree.isHidden = true
        
        menuImageViewFour.image = UIImage(named: "updateMediaImage")
        deleteMenuFour.isHidden = true
        
        menuImageViewFive.image = UIImage(named: "updateMediaImage")
        deleteMenuFive.isHidden = true
        
        let index = sender.tag - 1
        if menuImageUrl[index].contains("https") {
            menuImageUrl.remove(at: index)
            menuImageUrl.insert("\(index)", at: index)
        }
        
       /* if sender.tag == 1 {
            
            menuImageUrl.remove(at: sender.tag - 1)
            menuArray.append(sender.tag)
            
        }
        else if sender.tag == 2 {
            
            menuImageUrl.remove(at: sender.tag - 1)
            menuArray.append(sender.tag)
        }
        else if sender.tag == 3 {
            
            menuImageUrl.remove(at: sender.tag - 1)
            menuArray.append(sender.tag)
        }
        else if sender.tag == 4 {
            
            menuImageUrl.remove(at: sender.tag - 1)
            menuArray.append(sender.tag)
        }
        else if sender.tag == 5 {
            
            menuImageUrl.remove(at: sender.tag - 1)
            menuArray.append(sender.tag)
        }*/
        
        for (index,element) in menuImageUrl.enumerated() {
            if menuImageUrl[index].contains("https") {
                if index == 0 {
                    menuImageViewOne.kf.setImage(with: URL(string: menuImageUrl[index]))
                    deleteMenuOne.isHidden = false
                }
                else if index == 1
                {
                    menuImageViewTwo.kf.setImage(with: URL(string: menuImageUrl[index]))
                    deleteMenuTwo.isHidden = false
                }
                else if index == 2 {
                    menuImageViewThree.kf.setImage(with: URL(string: menuImageUrl[index]))
                    deleteMenuThree.isHidden = false
                }
                else if index == 3
                {
                    menuImageViewFour.kf.setImage(with: URL(string: menuImageUrl[index]))
                    deleteMenuFour.isHidden = false
                }
                else if index == 4
                {
                    menuImageViewFive.kf.setImage(with: URL(string: menuImageUrl[index]))
                    deleteMenuFive.isHidden = false
                }
            }
        }
        
    }
    
    @IBAction func didClickDeleteImage(_ sender: UIButton) {
        
        imagesImageViewOne.image = UIImage(named: "updateMediaImage")
        deleteImagesOne.isHidden = true
        
        imagesImageViewTwo.image = UIImage(named: "updateMediaImage")
        deleteImagesTwo.isHidden = true
        
        imagesImageViewThree.image = UIImage(named: "updateMediaImage")
        deleteImagesThree.isHidden = true
        
        imagesImageViewFour.image = UIImage(named: "updateMediaImage")
        deleteImagesFour.isHidden = true
        
        imagesImageViewFive.image = UIImage(named: "updateMediaImage")
        deleteImagesFive.isHidden = true
        
        let index = sender.tag - 1
        if imagesUrl[index].contains("https") {
            imagesUrl.remove(at: index)
            imagesUrl.insert("\(index)", at: index)
        }
        
       /*  if sender.tag == 1 {
            
            imagesUrl.remove(at: sender.tag - 1)
            imagesArray.append(sender.tag)
        }
        else if sender.tag == 2 {
           
            imagesUrl.remove(at: sender.tag - 1)
            imagesArray.append(sender.tag)
        }
        else if sender.tag == 3 {
            
            imagesUrl.remove(at: sender.tag - 1)
            imagesArray.append(sender.tag)
        }
        else if sender.tag == 4 {
            
            imagesUrl.remove(at: sender.tag - 1)
            imagesArray.append(sender.tag)
        }
        else if sender.tag == 5 {
            
            imagesUrl.remove(at: sender.tag - 1)
            imagesArray.append(sender.tag)
        }*/
        
        for (index,element) in imagesUrl.enumerated() {
            if imagesUrl[index].contains("https") {
                if index == 0 {
                    imagesImageViewOne.kf.setImage(with: URL(string: imagesUrl[index]))
                    deleteImagesOne.isHidden = false
                }
                else if index == 1 {
                    imagesImageViewTwo.kf.setImage(with: URL(string: imagesUrl[index]))
                    deleteImagesTwo.isHidden = false
                }
                else if index == 2 {
                    imagesImageViewThree.kf.setImage(with: URL(string: imagesUrl[index]))
                    deleteImagesThree.isHidden = false
                }
                else if index == 3 {
                    imagesImageViewFour.kf.setImage(with: URL(string: imagesUrl[index]))
                    deleteImagesFour.isHidden = false
                }
                else if index == 4 {
                    imagesImageViewFive.kf.setImage(with: URL(string: imagesUrl[index]))
                    deleteImagesFive.isHidden = false
                }
            }
        }
        
    }
    
    @IBAction func didClickCoverPhoto(_ sender: UIButton) {
        
        selectedTag = sender.tag
        didClickGallery(tag: sender.tag)
    }
    
    @IBAction func didClickUpdate(_ sender: UIButton)
    {
        
        for (index,element) in imagesUrl.enumerated() {
            if imagesUrl[index].contains("https") {
                uploadImagesUrl.append(element)
                print("Value Available")
                
            }
            else
            {
                
            }
        }
        for (index,element) in coverPhotoImageUrl.enumerated() {
            if coverPhotoImageUrl[index].contains("https") {
                print("Value Available")
                uploadCoverPhotoImageUrl.append(element)
            }
            else
            {
                
            }
        }
        for (index,element) in menuImageUrl.enumerated() {
            if menuImageUrl[index].contains("https") {
                uploadMenuImageUrl.append(element)
                print("Value Available")
            }
            else
            {
                
            }
        }
        
        if (uploadCoverPhotoImageUrl.count == 0 && uploadMenuImageUrl.count == 0 && uploadImagesUrl.count == 0) {
            HSAlertView.showAlert(withTitle: "HoneySpot", message: "Kindly upload the image")
        }
        else
        {
            self.showLoadingHud()
            self.spotModel.menuPictures = uploadMenuImageUrl
            self.spotModel.foodPictures = uploadImagesUrl
            self.spotModel.customerPictures = uploadCoverPhotoImageUrl
            
            BusinessRestaurantDataSource().saveSpot(spotModel: self.spotModel) { (result) in
                switch(result){
                case .success(let str):
                    self.hideAllHuds()
                    self.dismiss(animated: true, completion: nil)
                case .failure(let err):
                    self.hideAllHuds()
                    self.showErrorHud(message: "Problem occured please try again")
                }
            }
        }
        
        
    }
    
    func didClickGallery(tag:Int)  {
        
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alert, animated: true)
        
        
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.showLoadingHud()
        var img: UIImage? = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if img == nil {
            img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        guard let image = img else {
            return
        }
        let pictureData: Data = image.jpegData(compressionQuality: 1)!
        let newImage:UIImage = UIImage(data: pictureData)!
        let imageBase64String:String = pictureData.base64EncodedString()
        print(imageBase64String)

        
        if selectedTag == 1 {
            coverPhotoImageViewOne.image = newImage
            deleteCoverPhotoOne.isHidden = false
        }
        else if selectedTag == 2 {
            coverPhotoImageViewTwo.image = newImage
            deleteCoverPhotoTwo.isHidden = false
        }

        else if selectedTag == 3 {
            coverPhotoImageViewThree.image = newImage
            deleteCoverPhotoThree.isHidden = false
        }
        else if selectedTag == 4 {
            coverPhotoImageViewFour.image = newImage
            deleteCoverPhotoFour.isHidden = false
        }
        else if selectedTag == 5 {
            coverPhotoImageViewFive.image = newImage
            deleteCoverPhotoFive.isHidden = false
        }
        else if selectedTag == 6 {
            menuImageViewOne.image = newImage
            deleteMenuOne.isHidden = false
        }
        else if selectedTag == 7 {
            menuImageViewTwo.image = newImage
            deleteMenuTwo.isHidden = false
        }
        else if selectedTag == 8 {
            menuImageViewThree.image = newImage
            deleteMenuThree.isHidden = false
        }
        else if selectedTag == 9 {
            menuImageViewFour.image = newImage
            deleteMenuFour.isHidden = false
        }
        else if selectedTag == 10 {
            menuImageViewFive.image = newImage
            deleteMenuFive.isHidden = false
        }
        else if selectedTag == 11 {
            imagesImageViewOne.image = newImage
            deleteImagesOne.isHidden = false
        }
        else if selectedTag == 12 {
            imagesImageViewTwo.image = newImage
            deleteImagesTwo.isHidden = false
        }
        else if selectedTag == 13 {
            imagesImageViewThree.image = newImage
            deleteImagesThree.isHidden = false
        }
        else if selectedTag == 14 {
            imagesImageViewFour.image = newImage
            deleteImagesFour.isHidden = false
        }
        else if selectedTag == 15 {
            imagesImageViewFive.image = newImage
            deleteImagesFive.isHidden = false
        }
        self.uploadImage(imageBase64String: imageBase64String, selectedTag: selectedTag)
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(imageBase64String:String, selectedTag:Int)  {
        
        self.showLoadingHud()
        BusinessRestaurantDataSource().uploadImage(imageBase64:imageBase64String) { (result) in
            switch(result){
            case .success(let imageModel):
                print(imageModel.ImageURL)
                if self.selectedTag == 1 {
                    self.coverPhotoImageUrl.remove(at: 0)
                    self.coverPhotoImageUrl.insert(imageModel.ImageURL, at: 0)
                }
                else if self.selectedTag == 2 {
                    self.coverPhotoImageUrl.remove(at: 1)
                    self.coverPhotoImageUrl.insert(imageModel.ImageURL, at: 1)
                }
                else if self.selectedTag == 3 {
                    self.coverPhotoImageUrl.remove(at: 2)
                    self.coverPhotoImageUrl.insert(imageModel.ImageURL, at: 2)
                }
                else if self.selectedTag == 4 {
                    self.coverPhotoImageUrl.remove(at: 3)
                    self.coverPhotoImageUrl.insert(imageModel.ImageURL, at: 3)
                }
                else if self.selectedTag == 5 {
                    self.coverPhotoImageUrl.remove(at: 4)
                    self.coverPhotoImageUrl.insert(imageModel.ImageURL, at: 4)
                }
                else if self.selectedTag == 6 {
                    self.menuImageUrl.remove(at: 0)
                    self.menuImageUrl.insert(imageModel.ImageURL, at: 0)
                }
                else if self.selectedTag == 7 {
                    self.menuImageUrl.remove(at: 1)
                    self.menuImageUrl.insert(imageModel.ImageURL, at: 1)
                }
                else if self.selectedTag == 8 {
                    self.menuImageUrl.remove(at: 2)
                    self.menuImageUrl.insert(imageModel.ImageURL, at: 2)
                }
                else if self.selectedTag == 9 {
                    self.menuImageUrl.remove(at: 3)
                    self.menuImageUrl.insert(imageModel.ImageURL, at: 3)
                }
                else if self.selectedTag == 10 {
                    self.menuImageUrl.remove(at: 4)
                    self.menuImageUrl.insert(imageModel.ImageURL, at: 4)
                }
                else if self.selectedTag == 11 {
                    self.imagesUrl.remove(at: 0)
                    self.imagesUrl.insert(imageModel.ImageURL, at: 0)
                }
                else if self.selectedTag == 12 {
                    self.imagesUrl.remove(at: 1)
                    self.imagesUrl.insert(imageModel.ImageURL, at: 1)
                }
                else if self.selectedTag == 13 {
                    self.imagesUrl.remove(at: 2)
                    self.imagesUrl.insert(imageModel.ImageURL, at: 2)
                }
                else if self.selectedTag == 14 {
                    self.imagesUrl.remove(at: 3)
                    self.imagesUrl.insert(imageModel.ImageURL, at: 3)
                }
                else if self.selectedTag == 15 {
                    self.imagesUrl.remove(at: 4)
                    self.imagesUrl.insert(imageModel.ImageURL, at: 4)
                }
                self.hideAllHuds()
            case .failure(let err):
                self.hideAllHuds()
                self.showErrorHud(message: "Problem occured please try again")
            }
        }
        
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
extension MediaEditViewController : UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        configureTab(index: scrollView.currentPage)
    }
    
}
extension MediaEditViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagMediaCellId", for: indexPath) as! MediaCollectionViewCell
        cell.spotModel = self.spotModel
        if(indexPath.row == 0){
            cell.tags = coverPhotoTags
            cell.currentIndex = currentIndex
        }else if(indexPath.row == 1){
            cell.tags = menuTags
            cell.currentIndex = currentIndex
        }else if(indexPath.row == 2){
            cell.tags = imagesTags
            cell.currentIndex = currentIndex
        }
        cell.superVc = self
        cell.prepareCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 30)
    }
    
}
