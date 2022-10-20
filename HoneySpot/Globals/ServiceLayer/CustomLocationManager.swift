//
//  CustomLocationManager.swift
//  HoneySpot
//
//  Created by Max on 2/15/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import CoreLocation

protocol CustomLocationServiceDelegate {
    func locationDidUpdateToLocation(currentLocation: CLLocation)
    func locationUpdateDidFailWithError(error: Error)
}

class CustomLocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = CustomLocationManager()
    var locationManager: CLLocationManager = CLLocationManager()
    var lastLocation: CLLocation?
    var delegate: CustomLocationServiceDelegate?
    
    private override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if CLLocationManager.authorizationStatus() == .denied {
            // Alert to ask user to enable location service to use the app properly
        }
    }
    
    func startUpdatingLocation() {
        print("Starting location updates")
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop location updates")
        locationManager.stopUpdatingLocation()
    }
    
    func startMonitoringSignificantLocationChanges() {
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant from Settings app
            // Show message to ask user to enable location service for this app
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        // Singleton for last location
        lastLocation = location
        // Call delegate with new location value
        updateLocation(location: location)
        // Stop Location Updating
        stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationDidFailWithError(error: error)
    }
    
    // Private actions
    private func updateLocation(location: CLLocation) {
        guard let delegate = delegate else {
            return
        }
        delegate.locationDidUpdateToLocation(currentLocation: location)
    }
    
    private func updateLocationDidFailWithError(error: Error) {
        guard let delegate = delegate else {
            return
        }
        delegate.locationUpdateDidFailWithError(error: error)
    }
}
