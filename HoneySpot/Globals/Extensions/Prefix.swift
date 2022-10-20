//
//  Prefix.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 26.08.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import MapKit

var currentUser = emptyUserModel()

var globalTags = [
    //Meals
    Tag(id: 1, name: "Breakfast", image: UIImage(named: "breakfast")!, grayImage: UIImage(named: "breakfast-gray")!),
    Tag(id: 2, name: "Brunch", image: UIImage(named: "brunch")!, grayImage: UIImage(named: "brunch-gray")!),
    Tag(id: 3, name: "Lunch", image: UIImage(named: "lunch")!, grayImage: UIImage(named: "lunch-gray")!),
    Tag(id: 4, name: "Dinner", image: UIImage(named: "dinner")!, grayImage: UIImage(named: "dinner-gray")!),
    //Cuisines
    Tag(id: 5, name: "Pizza", image: UIImage(named: "pizza")!, grayImage: UIImage(named: "pizza-gray")!),
    Tag(id: 6, name: "Sushi", image: UIImage(named: "sushi")!, grayImage: UIImage(named: "sushi-gray")!),
    Tag(id: 7, name: "Indian", image: UIImage(named: "indian")!, grayImage: UIImage(named: "indian-gray")!),
    Tag(id: 8, name: "Dessert", image: UIImage(named: "dessert")!, grayImage: UIImage(named: "dessert-gray")!),
    Tag(id: 9, name: "Mexican", image: UIImage(named: "mexican")!, grayImage: UIImage(named: "mexican-gray")!),
    Tag(id: 10, name: "American", image: UIImage(named: "american")!, grayImage: UIImage(named: "american-gray")!),
    Tag(id: 11, name: "Italian", image: UIImage(named: "italian")!, grayImage: UIImage(named: "italian-gray")!),
    Tag(id: 12, name: "Seafood", image: UIImage(named: "seafood")!, grayImage: UIImage(named: "seafood-gray")!),
    Tag(id: 13, name: "Asian", image: UIImage(named: "asian")!, grayImage: UIImage(named: "asian-gray")!),
    Tag(id: 14, name: "Mediterranean", image: UIImage(named: "mediterranean")!, grayImage: UIImage(named: "mediterranean-gray")!),
    Tag(id: 15, name: "Peruvian", image: UIImage(named: "peruvian")!, grayImage: UIImage(named: "peruvian-gray")!),
    Tag(id: 16, name: "Latin American", image: UIImage(named: "latin")!, grayImage: UIImage(named: "latin-gray")!),
    Tag(id: 17, name: "Caribbean", image: UIImage(named: "caribbean")!, grayImage: UIImage(named: "caribbean-gray")!),
    Tag(id: 18, name: "Spanish", image: UIImage(named: "spanish")!, grayImage: UIImage(named: "spanish-gray")!),
    Tag(id: 19, name: "Juice & Smoothies", image: UIImage(named: "juice")!, grayImage: UIImage(named: "juice-gray")!),
    Tag(id: 20, name: "Coffee & Tea", image: UIImage(named: "coffee")!, grayImage: UIImage(named: "coffee-gray")!),
    //Diets
    Tag(id: 21, name: "Vegan", image: UIImage(named: "vegan")!, grayImage: UIImage(named: "vegan-gray")!),
    Tag(id: 22, name: "Vegetarian", image: UIImage(named: "vegetarian")!, grayImage: UIImage(named: "vegetarian-gray")!),
    Tag(id: 23, name: "Gluten-Free", image: UIImage(named: "gluten-free")!, grayImage: UIImage(named: "gluten-free-gray")!),
    //Occasions
    Tag(id: 24, name: "Fine Dining", image: UIImage(named: "fine-dining")!, grayImage: UIImage(named: "fine-dining-gray")!),
    Tag(id: 25, name: "Casual", image: UIImage(named: "casual")!, grayImage: UIImage(named: "casual-gray")!),
    Tag(id: 26, name: "Family Style", image: UIImage(named: "family-style")!, grayImage: UIImage(named: "family-style-gray")!),
    Tag(id: 27, name: "Date Night", image: UIImage(named: "date-night")!, grayImage: UIImage(named: "date-night-gray")!),
    Tag(id: 28, name: "Drinks", image: UIImage(named: "drinks")!, grayImage: UIImage(named: "drinks-gray")!),
    Tag(id: 29, name: "Night-out", image: UIImage(named: "night-out")!, grayImage: UIImage(named: "night-out-gray")!),
    
    //Extra Diet
    Tag(id: 30, name: "Vegan/Vegetarian", image: UIImage(named: "vegan")!, grayImage: UIImage(named: "vegan-gray")!),
    
    //Extra Cuisines
    Tag(id: 31, name: "Healthy", image: UIImage(named: "healthy")!, grayImage: UIImage(named: "healthy-gray")!),
    
    //Extra Meal
    Tag(id: 32, name: "Late Night", image: UIImage(named: "late-night")!, grayImage: UIImage(named: "late-night-gray")!),
    
    //Extra Occasions
    Tag(id: 33, name: "Upscale", image: UIImage(named: "upscale")!, grayImage: UIImage(named: "upscale-gray")!),
    Tag(id: 34, name: "Happy Hour", image: UIImage(named: "happy-hour")!, grayImage: UIImage(named: "happy-hour-gray")!),
    Tag(id: 35, name: "Good for groups", image: UIImage(named: "good-for-groups")!, grayImage: UIImage(named: "good-for-groups-gray")!),
    Tag(id: 36, name: "Party Scene", image: UIImage(named: "party-scene")!, grayImage: UIImage(named: "party-scene-gray")!)
]

var allTags = cusinesTags + dietsTags + occasionsTags + mealsTags

var selectedBusiness : ClaimModel!

var mealsTags = [
    globalTags[0],
    globalTags[1],
    globalTags[2],
    globalTags[3],
    globalTags[31]
]

var cusinesTags = [
    globalTags[4],
    globalTags[5],
    globalTags[9],
    globalTags[10],
    globalTags[30],
    globalTags[8],
    globalTags[11],
    globalTags[6],
    globalTags[12],
    globalTags[13],
    globalTags[15],
    globalTags[7]
]


var dietsTags = [
    globalTags[29],
    globalTags[22]
]

var occasionsTags = [
    globalTags[32],
    globalTags[26],
    globalTags[33],
    globalTags[34],
    globalTags[35],
    globalTags[27]
]

var globalHoursTags = [
    //Meals
    Tag(id: 1, name: "Image1", image: UIImage(named: "addMediaImage")!, grayImage: UIImage(named: "breakfast-gray")!),
    Tag(id: 2, name: "Image2", image: UIImage(named: "addMediaImage")!, grayImage: UIImage(named: "brunch-gray")!),
    Tag(id: 3, name: "Image3", image: UIImage(named: "addMediaImage")!, grayImage: UIImage(named: "lunch-gray")!),
    Tag(id: 4, name: "Image4", image: UIImage(named: "addMediaImage")!, grayImage: UIImage(named: "dinner-gray")!),
    Tag(id: 5, name: "Image5", image: UIImage(named: "addMediaImage")!, grayImage: UIImage(named: "dinner-gray")!),
    Tag(id: 6, name: "Image6", image: UIImage(named: "addMediaImage")!, grayImage: UIImage(named: "breakfast-gray")!),
    Tag(id: 7, name: "Image7", image: UIImage(named: "addMediaImage")!, grayImage: UIImage(named: "brunch-gray")!),
    Tag(id: 8, name: "Image8", image: UIImage(named: "addMediaImage")!, grayImage: UIImage(named: "lunch-gray")!),
    Tag(id: 9, name: "Image9", image: UIImage(named: "addMediaImage")!, grayImage: UIImage(named: "dinner-gray")!),
    Tag(id: 10, name: "Image10", image: UIImage(named: "addMediaImage")!, grayImage: UIImage(named: "dinner-gray")!),
    Tag(id: 11, name: "Image11", image: UIImage(named: "addMediaImage")!, grayImage: UIImage(named: "breakfast-gray")!),
    Tag(id: 12, name: "Image12", image: UIImage(named: "addMediaImage")!, grayImage: UIImage(named: "brunch-gray")!),
    Tag(id: 13, name: "Image13", image: UIImage(named: "addMediaImage")!, grayImage: UIImage(named: "lunch-gray")!),
    Tag(id: 14, name: "Image14", image: UIImage(named: "addMediaImage")!, grayImage: UIImage(named: "dinner-gray")!),
    Tag(id: 15, name: "Image15", image: UIImage(named: "addMediaImage")!, grayImage: UIImage(named: "dinner-gray")!)
]
var coverPhotoTags = [
    globalHoursTags[0],
    globalHoursTags[1],
    globalHoursTags[2],
    globalHoursTags[3],
    globalHoursTags[4]
]
var menuTags = [
    globalHoursTags[5],
    globalHoursTags[6],
    globalHoursTags[7],
    globalHoursTags[8],
    globalHoursTags[9]
]
var imagesTags = [
    globalHoursTags[10],
    globalHoursTags[11],
    globalHoursTags[12],
    globalHoursTags[13],
    globalHoursTags[14]
]

func getTagFromInt(id : Int) -> Tag? {
    return globalTags.filter { (t) -> Bool in
        return t.id == id
    }.first
}

let colors = [
	UIColor(rgb: 0xE74C3C),
	UIColor(rgb: 0xA569BD),
	UIColor(rgb: 0x5499C7),
	UIColor(rgb: 0x48C9B0),
	UIColor(rgb: 0xF4D03F),
	UIColor(rgb: 0x34495E),
	UIColor(rgb: 0xb71c1c),
	UIColor(rgb: 0xc2185b),
	UIColor(rgb: 0x8e24aa),
	UIColor(rgb: 0x651fff),
	UIColor(rgb: 0x0091ea),
	UIColor(rgb: 0x64ffda)
]

let pieChartColors = [
   
    UIColor(red: 251.0/255.0, green: 117.0/255.0, blue: 147.0/255.0, alpha: 1.0),
    UIColor(red: 255.0/255.0, green: 185.0/255.0, blue: 94.0/255.0, alpha: 1.0),
    UIColor(red: 156.0/255.0, green: 143.0/255.0, blue: 254.0/255.0, alpha: 1.0),
    UIColor(red: 47.0/255.0, green: 197.0/255.0, blue: 197.0/255.0, alpha: 1.0)
    

]

var recents = [RecentPlace]()

func saveRecents(){
    let placesArray = recents
    do {
        let placesData = try NSKeyedArchiver.archivedData(withRootObject: placesArray, requiringSecureCoding: false)
        UserDefaults.standard.set(placesData, forKey: "places")
    } catch let error {
        print(error)
    }
}

func loadRecents(){
    let placesData = UserDefaults.standard.object(forKey: "places") as? Data

    if let placesData = placesData {
        do {
            let placesArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(placesData) as? [RecentPlace]
             recents = placesArray ?? [RecentPlace]()
        } catch _ {
            print("Error")
        }
    }
}

func getVisiblVc() -> UIViewController? {
	var currentVc = UIApplication.shared.keyWindow?.rootViewController
	while let presentedVc = currentVc?.presentedViewController {
		if let navVc = (presentedVc as? UINavigationController)?.viewControllers.last {
			currentVc = navVc
		} else if let tabVc = (presentedVc as? UITabBarController)?.selectedViewController {
			currentVc = tabVc
		} else {
			currentVc = presentedVc
		}
	}
	return currentVc
}


//func getCityNameOfLocation(lat : Double , lon : Double,completion: @escaping (String) -> ()){
//    let location: CLLocation = CLLocation(latitude: lat, longitude: lon)
//    let geoCoder = CLGeocoder()
//    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) in
//        if let placemarks = placemarks {
//            let p: CLPlacemark = placemarks[0]
//            let (cityName, address) = p.getCityNameAndAddress()
//            completion(cityName)
//        } else {
//            print("Reverse geocoding failed\(error!)")
//            completion("")
//        }
//    })
//}

func emptySpotSaveModel() -> SpotSaveModel{
	return SpotSaveModel(id: "", createdAt: nil, user: emptyUserModel(), spot: emptySpotModel(), description: "", tags: [], commentCount: 0, likeCount: 0, favoriteDishes: [])
}

func emptySpotModel() -> SpotModel{
    return SpotModel(id: "", name: "", photoUrl: "", address: "", lat: 0.0, lon: 0.0, phoneNumber: "", googlePlaceId: "", city: "")
}

func emptyUserModel() -> UserModel{
    return UserModel(id: "", username: "", fullname: "", pictureUrl: "", userBio: "", spotCount: 0, followerCount: 0, followingCount: 0)
}


extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
        
    }

}

extension UIScrollView {
	var currentPage: Int {
		return Int(self.contentOffset.x) / Int(self.frame.width)
	}
}

extension CALayer {
	
  func applySketchShadow(
	color: UIColor = .black,
	alpha: Float = 0.5,
	x: CGFloat = 0,
	y: CGFloat = 2,
	blur: CGFloat = 4,
	spread: CGFloat = 0)
  {
	masksToBounds = false
	shadowColor = color.cgColor
	shadowOpacity = alpha
	shadowOffset = CGSize(width: x, height: y)
	shadowRadius = blur / 2.0
	if spread == 0 {
	  shadowPath = nil
	} else {
	  let dx = -spread
	  let rect = bounds.insetBy(dx: dx, dy: dx)
	  shadowPath = UIBezierPath(rect: rect).cgPath
	}
  }
	
}

extension UILabel {

    func setLineHeightMultiple(to height: CGFloat, withAttributedText attributedText: NSMutableAttributedString) {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = height
        paragraphStyle.alignment = textAlignment

        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length - 1))

        self.attributedText = attributedText
    }
}
