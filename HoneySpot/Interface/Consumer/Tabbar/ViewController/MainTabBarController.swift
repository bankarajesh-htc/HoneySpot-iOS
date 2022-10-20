//
//  MainTabBarController.swift
//  HoneySpot
//
//  Created by Max on 2/13/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import ESTabBarController_swift
 
import Alamofire
import MapKit
import Crashlytics

class MainTabBarController: ESTabBarController {

    let tabbarIcons = ["TabbarIconList", "TabbarIconLocate","TabbarIconSearch", "TabbarIconProfile"] //"TabbarIconAdd"
    //let tabbarIcons = ["TabbarIconList", "TabbarIconLocate", "TabbarIconAdd", "TabbarIconProfile"]
    var previousIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }

        // Do any additional setup after loading the view.
        initializeTabbar()
        initializeData()
        
        if #available(iOS 13, *) {
                          let appearance = self.tabBar.standardAppearance.copy()
                          appearance.backgroundImage = UIImage()
                          appearance.shadowImage = UIImage()
                          appearance.shadowColor = .clear
                          self.tabBar.standardAppearance = appearance
                      } else {
                          self.tabBar.backgroundImage = UIImage()
                          self.tabBar.shadowImage = UIImage()
                      }
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
        self.selectedIndex = 0
		
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
        CustomLocationManager.sharedInstance.delegate = self
        CustomLocationManager.sharedInstance.startUpdatingLocation()
        self.logUser()
    }
    
    func logUser() {
        Crashlytics.sharedInstance().setUserIdentifier(UserDefaults.standard.string(forKey: "userId") ?? "")
        Crashlytics.sharedInstance().setUserName(UserDefaults.standard.string(forKey: "username") ?? "")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}

extension MainTabBarController: CustomLocationServiceDelegate {
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

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 {
            // If user tapped on the feed button again while on the feed screen
            // Scroll to top
            
            
//            NotificationCenter.default.post(
//                name: NSNotification.Name(.FEED_NORAMLLIST),
//                object: nil,
//                userInfo: nil
//            )
//            if previousIndex == 0 {
//                NotificationCenter.default.post(
//                    name: NSNotification.Name(.NOTIFICATION_SCROLLFEEDTOTOP),
//                    object: nil,
//                    userInfo: nil
//                )
//            }
        }
        else if tabBarController.selectedIndex == 1
        {
            AppDelegate.originalDelegate.isWishlist = false
        }
        else if tabBarController.selectedIndex == 2
        {
            AppDelegate.originalDelegate.isWishlist = false
        }
        else if tabBarController.selectedIndex == 3 {
            // If user tapped on the feed button again while on the feed screen
            // Scroll to top
            AppDelegate.originalDelegate.isWishlist = true
            if AppDelegate.originalDelegate.isGuestLogin {
                //AppDelegate.originalDelegate.isFeedProfile = false
            }
//            NotificationCenter.default.post(
//                name: NSNotification.Name(.FEED_WISHLIST),
//                object: nil,
//                userInfo: nil
//            )
            
            
        }
        
        self.previousIndex = tabBarController.selectedIndex
    }
    
}
