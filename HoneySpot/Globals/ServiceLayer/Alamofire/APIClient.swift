//
//  APIClient.swift
//  HoneySpot
//
//  Created by Max on 2/21/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    @discardableResult
    private static func performRequest<T: Decodable>(route: APIRouter, decoder: JSONDecoder = JSONDecoder(), completion: @escaping(Result<T,AFError>)->Void) -> DataRequest {
        return AF.request(route).responseDecodable (decoder: decoder){ (response: DataResponse<T,AFError>) in
                completion(response.result)
        }
    }
    static func getTeleportUrbanAreas(completion: @escaping(Result<TeleportUrbanAreasVolatile,AFError>)-> Void) {
        performRequest(route: APIRouter.areas, completion: completion)
    }

    static func getGooglePlaceDetail(GooglePlaceID googlePlaceId: String, completion: @escaping(_ googlePlace: GooglePlace?)-> Void) {
        let urlString: String = String(format: .GOOGLEPLACES_API_GET_PLACE_FORMATSTRING, googlePlaceId.addingPercentEncoding(withAllowedCharacters: String.ENCODING_ALLOWED_CHARACTERS)!)

        AF.request(urlString)
            .responseDecodable { (response: DataResponse<GooglePlace,AFError>) in
                switch response.result {
                case .success(let googlePlace):
                    completion(googlePlace)
                    break
                case .failure(let error):
                    completion(nil)
                    print("Error with getting google place info", urlString, error)
                    break
                }
        }
    }
}
