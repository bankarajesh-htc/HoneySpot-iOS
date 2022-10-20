//
//  MapViewController.swift
//  HoneySpot
//
//  Created by Max on 2/13/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import MapKit
import UPCarouselFlowLayout

protocol MapDelegate {
    func didInfoSheetMinimize()
    func didInfoSheetFullHeight()
    func didInfoSheetScrolled(transitionY : CGFloat)
    func didInfoSheetDetailTapped(spotSaveModel : SpotSaveModel)
    func didFilterChanged(filters : [Int])
}

protocol MapLocationChangeDelegate {
    func locationChanged(location : MapLocation)
    func locationChangedToCurrent()
}

class MapViewController: UIViewController, MKMapViewDelegate, CustomLocationServiceDelegate, UIGestureRecognizerDelegate,MapDelegate,MapLocationChangeDelegate {

    var isAnnotation = false
	@IBOutlet var currentCityLabel: UILabel!
	
	@IBOutlet weak var mapView: MKMapView!
    
	@IBOutlet var placesCollectionView: UICollectionView!
	@IBOutlet var filterCollectionView: UICollectionView!
	
    var currentFilters = [Int]()
    var isFirstLoad = false
	var annotations = [SpotAnnotation]()
    var initialSelectedIndexPath: IndexPath!
    
	override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }

        CustomLocationManager.sharedInstance.startUpdatingLocation()
        // Do any additional setup after loading the view.
        if AppDelegate.originalDelegate.isGuestLogin
        {
            
            initMapView()
            registerAnnotationViews()
        }
        else
        {
            initMapView()
            registerAnnotationViews()
        }
        isFirstLoad = true
        
        
        
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let observedObject = object as? UICollectionView, observedObject == self.placesCollectionView {
            print("collectionViewDidLoad")
            self.perform(#selector(self.reloadFirst), with: nil, afterDelay: 1.0)
            self.placesCollectionView?.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkData(_:)), name: NSNotification.Name.init("DeepLinkData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkCityData(_:)), name: NSNotification.Name.init("DeepLinkCityData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeepLinkProfileData(_:)), name: NSNotification.Name.init("DeepLinkProfileData"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            NotificationCenter.default.removeObserver(self)
        }
    
    @objc func showDeepLinkData(_ notification: NSNotification){
        
        print(notification.userInfo ?? "")
        let viewController = self.FeedFullPostViewControllerInstance()
                if let dict = notification.userInfo as NSDictionary? {
                    if let spotId = dict["spotId"] as? String{
                        viewController.spotSaveId = spotId
                    }
                }
        self.navigationController?.pushViewController(viewController, animated: true)
       
    }
    @objc func showDeepLinkCityData(_ notification: NSNotification){
        
        print(notification.userInfo ?? "")
        let viewController = self.SearchTopRestaurantsViewControllerInstance()
                if let dict = notification.userInfo as NSDictionary? {
                    if let cityName = dict["cityName"] as? String{
                        viewController.cityName = cityName
                    }
                }
       
        self.navigationController?.pushViewController(viewController, animated: true)
       
    }
    @objc func showDeepLinkProfileData(_ notification: NSNotification){
        
        print(notification.userInfo ?? "")
        let viewController = self.ProfileViewControllerInstance()
                if let dict = notification.userInfo as NSDictionary? {
                    if let profileId = dict["userId"] as? String{
                        viewController.profileId = profileId
                    }
                }
        viewController.isProfileDeepLinked = true
//        if AppDelegate.originalDelegate.isGuestLogin {
//            viewController.isProfileDeepLinked = true
//
//        }
       
        self.navigationController?.pushViewController(viewController, animated: true)
       
    }
    
    func configureStartLocation(){
        if (CLLocationManager.locationServicesEnabled())
        {
            //CustomLocationManager.sharedInstance.startUpdatingLocation()
//            var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
//			if(self.mapView.userLocation.coordinate.latitude == 0.0 || self.mapView.userLocation.coordinate.longitude == 0.0){
//				mapRegion.center = CLLocationCoordinate2D(latitude: 25.76167980, longitude: -80.19179020)
//                mapRegion.span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
//			}else{
//				mapRegion.center = self.mapView.userLocation.coordinate
//                mapRegion.span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
//			}
//
//            mapRegion.center = self.mapView.userLocation.coordinate
//            mapRegion.span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
//
//            self.mapView.setRegion(mapRegion, animated: true)
            
            locationChangedToCurrent()
        }else{
            var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
            mapRegion.center = CLLocationCoordinate2D(latitude: 25.76167980, longitude: -80.19179020)
            mapRegion.span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
            //self.currentCityLabel.text = "Miami"
            self.mapView.userTrackingMode = .follow
            self.mapView.setRegion(mapRegion, animated: true)
        }
        
    }
    func showAlert(title: String)  {
        
        let alert: UIAlertController = UIAlertController(
            title: title,
            message: "Sign in to make your opinion count",
            preferredStyle: .alert)
        
        //Add Buttons
        let yesButton: UIAlertAction = UIAlertAction(
            title: "SIGNIN",
            style: .default) { (action: UIAlertAction) in
            AppDelegate.originalDelegate.isLogin = true
            UIViewController.LOGIN_NAVIGATIONCONTROLLER.popToRootViewController(animated: false)
            UIViewController.APP_DELEGATE_INSTANCE.window?.rootViewController = .FIRST_LOGINCONTROLLER

        }
        
        let noButton: UIAlertAction = UIAlertAction(
            title: "CANCEL",
            style: .cancel) { (action: UIAlertAction) in
            
        }
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
        
    }
    deinit {
        annotations.removeAll()
    }
    
    // MARK: - Notification Handler
    @objc func handleGetFriendsFinished(_ notification: Notification?) {
        if notification?.name.rawValue == .NOTIFICATION_GETFRIENDS_FINISHED {
            loadSpotsForVisibleMapRegion()
        }
    }
    
    @objc func reloadFirst()
    {
        
        if self.isFirstLoad {

            self.showLoadingHud()
            let center = CGPoint(x: placesCollectionView.contentOffset.x + (placesCollectionView.frame.width / 2), y: (placesCollectionView.frame.height / 2))
            if let ip = self.placesCollectionView!.indexPathForItem(at: center) {
                
                if self.annotations.count > 0 && ip.row < self.annotations.count {

                    let currentAnnotation = self.annotations[ip.row]
                    self.mapView.selectAnnotation(currentAnnotation, animated: true)
                }
            }
            isFirstLoad = false
            self.hideAllHuds()
            
        }
        
        
    }
    
    
    
    func initMapView(){
        CustomLocationManager.sharedInstance.delegate = self
        mapView.delegate = self
        configureStartLocation()
    }

    func registerAnnotationViews(){
        self.mapView.register(SpotAnnotationView.self, forAnnotationViewWithReuseIdentifier: SpotAnnotationView.SPOT_ANNOTATION_VIEW_REUSE_IDENTIFICATION)
        //loadSpotsForVisibleMapRegion()
        //self.mapView.register(SpotClusterView.self, forAnnotationViewWithReuseIdentifier: SpotClusterView.SPOT_CLUSTER_VIEW_REUSE_IDENTIFICATION)
    }
    
    func locationUpdateDidFailWithError(error: Error) {
        print(error)
    }
    
    func locationDidUpdateToLocation(currentLocation: CLLocation) {
        if (CLLocationManager.locationServicesEnabled())
        {
            locationChangedToCurrent()
        }
    }
    
    @objc func loadSpotsForVisibleMapRegion() {
        if AppDelegate.originalDelegate.isGuestLogin
        {
            //initMapView()
            self.showLoadingHud()
            self.view.isUserInteractionEnabled = false
            let rect: MKMapRect = mapView.visibleMapRect
            let sw: CLLocationCoordinate2D = getSWCoordinate(rect)
            let ne: CLLocationCoordinate2D = getNECoordinate(rect)
            let NELat = Double(round(1000*ne.latitude)/1000)
            let NELon = Double(round(1000*ne.longitude)/1000)
            let SWLat = Double(round(1000*sw.latitude)/1000)
            let SWLon = Double(round(1000*sw.longitude)/1000)
            
                DispatchQueue.global().async {
                    MapDataSource().searchGuestMapPlaces(northEastLatitude: NELat, northEastLongtitude: NELon, southWestLatitude: SWLat, southWestLongtitude: SWLon, tags: self.currentFilters) { (result) in
                        switch(result){
                        case .success(let saves):

                            var annotationsToAdd: [SpotAnnotation] = []
                            var annotationsToRemove: [SpotAnnotation] = []
                           
                            
                            let annotations = self.mapView.annotations
                            
                            var mySpotSaves: [SpotSaveModel] = saves
                            
                            for annotation in annotations {
                                if !(annotation is SpotAnnotation) {
                                    continue
                                }
                                let sa = annotation as! SpotAnnotation
                                let foundSpotSave: SpotSaveModel? = saves.filter{ $0.id == sa.spotSaveModel?.id }.first
                                if foundSpotSave != nil {
                                    mySpotSaves.removeAll(where: { (spotSave: SpotSaveModel) -> Bool in
                                        return spotSave.id == foundSpotSave?.id
                                    })
                                } else {
                                    annotationsToRemove.append(sa)
                                }
                            }
                            
                            for s: SpotSaveModel in mySpotSaves {
                                let sa: SpotAnnotation = SpotAnnotation.init(spotSaveModel: s)
                                annotationsToAdd.append(sa)
                            }
                            
                            DispatchQueue.main.async
                            {
                                self.mapView.removeAnnotations(annotationsToRemove)
                                self.mapView.addAnnotations(annotationsToAdd)
                                self.annotations.removeAll()
                                for ann in self.mapView.annotations{
                                    if let annot = ann as? SpotAnnotation{
                                        self.annotations.append(annot)
                                    }
                                }
                                if self.annotations.count == 0 {
                                    self.placesCollectionView.isHidden = true
                                }
                                else
                                {
                                    self.placesCollectionView.isHidden = false
                                    self.placesCollectionView.reloadData()
                                    self.placesCollectionView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                                    
                                    
                                    //self.perform(#selector(self.reloadFirst), with: nil, afterDelay: 2.0)
                                   // self.placesCollectionView.selectItem(at: self.initialSelectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
//                                    let currentAnnotation = self.annotations[0]
//                                    self.mapView.selectAnnotation(currentAnnotation, animated: true)
                                }
                                self.hideAllHuds()
                                self.view.isUserInteractionEnabled = true
                                
                            }
                            
                            
                        case .failure(let err):
                            self.hideAllHuds()
                            print(err.errorMessage)
                        }
                    }
                
            }
            
        }
        else
        {
            self.showLoadingHud()
            self.view.isUserInteractionEnabled = false
            let rect: MKMapRect = mapView.visibleMapRect
            let sw: CLLocationCoordinate2D = getSWCoordinate(rect)
            let ne: CLLocationCoordinate2D = getNECoordinate(rect)
            let NELat = Double(round(1000*ne.latitude)/1000)
            let NELon = Double(round(1000*ne.longitude)/1000)
            let SWLat = Double(round(1000*sw.latitude)/1000)
            let SWLon = Double(round(1000*sw.longitude)/1000)
            
             DispatchQueue.global().async {
                    MapDataSource().searchMapPlaces(northEastLatitude: NELat, northEastLongtitude: NELon, southWestLatitude: SWLat, southWestLongtitude: SWLon, tags: self.currentFilters) { (result) in
                        switch(result){
                        case .success(let saves):
                            print("\(saves.count)")

                            var annotationsToAdd: [SpotAnnotation] = []
                            var annotationsToRemove: [SpotAnnotation] = []
                            let annotations = self.mapView.annotations
                            
                            var mySpotSaves: [SpotSaveModel] = saves
                            
                            for annotation in annotations {
                                if !(annotation is SpotAnnotation) {
                                    continue
                                }
                                let sa = annotation as! SpotAnnotation
                                let foundSpotSave: SpotSaveModel? = saves.filter{ $0.id == sa.spotSaveModel?.id }.first
                                if foundSpotSave != nil {
                                    mySpotSaves.removeAll(where: { (spotSave: SpotSaveModel) -> Bool in
                                        return spotSave.id == foundSpotSave?.id
                                    })
                                } else {
                                    annotationsToRemove.append(sa)
                                }
                            }
                            
                            for s: SpotSaveModel in mySpotSaves {
                                let sa: SpotAnnotation = SpotAnnotation.init(spotSaveModel: s)
                                annotationsToAdd.append(sa)
                            }
                            
                            DispatchQueue.main.async
                            {
                                self.mapView.removeAnnotations(annotationsToRemove)
                                self.mapView.addAnnotations(annotationsToAdd)
                                self.annotations.removeAll()
                                for ann in self.mapView.annotations{
                                    if let annot = ann as? SpotAnnotation{
                                        self.annotations.append(annot)
                                    }
                                }
                                if self.annotations.count == 0 {
                                    self.placesCollectionView.isHidden = true
                                }
                                else
                                {
                                    self.placesCollectionView.isHidden = false
                                    self.placesCollectionView.reloadData()
                                    self.placesCollectionView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                                    
                                    //self.perform(#selector(self.reloadFirst), with: nil, afterDelay: 2.0)
                                }
                                self.hideAllHuds()
                                self.view.isUserInteractionEnabled = true
                            }
                            
                            
                        case .failure(let err):
                            print(err.errorMessage)
                            self.hideAllHuds()
                        }
                    }
                }
        }
        
    }

    func getNECoordinate(_ mRect: MKMapRect) -> CLLocationCoordinate2D {
        return getCoordinateFromMapRectanglePoint(x: mRect.maxX, y: mRect.origin.y)
    }


    func getSWCoordinate(_ mRect: MKMapRect) -> CLLocationCoordinate2D {
        return getCoordinateFromMapRectanglePoint(x: mRect.origin.x, y: mRect.maxY)
    }

    func getCoordinateFromMapRectanglePoint(x: Double, y: Double) -> CLLocationCoordinate2D {
        return MKMapPoint.init(x: x, y: y).coordinate
    }

    // MARK: - Map View Delegate
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        print("Finsih Render Change")
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(loadSpotsForVisibleMapRegion), object: nil)
        self.showLoadingHud()
        self.perform(#selector(loadSpotsForVisibleMapRegion), with: nil, afterDelay: 0.2)
        print(mapView.region.span.latitudeDelta)
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("Will Change")
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("Did Change")
        if isAnnotation {
            
        }
        else
        {
            
        }
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let v = SpotAnnotationView(annotation: annotation, reuseIdentifier: SpotAnnotationView.SPOT_ANNOTATION_VIEW_REUSE_IDENTIFICATION)
        v.centerImageView.image = UIImage(named: "annotationImage")
        v.annotation = annotation
        return v
    }

    // MARK: - GestureRecognizer Delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is SpotAnnotationView)
    }
    
    
    @IBAction func didChangeLocationTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "mapToChangeLocation", sender: nil)
    }
    
    
    @IBAction func didFilterTapped(_ sender: Any) {
		self.performSegue(withIdentifier: "filter", sender: nil)
    }
    
    func didInfoSheetDetailTapped(spotSaveModel: SpotSaveModel) {
        let s: SpotSaveModel = spotSaveModel
        let viewController = self.FeedFullPostViewControllerInstance()
        viewController.spotSaveModel = s
        viewController.isComingFromMap = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func didLocateMeTapped(_ sender: Any) {
        DispatchQueue.main.async {
            CustomLocationManager.sharedInstance.startUpdatingLocation()
            var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
            mapRegion.center = self.mapView.userLocation.coordinate
            mapRegion.span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
            self.mapView.setRegion(mapRegion, animated: true)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //removeAllBottomSheets()
        if AppDelegate.originalDelegate.isGuestLogin {
            
           // self.showAlert(title: "Want to select annotations?")
        }
        else
        {
            
        }
        isAnnotation = true
        let span = MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 1.5)
        let region = MKCoordinateRegion(center: view.annotation!.coordinate, span: mapView.region.span)
        mapView.setRegion(region, animated: true)
        addNewBottomSheet(view : view)
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        isAnnotation = false
        //removeAllBottomSheets()
    }
    
    func addNewBottomSheet(view : MKAnnotationView) {
        

		guard let viewAnnotation = view.annotation as? SpotAnnotation else { return }
		
        let ssModel: SpotSaveModel = viewAnnotation.spotSaveModel!
		
		FeedDataSource().postAnalyticsData(spotId: ssModel.spot.id, eventName: "mapAnnotation")
		
		var counter = 0
		for ann in self.annotations{
			if(
				ssModel.id == ann.spotSaveModel?.id
			){
				self.placesCollectionView.scrollToItem(at: IndexPath(row: counter, section: 0), at: .centeredHorizontally, animated: true)
			}
            
			counter += 1
		}
		
    }
    
    func didInfoSheetMinimize() {
        //self.filterButtonBottomConstant.constant = 0
    }
    
    func didInfoSheetFullHeight() {
        //self.filterButtonBottomConstant.constant = 174
    }
    
    func didInfoSheetScrolled(transitionY : CGFloat) {
        print(transitionY)
        //self.filterButtonBottomConstant.constant = self.filterButtonBottomConstant.constant - transitionY
    }
    
    func didFilterChanged(filters : [Int]) {
        self.currentFilters = filters
		self.filterCollectionView.reloadData()
        loadSpotsForVisibleMapRegion()
    }
    
    func locationChanged(location: MapLocation) {
        
        var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
        mapRegion.center = location.location!.coordinate
        mapRegion.span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        self.mapView.setRegion(mapRegion, animated: true)
        
        self.currentCityLabel.text = location.cityName
        
    }
    
    func locationChangedToCurrent() {
        DispatchQueue.main.async {
            if (CLLocationManager.locationServicesEnabled())
            {
                self.currentCityLabel.text = "Current Location"
                //CustomLocationManager.sharedInstance.startUpdatingLocation()
                var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
                if(self.mapView.userLocation.coordinate.latitude == 0.0 || self.mapView.userLocation.coordinate.longitude == 0.0){
                    mapRegion.center = CLLocationCoordinate2D(latitude: 25.76167980, longitude: -80.19179020)
                    mapRegion.span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
                }else{
                    mapRegion.center = self.mapView.userLocation.coordinate
                    mapRegion.span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
                }
//                mapRegion.center = self.mapView.userLocation.coordinate
//                mapRegion.span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
                if(mapRegion.center.longitude == -180.00000000){
                    NSLog("Invalid region!")
                }else{
                    self.mapView.setRegion(mapRegion, animated: true)
                }
            }
            else
            {
                CustomLocationManager.sharedInstance.startUpdatingLocation()
                print("Location Not Enabled")
            }
			
        }
    }
	
	@IBAction func filterSearchTapped(_ sender: Any) {
		self.performSegue(withIdentifier: "mapToChangeLocation", sender: nil)
	}
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mapToChangeLocation"){
            if AppDelegate.originalDelegate.isGuestLogin
            {
                //self.showAlert(title: "Want to search the location to find HoneySpots?")
            }
            else
            {
                
            }
            let dest = segue.destination as! MapLocationFilterViewController
            dest.delegate = self
           
		}else if(segue.identifier == "filter"){
            if AppDelegate.originalDelegate.isGuestLogin
            {
                //self.showAlert(title: "Want to Filter your dishes?")
            }
            else
            {
                
            }
            let dest = segue.destination as! MapBottomFilterViewController
            dest.filterArray = self.currentFilters
            dest.delegate = self
			
		}
    }
}

extension MapViewController : UIScrollViewDelegate {
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		
		if(scrollView == placesCollectionView){
			let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
			if let ip = self.placesCollectionView!.indexPathForItem(at: center) {
				let currentAnnotation = self.annotations[ip.row]
				self.mapView.selectAnnotation(currentAnnotation, animated: true)
                isAnnotation = true
			}
		}
		
	}
}

extension MapViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if(collectionView == filterCollectionView){
			if(currentFilters.count >= 4){
				return 2
			}else if(currentFilters.count > 0 && currentFilters.count < 4){
				return 4
			}else{
				return 4
			}
		}else{
			return self.annotations.count
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if(collectionView == filterCollectionView){
			if(indexPath.row == 0){
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCellId", for: indexPath) as! FeedTagCollectionViewCell
				cell.bView.backgroundColor = UIColor(rgb: 0x6E6E6E)
				cell.img.image = UIImage(named: "filterIcon")
				cell.label.textColor = UIColor.white
				cell.label.text = "All"
				return cell
			}else if(currentFilters.count >= 4){
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagSelectedCellId", for: indexPath) as! MapFilterTagSelectedCollectionViewCell
				let filter = allTags.filter({ $0.id == self.currentFilters[indexPath.row - 1]}).first!
				cell.bView.backgroundColor = UIColor.white
				cell.img.image = filter.image
				cell.label.text = filter.name + " and " + (self.currentFilters.count - 1).description + " more"
				return cell
			}else if(currentFilters.count > 0 && currentFilters.count < 4){
				let currentFilters = allTags.filter({ self.currentFilters.contains($0.id)})
				let notInCurrentFilters = allTags.filter({ !self.currentFilters.contains($0.id)})
				let newFilterArr = currentFilters + notInCurrentFilters
				
				let filter = newFilterArr[indexPath.row - 1]
				if(self.currentFilters.contains(filter.id)){
					let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagSelectedCellId", for: indexPath) as! MapFilterTagSelectedCollectionViewCell
					cell.bView.backgroundColor = UIColor.white
					cell.img.image = filter.image
					cell.label.text = filter.name
					return cell
				}else{
					let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCellId", for: indexPath) as! FeedTagCollectionViewCell
					cell.bView.backgroundColor = UIColor(rgb: 0xF5F5F5)
					cell.img.image = filter.image
					cell.label.textColor = UIColor(rgb: 0x2A2A2A)
					cell.label.text = filter.name
					return cell
				}
			}else{
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCellId", for: indexPath) as! FeedTagCollectionViewCell
				let filter = allTags[indexPath.row - 1]
				cell.bView.backgroundColor = UIColor(rgb: 0xF5F5F5)
				cell.img.image = filter.image
				cell.label.textColor = UIColor(rgb: 0x2A2A2A)
				cell.label.text = filter.name
				return cell
			}
		}else{
            if self.annotations.count > 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeCellId", for: indexPath) as! MapLocationCollectionViewCell
                cell.spinner.startAnimating()
                cell.img.kf.setImage(with: URL(string: self.annotations[indexPath.row].spotSaveModel?.spot.photoUrl ?? ""))
                cell.name.adjustsFontSizeToFitWidth = true
                cell.name.text = self.annotations[indexPath.row].spotSaveModel?.spot.name
                
                let addresses = self.annotations[indexPath.row].spotSaveModel?.spot.address.split(separator: ",")
                var addressStr = ""
                var addressCount = 0
                for a in addresses! {
                    var newStr = a
                    if(newStr.hasPrefix(" ")){
                        newStr.removeFirst()
                    }
                    if(addressCount != 0 && (a.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil)){
                        addressStr = addressStr + newStr + ", "
                    }
                    addressCount += 1
                }
                
                if(addressCount > 2){
                    //addressStr.removeLast()
                    //addressStr.removeLast()
                }
                

                cell.address.text = addressStr
                cell.backView.layer.applySketchShadow(color: UIColor(rgb: 0xA6A6A6), alpha: 0.5, x: 0.0, y: 4.0, blur: 10.0, spread: 0.0)
                cell.spinner.stopAnimating()
                
                return cell
            }
            return UICollectionViewCell()
			
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if(collectionView == filterCollectionView){
			if(indexPath.row == 0){
				let lbl = UILabel()
				lbl.text = "All"
				return CGSize(width: CGFloat(50 + lbl.intrinsicContentSize.width) , height: 32)
			}else if(currentFilters.count >= 4){
				let filter = allTags.filter({ $0.id == self.currentFilters[indexPath.row - 1]}).first!
				let lbl = UILabel()
				lbl.text = filter.name + " and " + (self.currentFilters.count - 1).description + " more"
				return CGSize(width: CGFloat(80 + lbl.intrinsicContentSize.width) , height: 32)
			}else if(currentFilters.count > 0 && currentFilters.count < 4){
				let currentFilters = allTags.filter({ self.currentFilters.contains($0.id)})
				let notInCurrentFilters = allTags.filter({ !self.currentFilters.contains($0.id)})
				let newFilterArr = currentFilters + notInCurrentFilters
				let filter = newFilterArr[indexPath.row - 1]
				let lbl = UILabel()
				lbl.text = filter.name
				return CGSize(width: CGFloat(50 + lbl.intrinsicContentSize.width) , height: 32)
			}else{
				let filter = allTags[indexPath.row - 1]
				let lbl = UILabel()
				lbl.text = filter.name
				return CGSize(width: CGFloat(50 + lbl.intrinsicContentSize.width) , height: 32)
			}
		}else{
			return CGSize(width: 195.0, height: 227.0)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if(collectionView == filterCollectionView){
			if(indexPath.row == 0){
				self.performSegue(withIdentifier: "filter", sender: nil)
			}else if(currentFilters.count >= 4){
				self.currentFilters.removeAll()
				collectionView.reloadData()
				self.didFilterChanged(filters: self.currentFilters)
			}else if(currentFilters.count > 0 && currentFilters.count < 4){
				let currentFilters = allTags.filter({ self.currentFilters.contains($0.id)})
				let notInCurrentFilters = allTags.filter({ !self.currentFilters.contains($0.id)})
				let newFilterArr = currentFilters + notInCurrentFilters
				let filter = newFilterArr[indexPath.row - 1]
				if(self.currentFilters.contains(filter.id)){
					self.currentFilters = self.currentFilters.filter({ $0 != filter.id})
					collectionView.reloadData()
				}else{
					self.currentFilters.append(filter.id)
					collectionView.reloadData()
				}
				self.didFilterChanged(filters: self.currentFilters)
			}else{
                if AppDelegate.originalDelegate.isGuestLogin
                {
                    //self.showAlert(title: "Want to Filter your dishes to find HoneySpots?")
                }
                else
                {
                    
                }
                let filter = allTags[indexPath.row - 1]
                self.currentFilters.append(filter.id)
                collectionView.reloadData()
                self.didFilterChanged(filters: self.currentFilters)
				
			}
		}else if(collectionView == placesCollectionView){
            if AppDelegate.originalDelegate.isGuestLogin {
                
                //self.showAlert(title: "Want to view the details of the restaurant?")
            }
            else
            {
                
            }
            
            if self.annotations.count > 0 {
                let ssModel = self.annotations[indexPath.row].spotSaveModel
                let fModel = FeedModel(user: ssModel!.user, spotSave: ssModel!)
                AppDelegate.originalDelegate.isMap = true
                let viewController = self.FeedFullPostViewControllerInstance()
                viewController.spotSaveModel = fModel.spotSave
                viewController.feedModel = fModel
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		if(collectionView == filterCollectionView){
			return 8
		}else{
			return 0
		}
		
	}
	

	
}
