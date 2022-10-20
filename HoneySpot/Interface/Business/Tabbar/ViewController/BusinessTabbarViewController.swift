//
//  BusinessTabbarViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 30.06.2020.
//  Copyright © 2020 HoneySpot. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import Alamofire
import Crashlytics
import MapKit

class BusinessTabbarViewController: ESTabBarController {

	let tabbarIcons = ["businessTab1", "businessTab2","businessTab3","businessTab4"] //"businessTab3"
	var previousIndex = -1
	
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeTabbar()
        initializeData()
    }
    
    private func initializeTabbar() {
        if let tabBar = self.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }
        self.delegate = self
        
        guard let viewControllers = self.viewControllers else {
            return
        }
        for (index, viewController) in zip(viewControllers.indices, viewControllers) {
            viewController.tabBarItem = ESTabBarItem.init(TabBarHighlightableContentView(), title: nil, image: UIImage(named: tabbarIcons[index]), selectedImage: UIImage(named: tabbarIcons[index]))
        }
		
//        self.didHijackHandler = {
//            tabBarController, viewController, index in
//            if index == 2 {
//                self.dismiss(animated: true, completion: {
//
//                })
//            }
//        }
    }
    

    private func initializeData() {
        self.logUser()
    }
    
    func logUser() {
        Crashlytics.sharedInstance().setUserIdentifier(UserDefaults.standard.string(forKey: "userId") ?? "")
        Crashlytics.sharedInstance().setUserName(UserDefaults.standard.string(forKey: "username") ?? "")
    }

}

extension BusinessTabbarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 {
            if previousIndex == 0 {
                NotificationCenter.default.post(
                    name: NSNotification.Name(.NOTIFICATION_SCROLLFEEDTOTOP),
                    object: nil,
                    userInfo: nil
                )
            }
        }
        self.previousIndex = tabBarController.selectedIndex
    }
}
extension BusinessTabbarViewController: CustomLocationServiceDelegate {
    // MARK: - CustomLocationServiceDelegate
    func locationDidUpdateToLocation(currentLocation: CLLocation) {
        let mapView = MKMapView()
        var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
        mapRegion.center = mapView.userLocation.coordinate
        mapRegion.span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        if(mapRegion.center.longitude == -180.00000000){
            NSLog("Invalid region!")
        }else{
            mapView.setRegion(mapRegion, animated: true)
        }
//        CustomLocationManager.sharedInstance.stopUpdatingLocation()
    }
    
    func locationUpdateDidFailWithError(error: Error) {
//        CustomLocationManager.sharedInstance.stopUpdatingLocation()
    }
}
