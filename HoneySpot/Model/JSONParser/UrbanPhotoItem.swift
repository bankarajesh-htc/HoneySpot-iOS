//
//  UrbanPhotoItem.swift
//  HoneySpot
//
//  Created by Max on 2/21/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation

struct UrbanPhotoItem {
    
    var mobile: String?
    
    // Constructor
    init(mobile: String?, web: String?) {
        self.mobile = mobile
    }
    
    // This matches property names with the json keys
    enum CodingKeys: String, CodingKey {
        case image = "image"
        case mobile = "mobile"
    }
}

extension UrbanPhotoItem: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var image = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .image)
        try image.encode(mobile, forKey: .mobile)
    }
}

extension UrbanPhotoItem: Decodable {
    // Initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let image = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .image)
        mobile = try image.decode(String.self, forKey: .mobile)
    }
}
