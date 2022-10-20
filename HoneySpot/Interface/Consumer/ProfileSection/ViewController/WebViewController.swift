//
//  WebViewController.swift
//  HoneySpot
//
//  Created by Max on 2/19/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var newSubView: UIView!
    
	@IBOutlet var titleLabel: UILabel!
    
    //var myWebView =  ProfileWebView()
	
	var titleStr = ""
    static let STORYBOARD_IDENTIFIER = "WebViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
		titleLabel.text = titleStr
        // Do any additional setup after loading the view.
    }
    
    func loadPrivacyPolicy()  {
            if Connectivity.isConnectedToInternet {
                    print("Yes! internet is available.")
                    // do some tasks..
             }
            else
            {
                print("No! internet is not available.")
                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please check your internet connection")
            }
            self.showLoadingHud()

            guard let htmlPath = Bundle.main.path(forResource: "HoneyspotPrivacyPolicy", ofType: "html") else {

                return

            }
            let request = URLRequest(url: URL(fileURLWithPath: htmlPath))
            let myURL = URL(string:"https://honeyspot-documents.s3.us-east-2.amazonaws.com/HoneyspotPrivacyPolicy.html")
            let myRequest = URLRequest(url: myURL!)
            self.loadViewIfNeeded()
            self.webView.isOpaque = false
            self.webView.backgroundColor = UIColor.clear
            self.webView.load(myRequest)
            self.hideAllHuds()
        }
        func termsOfServices()  {
            if Connectivity.isConnectedToInternet {
                    print("Yes! internet is available.")
                    // do some tasks..
             }
            else
            {
                print("No! internet is not available.")
                HSAlertView.showAlert(withTitle: "HoneySpot", message: "Please check your internet connection")
            }
            self.showLoadingHud()
            guard let htmlPath = Bundle.main.path(forResource: "HoneyspotTermsofService", ofType: "html") else {

                return

            }

            let request = URLRequest(url: URL(fileURLWithPath: htmlPath))
            let myURL = URL(string:"https://honeyspot-documents.s3.us-east-2.amazonaws.com/HoneyspotTermsofService.html")
            let myRequest = URLRequest(url: myURL!)
            self.loadViewIfNeeded()
            self.webView.isOpaque = false
            self.webView.backgroundColor = UIColor.clear
            self.webView.load(myRequest)
            self.hideAllHuds()

        }
    
    
    class func privacyPolicyController() -> WebViewController? {
        
        guard let htmlPath = Bundle.main.path(forResource: "HoneyspotTermsofService", ofType: "html") else {
            return nil
        }
        let request = URLRequest(url: URL(fileURLWithPath: htmlPath))
        WEB_VIEWCONTROLLER.loadViewIfNeeded()
        WEB_VIEWCONTROLLER.webView.isOpaque = false
        WEB_VIEWCONTROLLER.webView.backgroundColor = UIColor.clear
        WEB_VIEWCONTROLLER.webView.load(request)
        return WEB_VIEWCONTROLLER
    }
    
    class func termsOfServiceController() -> WebViewController? {
        guard let htmlPath = Bundle.main.path(forResource: "HoneyspotTermsofService", ofType: "html") else {
            return nil
        }
        let request = URLRequest(url: URL(fileURLWithPath: htmlPath))
        WEB_VIEWCONTROLLER.loadViewIfNeeded()
        WEB_VIEWCONTROLLER.webView.isOpaque = false
        WEB_VIEWCONTROLLER.webView.backgroundColor = UIColor.clear
        WEB_VIEWCONTROLLER.webView.load(request)
        return WEB_VIEWCONTROLLER
    }
    
    @IBAction func onCloseButtonTap(_ sender: Any) {
        self.dismiss(animated: true) { }
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
