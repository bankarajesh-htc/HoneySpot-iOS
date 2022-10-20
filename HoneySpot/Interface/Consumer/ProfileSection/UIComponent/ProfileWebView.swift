//
//  ProfileWebView.swift
//  HoneySpot
//
//  Created by htcuser on 30/01/22.
//  Copyright © 2022 HoneySpot. All rights reserved.
//

import Foundation
import WebKit
import UIKit

public class ProfileWebView: UIView, WKNavigationDelegate {

// initialize the view
let view: WKWebView = {
    let view = WKWebView()
    return view
}()

// get the url and load the page
public func passUrl(url: String) {
    guard let url = URL(string: url) else { return }
    view.navigationDelegate = self
    view.load(URLRequest(url: url))
    view.allowsBackForwardNavigationGestures = true
    view.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
}

// Observe value
override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if let key = change?[NSKeyValueChangeKey.newKey] {
        print("URL Changes: \(key)")
        let alert = UIAlertController(title: "URL Changed", message: "\(key)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

public override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
}

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

private func setupView() {
    view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(view)
    NSLayoutConstraint.activate([
        view.topAnchor.constraint(equalTo: topAnchor),
        view.leadingAnchor.constraint(equalTo: leadingAnchor),
        view.trailingAnchor.constraint(equalTo: trailingAnchor),
        view.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
}
}
