//
//  BusinessAnalyticsViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 25.02.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class BusinessAnalyticsViewController: UIViewController {

	@IBOutlet var analyticsTableView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var noDataRestaurantNameLabel: UILabel!
    
    var subscriptionNewModel: SubscriptionNewModel!
	var claims = [ClaimModel]()
	var selectedClaim : ClaimModel!
	
	var influenceArr = [ActivityType]()
	var influenceCompareArr = [ActivityType]()
	
	var activityArr = [ActivityDate]()
	var activityCompareArr = [ActivityDate]()
	
	var engagementArr = [EngagementType]()
	var engagementCompareArr = [EngagementType]()
    var saves = [Date:Int]()
	
	var influenceStartDate = Date()
	var influenceEndDate = Date()
	var activityStartDate = Date()
	var activityEndDate = Date()
	var engagementStartDate = Date()
	var engagementEndDate = Date()
	
    var subscriptionModel: SubscriptionModel!
    var honeySpotCount = 0
	var influenceRange = 30
	var activityRange = 30
	var engagementRange = 30
    
    private let refreshControl = UIRefreshControl()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
		getClaims()
        
		NotificationCenter.default.addObserver(self, selector: #selector(self.restaurantChanged), name: NSNotification.Name.init("restaurantChanged"), object: nil)
        
        analyticsTableView.refreshControl = refreshControl
        refreshControl.tintColor = UIColor.black
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Analytics Data ...")

        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.getAnalyticsData()
        self.getNotificationStatus()
        self.tabBarController?.tabBar.layer.zPosition = 0
    }
    
    @objc func refreshTable(){
       // self.dataSource.removeAll()
        restaurantChanged()
        self.analyticsTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
	
	func setupViews(){
		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
		self.navigationController?.isNavigationBarHidden = true
		
		influenceEndDate.changeDays(by: 1)
		activityEndDate.changeDays(by: 1)
		engagementEndDate.changeDays(by: 1)
		
		influenceStartDate.changeDays(by: -1 * influenceRange)
		activityStartDate.changeDays(by: -1 * activityRange)
		engagementStartDate.changeDays(by: -1 * engagementRange)
        
        let attributedString = NSMutableAttributedString(string:"Promote & engage with your customers to honeyspot your restaurant")
        
        noDataLabel.setLineHeightMultiple(to: 1.3, withAttributedText: attributedString)
	}
	
	func getClaims(){
		showLoadingHud()
		if(selectedBusiness == nil){
			BusinessRestaurantDataSource().getClaims { (result) in
				self.hideAllHuds()
				switch(result){
				case .success(let claims):
					if(claims.count > 0){
                        self.claims = claims
                        self.getLastSavedData()
						
//						selectedBusiness = claims[0]
//						self.selectedClaim = claims[0]
//						self.getAnalyticsData()
//                        self.noDataRestaurantNameLabel.text = self.selectedClaim.spot.name
                        
					}else{
						self.showErrorHud(message: "Your verification is still under review.")
					}
				case .failure(let err):
					print(err.localizedDescription)
					self.showErrorHud(message: "Your verification is still under review.")
				}
			}
		}else{
			self.selectedClaim = selectedBusiness
			self.getAnalyticsData()
		}
	}
	
	@objc func restaurantChanged(){
        
		self.selectedClaim = selectedBusiness
		self.getAnalyticsData()
	}
    func getNotificationStatus()  {
        
        self.showLoadingHud()
        DispatchQueue.global().async {
            ProfileDataSource().notificationGetStatus { (result) in
                switch(result){
                case .success(let notificationStatus):
                    print("Status \(notificationStatus) ")
                    AppDelegate.originalDelegate.isConsumerSwitch = notificationStatus
                    self.hideAllHuds()
                    
                case .failure(let err):
                    print(err)
                    self.hideAllHuds()
                }
            }
        }
        
        
    }
    func loadHoneySpotters() {
        self.showLoadingHud()
        BusinessRestaurantDataSource().honeySpotters(spotId: self.selectedClaim.spot.id) { (result) in
            
            switch(result){
            case .success(let honeySpotters):
                DispatchQueue.main.async {
                    self.honeySpotCount = honeySpotters.count
                    self.hideAllHuds()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    func getSubscriptionData(){
        self.showLoadingHud()
        ProfileDataSource().getSubscrition { (result) in
            self.hideAllHuds()
            switch(result){
            case .success(let subscriptionModel):
                DispatchQueue.main.async {
                    
                    if subscriptionModel.count > 0
                    {
                        self.subscriptionModel = subscriptionModel.last
                        if self.subscriptionModel.plans == "premium" {
                            UserDefaults.standard.set("premium", forKey: "userStatus")
                            AppDelegate.originalDelegate.isFree = false
                        }
                        else
                        {
                            UserDefaults.standard.set("free", forKey: "userStatus")
                            AppDelegate.originalDelegate.isFree = true
                        }
                        print(subscriptionModel)
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func getSubscriptionDataNew(){
        self.showLoadingHud()
        self.view.isUserInteractionEnabled = false
        ProfileDataSource().getSubscritionNew { (result) in
            self.hideAllHuds()
            switch(result){
            case .success(let subscriptionModel):
                DispatchQueue.main.async {
                    if subscriptionModel.count > 0
                    {
                        self.subscriptionNewModel = subscriptionModel.last
                        if self.subscriptionNewModel.plans == "premium" {
                            AppDelegate.originalDelegate.isFree = false
                        }
                        else
                        {
                            AppDelegate.originalDelegate.isFree = true
                        }
                        self.dismiss(animated: true, completion: nil)
                        print(subscriptionModel)
                    }
                    self.view.isUserInteractionEnabled = true
                }
            case .failure(let err):
                print(err.localizedDescription)
                self.view.isUserInteractionEnabled = true
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func getLastSavedData() {
        self.showLoadingHud()
        BusinessRestaurantDataSource().getLastSavedSpot { (result) in
            switch(result){
            case .success(let savedSpotModel):
                print(savedSpotModel)
                if savedSpotModel.count > 0 {
                    let savedModel = savedSpotModel[0]
                    if savedModel.lastsavedspot == 0 {
                        selectedBusiness = self.claims[0]
                        self.selectedClaim = self.claims[0]
                        self.getAnalyticsData()
                        self.noDataRestaurantNameLabel.text = self.selectedClaim.spot.name
                    }
                    else
                    {
                        var index = 0
                        for item in self.claims
                        {
                            let savedId = "\(savedModel.lastsavedspot)"
                            if  savedId == item.id {
                                selectedBusiness = self.claims[index]
                                self.selectedClaim = self.claims[index]
                                self.getAnalyticsData()
                                self.noDataRestaurantNameLabel.text = self.selectedClaim.spot.name
                            }
                            index += 1
                        }
                    }
                    
                }
                else
                {
                    selectedBusiness = self.claims[0]
                    self.selectedClaim = self.claims[0]
                    self.getAnalyticsData()
                    self.noDataRestaurantNameLabel.text = self.selectedClaim.spot.name
                }
                self.hideAllHuds()
            case .failure(let err):
                print(err.localizedDescription)
                self.hideAllHuds()
                self.showErrorHud(message: "Please check your internet connection")
        }
    }
    }
	
	func getAnalyticsData(){
		
        self.view.isUserInteractionEnabled = false
        noDataView.isHidden = true
        analyticsTableView.isHidden = true
        
		self.showLoadingHud()
        
        
		let group = DispatchGroup()
        
        group.enter()
        loadHoneySpotters()
        group.leave()
		
		//Influence -----------------------
		
        print(influenceStartDate)
        print(influenceEndDate)
        
        
        self.showLoadingHud()
        
		group.enter()
		BusinessAnalyticsDataSource().getEngagementType(spotId: self.selectedClaim.spot.id, startDate: influenceStartDate, endDate: influenceEndDate, completion: { (result) in
			switch(result){
			case .success(let eng):
				self.influenceArr = eng
			case .failure(let err):
				print(err.errorMessage)
			}
			group.leave()
		})

		var influenceCompareStart = influenceStartDate
		influenceCompareStart.changeDays(by: -1 * influenceRange)
		let influenceCompareEnd = influenceStartDate

        print(influenceCompareStart)
        print(influenceCompareEnd)

		group.enter()
		BusinessAnalyticsDataSource().getEngagementType(spotId: self.selectedClaim.spot.id, startDate: influenceCompareStart, endDate: influenceCompareEnd, completion: { (result) in
			switch(result){
			case .success(let eng):
				self.influenceCompareArr = eng
			case .failure(let err):
				print(err.errorMessage)
			}
			group.leave()
		})

		//Activity ------------------------

		group.enter()
		BusinessAnalyticsDataSource().getEngagementDate(spotId: self.selectedClaim.spot.id, startDate: activityStartDate, endDate: activityEndDate, completion: { (result) in
			switch(result){
			case .success(let eng):
				self.activityArr = eng
			case .failure(let err):
				print(err.errorMessage)
			}
			group.leave()
		})

		var activityCompareStart = activityStartDate
		activityCompareStart.changeDays(by: -1 * activityRange)
		let activityCompareEnd = activityStartDate

		group.enter()
		BusinessAnalyticsDataSource().getEngagementDate(spotId: self.selectedClaim.spot.id, startDate: activityCompareStart, endDate: activityCompareEnd, completion: { (result) in
			switch(result){
			case .success(let eng):
				self.activityCompareArr = eng
			case .failure(let err):
				print(err.errorMessage)
			}
			group.leave()
		})
		
		//Engagement -----------------------
		
        group.enter()
        BusinessAnalyticsDataSource().getEngagementData(spotId: self.selectedClaim.spot.id, startDate: engagementStartDate, endDate: engagementEndDate, completion: { (result) in
            switch(result){
            case .success(let eng):
                self.engagementArr = eng
            case .failure(let err):
                print(err.errorMessage)
            }
            group.leave()
        })
        
        
        getSubscriptionDataNew()
        
        
		group.notify(queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default), execute: {
			DispatchQueue.main.async {
				
                self.view.isUserInteractionEnabled = true
                if self.activityArr.count > 0 && self.influenceArr.count > 0 && self.engagementArr.count > 0
                {
                    self.analyticsTableView.isHidden = false
                    self.noDataView.isHidden = true
                    self.analyticsTableView.reloadData()
                    self.scrollToTop()
                }
                else
                {
                    self.analyticsTableView.isHidden = true
                    self.noDataView.isHidden = false
                    self.noDataRestaurantNameLabel.text = self.selectedClaim.spot.name
                }
                self.hideAllHuds()
				
			}
		})
		
	}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "honeySpot"){
            let dest = segue.destination as! BusinessHoneyspottersViewController
            dest.selectedClaim = self.selectedClaim
        }
    }
	

    
	@IBAction func selectRestaurantTapped(_ sender: Any) {
		
	}
    
    func scrollToTop() {
        // 1
        let topRow = IndexPath(row: 0,
                               section: 0)
                               
        // 2
        self.analyticsTableView.scrollToRow(at: topRow,
                                   at: .top,
                                   animated: true)
    }
    
	
}

extension BusinessAnalyticsViewController : UITableViewDelegate , UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
			let cell = tableView.dequeueReusableCell(withIdentifier: "nameCellId") as! BusinessAnalyticsNameTableViewCell
			if(self.selectedClaim != nil){
				cell.nameLabel.text = self.selectedClaim.spot.name
			}
			return cell
		}else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "honeyCellId") as! HoneySpotTableViewCell
            if(self.selectedClaim != nil){
                cell.honeySpotLabel.text = "\(honeySpotCount)"
            }
            return cell
        }
        else if(indexPath.row == 2){
			let cell = tableView.dequeueReusableCell(withIdentifier: "influenceCellId") as! BusinessAnalyticsInfluenceTableViewCell
			if(self.influenceArr.count > 0 ){
				cell.emptyView.isHidden = true
				cell.chartView.isHidden = false
                
                cell.influenceArr = self.influenceArr
                cell.influenceCompareArr = self.influenceCompareArr
                cell.influenceRange = self.influenceRange
                cell.selectedType = "totalhoneyspoters" //approximatereach
                
				var totalUsers = 0
				var totalCompareUsers = 0
				var spotAdd = 0
				var spotAddCompare = 0
//				for i in influenceArr {
//					totalUsers = i.reachCount
//					if(i.eventName == "feedFull"){
//						spotAdd += i.userCount
//					}
//				}
//				for i in influenceCompareArr {
//					totalCompareUsers = i.reachCount
//					if(i.eventName == "feedFull"){
//						spotAddCompare += i.userCount
//					}
//				}
				
                for i in influenceArr {
                    totalUsers = i.reachCount
                    if(i.eventName == "spotAdd"){
                        spotAdd += i.userCount
                    }
                    if(i.eventName == "feedFull"){
                       // totalUsers += i.reachCount
                    }
                }
                for i in influenceCompareArr {
                    totalCompareUsers = i.reachCount
                    if(i.eventName == "spotAdd"){
                        spotAddCompare += i.userCount
                    }
                    if(i.eventName == "feedFull"){
                        //totalCompareUsers += i.reachCount
                    }
                }
                
				cell.totalUsersCount.text = totalUsers.description
//				if(totalCompareUsers == 0){
//					totalCompareUsers = 1
//				}
//				if(totalUsers == 0){
//					totalUsers = 1
//				}
				let percentageUser = percentageDifference(from: Double(totalCompareUsers), x2: Double(totalUsers))
				if(percentageUser >= 0){
					cell.totalUserCountPercentage.text = percentageUser.description + "%"
					cell.totalUserCountPercentageImage.image = UIImage(named: "analyticsUp")
				}else{
					cell.totalUserCountPercentage.text = percentageUser.description + "%"
					cell.totalUserCountPercentageImage.image = UIImage(named: "businessPercentageDown")
				}
				
				cell.totalHoneyspotUsersCount.text = spotAdd.description
//				if(spotAdd == 0){
//					spotAdd = 1
//				}
//				if(spotAddCompare == 0){
//					spotAddCompare = 1
//				}
				let percentageHoneyspot = percentageDifference(from: Double(spotAddCompare), x2: Double(spotAdd))
				if(percentageHoneyspot >= 0){
					cell.totalHoneyspotUsersPercentage.text = percentageHoneyspot.description + "%"
					cell.totalHoneyspotUserPercentageImage.image = UIImage(named: "analyticsUp")
				}else{
					cell.totalHoneyspotUsersPercentage.text = percentageHoneyspot.description + "%"
					cell.totalHoneyspotUserPercentageImage.image = UIImage(named: "businessPercentageDown")
				}
                
                cell.prepareCell()
				
			}else{
				cell.emptyView.isHidden = false
				cell.chartView.isHidden = true
                
			}
			return cell
		}else if(indexPath.row == 3){
			let cell = tableView.dequeueReusableCell(withIdentifier: "activityCellId") as! BusinessAnalyticsActivityTableViewCell
			if(self.activityArr.count > 0 ){
				cell.emptyView.isHidden = true
				cell.chartView.isHidden = false
				
				cell.activityArr = self.activityArr
				cell.activityRange = self.activityRange
				
				var honeyspotCount = 0
				var honeyspotCompareCount = 0
				
				var impressionCount = 0
				var impressionCompareCount = 0
				
				var pageviewCount = 0
				var pageviewCompareCount = 0
				
				for i in activityArr {
					honeyspotCount += i.honeyspotCount
					impressionCount += i.impressionCount
					pageviewCount += i.pageviewCount
				}
				for i in activityCompareArr {
					honeyspotCompareCount += i.honeyspotCount
					impressionCompareCount += i.impressionCount
					pageviewCompareCount += i.pageviewCount
				}
				
				cell.honeyspottedCountLabel.text = honeyspotCount.description
				cell.impressionCountLabel.text = impressionCount.description
				cell.pageViewsCountLabel.text = pageviewCount.description
				
				honeyspotCount = ( honeyspotCount == 0 ) ? 0 : honeyspotCount
				honeyspotCompareCount = ( honeyspotCompareCount == 0 ) ? 0 : honeyspotCompareCount
				impressionCount = ( impressionCount == 0 ) ? 0 : impressionCount
				impressionCompareCount = ( impressionCompareCount == 0 ) ? 0 : impressionCompareCount
				pageviewCount = ( pageviewCount == 0 ) ? 0 : pageviewCount
				pageviewCompareCount = ( pageviewCompareCount == 0 ) ? 0 : pageviewCompareCount
                
                
               
                

				let percentageHoneyspot = percentageDifference(from: Double(honeyspotCompareCount), x2: Double(honeyspotCount))
				if(percentageHoneyspot >= 0){
					cell.honeyspottedPercentageLabel.text = percentageHoneyspot.description + "%"
					cell.honeyspottedPercentageImage.image = UIImage(named: "analyticsUp")
				}else{
					cell.honeyspottedPercentageLabel.text = percentageHoneyspot.description + "%"
					cell.honeyspottedPercentageImage.image = UIImage(named: "businessPercentageDown")
				}
				
				let percentageImpression = percentageDifference(from: Double(impressionCompareCount), x2: Double(impressionCount))
				if(percentageImpression >= 0){
					cell.impressionPercentageLabel.text = percentageImpression.description + "%"
					cell.impressionPercentageImage.image = UIImage(named: "analyticsUp")
				}else{
					cell.impressionPercentageLabel.text = percentageImpression.description + "%"
					cell.impressionPercentageImage.image = UIImage(named: "businessPercentageDown")
				}
				
				let percentagePageView = percentageDifference(from: Double(pageviewCompareCount), x2: Double(pageviewCount))
				if(percentagePageView >= 0){
					cell.pageViewsPercentageLabel.text = percentagePageView.description + "%"
					cell.pageViewsPercentageImage.image = UIImage(named: "analyticsUp")
				}else{
					cell.pageViewsPercentageLabel.text = percentagePageView.description + "%"
					cell.pageViewsPercentageImage.image = UIImage(named: "businessPercentageDown")
				}
				
				cell.prepareCell()
			}else{
				cell.emptyView.isHidden = false
				cell.chartView.isHidden = true
                
			}
			return cell
		}else{
			let cell = tableView.dequeueReusableCell(withIdentifier: "engagementCellId") as! BusinessAnalyticsEngagementTableViewCell
			if(self.engagementArr.count > 0 ){
				cell.emptyView.isHidden = true
				cell.chartView.isHidden = false
				
				cell.engagementArr = self.engagementArr
				
				cell.prepareCell()
			}else{
				cell.emptyView.isHidden = false
				cell.chartView.isHidden = true
                
			}
			return cell
		}
	}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 1){
            self.performSegue(withIdentifier: "honeySpot", sender: nil)
        }
    }
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 50
        }
        else if(indexPath.row == 1){
			return 100
		}else if(indexPath.row == 2){
			return 370
		}else if(indexPath.row == 3){
			return 410
		}else{
			return 450
		}
	}
	
	public func calculatePercentage(value:Double,percentageVal:Double)->Double{
		if(value == 0 || percentageVal == 0){
			return 0
		}else{
			return value / percentageVal
		}
	}
	
	func percentageDifference(from x1: Double, x2: Double) -> Double {
        var diff:Double = 0
        
        if x1 == 0 {
            
            diff = x2 - x1
        }
        else
        {
             diff = (x2 - x1) / x1
        }
            
        return Double(round(100 * (diff * 100)) / 100)
			//return Double(round(diff * 100))
	}
	
}
