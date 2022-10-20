//
//  DetailViewController.swift
//  HoneySpot
//
//  Created by htcuser on 28/09/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView?
  
  var image: UIImage? {
    didSet {
      configureView()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureView()
  }
  
  func configureView() {
    imageView?.image = image
  }
}
