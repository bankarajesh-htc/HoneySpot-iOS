//
//  BusinessHoneyspottersViewController.swift
//  HoneySpot
//
//  Created by htcuser on 10/11/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class BusinessHoneyspottersViewController: UIViewController {

    @IBOutlet weak var honeySpottersTableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchCancelButton: UIButton!
    
    var selectedClaim : ClaimModel!
    var honeySpottersModel = [HoneyspotterModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        initialize()
        loadHoneySpotters()

        // Do any additional setup after loading the view.
    }
    func initialize() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.isNavigationBarHidden = true
        searchTextField.autocapitalizationType = .none
        addDoneButtonOnKeyboard()
        
        CustomLocationManager.sharedInstance.startUpdatingLocation()
    }
    @IBAction func didClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadHoneySpotters() {
        self.showLoadingHud()
        BusinessRestaurantDataSource().honeySpotters(spotId: self.selectedClaim.spot.id) { (result) in
            self.hideAllHuds()
            switch(result){
            case .success(let honeySpotters):
                DispatchQueue.main.async {
                    self.honeySpottersModel = honeySpotters
                    print(self.honeySpottersModel)
                    self.honeySpottersTableView.reloadData()
                    self.hideAllHuds()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    @IBAction func searchChanged(_ sender: Any) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
        self.perform(#selector(self.reload), with: nil, afterDelay: 0.3)
    }
    @IBAction func searchCancelTapped(_ sender: Any) {
        searchTextField.text = ""
        searchCancelButton.isHidden = true
        loadHoneySpotters()
        //self.honeySpottersTableView.isHidden = true
    }
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        searchTextField.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction(){
        searchTextField.resignFirstResponder()
    }
    @objc func reload() {
        self.showLoadingHud()
        let term = searchTextField.text ?? ""
        
        if(term.count > 0){
            searchCancelButton.isHidden = false
            self.honeySpottersTableView.isHidden = false
        }else{
            searchCancelButton.isHidden = true
            loadHoneySpotters()
            return
            
        }
        BusinessRestaurantDataSource().searchHoneySpotters(spotId: self.selectedClaim.spot.id, username: term ){ (result) in
            
            switch(result){
            case .success(let honeySpotters):
                DispatchQueue.main.async {
                    self.honeySpottersModel = honeySpotters
                    print(self.honeySpottersModel)
                    self.honeySpottersTableView.reloadData()
                    self.hideAllHuds()
                }
            case .failure(let err):
                self.hideAllHuds()
                print(err.localizedDescription)
            }
        }
        
        
        
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

extension BusinessHoneyspottersViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.honeySpottersModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "honeySpotCellId") as! HoneyspottersTableViewCell
        let honeySpot = self.honeySpottersModel[indexPath.row]
        cell.honeySpotterFullName.text = honeySpot.userfullname
        cell.honeySpotterName.text = honeySpot.username
        if honeySpot.userpictureurl == "" {
            cell.honeySpotterImage.image = UIImage(named: "AvatarPlaceHolder")
        }
        else
        {
            cell.honeySpotterImage.kf.setImage(with: URL(string: honeySpot.userpictureurl))
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
}
