//
//  UIViewController+Constants.swift
//  HoneySpot
//
//  Created by Max on 2/8/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

extension UIViewController {
    // MARK: - AppDelegate
    static var APP_DELEGATE_INSTANCE:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // MARK: - ViewControllers
    // Main Storyboard
    static let MAIN_VIEWCONTROLLER: MainTabBarController = UIStoryboard(name: .STORYBOARD_MAIN, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_MAIN_TABBARCONTROLLER) as! MainTabBarController
    
    static let FIRST_LOGINCONTROLLER: FirstLoadingViewController = UIStoryboard(name: .STORYBOARD_MAIN, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_FIRST_LOGINCONTROLLER) as! FirstLoadingViewController
    // Login Storyboard 
    static let ROOT_LOGIN_NAVIGATIONCONTROLLER: UINavigationController = UIStoryboard(name: .STORYBOARD_MAIN, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_ROOTLOGIN_NAVIGATIONCONTROLLER) as! UINavigationController
    static let LOGIN_NAVIGATIONCONTROLLER: UINavigationController = UIStoryboard(name: .STORYBOARD_LOGIN, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_LOGIN_NAVIGATIONCONTROLLER) as! UINavigationController
    static let BUSINESS_LOGIN_NAVIGATIONCONTROLLER: UINavigationController = UIStoryboard(name: .STORYBOARD_LOGIN, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_BUSINESS_LOGIN_VIEWCONTROLLER) as! UINavigationController
    
    func LoginViewControllerInstance() -> LoginViewController {
        return UIStoryboard(name: .STORYBOARD_LOGIN, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_LOGIN_VIEWCONTROLLER) as! LoginViewController
    }
//    func FollowSocialAccountFriendsViewControllerInstance() -> FollowSocialAccountFriendsViewController {
//        return UIStoryboard(name: .STORYBOARD_LOGIN, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_FOLLOWSOCIALCCOUNTFRIENDS_VIEWCONTROLLER) as! FollowSocialAccountFriendsViewController
//    }
    func InstagramAuthViewControllerInstance() -> InstagramAuthViewController {
        return UIStoryboard(name: .STORYBOARD_LOGIN, bundle: Bundle.main).instantiateViewController(withIdentifier: InstagramAuthViewController.STORYBOARD_IDENTIFIER) as! InstagramAuthViewController
    }
    func SignupViewControllerInstance() -> SignupViewController {
        return UIStoryboard(name: .STORYBOARD_LOGIN, bundle: Bundle.main).instantiateViewController(withIdentifier: SignupViewController.STORYBOARD_IDENTIFIER) as! SignupViewController
    }
    func ForgotPasswordViewControllerInstance() -> ForgotPasswordViewController {
        return UIStoryboard(name: .STORYBOARD_LOGIN, bundle: Bundle.main).instantiateViewController(withIdentifier: ForgotPasswordViewController.STORYBOARD_IDENTIFIER) as! ForgotPasswordViewController
    }
    
    // Profile Storyboard
    func ProfileViewControllerInstance() -> ProfileViewController {
        return UIStoryboard(name: .STORYBOARD_PROFILE, bundle: Bundle.main).instantiateViewController(withIdentifier: ProfileViewController.STORYBOARD_IDENTIFIER) as! ProfileViewController
    }
//    static let PROFILE_SPOTS_SUB_VIEWCONTROLLER: ProfileSpotsSubViewController = UIStoryboard(name: .STORYBOARD_PROFILE, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_PROFILE_SPOTS_SUB_VIEWCONTROLLER) as! ProfileSpotsSubViewController
    func ProfileSpotsSubViewControllerInstance() -> ProfileSpotsSubViewController {
        return UIStoryboard(name: .STORYBOARD_PROFILE, bundle: Bundle.main).instantiateViewController(withIdentifier: ProfileSpotsSubViewController.STORYBOARD_IDENTIFIER) as! ProfileSpotsSubViewController
    }
    func ProfileSpotMapViewControllerInstance() -> ProfileSpotMapViewController {
        return UIStoryboard(name: .STORYBOARD_PROFILE, bundle: Bundle.main).instantiateViewController(withIdentifier: ProfileSpotMapViewController.STORYBOARD_IDENTIFIER) as! ProfileSpotMapViewController
    }
//    static let PROFILE_SETTINGS_SUB_VIEWCONTROLLER: ProfileSettingsSubViewController = UIStoryboard(name: .STORYBOARD_PROFILE, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_PROFILE_SETTINGS_SUB_VIEWCONTROLLER) as! ProfileSettingsSubViewController
    func ProfileSettingsSubViewControllerInstance() -> ProfileSettingsSubViewController {
        return UIStoryboard(name: .STORYBOARD_PROFILE, bundle: Bundle.main).instantiateViewController(withIdentifier: ProfileSettingsSubViewController.STORYBOARD_IDENTIFIER) as! ProfileSettingsSubViewController
    }
//    static let PROFILE_CONTACTS_VIEWCONTROLLER: ProfileContactsViewController = UIStoryboard(name: .STORYBOARD_PROFILE, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_PROFILE_CONTACTS_VIEWCONTROLLER) as! ProfileContactsViewController
    func ProfileContactsViewControllerInstance() -> ProfileContactsViewController {
        return UIStoryboard(name: .STORYBOARD_PROFILE, bundle: Bundle.main).instantiateViewController(withIdentifier: ProfileContactsViewController.STORYBOARD_IDENTIFIER) as! ProfileContactsViewController
    }
//    static let PROFILE_EDIT_VIEWCONTROLLER: ProfileEditViewController = UIStoryboard(name: .STORYBOARD_PROFILE, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_PROFILE_EDIT_VIEWCONTROLLER) as! ProfileEditViewController
    func ProfileEditViewControllerInstance() -> ProfileEditViewController {
        return UIStoryboard(name: .STORYBOARD_PROFILE, bundle: Bundle.main).instantiateViewController(withIdentifier: ProfileEditViewController.STORYBOARD_IDENTIFIER) as! ProfileEditViewController
    }
    static let WEB_VIEWCONTROLLER: WebViewController = UIStoryboard(name: .STORYBOARD_PROFILE, bundle: Bundle.main).instantiateViewController(withIdentifier: WebViewController.STORYBOARD_IDENTIFIER) as! WebViewController
    func InviteFriendsViewControllerInstance() -> InviteFriendsViewController {
        return UIStoryboard(name: .STORYBOARD_PROFILE, bundle: Bundle.main).instantiateViewController(withIdentifier: InviteFriendsViewController.STORYBOARD_IDENTIFIER) as! InviteFriendsViewController
    }
    func WebViewControllerInstance() -> WebViewController {
        return UIStoryboard(name: .STORYBOARD_PROFILE, bundle: Bundle.main).instantiateViewController(withIdentifier: WebViewController.STORYBOARD_IDENTIFIER) as! WebViewController
    }
    func ProfileSettingsViewControllerInstance() -> ProfileSettingsViewController {
        return UIStoryboard(name: .STORYBOARD_PROFILE, bundle: Bundle.main).instantiateViewController(withIdentifier: ProfileSettingsViewController.STORYBOARD_IDENTIFIER) as! ProfileSettingsViewController
    }
    
    // AddSpot Storyboard
    static let ADD_SPOT_NAVIGATIONCONTROLLER: UINavigationController = UIStoryboard(name: .STORYBOARD_ADDSPOT, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_ADDSPOT_NAVIGATION_VIEWCONTROLLER) as! UINavigationController
    func AddSpotSearchViewControllerInstance() -> AddSpotSearchViewController {
        return UIStoryboard(name: .STORYBOARD_ADDSPOT, bundle: Bundle.main).instantiateViewController(withIdentifier: AddSpotSearchViewController.STORYBOARD_IDENTIFIER) as! AddSpotSearchViewController
    }
    func EditSpotViewControllerInstance() -> EditSpotViewController {
        return UIStoryboard(name: .STORYBOARD_ADDSPOT, bundle: Bundle.main).instantiateViewController(withIdentifier: EditSpotViewController.STORYBOARD_IDENTIFIER) as! EditSpotViewController
    }  
    
    // Search Storyboard
//    static let SEARCH_AUTOCOMPLETE_VIEWCONTROLLER: SearchAutocompleteViewController = UIStoryboard(name: .STORYBOARD_SEARCH, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_SEARCH_AUTOCOMPLETE_VIEWCONTROLLER) as! SearchAutocompleteViewController
    func SearchViewControllerInstance() -> SearchViewController {
        return UIStoryboard(name: .STORYBOARD_SEARCH, bundle: Bundle.main).instantiateViewController(withIdentifier: SearchViewController.STORYBOARD_IDENTIFIER) as! SearchViewController
    }
    func SearchTopRestaurantsViewControllerInstance() -> SearchTopRestaurantsViewController {
        return UIStoryboard(name: .STORYBOARD_SEARCH, bundle: Bundle.main).instantiateViewController(withIdentifier: SearchTopRestaurantsViewController.STORYBOARD_IDENTIFIER) as! SearchTopRestaurantsViewController
    }
    
    // Feed Storyboard
    func FeedViewControllerInstance() -> FeedViewViewController {
        return UIStoryboard(name: .STORYBOARD_FEED, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_FEED_VIEWCONTROLLER) as! FeedViewViewController
    }
    func SaveToTryViewControllerInstance() -> SaveToTryViewController {
        return UIStoryboard(name: .STORYBOARD_FEED, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_SAVE_VIEWCONTROLLER) as! SaveToTryViewController
    }
    func FeedFullPostViewControllerInstance() -> FeedFullPostViewController {
        return UIStoryboard(name: .STORYBOARD_FEED, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_FEED_FULLPOST_VIEWCONTROLLER) as! FeedFullPostViewController
    }
    func CommentsViewControllerInstance() -> CommentsViewController {
        return UIStoryboard(name: .STORYBOARD_FEED, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_COMMENTS_VIEWCONTROLLER) as! CommentsViewController
    }
    func LocationsViewControllerInstance() -> LocationsViewController {
        return UIStoryboard(name: .STORYBOARD_FEED, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_FEED_LOCATION_VIEWCONTROLLER) as! LocationsViewController
    }
    func AnnouncementViewControllerInstance() -> AnnouncementDetailViewController {
        return UIStoryboard(name: .STORYBOARD_ANNOUNCEMENT, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_ANNOUNCEMENT_VIEWCONTROLLER) as! AnnouncementDetailViewController
    }
    func AdminViewControllerInstance() -> AdminViewController {
        return UIStoryboard(name: .STORYBOARD_ADMIN, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_ADMIN_VIEWCONTROLLER) as! AdminViewController
    }
    func MasterViewControllerInstance() -> MasterViewController {
        return UIStoryboard(name: .STORYBOARD_SETTINGS, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_MASTER_VIEWCONTROLLER) as! MasterViewController
    }
    func DetailAdminViewControllerInstance() -> DetailAdminViewController {
        return UIStoryboard(name: .STORYBOARD_ADMIN, bundle: Bundle.main).instantiateViewController(withIdentifier: .IDENTIFIER_ADMIN_DETAILVIEWCONTROLLER) as! DetailAdminViewController
    }
    
    // MARK: - UtilityMethods
    func showLoadingHud() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
    }
    
    func showInformationHud(message: String) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = message
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3.0)
    }
    
    func showSuccessHud() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Success"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView.init()
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 1.0)
    }
    
    func showErrorHud(message: String = "Error") {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = message
        hud.indicatorView = JGProgressHUDErrorIndicatorView.init()
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 2.5)
    }
    
    func hideAllHuds() {
        let huds = JGProgressHUD.allProgressHUDs(inViewHierarchy: self.view)
        for hud: JGProgressHUD in huds {
            hud.dismiss(animated: true)
        }
    }
    
    func presentOnRoot(with viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        //navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.presentOverlayController(with: navigationController)
    }
    
    func presentOverlayController(with navigationController: UINavigationController) {
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navigationController.view.clipsToBounds = true
        self.present(navigationController, animated: false, completion: nil)
    }
    
//    func presentOverlayController(_ c: UIViewController, animated: Bool, fullscreen: Bool, completion: @escaping () -> Void, cancel: @escaping () -> Void) {
//        let present: (() -> Void) = {
//            AppManager.sharedInstance.currentOverlayController = c
//            var f: CGRect = c.view.frame
//            if (fullscreen) {
//                if UIScreen.main.bounds.size.height / UIScreen.main.bounds.size.width >= 896.0 / 414.0 {
//                    // If iphone x family
//                    f.size.height = self.view.bounds.size.height-84
//                } else {
//                    f.size.height = self.view.bounds.size.height-50
//                }
//            }
//
//            self.addChild(c)
//
//            if animated {
//                c.view.frame = CGRect(x: 0, y: -f.size.height, width: self.view.bounds.size.width, height: f.size.height)
//            } else {
//                c.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: f.size.height)
//            }
//            self.view.addSubview(c.view)
//            c.didMove(toParent: self)
//
//            if (animated) {
//                UIView.animate(withDuration: 0.3, animations: {
//                    c.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: f.size.height)
//                }, completion: { (finished: Bool) in
//                    completion()
//                })
//            } else {
//                completion()
//            }
//
////            if !fullscreen {
////                var h: CGFloat = self.view.bounds.size.height - f.size.height
////                self.overlayDismissButton = [UIButton new];
////                self.overlayDismissButton.frame = CGRectMake(0, f.size.height, self.window.rootViewController.view.bounds.size.width, h);
////                self.overlayDismissButton.backgroundColor = [UIColor clearColor];
////                [self.overlayDismissButton bk_addEventHandler:^(id sender) {
////                    [self dismissOverlayControllerAnimated:YES completion:cancel];
////                    } forControlEvents:UIControlEventTouchUpInside];
////                [self.window.rootViewController.view addSubview:self.overlayDismissButton];
////            }
//        }
//
//        if AppManager.sharedInstance.currentOverlayController != nil {
////            dismissOverlayControllerAnimated(animated, completion: present)
//        } else {
//            present()
//        }
//    }
}
