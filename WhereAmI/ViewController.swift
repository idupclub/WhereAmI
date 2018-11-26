//
//  ViewController.swift
//  WhereAmI
//
//  Created by Chun Cao on 16/5/17.
//  Copyright © 2016年 NJU. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate  {
    
    
    @IBAction func locateMe(){
        
        
        if ( CLLocationManager.authorizationStatus() == .notDetermined){
            locationManager.requestWhenInUseAuthorization()
            //locationManager.requestAlwaysAuthorization()
        }
        
//        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.startUpdatingLocation()
//        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    @IBOutlet weak var locTextField: UITextField!
    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var areaTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied:
            
            let alertController = UIAlertController(title: "Locating Denied", message: "You did not grant the locating permission for this app.", preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            return
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        print(locations[0].altitude)
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
        
        
        if let containsPlacemark = placemark {
            
            
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.subAdministrativeArea != nil) ? containsPlacemark.subAdministrativeArea : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            locTextField.text = locality
            postTextField.text = postalCode
            areaTextField.text = administrativeArea
            countryTextField.text = country
        }
        
    }
    
}

