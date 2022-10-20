//
//  String+Constants.swift
//  HoneySpot
//
//  Created by Max on 2/8/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import UIKit

// MARK: String Constants
extension String {
    
    //---Storyboards-------------------------------
    // Login Storyboard
    static let STORYBOARD_LOGIN = "Login"
    static let IDENTIFIER_ROOTLOGIN_NAVIGATIONCONTROLLER = "RootNavigationController"
    static let IDENTIFIER_LOGIN_NAVIGATIONCONTROLLER = "LoginNavigationController"
    static let IDENTIFIER_FIRST_LOGINCONTROLLER = "FirstLoadingViewController"
    static let IDENTIFIER_LOGIN_VIEWCONTROLLER = "LoginViewController"
    static let IDENTIFIER_BUSINESS_LOGIN_VIEWCONTROLLER = "BusinessLoginViewController"
    static let IDENTIFIER_FOLLOWSOCIALCCOUNTFRIENDS_VIEWCONTROLLER = "FollowSocialAccountFriendsViewController"
    // Main Storyboard
    static let STORYBOARD_MAIN = "Main"
    static let IDENTIFIER_MAIN_TABBARCONTROLLER = "MainTabBarController"
    // Feed Storyboard
    static let STORYBOARD_FEED = "Feed"
    static let IDENTIFIER_FEED_VIEWCONTROLLER = "FeedViewViewController"
    static let IDENTIFIER_SAVE_VIEWCONTROLLER = "SaveToTryViewController"
    static let IDENTIFIER_FEED_FULLPOST_VIEWCONTROLLER = "FeedFullPostViewController"
    static let IDENTIFIER_FEED_LOCATION_VIEWCONTROLLER = "LocationsViewController"
    static let IDENTIFIER_COMMENTS_VIEWCONTROLLER = "CommentsViewController"
    // Map Storyboard
    static let STORYBOARD_MAP = "Map"
    // AddSpot Storyboard
    static let STORYBOARD_ADDSPOT = "AddSpot"
    static let IDENTIFIER_ADDSPOT_NAVIGATION_VIEWCONTROLLER = "AddSpotNavigationController"
    static let IDENTIFIER_ADDSPOT_CONFIRM_VIEWCONTROLLER = "AddSpotConfirmViewController"
    static let IDENTIFIER_ADDSPOT_DETAILS_VIEWCONTROLLER = "AddSpotDetailsViewController"
    static let IDENTIFIER_ADDSPOT_FINAL_VIEWCONTROLLER = "AddSpotFinalViewController"
    // Search Storyboard
    static let STORYBOARD_SEARCH = "Search"
    static let IDENTIFIER_SEARCH_AUTOCOMPLETE_VIEWCONTROLLER = "SearchAutocompleteViewController"
    // Profile Storyboard
    static let STORYBOARD_PROFILE = "Profile"
    //-----------------------------------------------
    //StoryBoard Announcement
    static let STORYBOARD_ANNOUNCEMENT = "Announcement"
    static let IDENTIFIER_ANNOUNCEMENT_VIEWCONTROLLER = "AnnouncementDetailViewController"
    //StoryBoard Admin
    static let STORYBOARD_ADMIN = "Admin"
    static let IDENTIFIER_ADMIN_VIEWCONTROLLER = "AdminViewController"
    static let IDENTIFIER_ADMIN_DETAILVIEWCONTROLLER = "DetailAdminViewController"
    static let STORYBOARD_SETTINGS = "BusinessSetting"
    
    static let IDENTIFIER_MASTER_VIEWCONTROLLER = "MasterViewController"
    //Backend API URLS
    
    //static let BackendBaseUrl = "https://dfk2nmi02r42q.cloudfront.net"
    static let BackendBaseUrl = "https://85rifqarab.execute-api.us-east-2.amazonaws.com/production"
    static let BackendDevBaseUrl = "https://85rifqarab.execute-api.us-east-2.amazonaws.com/development"
    static let BackendProdBaseUrl = "https://85rifqarab.execute-api.us-east-2.amazonaws.com/production"
    //https://85rifqarab.execute-api.us-east-2.amazonaws.com/production/spot/analytics/spot_activity_count
//https://85rifqarab.execute-api.us-east-2.amazonaws.com/production
    // GooglePlaces API URL
    static let GOOGLEPLACES_API_KEY = "AIzaSyAMdmOyJ0OPLTTlKAoRIuKh8NuT-G7h78M"//"AIzaSyB8ynPtOlTXZ_lp0GhUv-mSP2NYzzet05w"
    static let GOOGLEPLACES_API_URL_FORMATSTRING = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%.7f,%.7f&radius=500&type=restaurant&key=\(GOOGLEPLACES_API_KEY)"
    static let GOOGLEPLACES_API_GET_PLACE_FORMATSTRING = "https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=\(GOOGLEPLACES_API_KEY)"
    static let GOOGLEPLACES_API_GET_CITY_FORMATSTRING = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=(cities)&key=\(GOOGLEPLACES_API_KEY)"
    static let GOOGLEPLACE_AUTOCOMPLETE_API_FORMATSTRING = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&key=\(GOOGLEPLACES_API_KEY)"
    static let GOOGLEPLACE_AUTOCOMPLETE_RESTAURANT_API_FORMATSTRING = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=restaurant&key=\(GOOGLEPLACES_API_KEY)"
    static let GOOGLEPLACE_PHOTO_URL = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1000&photoreference=%@&key=\((GOOGLEPLACES_API_KEY))"
    
    // Apple Map
    static let APPLE_MAP_URL = "http://maps.apple.com/?address=%@"
    
    // Instagram Keys
    static let INSTAGRAM_CLIENT_ID = "e9319c9c6ef840d9ae09a0c62337757b"
    static let INSTAGRAM_REDIRECT_URL = "https://www.test.com/login/callback"
    static let INSTAGRAM_AUTH_URL = "https://api.instagram.com/oauth/authorize/?client_id=\(INSTAGRAM_CLIENT_ID)&redirect_uri=\(INSTAGRAM_REDIRECT_URL)&response_type=token"
    static let INSTAGRAM_API_GET_USER = "https://api.instagram.com/v1/users/self/?access_token=%@"
    static let INSTAGRAM_API_GET_FOLLOWS = "https://api.instagram.com/v1/users/%@/follows?access_token=%@" // user-id, token
    
    // OneSignal
    static let ONESIGNAL_APP_ID = "55af464c-2f7b-4f8d-97fb-5019390bff27"
    
    // Notifications
    static let NOTIFICATION_GETFRIENDS_FINISHED = "getFriendsFinished"
    static let NOTIFICATION_SHOW_CONTACTS = "showContacts"
    static let NOTIFICATION_SCROLLFEEDTOTOP = "scrollFeedToTop"
    static let FEED_WISHLIST = "wishlist"
    static let FEED_NORAMLLIST = "normallist"
    static let NOTIFICATION_FOLLOWER_CHANGED = "followerChanged"
    
    // Character Encoding
    static let CHARACTERS_TO_ESCAPE = "!*'();:@&=+$,/?%#[]\" "
    static let ENCODING_ALLOWED_CHARACTERS: CharacterSet = CharacterSet(charactersIn:CHARACTERS_TO_ESCAPE).inverted
    
    // Convenience method to create random strings with variable length
    init(randomStringLength: Int) {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        self.init((0...randomStringLength-1).map{ _ in letters.randomElement()! })
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidUserName() -> Bool {
        let RegEx = "\\w{3,30}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    func isValidFullName(testStr:String) -> Bool {

        let predicateTest = NSPredicate(format: "SELF MATCHES %@","^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
        return predicateTest.evaluate(with: testStr)
    }
}

extension Double {
    // Example Usage
    // Double(3.14159265359).format(".3") returns "3.142"
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

extension Int {
    // Example Usage
    // Int(15).format("03") returns "015"
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
