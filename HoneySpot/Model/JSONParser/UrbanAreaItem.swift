//
//  UrbanAreaItem.swift
//  HoneySpot
//
//  Created by Max on 2/20/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

struct UrbanAreaItem {
    
    var href: String?
    var name: String?
    
    // Constructor
    init(href: String?, name: String?) {
        self.href = href
        self.name = name
    }
    
    // This matches property names with the json keys
    enum CodingKeys: String, CodingKey {
        case href = "href"
        case name = "name"
    }
}

extension UrbanAreaItem: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(href, forKey: .href)
        try container.encode(name, forKey: .name)
    }
}

extension UrbanAreaItem: Decodable {
    // Initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        href = try container.decode(String.self, forKey: .href)
        name = try container.decode(String.self, forKey: .name)
    }
    
    // Parse Json data into Object Array
    /*
    static func decodeFromJsonData(data: Data) -> [UrbanAreaItem]? {
        do {
            let decoder = JSONDecoder()
            let itemArray = try decoder.decode([UrbanAreaItem].self, from: data)
            return itemArray
        } catch {
            print("JSON parsing error:\(error)")
        }
        return nil
    }*/
}
