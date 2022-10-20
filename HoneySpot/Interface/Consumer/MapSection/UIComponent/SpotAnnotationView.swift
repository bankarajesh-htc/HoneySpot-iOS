//
//  SpotAnnotationView.swift
//  HoneySpot
//
//  Created by Max on 2/15/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import MapKit

class SpotAnnotationView: MKAnnotationView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var logoContainerView: UIView = UIView()
    var centerImageView: UIImageView = UIImageView()
    var countLabel: UILabel = UILabel()
//    var savedFriendsCount: Int = 0 {
//        didSet {
//            self.countLabel.text = String(format: "%d", savedFriendsCount)
//        }
//    }
    
    static let SPOT_ANNOTATION_VIEW_REUSE_IDENTIFICATION = "SpotAnnotationView"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        //clusteringIdentifier = SpotClusterView.SPOT_CLUSTER_VIEW_REUSE_IDENTIFICATION
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    func sharedInit() {
        logoContainerView.removeFromSuperview()
        centerImageView.removeFromSuperview()
        
        canShowCallout = false
        frame = CGRect(x: 0, y: 0, width: 42, height: 47)
        backgroundColor = UIColor.clear
        
        logoContainerView.frame = CGRect(x: 0, y: 0, width: 42, height: 47)
        addSubview(logoContainerView)

        centerImageView.frame = CGRect(x: 0, y: 0, width: 42, height: 47)
        centerImageView.center = logoContainerView.center
        centerImageView.frame.origin.y = (logoContainerView.frame.size.height - centerImageView.frame.size.width) / 2
        centerImageView.backgroundColor = UIColor.clear
        centerImageView.contentMode = .scaleAspectFit
        centerImageView.image = UIImage(named: "annotationImage")
        logoContainerView.addSubview(centerImageView)
        
        self.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if AppDelegate.originalDelegate.isGuestLogin {
            
        }
        else
        {
            
        }
        
        if(selected){
            centerImageView.image = UIImage(named: "annotationSelectedImage")
        }else{
            centerImageView.image = UIImage(named: "annotationImage")
        }
    }
}
