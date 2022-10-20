//
//  MapLocationCollectionViewCell.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 14.12.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit

class MapLocationCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var img: UIImageView!
	@IBOutlet var name: UILabel!
	@IBOutlet var address: UILabel!
	@IBOutlet var backView: UIView!
    lazy var spinner = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
         spinner.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
     }
	
}
