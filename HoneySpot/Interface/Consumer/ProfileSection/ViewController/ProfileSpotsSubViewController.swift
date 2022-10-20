//
//  ProfileSpotsSubViewController.swift
//  HoneySpot
//
//  Created by Max on 2/18/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
 
import Alamofire
import SDWebImage

class ProfileSpotsSubViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var honeySpotButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var sortFullView: UIView!
    @IBOutlet weak var honeySpotImageView: UIImageView!
    @IBOutlet weak var honeySpotView: UIView!
    @IBOutlet weak var sortView: UIView!
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    private let PROFILE_SPOT_SQUARE_COLLECTIONVIEWCELL_IDENTIFIER = "ProfileSpotSquareCollectionViewCell"
    private let PROFILE_SPOT_THIN_COLLECTIONVIEWCELL_IDENTIFIER = "ProfileSpotThinCollectionViewCell"
    private let PROFILE_SPOT_MAP_COLLECTIONVIEWCELL_IDENTIFIER = "ProfileSpotMapCollectionViewCell"
    
    static let STORYBOARD_IDENTIFIER = "ProfileSpotsSubViewController"
    
    var citySaveModels = [CitySaveModel]()
    var spotSaves = [SpotSaveModel]()
    var feedModel = [FeedModel]()
    
    var userId = ""
    
    var selectedCity = ""

    var layoutSquare = true 

    override func viewDidLoad() {
        honeySpotButton.isSelected = true
        sortButton.isSelected = false
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }

        // Do any additional setup after loading the view.
        layoutSquare = true
        selectedCity = ""
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 12, bottom: 20, right: 12)
        headerViewHeightConstraint.constant = 50
        cityNameLabel.text = ""
        
        collectionView.register(UINib(nibName: PROFILE_SPOT_SQUARE_COLLECTIONVIEWCELL_IDENTIFIER, bundle: nil), forCellWithReuseIdentifier: PROFILE_SPOT_SQUARE_COLLECTIONVIEWCELL_IDENTIFIER)
        collectionView.register(UINib(nibName: PROFILE_SPOT_THIN_COLLECTIONVIEWCELL_IDENTIFIER, bundle: nil), forCellWithReuseIdentifier: PROFILE_SPOT_THIN_COLLECTIONVIEWCELL_IDENTIFIER)
        collectionView.register(UINib(nibName: PROFILE_SPOT_MAP_COLLECTIONVIEWCELL_IDENTIFIER, bundle: nil), forCellWithReuseIdentifier: PROFILE_SPOT_MAP_COLLECTIONVIEWCELL_IDENTIFIER)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    // MARK: - UICollectionView DataSource and Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !selectedCity.isEmpty {
            return spotSaves.count
        } else {
            return citySaveModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell & ProfileSpotCollectionViewProtocol
        var isLastItem: Bool = false
//        if !selectedCity.isEmpty {
//            isLastItem = indexPath.row >= spotSaves.count
//        } else {
//            isLastItem = indexPath.row >= citySaveModels.count
//        }

        if isLastItem {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: PROFILE_SPOT_MAP_COLLECTIONVIEWCELL_IDENTIFIER, for: indexPath) as! UICollectionViewCell & ProfileSpotCollectionViewProtocol
        } else {
            if self.layoutSquare {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: PROFILE_SPOT_SQUARE_COLLECTIONVIEWCELL_IDENTIFIER, for: indexPath) as! ProfileSpotSquareCollectionViewCell
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: PROFILE_SPOT_THIN_COLLECTIONVIEWCELL_IDENTIFIER, for: indexPath) as! ProfileSpotThinCollectionViewCell
            }
            cell.cellTagLabel.isHidden = false

            cell.backgroundColor = UIColor.init(white: 0.85, alpha: 1)

            if !selectedCity.isEmpty {
                
                self.titleButton.isHidden = false
                self.sortByButton.isHidden = true
                self.cityNameLabel.isHidden = false
                self.shareButton.isHidden = false
                
                self.sortFullView.isHidden = true
                
                let spotSaveModel = spotSaves[indexPath.row]
                let s = spotSaveModel.spot
                cell.cellTitleLabel.text = s.name
                cell.cellImageView.kf.setImage(with: URL(string: s.photoUrl))
                cell.cellTagLabel.isHidden = true
            } else {
                
                self.sortByButton.isHidden = false
                prepareCell(cell, withCity: citySaveModels[indexPath.row])
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if AppDelegate.originalDelegate.isGuestLogin {
            
            if AppDelegate.originalDelegate.isFeedProfile
            {
                var isLastItem: Bool = false
                if !selectedCity.isEmpty {
                    isLastItem = indexPath.row >= spotSaves.count
                } else {
                    isLastItem = indexPath.row >= citySaveModels.count
                }
                
                if isLastItem {
                    let parentVC: ProfileViewController = self.parent as! ProfileViewController
                    if !selectedCity.isEmpty {
                        parentVC.mapDrilldown(spotSavesModels: spotSaves)
                    } else {
                        //parentVC.mapDrilldown(withSpotSaves: citySaveModels)
                    }
                } else {
                    if !selectedCity.isEmpty {
                       
                        
                        let spot = spotSaves[indexPath.row].spot
                        let viewController = self.FeedFullPostViewControllerInstance()
                        let parentVC: ProfileViewController = self.parent as! ProfileViewController
                        //viewController.spotSaveModel = spotSaves[indexPath.row]
                        viewController.isComingFromProfile = true
                        viewController.tempSpotSaveModel = spotSaves[indexPath.row]
                        parentVC.navigationController?.pushViewController(viewController, animated: true)
                    } else {
                        self.sortFullView.isHidden = true
                        selectedCity = self.citySaveModels[indexPath.row].city
                        headerViewHeightConstraint.constant = 50
                        cityNameLabel.text = selectedCity.uppercased()
                        loadCity(city: selectedCity)
                    }
                }
            }
            else
            {
                
            }
        }
        else
        {
            var isLastItem: Bool = false
            if !selectedCity.isEmpty {
                isLastItem = indexPath.row >= spotSaves.count
            } else {
                self.sortByButton.isHidden = true
                isLastItem = indexPath.row >= citySaveModels.count
            }
            
            if isLastItem {
                let parentVC: ProfileViewController = self.parent as! ProfileViewController
                if !selectedCity.isEmpty {
                    parentVC.mapDrilldown(spotSavesModels: spotSaves)
                } else {
                    //parentVC.mapDrilldown(withSpotSaves: citySaveModels)
                }
            } else {
                if !selectedCity.isEmpty {
                    
                    
                    let spot = spotSaves[indexPath.row].spot
                    let viewController = self.FeedFullPostViewControllerInstance()
                    let parentVC: ProfileViewController = self.parent as! ProfileViewController
                    //viewController.spotSaveModel = spotSaves[indexPath.row]
                    AppDelegate.originalDelegate.isWishlist = false
                    viewController.isComingFromProfile = true
                    viewController.tempSpotSaveModel = spotSaves[indexPath.row]
                    parentVC.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    self.sortFullView.isHidden = true
                    selectedCity = self.citySaveModels[indexPath.row].city
                    headerViewHeightConstraint.constant = 50
                    cityNameLabel.text = selectedCity.uppercased()
                    loadCity(city: selectedCity)
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if layoutSquare {
            return CGSize(width: collectionView.bounds.size.width / 2 - 20, height: CGFloat(130))
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 50)
        }
    }
    
    func loadCity(city : String){
        
        self.spotSaves.removeAll()
        collectionView.reloadData()
        if AppDelegate.originalDelegate.isGuestLogin {
            
            if AppDelegate.originalDelegate.isFeedProfile
            {
                
                showLoadingHud()
                ProfileDataSource().getProfileGuestCitySaves(userId: userId, city: city) { (result) in
                    self.hideAllHuds()
                    switch(result){
                    case .success(let saves):
                        self.spotSaves = saves
                        self.collectionView.reloadData()
                    case .failure(let err):
                        print(err)
                    }
                }
            }
            else
            {
                
            }
        }
        else
        {
            showLoadingHud()
            ProfileDataSource().getProfileCitySaves(userId: userId, city: city) { (result) in
                self.hideAllHuds()
                switch(result){
                case .success(let saves):
                    self.spotSaves = saves
                    self.collectionView.reloadData()
                case .failure(let err):
                    print(err)
                }
            }
        }
        
        
    }
    
    func prepareCell(_ cell: (UICollectionViewCell & ProfileSpotCollectionViewProtocol), withCity cityModel: CitySaveModel) {
        
        self.titleButton.isHidden = true
        
        self.cityNameLabel.isHidden = true
        self.shareButton.isHidden = true
        
        self.sortFullView.isHidden = false
        
        
        
        if(cityModel.photoUrl == ""){
            let placeholderCityImage = UIImage(named: "ImagePlaceholder")!
            cell.cellImageView.image = placeholderCityImage
        }else{
            cell.cellImageView.kf.setImage(with: URL(string: cityModel.photoUrl))
        }
        
        cell.cellTitleLabel.text = cityModel.city
        cell.cellTagLabel.isHidden = cityModel.saveCount == 0
        cell.cellTagLabel.text = String(format: "%lu", cityModel.saveCount)
  
    }

    @IBAction func onTitleButtonTap(_ sender: Any) {
        if !selectedCity.isEmpty {
            selectedCity = ""
            headerViewHeightConstraint.constant = 50
            cityNameLabel.text = selectedCity
            collectionView.reloadData()
        }
    }
    // Sort By Action sheet
    func showSortOptions()  {
        let alert = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Sort by Alphabetical", style: .default, handler: { _ in
            let model = self.citySaveModels.sorted { $0.city < $1.city }
            self.citySaveModels = model
            self.collectionView.reloadData()
            
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "Sort by HoneySpots", style: .default, handler: { _ in
            let tempSaves = self.citySaveModels.sorted { (s1, s2) -> Bool in
                return s1.saveCount > s2.saveCount
            }
            self.citySaveModels = tempSaves
            self.collectionView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func onSortByTap(_ sender: UIButton)
    {
        showSortOptions()
    }
    @IBAction func onHoneyButtonTap(_ sender: UIButton) {
        //sender.isSelected = !sender.isSelected
        if sender.isSelected {
            
            sender.isSelected = false
            sortButton.isSelected = true
            honeySpotImageView.image = UIImage(named: "unselectedHoneySpot")
            
            
            let tempSaves = citySaveModels.sorted { (s1, s2) -> Bool in
                return s1.saveCount > s2.saveCount
            }
            let model = citySaveModels.sorted { $0.city < $1.city }
            self.citySaveModels = model
            self.collectionView.reloadData()
            
            
        }
        else
        {
            sender.isSelected = true
            print("UnSelcted")
            sortButton.isSelected = false
            honeySpotImageView.image = UIImage(named: "selectedHoneySpot")
            
            
            let tempSaves = citySaveModels.sorted { (s1, s2) -> Bool in
                return s1.saveCount > s2.saveCount
            }
            let model = citySaveModels.sorted { $0.city < $1.city }
            self.citySaveModels = tempSaves
            self.collectionView.reloadData()
            
            
            
            
        }
        
        
    }
    @IBAction func onSortButtonTap(_ sender: UIButton)
    {
        //sender.isSelected = !sender.isSelected
        if sender.isSelected {
            
            sender.isSelected = false
            honeySpotButton.isSelected = true
            print("UnSelcted")
            
            
            honeySpotImageView.image = UIImage(named: "selectedHoneySpot")
            
            let tempSaves = citySaveModels.sorted { (s1, s2) -> Bool in
                return s1.saveCount > s2.saveCount
            }
            let model = citySaveModels.sorted { $0.city < $1.city }
            self.citySaveModels = tempSaves
            self.collectionView.reloadData()
            
            
            
        }
        else
        {
            print("Selected")
            sender.isSelected = true
            honeySpotButton.isSelected = false
            
            
            honeySpotImageView.image = UIImage(named: "unselectedHoneySpot")
            
            let tempSaves = citySaveModels.sorted { (s1, s2) -> Bool in
                return s1.saveCount > s2.saveCount
            }
            let model = citySaveModels.sorted { $0.city < $1.city }
            self.citySaveModels = model
            self.collectionView.reloadData()
            
        }
        
        
    }
    
    @IBAction func onShareButtonTap(_ sender: Any) {
        if AppDelegate.originalDelegate.isGuestLogin {
            
            self.showAlert(title: "Want to Share the restaurants in this city?")
        }
        else
        {
            let image = UIImage(named: "LogoSmall")
            let text = "I am Sharing the Cities in Honeyspot App!. You can see it from -> https://honeyspotapp.app.link/cityName?$custom_data=\(selectedCity)"
            let shareAll = [text , image as Any] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
        
    }
    func showAlert(title: String)  {
        
        let alert: UIAlertController = UIAlertController(
            title: title,
            message: "Sign in to make your opinion count",
            preferredStyle: .alert)
        
        //Add Buttons
        let yesButton: UIAlertAction = UIAlertAction(
            title: "SIGNIN",
            style: .default) { (action: UIAlertAction) in
            AppDelegate.originalDelegate.isLogin = true
            UIViewController.LOGIN_NAVIGATIONCONTROLLER.popToRootViewController(animated: false)
            UIViewController.APP_DELEGATE_INSTANCE.window?.rootViewController = .FIRST_LOGINCONTROLLER

        }
        
        let noButton: UIAlertAction = UIAlertAction(
            title: "CANCEL",
            style: .cancel) { (action: UIAlertAction) in
            
        }
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
        
    }
}
