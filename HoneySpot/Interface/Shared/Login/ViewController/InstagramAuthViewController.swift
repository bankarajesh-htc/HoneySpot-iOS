//
//  InstagramAuthViewController.swift
//  HoneySpot
//
//  Created by Max on 2/8/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import WebKit

class InstagramAuthViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Variables
    var authResult: ((_ accessToken: String?) -> Void)?
    static let STORYBOARD_IDENTIFIER = "InstagramAuthViewController"
    
    // MARK: - UIComponents
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }

        webView?.navigationDelegate = self
        if let url = URL(string: .INSTAGRAM_AUTH_URL) {
            webView?.load(URLRequest(url: url))
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let urlString: String? = navigationAction.request.url?.absoluteString
        guard let url: String = urlString else {
            decisionHandler(WKNavigationActionPolicy.allow)
            return
        }
        
        if url.hasPrefix(.INSTAGRAM_REDIRECT_URL) {
            let anchor: String = "#access_token="
            let token: String = String(url.suffix(from: (url.range(of: anchor)?.upperBound)!))
            if let authResult = authResult {
                authResult(token)
            }
            decisionHandler(WKNavigationActionPolicy.cancel)
            dismiss(animated: true)
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
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
