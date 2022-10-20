//
//  MapLocation.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 26.08.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import MapKit

struct MapLocation {
    let googlePlaceId : String
    let cityName : String
    let countryName : String
    var location : CLLocation?
}
