//
//  TeleportUrbanAreasVolatile.swift
//  HoneySpot
//
//  Created by Max on 2/20/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

struct TeleportUrbanAreasVolatile {
    
    var areaItems: [UrbanAreaItem]
    
    // Constructor
    init(areaItems: [UrbanAreaItem] = []) {
        self.areaItems = areaItems
    }
    
    // This matches property names with the json keys
    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case areaItems = "ua:item"
    }
}

extension TeleportUrbanAreasVolatile: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var links = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .links)
        try links.encode(areaItems, forKey: .areaItems)
    }
}

extension TeleportUrbanAreasVolatile: Decodable {
    // Initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let links = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .links)
        areaItems = try links.decode([UrbanAreaItem].self, forKey: .areaItems)
    }
    
    // Parse Json data into Object Array
    /*static func decodeFromJsonData(UrbanAreaData data: Data) -> TeleportUrbanAreasVolatile? {
        do {
            let decoder = JSONDecoder()
            let urbanAreasVolatile = try decoder.decode(TeleportUrbanAreasVolatile.self, from: data)
            return urbanAreasVolatile
        } catch {
            print("JSON parsing error:\(error)")
        }
        return nil
    }*/
}
