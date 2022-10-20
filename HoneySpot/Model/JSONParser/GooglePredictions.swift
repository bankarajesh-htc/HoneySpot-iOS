//
//  GooglePredictions.swift
//  HoneySpot
//
//  Created by Max on 2/22/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation

struct GooglePredictions: Decodable {
    
    struct Prediction: Decodable {
        let place_id: String
        let description: String
        
        struct Term: Decodable {
            let value: String
        }
        let terms: [Term]
    }
    
    let predictions: [Prediction]
}
