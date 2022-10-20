//
//  APIRouter.swift
//  HoneySpot
//
//  Created by Max on 2/21/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: APIConfiguration {
    
    case areas
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .areas:
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .areas:
            return APIEndPoints.TeleportUrbanAreasVolatile.urlPath
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .areas:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try path.asURL()
        var urlRequest = URLRequest(url: url)
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
    
}
