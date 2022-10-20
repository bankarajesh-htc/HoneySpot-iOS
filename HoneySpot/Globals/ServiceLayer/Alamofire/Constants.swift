//
//  Constants.swift
//  HoneySpot
//
//  Created by Max on 2/21/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

struct APIEndPoints {
    struct TeleportUrbanAreasVolatile {
        static let urlPath = "https://api.teleport.org/api/urban_areas/"
    }
    
    struct APIParameterKey {
        //        static let email = "email"
        //        static let password = "password"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
