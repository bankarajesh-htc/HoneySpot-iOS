//
//  MediaUpdateCollectionViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 28/10/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class MediaUpdateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bView: UIView!
    @IBOutlet weak var tagImage: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var selectedIcon: UIImageView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var deleteImageButton: UIButton!
    var delegate : BusinessMediaEditDelegate!
    var currentIndex = 0
    
    func prepareCell(model : SpotModel,currentIndex:Int,indexPath:IndexPath){
        print("CI..\(currentIndex) Index...\(indexPath.row)")
        self.currentIndex = currentIndex
    }
    
    @IBAction func didClickDelete(_ sender: UIButton) {
        self.delegate.imageDeleteTapped(cell: self,currentIndex:currentIndex)
    }
    
}
