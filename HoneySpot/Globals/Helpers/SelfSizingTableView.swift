//
//  SelfSizingTableView.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 20.01.2021.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import Foundation
import UIKit

class SelfSizingTableView: UITableView {
  
	var maxHeight: CGFloat = UIScreen.main.bounds.size.height
  
	override func reloadData() {
		super.reloadData()
		self.invalidateIntrinsicContentSize()
		self.layoutIfNeeded()
	}
	  
	override var intrinsicContentSize: CGSize {
		setNeedsLayout()
		layoutIfNeeded()
		let height = min(contentSize.height, maxHeight)
		return CGSize(width: contentSize.width, height: height)
	}
	
}
