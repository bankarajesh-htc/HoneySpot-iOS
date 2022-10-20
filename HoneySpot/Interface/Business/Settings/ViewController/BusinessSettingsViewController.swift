//
//  BusinessSettingsViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 30.06.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import JGProgressHUD

protocol BusinessSubscriptionDelegate:AnyObject {
    func navigateToSubscriptionPage()
}

class BusinessSettingsViewController: UIViewController {
    
    
    var todayDate = Date()
	@IBOutlet var settingsTableView: UITableView!
    var loader = JGProgressHUD()
	
	var userM : UserModel!
    var subscriptionModel: SubscriptionModel!
    var subscriptionNewModel: SubscriptionNewModel!
    var isTerms = false
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
		
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getData()
    }
	
	func getData(){
		self.showLoadingHud()
        self.view.isUserInteractionEnabled = false
        DispatchQueue.global().async {
            ProfileDataSource().getUser(userId: UserDefaults.standard.string(forKey: "userId") ?? "") { (result) in
                self.hideAllHuds()
                switch(result){
                case .success(let userM):
                    DispatchQueue.main.async {
                        self.userM = userM
                        self.settingsTableView.reloadData()
                        self.getSubscriptionNewData()
                        self.view.isUserInteractionEnabled = true
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
		
	}
    func getSubscriptionData(){
        self.showLoadingHud()
        self.view.isUserInteractionEnabled = false
        ProfileDataSource().getSubscrition { (result) in
            self.hideAllHuds()
            switch(result){
            case .success(let subscriptionModel):
                DispatchQueue.main.async {
                    if subscriptionModel.count > 0
                    {
                        self.subscriptionModel = subscriptionModel.last
                        if self.subscriptionModel.plans == "premium" {
                            AppDelegate.originalDelegate.isFree = false
                        }
                        else
                        {
                            AppDelegate.originalDelegate.isFree = true
                        }
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
    func getSubscriptionNewData(){
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
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                        let expiryDate = dateFormatter.date(from: self.subscriptionNewModel.expiry_date ?? "")
                        let today = dateFormatter.string(from: self.todayDate)
                        
                        let dateFormatter1 = DateFormatter()
                        dateFormatter1.dateFormat = "yyyy-MM-dd"
                        
                        let finalDate = dateFormatter.date(from: today)
                        print(expiryDate as Any)
                        print(finalDate as Any)
                        
                        let isDateExpired = self.checkDate(currentDate: finalDate ?? Date(), endDate: expiryDate ?? Date())
                        if isDateExpired {
                            print("Expired")
                        }
                        else
                        {
                            print("Not Expired")
                        }
                        
                        if self.subscriptionNewModel.plans == "premium" {
                            AppDelegate.originalDelegate.isFree = false
                        }
                        else
                        {
                            AppDelegate.originalDelegate.isFree = true
                        }
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
    func checkDate(currentDate: Date, endDate: Date) -> Bool{
        
        if currentDate > endDate  {
            
            return true
        }
        else
        {
            return false
        }
    }

	func setupViews(){
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
		self.navigationController?.isNavigationBarHidden = true
        AppDelegate.originalDelegate.isGuestLogin = false
	}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "subscription"){
            let dest = segue.destination as! BusinessSubscriptionViewController
            if subscriptionModel != nil {
                dest.plans = self.subscriptionModel.plans!
            }
            
        }
        else if(segue.identifier == "webController"){
            let dest = segue.destination as! WebViewController
            if isTerms  {
                dest.termsOfServices()
            }
            else
            {
                dest.loadPrivacyPolicy()
            }
            
        }
    }
	
}
extension BusinessSettingsViewController : BusinessSubscriptionDelegate
{
    func navigateToSubscriptionPage() {
        
        self.performSegue(withIdentifier: "subscription", sender: nil)
    }
    
    
}

extension BusinessSettingsViewController : UITableViewDataSource, UITableViewDelegate {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 8
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if(indexPath.row == 0){
			let cell = tableView.dequeueReusableCell(withIdentifier: "infoCellId") as! BusinessSettingsInfoTableViewCell
			cell.name.text = "-"
			cell.email.text = "-"
			cell.member.text = "-"
			if(userM != nil){
				cell.name.text = self.userM.fullname
				cell.email.text = self.userM.email
				cell.member.text = ""
			}
			return cell
		}else if(indexPath.row == 1){
			let cell = tableView.dequeueReusableCell(withIdentifier: "switchCellId") as! BusinessSettingsSwitchTableViewCell
			cell.img.image = UIImage(named: "businessNotf")
            cell.prepareCell()
			cell.titleLabel.text = "Notifications"
			return cell
		}else if(indexPath.row == 2){
			let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! BusinessSettingsTableViewCell
			cell.img.image = UIImage(named: "businessEdit")
            cell.upgradeButton.isHidden = true
			cell.titleLabel.text = "Edit Account"
			return cell
		}
        else if(indexPath.row == 3){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! BusinessSettingsTableViewCell
            cell.img.image = UIImage(named: "businessSubscription")
            cell.upgradeButton.isHidden = false
            cell.titleLabel.text = "Subscriptions"
            cell.delegate = self
            return cell
        }else if(indexPath.row == 4){
			let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! BusinessSettingsTableViewCell
			cell.img.image = UIImage(named: "businessTerms")
            cell.upgradeButton.isHidden = true
			cell.titleLabel.text = "Terms of Service"
			return cell
		}else if(indexPath.row == 5){
			let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! BusinessSettingsTableViewCell
			cell.img.image = UIImage(named: "businessPrivacy")
            cell.upgradeButton.isHidden = true
			cell.titleLabel.text = "Privacy Policy"
			return cell
		}else if(indexPath.row == 6){
			let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! BusinessSettingsTableViewCell
			cell.img.image = UIImage(named: "businessSignOut")
            cell.upgradeButton.isHidden = true
			cell.titleLabel.text = "Sign Out"
			return cell
		}else{
			let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! BusinessSettingsTableViewCell
			cell.img.image = UIImage(named: "businessDelete")
            cell.upgradeButton.isHidden = true
			cell.titleLabel.text = "Delete Account"
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if(indexPath.row == 2){
			self.performSegue(withIdentifier: "edit", sender: nil)
        } else if(indexPath.row == 3)
        {
            self.performSegue(withIdentifier: "subscription", sender: nil)
        }
        else if(indexPath.row == 4){
            
            isTerms = true
            self.performSegue(withIdentifier: "webController", sender: nil)
            
//			guard let c = WebViewController.termsOfServiceController() else {
//				return
//			}
//			c.titleStr = "TERMS OF SERVICE"
//			self.presentOnRoot(with: c)
		}else if(indexPath.row == 5){
            
            isTerms = false
            self.performSegue(withIdentifier: "webController", sender: nil)
//			guard let c = WebViewController.privacyPolicyController() else {
//				return
//			}
//			c.titleStr = "PRIVACY POLICY"
//			self.presentOnRoot(with: c)
		}else if(indexPath.row == 6){
         
            let alert: UIAlertController = UIAlertController(
                title: "SignOut Your Account",
                message: "Are you sure you want to signout?",
                preferredStyle: .alert)
            
            //Add Buttons
            let yesButton: UIAlertAction = UIAlertAction(
                title: "Ok",
                style: .default) { (action: UIAlertAction) in
                let appDomain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
                UserDefaults.standard.synchronize()
                print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
                    
                selectedBusiness = nil
                
                UIViewController.LOGIN_NAVIGATIONCONTROLLER.popToRootViewController(animated: false)
                UIViewController.APP_DELEGATE_INSTANCE.window?.rootViewController = .LOGIN_NAVIGATIONCONTROLLER
            }
            
            let noButton: UIAlertAction = UIAlertAction(
                title: "Cancel",
                style: .cancel) { (action: UIAlertAction) in
            }
            
            alert.addAction(yesButton)
            alert.addAction(noButton)
            present(alert, animated: true, completion: nil)
            
            
		}else if(indexPath.row == 7){
			let alert: UIAlertController = UIAlertController(
				title: "Delete Your Account",
				message: "Are you sure you want to delete your account ? This action is not revertable",
				preferredStyle: .alert)
			
			//Add Buttons
			let yesButton: UIAlertAction = UIAlertAction(
				title: "Delete",
				style: .default) { (action: UIAlertAction) in
					self.showLoadingHud()
					ProfileDataSource().deleteUser { (result) in
						self.hideAllHuds()
						switch(result){
						case .success(let successStr):
							print(successStr)
                            let appDomain = Bundle.main.bundleIdentifier!
                            UserDefaults.standard.removePersistentDomain(forName: appDomain)
                            UserDefaults.standard.synchronize()
                            print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
                            
                            selectedBusiness = nil
                            
							UIViewController.LOGIN_NAVIGATIONCONTROLLER.popToRootViewController(animated: false)
							UIViewController.APP_DELEGATE_INSTANCE.window?.rootViewController = .LOGIN_NAVIGATIONCONTROLLER
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
		
	}
	
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if(indexPath.row == 0){
			return 90
		}else if(indexPath.row == 1){
			return 75
		}else{
			return 75
		}
	}
	
}
