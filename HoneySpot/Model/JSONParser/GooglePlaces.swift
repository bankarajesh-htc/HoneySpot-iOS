//
//  GooglePlace.swift
//  HoneySpot
//
//  Created by Max on 2/22/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation

struct GooglePlaces: Decodable {
    
    struct Place: Decodable {
        struct Geometry: Decodable {
            struct Location: Decodable {
                let lat: Double
                let lng: Double
            }
            let location: Location
            
            enum CodingKeys: String, CodingKey {
                case location
            }
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                location = try container.decode(Location.self, forKey: .location)
            }
        }
        
        struct ReferencePhotos : Decodable {
            let photo_reference : String
        }
        
        struct Photo: Decodable {
            let height: Int
            let htmlAttributions: [String]
            let photoReference: String
            let width: Int

            enum CodingKeys: String, CodingKey {
                case height
                case htmlAttributions = "html_attributions"
                case photoReference = "photo_reference"
                case width
            }
        }
        
        let geometry: Geometry
        let name: String
        let place_id: String
        //let vicinity: String
		let photos: [Photo]? 
		var formatted_address: String
        
        enum CodingKeys: String, CodingKey {
            case geometry
            case name
            case place_id
            //case vicinity
            case photos
			case formatted_address
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            photos = try container.decodeIfPresent([Photo].self, forKey: .photos)
           // photos = try container.decode([Photo].self, forKey: .photos)
            print(photos)
            if photos == nil {
                print("Photo is nill")
            }
            geometry = try container.decode(Geometry.self, forKey: .geometry)
            name = try container.decode(String.self, forKey: .name)
            place_id = try container.decode(String.self, forKey: .place_id)
			formatted_address = try container.decode(String.self, forKey: .formatted_address)
            //vicinity = try container.decode(String.self, forKey: .vicinity)
        }
        
    }

    let results: [Place]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decode([Place].self, forKey: .results)
        print(results)
    }
}
