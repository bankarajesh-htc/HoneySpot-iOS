//
//  ProfileSpotMapViewController.swift
//  HoneySpot
//
//  Created by Max on 2/18/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import MapKit
 

class ProfileSpotMapViewController: UIViewController, MKMapViewDelegate {

    static let STORYBOARD_IDENTIFIER = "ProfileSpotMapViewController"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var restaurantInfoContainerView: UIView!
    @IBOutlet weak var openMapContainerView: UIView!
    @IBOutlet weak var spotImageView: UIImageView!
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var spotNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
//    var targetUser: User? // Spot
    var userId = ""
    var spotSaveModels = [SpotSaveModel]()
    var cityModels = [CitySaveModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restaurantInfoContainerView.isHidden = true
        openMapContainerView.isHidden = true
        
        
        if AppDelegate.originalDelegate.isGuestLogin {
            
            if AppDelegate.originalDelegate.isFeedProfile {
                
                showLoadingHud()
                DispatchQueue.global().async {
                    
                    ProfileDataSource().getGuestUserLastSaves(userId: self.userId) { (result) in
                        self.hideAllHuds()
                        switch(result){
                        case .success(let spotsaves):
                            DispatchQueue.main.async
                            {
                                self.spotSaveModels = spotsaves
                                self.initialize()
                            }
                        case .failure(let err):
                            print(err.errorMessage)
                        }
                    }
                    
                }
            }
        }
        else
        {
            showLoadingHud()
            DispatchQueue.global().async {
                
                ProfileDataSource().getUserLastSaves(userId: self.userId) { (result) in
                    self.hideAllHuds()
                    switch(result){
                    case .success(let spotsaves):
                        DispatchQueue.main.async
                        {
                            self.spotSaveModels = spotsaves
                            self.initialize()
                        }
                    case .failure(let err):
                        print(err.errorMessage)
                    }
                }
                
            }
            
        }
        
    }

    func initialize() {
        self.view.isUserInteractionEnabled = false
        var annotationsToAdd: [SpotAnnotation] = []
        for s in spotSaveModels {
            let sa: SpotAnnotation = SpotAnnotation(spotSaveModel: s)
            annotationsToAdd.append(sa)
        }
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(annotationsToAdd)
        self.mapView.showAnnotations(annotationsToAdd, animated: false)
        
        self.mapView.fitAll()
        self.view.isUserInteractionEnabled = true
    }
    
    @IBAction func onOpenMapButtonTap(_ sender: Any) {
        restaurantInfoContainerView.isHidden = true
        openMapContainerView.isHidden = true
    }
    
    @IBAction func onDeleteButtonTap(_ sender: Any) {
    }
    
    @IBAction func onBackButtonTap(_ sender: Any) {
            let parentVC: ProfileViewController = self.parent as! ProfileViewController
            parentVC.mapDrilldownBack()
    }
    
    @IBAction func onBackToGridView(_ sender: Any) {
        let parentVC: ProfileViewController = self.parent as! ProfileViewController
        parentVC.mapDrilldownBack()
    }
    
    // MARK: - Map Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let v = SpotAnnotationView(annotation: annotation, reuseIdentifier: SpotAnnotationView.SPOT_ANNOTATION_VIEW_REUSE_IDENTIFICATION)
        v.annotation = annotation
        return v
        
//        let v: SpotAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: SpotAnnotationView.SPOT_ANNOTATION_VIEW_REUSE_IDENTIFICATION) as? SpotAnnotationView
//        if let sav = v {
//            sav.annotation = annotation
//            return sav
//        } else {
//            v?.annotation = annotation
//           // v = SpotAnnotationView(annotation: annotation, reuseIdentifier: SpotAnnotationView.SPOT_ANNOTATION_VIEW_REUSE_IDENTIFICATION)
//            return v
//        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    }
}

extension MKMapView {
    /// when we call this function, we have already added the annotations to the map, and just want all of them to be displayed.
    func fitAll() {
        var zoomRect            = MKMapRect.null;
        for annotation in annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect       = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01);
            zoomRect            = zoomRect.union(pointRect);
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }
    
    /// we call this function and give it the annotations we want added to the map. we display the annotations if necessary
    func fitAll(in annotations: [MKAnnotation], andShow show: Bool) {
        var zoomRect:MKMapRect  = MKMapRect.null
        
        for annotation in annotations {
            let aPoint          = MKMapPoint(annotation.coordinate)
            let rect            = MKMapRect(x: aPoint.x, y: aPoint.y, width: 0.1, height: 0.1)
            
            if zoomRect.isNull {
                zoomRect = rect
            } else {
                zoomRect = zoomRect.union(rect)
            }
        }
        if (show) {
            addAnnotations(annotations)
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }
    
}
