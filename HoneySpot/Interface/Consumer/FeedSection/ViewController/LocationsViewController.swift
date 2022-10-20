//
//  LocationsViewController.swift
//  HoneySpot
//
//  Created by htcuser on 08/12/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit
import MapKit


class LocationsViewController: UIViewController {
    var spotSavemodel : SpotSaveModel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapViewAddressLabel: UILabel!
    @IBOutlet var directionsButton: UIButton!
    @IBOutlet var callButton: UIButton!
    var phoneNumber = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        showLocation()
        // Do any additional setup after loading the view.
    }
    
    func showLocation()  {
        
        self.phoneNumber = spotSavemodel.spot.phoneNumber ?? ""
        callButton.setTitle(self.phoneNumber, for: .normal)
        //self.mapViewAddressLabel.text = spotSavemodel.spot.address
        if(spotSavemodel.spot.operationhours.count == 7){
            //self.mapViewAddressLabel.text = (self.mapViewAddressLabel.text ?? "") + "\n"
            let hours = spotSavemodel.spot.operationhours[Calendar.current.component(.weekday, from: Date()) - 1].split(separator: "|")
            if(hours[0] == "close"){
                //self.mapViewAddressLabel.text = (self.mapViewAddressLabel.text ?? "") + "Closed"
            }else{
                //self.mapViewAddressLabel.text = (self.mapViewAddressLabel.text ?? "") + "Open Hours :  " + hours[1] + " - " + hours[2]
            }
        }
        
        var annotationsToAdd: [SpotAnnotation] = []
        let sa: SpotAnnotation = SpotAnnotation(spotSaveModel: spotSavemodel)
        annotationsToAdd.append(sa)
        self.mapView.addAnnotations(annotationsToAdd)
        
        let mapRegion: MKCoordinateRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: spotSavemodel.spot.lat, longitude: spotSavemodel.spot.lon),
            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        )
        self.mapView.setRegion(mapRegion, animated: true)
        
    }
    
    @IBAction func directionsTapped(_ sender: Any){
        let spot = spotSavemodel.spot
        let urlString: String = String(format: .APPLE_MAP_URL, spot.address.addingPercentEncoding(withAllowedCharacters: String.ENCODING_ALLOWED_CHARACTERS)!)
        UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
    }
    @IBAction func callTapped(_ sender: Any)
    {
        self.phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        if(self.phoneNumber != ""){
            let phoneUrl = URL(string: "tel://\(self.phoneNumber)")!
            if(UIApplication.shared.canOpenURL(phoneUrl)){
                UIApplication.shared.open(phoneUrl, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    @IBAction func didClickBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LocationsViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotSavemodel.spot.otherlocations.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "honeyLocationCellId") as! LocationTableViewCell
            cell.locationName.text = spotSavemodel.spot.address
            cell.img.isHidden = false
            return cell
        }
        else{
            print(indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: "honeyLocationCellId") as! LocationTableViewCell
            let addresses =  spotSavemodel.spot.otherlocations[indexPath.row - 1].split(separator: "|")
            if addresses.count == 0 {
                print("No Data")
                cell.locationName.text = ""
                
            }
            else
            {
                cell.locationName.text = (addresses[0]).description + "," + (addresses[1]).description + "," + (addresses[2]).description + "," + (addresses[3]).description
            }
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            //Normal
        }else{
            //OtherLocation
            //self.index = indexPath.row - 1
        }
    }
    
    
    
}
