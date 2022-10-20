//
//  AppDelegate.swift
//  HoneySpot
//
//  Created by Max on 2/7/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
 
import IQKeyboardManagerSwift
import FBSDKCoreKit
import OneSignal
import Amplitude_iOS
import Fabric
import Crashlytics
import GoogleSignIn
import Branch
import TwitterKit
import AWSS3
import Firebase
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    static var originalDelegate : AppDelegate!
    var openFeedDetailPage = false
    var spotId = ""
    
    var isLogout = false
    var isMap = false
    var isSameProfile = false
    var isFeedProfile = false
    var isFree = true
    var isAdminLogin = false
    var isGuestLogin = true
    var isSignUp = false
    var isConsumerSwitch = true
    var isBusinessSwitch = true
    var isEditProfile = false
    var isWishlist = false
    var isSaveToTry = false
    var isSettings = false
    var isLogin = false
    
    var honeyspots : Int = 0
    var newrequests : Int = 0
    var approved : Int = 0
    var rejected : Int = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        
        AppDelegate.originalDelegate = self
        application.registerForRemoteNotifications()
		
		FirebaseApp.configure()
        
        //Amplitude
        Amplitude.instance()?.initializeApiKey("aea5bde61480328ac38d55a7cc295280")
        Amplitude.instance().trackingSessionEvents = true
        
        //Google Sign Inc
        GIDSignIn.sharedInstance().clientID = "354455822018-8p4a7e9v65f19eg0nvpi0ttst58ddsmh.apps.googleusercontent.com"
        
        // IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        
        // Register PFObjects
        //TokenStorage.registerSubclass()
        
        // Parse Initialization
//        Parse.enableLocalDatastore()
//        let parseConfig = ParseClientConfiguration {
//            $0.applicationId = .PARSE_APPLICATION_ID
//            $0.clientKey = .PARSE_CLIENT_KEY
//            $0.server = .PARSE_SERVER
//        }
//        Parse.initialize(with: parseConfig)
        
        //checkUser()
        
        // Facebook Initialization
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Twitter
        TWTRTwitter.sharedInstance().start(withConsumerKey:"hTpkPVU4pThkM0", consumerSecret:"ovEqziMzLpUOF163Qg2mj")
        
        //Branch Deeplink
        let branch: Branch = Branch.getInstance()!
        branch.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {params, error in
            if error == nil {
                // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
                // params will be empty if no data found
                // ... insert custom logic here ...
                print("params: %@", params as? [String: AnyObject] ?? {})
                
                let title = (params?["$marketing_title"]) as? String
                if title  == "Test"{
                    if let refId = (params?["$custom_data"]) {
                                /// ******** handle deep linking here *********
                        self.spotId = refId as! String
                        let dataDict:[String: String] = ["spotId": self.spotId]
                        self.openFeedDetailPage = true
                        NotificationCenter.default.post(name: NSNotification.Name.init("DeepLinkData"), object: nil,userInfo: dataDict)
                        //HSAlertView.showAlert(withTitle: "HoneySpot", message: refId as! String)
                        print(refId)
                    }
                }
                else if title  == "city"
                {
                    if let refId = (params?["$custom_data"])
                    {
                        let city = refId as! String
                        let dataDict:[String: String] = ["cityName": city]
                        self.openFeedDetailPage = true
                        NotificationCenter.default.post(name: NSNotification.Name.init("DeepLinkCityData"), object: nil,userInfo: dataDict)
                        //HSAlertView.showAlert(withTitle: "HoneySpot", message: refId as! String)
                        print(refId)
                    }
                }
                else if title  == "Profile"
                {
                    if let refId = (params?["$custom_data"])
                    {
                        let userId = refId as! String
                        let dataDict:[String: String] = ["userId": userId]
                        NotificationCenter.default.post(name: NSNotification.Name.init("DeepLinkProfileData"), object: nil,userInfo: dataDict)
                        //HSAlertView.showAlert(withTitle: "HoneySpot", message: refId as! String)
                        print(refId)
                    }
                }
                else if title  == "Spot"
                {
                    if let refId = (params?["$custom_data"]) {
                                /// ******** handle deep linking here *********
                        self.spotId = refId as! String
                        let dataDict:[String: String] = ["spotId": self.spotId]
                        self.openFeedDetailPage = true
                        NotificationCenter.default.post(name: NSNotification.Name.init("DeepLinkData"), object: nil,userInfo: dataDict)
                        //HSAlertView.showAlert(withTitle: "HoneySpot", message: refId as! String)
                        print(refId)
                    }
                }
                
            }
        })

        // OneSignal
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: .ONESIGNAL_APP_ID,
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        // Fabric & Crashlytics
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    func checkUser(){
        // Decide Root View Controller
        let authToken = UserDefaults.standard.string(forKey: "authToken")
        if (authToken == nil || authToken == "") {
            // show login page if user is not logged in
            if AppDelegate.originalDelegate.isGuestLogin && !AppDelegate.originalDelegate.isLogin {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
                //self.performSegue(withIdentifier: "main", sender: nil)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
                (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginNavController)
                //self.performSegue(withIdentifier: "login", sender: nil)
            }
            
        } else {
            if(UserDefaults.standard.bool(forKey: "isBusiness")){
                BusinessRestaurantDataSource().getClaims { (result) in
                    switch(result){
                    case .success(let claims):
                        if(claims.count > 0){
                            var isVerified = false
                            for c in claims {
                                if(c.isVerified){
                                    isVerified = true
                                }
                            }
                            if(isVerified){
                               // self.performSegue(withIdentifier: "businessMain", sender: nil)
                            }else{
                               // self.performSegue(withIdentifier: "verification", sender: nil)
                            }
                        }else{
                           // self.performSegue(withIdentifier: "login", sender: nil)
                        }
                    case .failure(let err):
                        print(err.localizedDescription)
                       // self.performSegue(withIdentifier: "login", sender: nil)
                    }
                }
            }
            else{
                AppDelegate.originalDelegate.isGuestLogin = false
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
                //self.performSegue(withIdentifier: "main", sender: nil)
                //self.performSegue(withIdentifier: "main", sender: nil)
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }

        window.rootViewController = vc

        // add animation
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionFlipFromLeft],
                          animations: nil,
                          completion: nil)

    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        if(GIDSignIn.sharedInstance().handle(url)){
            return true
        }else if(ApplicationDelegate.shared.application(app, open: url, options: options)){
            return true
        }else if(Branch.getInstance()?.application(app, open: url, options: options) ?? false){
            return true
        }else if(TWTRTwitter.sharedInstance().application(app, open: url, options: options)){
            return true
        }

        return false
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        AWSS3TransferUtility.interceptApplication(application,
        handleEventsForBackgroundURLSession: identifier,
        completionHandler: completionHandler)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        Branch.getInstance()?.continue(userActivity)
        print("Continue User Activity called: ")
            if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
                let url = userActivity.webpageURL!
                print(url.absoluteString)
                //handle url and open whatever page you want to open.
            }
        return true
    }
    
    func appUpdateAvailable() -> Bool
    {
        let storeInfoURL: String = "https://itunes.apple.com/us/lookup?bundleId=com.honeyspot.app"
        var upgradeAvailable = false
        // Get the main bundle of the app so that we can determine the app's version number
        let bundle = Bundle.main
        if let infoDictionary = bundle.infoDictionary {
            // The URL for this app on the iTunes store uses the Apple ID for the  This never changes, so it is a constant
            let urlOnAppStore = URL(string: storeInfoURL)
            if let dataInJSON = try? Data(contentsOf: urlOnAppStore!) {
                // Try to deserialize the JSON that we got
                print(dataInJSON)
                if let dict: NSDictionary = try! JSONSerialization.jsonObject(with: dataInJSON, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject] as NSDictionary? {
                    print(dict)
                    if let results:NSArray = dict["results"] as? NSArray {
                        if let version = (results[0] as AnyObject).value(forKey: "version") as? String {
                            // Get the version number of the current version installed on device
                            if let currentVersion = infoDictionary["CFBundleShortVersionString"] as? String {
                                // Check if they are the same. If not, an upgrade is available.
                                let appStoreVersion = Int(version.replacingOccurrences(of: ".", with: ""))
                                let cV = Int(currentVersion.replacingOccurrences(of: ".", with: ""))
                                if appStoreVersion! > cV! {
                                    upgradeAvailable = true
                                }
                            }
                        }
                    }
                }
            }
        }
        return upgradeAvailable
    }


}
extension AppDelegate
{
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    
        
//        let viewController = GlobalFunctions.getWindowRootController()
//        let alert = UIAlertController(title: "Device Token", message: token, preferredStyle: .alert)
//        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//        viewController.present(alert, animated: true, completion: nil)
    }
    

    func application(_ application: UIApplication,didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
//        let viewController = GlobalFunctions.getWindowRootController()
//        let alert = UIAlertController(title: "Device Token Failer", message: "Failer", preferredStyle: .alert)
//        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//        viewController.present(alert, animated: true, completion: nil)
    }
    
    func registerForPushNotifications() {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) {
          [weak self] granted, error in
          print("Permission granted: \(granted)")
          guard granted else { return }
          self?.getNotificationSettings()
      }
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
        }
    }
    
}

