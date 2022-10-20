//
//  TeleportUrbanPhotosVolatile.swift
//  HoneySpot
//
//  Created by Max on 2/21/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

struct TeleportUrbanPhotosVolatile {
    
    var photoItems: [UrbanPhotoItem]
    
    // Constructor
    init(photoItems: [UrbanPhotoItem] = []) {
        self.photoItems = photoItems
    }
    
    // This matches property names with the json keys
    enum CodingKeys: String, CodingKey {
        case photos = "photos"
    }
}

extension TeleportUrbanPhotosVolatile: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(photoItems, forKey: .photos)
    }
}

extension TeleportUrbanPhotosVolatile: Decodable {
    // Initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        photoItems = try container.decode([UrbanPhotoItem].self, forKey: .photos)
    }
}
