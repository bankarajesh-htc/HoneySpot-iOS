//
//  SpotModel.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 19.12.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation

struct SpotModel {
    var id : String
    var name : String
    var photoUrl : String
    var address : String
    var lat : Double
    var lon : Double
    var phoneNumber : String?
    var googlePlaceId: String
    var city : String
	
	var deliveryOptions : [String]?
	var menuPictures = [String]()
	var foodPictures = [String]()
	var customerPictures = [String]()
	var logoUrl : String?
	var owners : String?
    var comment : String?
	var website : String?
	var email : String?
    var didILike : Bool = false
	
	var spotDescription : String = ""
    var spotreservationlink : String = ""
    var spotreservationdescription : String = ""
	var otherlocations = [String]()
	var categories = [Int]()
	var operationhours = [String]()
    
    //Feed Details
    var feedTitle = [String]()
    var feedId = [Int]()
    var feedPostedBy = [Int]()
    var feedDescription = [Any]()
    var feedImageUrl = [Any]()
    var createDate = [Any]()
    var endDate = [Any]()
    
    //wishlist
    var wishListId : String?
    var wishListCreateDate : String?
    
    
}
