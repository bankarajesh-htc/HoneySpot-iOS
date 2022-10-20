//
//  SelectRestaurantViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 2.03.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class SelectRestaurantViewController: UIViewController,CustomSegmentedControlDelegate {
    
    
    @IBOutlet weak var claimRestaurant: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    
    //Create Top Segment Control
    @IBOutlet weak var interfaceSegmented: CustomSegmentedControl!{
        didSet{
            interfaceSegmented.setButtonTitles(buttonTitles: ["My HoneySpots","Claim Requests"])
            interfaceSegmented.selectorViewColor = .orange
            interfaceSegmented.selectorTextColor = .black
            interfaceSegmented.delegate = self
            
        }
    }
	@IBOutlet var honeyspotsTableView: UITableView!
	
	var models = [ClaimModel]()
    var claimRequestModels = [ClaimModel]()
    
    var claimedRestaurant = Array<String>()
    var photoURL = Array<String>()
    var address = Array<String>()
    var selectedIndex = 0
	
	override func viewDidLoad() {
        super.viewDidLoad()
        claimedRestaurant = ["The C restaurant  bar","The bestie restaurant","Barton G. The Restaurant - Los Angeles"]
        photoURL = ["https://lh3.googleusercontent.com/places/AAcXr8pUPhzsX_lEFyZ6BeswPKoXTUtpePrCQSD-xdCjoqfLpE4FCHEJ_5PNPHGnLzn3dLs3_H4Xb4eaNujSAdTa9viP6cziONvSyaY=s1600-w500","https://lh3.googleusercontent.com/places/AAcXr8rwC7R1dWQ868p3s-SHE-oow6zlER218qRFoh1wJlWoBYtjHdBo1j46Strjl_d6ED8GlQDB9d9zpDi1ZrphL159fTSEkg_IE4s=s1600-w500","https://lh3.googleusercontent.com/places/AAcXr8riknRIWDfvpO-Dcaz4u8jibjxP1O1PDyANBAWW7VRWO0D-2L1WND5Oqayl876Xw_41RJAxMKLyYCPnGmM_Bw8cPIHocdgsT5I=s1600-w500"]
        address = ["750 Cannery Row, Monterey, CA 93940, USA","Chettiyar Agaram Rd, Devi Parasakthi Nagar, Porur, Chennai, Tamil Nadu 600116, India","861 N La Cienega Blvd, Los Angeles, CA 90069, USA"]
        
		setupViews()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		getData()
	}
	
	func setupViews(){
		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		}
        
        claimRestaurant.layer.cornerRadius = 20
        claimRestaurant.clipsToBounds = true
	}
   
    //MARK: - Get Restaurant Details
	func getData(){
        self.models.removeAll()
        self.claimRequestModels.removeAll()
        self.honeyspotsTableView.isHidden = false
        self.noDataLabel.isHidden = true
        
        showLoadingHud()
		BusinessRestaurantDataSource().getClaims { (result) in
			switch(result){
			case .success(let models):
				
                if (models.count > 0){
                    
                    for c in models{
                        if (c.isVerified && !c.isPending && !c.isDenied) //Check condition for verified restaurant
                        {
                            self.models.append(c)
                            print(self.models.count)
                        }
                        else
                        {
                            self.claimRequestModels.append(c)
                            if self.claimRequestModels.count > 0 {
                                print(self.claimRequestModels.count)
                            }
                            else
                            {
                                self.honeyspotsTableView.isHidden = true
                                self.noDataLabel.isHidden = false
                            }
                            
                        }
                    }
                }
                else{
                    //self.showErrorHud(message: "Your verification is still under review.")
                    self.honeyspotsTableView.isHidden = true
                    self.noDataLabel.isHidden = false
                }
			case .failure(let err):
				print(err.localizedDescription)
                self.honeyspotsTableView.isHidden = true
                self.noDataLabel.isHidden = false
                self.showErrorHud(message: "Please check your internet connection")
			}
			DispatchQueue.main.async {
                if self.selectedIndex == 1
                {
                    if self.claimRequestModels.count > 0{
                        print(self.claimRequestModels.count)
                        self.honeyspotsTableView.isHidden = false
                        self.noDataLabel.isHidden = true
                        
                    }
                    else
                    {
                        self.honeyspotsTableView.isHidden = true
                        self.noDataLabel.isHidden = false
                        self.noDataLabel.text = "No Claim Request Data is Available"
                    }
                }
                else
                {
                    if self.models.count > 0{
                        print(self.claimRequestModels.count)
                        self.honeyspotsTableView.isHidden = false
                        self.noDataLabel.isHidden = true
                        
                    }
                    else
                    {
                        self.honeyspotsTableView.isHidden = true
                        self.noDataLabel.isHidden = false
                        self.noDataLabel.text = "No HoneySpots Data is Available"
                    }
                }
                
                self.honeyspotsTableView.reloadData()
                self.hideAllHuds()
			}
		}
	}
    
	@IBAction func closeTapped(_ sender: Any) {
		self.dismiss(animated: true) {
			NotificationCenter.default.post(name: Notification.Name.init(rawValue: "restaurantChanged"), object: nil)
		}
	}
    
    
    //MARK: - Segment index change
    func selectSegment(to index: Int) {
        selectedIndex = index
        print(selectedIndex)
        getData()
    }
    
    
    @IBAction func didClickClaimRestaurant(_ sender: Any) {
        
        self.performSegue(withIdentifier: "claim", sender: nil)
    }
    
}

extension SelectRestaurantViewController : UITableViewDelegate , UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if interfaceSegmented.selectedIndex == 0 {
            
           return self.models.count
        }
        else if interfaceSegmented.selectedIndex == 1
        {
            return self.claimRequestModels.count
        }
		
        return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if interfaceSegmented.selectedIndex == 0 {
            if self.models.count > 0 {
                print(interfaceSegmented.selectedIndex)
                let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCellId") as! SelectRestaurantTableViewCell
                let data = self.models[indexPath.row]
                cell.img.kf.setImage(with: URL(string: data.spot.photoUrl))
                cell.name.text = data.spot.name
                cell.name.adjustsFontSizeToFitWidth = true
                if (data.isVerified && !data.isDenied && !data.isPending)
                {
                    print("Restaurants are claimed")
                    if (selectedBusiness != nil)
                    {
                        if(selectedBusiness.spot.id == data.spot.id){
                            cell.selectionImage.image = UIImage(named: "businessOptionSelected")
                        }else{
                            cell.selectionImage.image = UIImage(named: "businessOptionUnselected")
                        }
                    }
                    
                }
                else
                {
                    print("Restaurants are not claimed")
                }
                
                return cell
            }
            
        }
        else if interfaceSegmented.selectedIndex == 1
        {
            if self.claimRequestModels.count > 0 {
                
                print(interfaceSegmented.selectedIndex)
                let cell = tableView.dequeueReusableCell(withIdentifier: "claimRequestCellId") as! SelectRestaurantClaimTableViewCell
                let data = self.claimRequestModels[indexPath.row]
                cell.img.kf.setImage(with: URL(string: data.spot.photoUrl))
                //cell.img.kf.setImage(with: URL(string: photoURL[indexPath.row]))
                cell.name.text = data.spot.name //claimedRestaurant[indexPath.row]//
                cell.tags.text = data.spot.address //address[indexPath.row]//
                
                
                if (!data.isVerified && data.isDenied && !data.isPending)
                {
                    cell.claimButton.setTitle("Rejected", for: .normal)
                    cell.claimButton.backgroundColor = UIColor.init(red: 255, green: 103, blue: 106)
                }
                else if (!data.isVerified && !data.isDenied && data.isPending)
                {
                    cell.claimButton.setTitle("Pending", for: .normal)
                    cell.claimButton.backgroundColor = UIColor.init(red: 202, green: 202, blue: 202)
                }
                
                return cell
            }
            
        }
        
        return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if(indexPath.row == self.models.count){
			//self.performSegue(withIdentifier: "claim", sender: nil)
		}else{
            if selectedIndex == 0 {
                let data = self.models[indexPath.row]
                selectedBusiness = data
                BusinessRestaurantDataSource().lastSavedSpot(spotId: data.id) { (result) in
                    switch(result){
                    case .success(let str):
                        print(str)
                    case .failure(let err):
                        print(err.localizedDescription)
                        self.honeyspotsTableView.isHidden = true
                        self.noDataLabel.isHidden = false
                        self.showErrorHud(message: "Please check your internet connection")
                    }
                }
                tableView.reloadData()
                NotificationCenter.default.post(name: Notification.Name.init(rawValue: "restaurantChanged"), object: nil)
                self.dismiss(animated: true) {
                    
                }
            }
            else
            {
                
            }
			
		}
	}
	
}
