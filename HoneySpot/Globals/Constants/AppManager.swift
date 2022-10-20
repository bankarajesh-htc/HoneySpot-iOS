//
//  GlobalConstants.swift
//  HoneySpot
//
//  Created by Max on 2/6/19.
//

import Foundation
import UIKit
 



// Utility Methods
extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        switch self {
        case .some(let collection):
            return collection.isEmpty
        case .none:
            return true
        }
    }
}
