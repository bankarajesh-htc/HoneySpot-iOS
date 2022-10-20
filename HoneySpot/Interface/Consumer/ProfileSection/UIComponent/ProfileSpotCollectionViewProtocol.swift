//
//  ProfileSpotCollectionViewProtocol.swift
//  HoneySpot
//
//  Created by Max on 2/21/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import UIKit

@objc protocol ProfileSpotCollectionViewProtocol {
    var cellImageView: UIImageView! { get set }
    var cellTagLabel: UILabel! { get set }
    var cellTitleLabel: UILabel! { get set }
}
