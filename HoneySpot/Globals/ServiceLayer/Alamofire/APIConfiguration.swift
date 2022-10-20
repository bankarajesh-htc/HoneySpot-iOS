//
//  APIConfiguration.swift
//  HoneySpot
//
//  Created by Max on 2/21/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}
