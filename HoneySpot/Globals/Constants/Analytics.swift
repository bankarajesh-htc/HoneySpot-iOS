//
//  Analytics.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 15.05.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import Amplitude_iOS

class Analytics : NSObject{
    
    static public let shared = Analytics()
    
    func setUserId(userId : String){
        Amplitude.instance()?.setUserId(userId)
    }
    
    func setUserProperty(key : String , value : String){
        let identify = AMPIdentify.init().append(key, value: NSString.init(string: value))
        Amplitude.instance()?.identify(identify)
    }
    
    func sendAnalyticsEvent(eventName : String , eventParameters: [String : Any]){
        Amplitude.instance()?.logEvent(eventName, withEventProperties: eventParameters)
    }
    
}
