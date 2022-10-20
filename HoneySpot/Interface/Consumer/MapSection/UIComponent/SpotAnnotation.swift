//
//  SpotAnnotation.swift
//  HoneySpot
//
//  Created by Max on 2/15/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import MapKit

class SpotAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var spotSaveModel : SpotSaveModel?
    var title: String?
    var subtitle: String?
    
    init(spotSaveModel: SpotSaveModel) {
        super.init()
        self.spotSaveModel = spotSaveModel
        coordinate = CLLocationCoordinate2DMake(spotSaveModel.spot.lat, spotSaveModel.spot.lon)
        self.title = spotSaveModel.spot.name
        self.subtitle = spotSaveModel.spot.address
    }
}
