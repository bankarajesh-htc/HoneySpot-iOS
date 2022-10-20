//
//  GooglePlace.swift
//  HoneySpot
//
//  Created by Max on 2/22/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation

struct GooglePlace: Decodable {
    
    struct Place: Decodable {
        let formatted_address: String
        let formatted_phone_number: String?

        struct Geometry: Decodable {
            struct Location: Decodable {
                let lat: Double
                let lng: Double
            }
            let location: Location
        }
        let geometry: Geometry
        
        struct Photo: Decodable {
            let photo_reference: String
        }
        let photos: [Photo]?
    }

    let result: Place
}
