//
//  MasterViewController.swift
//  HoneySpot
//
//  Created by htcuser on 28/09/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit
import StoreKit

class MasterViewController: UIViewController {
    
    var subscriptionNewModel: SubscriptionNewModel!
    @IBOutlet var paymentTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    enum THEME_STYLE: Int {
        case STYLE1 = 0
        case STYLE2 = 1
        case STYLE3 = 2
        case STYLE4 = 3
    }
  
  let showDetailSegueIdentifier = "showDetail"
  
  var products: [SKProduct] = []
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if identifier == showDetailSegueIdentifier {
      guard let indexPath = paymentTableView.indexPathForSelectedRow else {
        return false
      }
      
      let product = products[(indexPath as NSIndexPath).row]
      
      return HoneySpotProducts.store.isProductPurchased(product.productIdentifier)
    }
    
    return true
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showDetailSegueIdentifier {
      guard let indexPath = paymentTableView.indexPathForSelectedRow else { return }
      
      let product = products[(indexPath as NSIndexPath).row]
      
      if let name = resourceNameForProductIdentifier(product.productIdentifier),
             let detailViewController = segue.destination as? DetailViewController {
        let image = UIImage(named: name)
        detailViewController.image = image
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Payment"
    self.navigationController?.isNavigationBarHidden = false
    self.navigationItem.titleView = navTitleLabel(withStyle: .STYLE4)
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "backIcon"), for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.tintColor = UIColor.black
    //button.addTarget(self, action: #selector(self.backButtonTapped), for: .touchUpInside)
    
    let rightBarItem = UIBarButtonItem(customView: button)
    rightBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
    rightBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
    rightBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
    rightBarItem.tintColor = UIColor.black
    
    self.navigationItem.leftBarButtonItem = rightBarItem
    
      paymentTableView.refreshControl = refreshControl
      refreshControl.addTarget(self, action: #selector(MasterViewController.reload), for: .valueChanged)
    
    let restoreButton = UIBarButtonItem(title: "Restore",
                                        style: .plain,
                                        target: self,
                                        action: #selector(MasterViewController.restoreTapped(_:)))
    navigationItem.rightBarButtonItem = restoreButton
    
    NotificationCenter.default.addObserver(self, selector: #selector(MasterViewController.handlePurchaseNotification(_:)),
                                           name: .IAPHelperPurchaseNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(MasterViewController.handlePurchaseNotification(_:)),
                                           name: .IAPHelperFailedPurchaseNotification,
                                           object: nil)
  }
    @objc func backButtonTapped(){
        print("Button Tapped")
        
        //self.dismiss(animated: true, completion: nil)
        
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
            navTitle = NSMutableAttributedString(string: "Save to Try", attributes:[
                NSAttributedString.Key.font: UIFont.fontHelveticaBold(withSize: 23),
                NSAttributedString.Key.foregroundColor: UIColor.BLACK_COLOR])
            navigationController?.navigationBar.barTintColor = .WHITE_COLOR
            break
        }
        navLabel.attributedText = navTitle
        
        return navLabel
    }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    reload()
  }
  
    @IBAction func didClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didClickRestore(_ sender: Any) {
        HoneySpotProducts.store.restorePurchases()
    }
        
  @objc func reload() {
    products = []
    
      paymentTableView.reloadData()
    
    HoneySpotProducts.store.requestProducts{ [weak self] success, products in
      guard let self = self else { return }
        DispatchQueue.main.async {
            
            if success {
              self.products = products!
                if products?.count == 0 {
                    self.showAlert(title: "No In-App Purchases were found")
                }
                else
                {
                    self.paymentTableView.reloadData()
                }
              
            }
          else
            {
              
                self.showAlert(title: "Unable to fetch available In-App Purchase products at the moment.")
            }
            
            self.refreshControl.endRefreshing()
        }
      
    }
  }
    func showAlert(title: String)  {
        
        let alert: UIAlertController = UIAlertController(
            title: title,
            message: "",
            preferredStyle: .alert)
        
        //Add Buttons
        let yesButton: UIAlertAction = UIAlertAction(
            title: "Ok",
            style: .default) { (action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)

        }
        
        let noButton: UIAlertAction = UIAlertAction(
            title: "CANCEL",
            style: .cancel) { (action: UIAlertAction) in
            
        }
        
        alert.addAction(yesButton)
       // alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
        
    }
    func callSubscriptionAPI() {
        ProfileDataSource().subscriptionNew(plans: "premium", price: 9.99, status: true) { (result) in
            self.hideAllHuds()
            switch(result){
            case .success(let plan):
                self.getSubscriptionData()
                DispatchQueue.main.async {
                    
                }
                //self.showAlert(title: "HoneySpot", message: "Upgraded Successfully")
            case .failure(let err):
                print(err.localizedDescription)
                HSAlertView.showAlert(withTitle: "HoneySpot", message: err.errorMessage)
            }
        }
        
    }
    func callFailedSubscriptionAPI() {
        ProfileDataSource().subscriptionNew(plans: "premium", price: 0.0, status: false) { (result) in
            self.hideAllHuds()
            switch(result){
            case .success(let plan):
                self.getSubscriptionData()
                DispatchQueue.main.async {
                    
                }
                //self.showAlert(title: "HoneySpot", message: "Upgraded Successfully")
            case .failure(let err):
                print(err.localizedDescription)
                HSAlertView.showAlert(withTitle: "HoneySpot", message: err.errorMessage)
            }
        }
        
    }
    func getSubscriptionData(){
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
    
  
  @objc func restoreTapped(_ sender: AnyObject) {
    HoneySpotProducts.store.restorePurchases()
  }
    @objc func handleFailedPurchaseNotification(_ notification: Notification) {
      guard
        let productID = notification.object as? String,
          let index = products.firstIndex(where: { product -> Bool in
          product.productIdentifier == productID
      
        })
      else { return }

        paymentTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        callFailedSubscriptionAPI()
    }

  @objc func handlePurchaseNotification(_ notification: Notification) {
    guard
      let productID = notification.object as? String,
        let index = products.firstIndex(where: { product -> Bool in
        product.productIdentifier == productID
    
      })
    else { return }

      paymentTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
      callSubscriptionAPI()
  }
}

// MARK: - UITableViewDataSource

extension MasterViewController: UITableViewDelegate,UITableViewDataSource {
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductCell
    
    let product = products[(indexPath as NSIndexPath).row]
    
    cell.product = product
    cell.buyButtonHandler = { product in
        HoneySpotProducts.store.buyProduct(product)
    }
    
    return cell
  }
}

