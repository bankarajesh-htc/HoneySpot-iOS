//
//  OnboardingViewController.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 4.05.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        self.currentPage += 1
        if self.currentPage > 2 {
            self.currentPage -= 1
            finishOnboarding()
        }
        self.onboardingCollectionView.scrollToItem(at: IndexPath(row: self.currentPage, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        self.checkPage()
    }
    
    func checkPage() {
        self.pageControl.currentPage = self.currentPage
        if self.currentPage == 2 {
            self.nextButton.setTitle("Get Started", for: .normal)
        } else {
            self.nextButton.setTitle("Next", for: .normal)
        }
    }
    
    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "isOnboardingShown")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
       // UIViewController.APP_DELEGATE_INSTANCE.window?.rootViewController = .MAIN_VIEWCONTROLLER
    }

}

extension OnboardingViewController :  UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        self.checkPage()
    }
    
}

extension OnboardingViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.CELL_IDENTIFIER, for: indexPath) as! OnboardingCollectionViewCell
        
        switch indexPath.row {
        case 0:
            cell.img.image = UIImage(named: "onboarding1Screenshot")
            cell.titleLabel.text = "Welcome to HoneySpot!"
            cell.descriptionLabel.text = "Share your recommendations"
            cell.messageLabel.text = "Create your profile with your favorite restaurants around the world."
        case 1:
            cell.img.image = UIImage(named: "onboarding2Screenshot")
            cell.titleLabel.text = "Connect with friends"
            cell.descriptionLabel.text = "Honeypot is better with friends"
            cell.messageLabel.text = "Follow your friends and foodies you trust to see their favorite restaurants around the world"
        case 2:
            cell.img.image = UIImage(named: "onboarding3Screenshot")
            cell.titleLabel.text = "Find a spot"
            cell.descriptionLabel.text = "Know where to go"
            cell.messageLabel.text = "Check the map for friend recommended spots around you or in any destination"
        default:
            break
        }
        
        return cell
    }

}

extension OnboardingViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}

