//
//  LocationManager.swift
//  WeatherByJPMC
//
//  Created by Muhammad kashif jawad on 6/2/23.
//

import UIKit
import CoreLocation

class LocationManager: NSObject,CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager?
    var currentLocation:CLLocation!
    var locationInformation:NSMutableDictionary!
    
    static let sharedInstance: LocationManager = { LocationManager() }()
    
    override init() {
        
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.distanceFilter = 10
        self.locationManager?.delegate = self
        if #available(iOS 8.0, *) {
            self.locationManager?.requestWhenInUseAuthorization()
        }
        locationInformation = NSMutableDictionary()
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let location: AnyObject? = (locations as NSArray).lastObject as AnyObject?
        self.currentLocation = location as? CLLocation
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(self.currentLocation!, completionHandler: {(placemarks, error) -> Void in
            print(location!)
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                
                self.stopUpdatingLocation()
                let pm = placemarks![0]
                if(pm.country != nil)
                {
                    self.locationInformation.setValue(pm.country, forKey: "country")
                }
                
                if(pm.locality != nil)
                {
                    self.locationInformation.setValue(pm.locality, forKey: "city")
                }
                
                if(pm.postalCode != nil)
                {
                    self.locationInformation.setValue(pm.postalCode, forKey: "postalcode")
                }
                
                if(pm.administrativeArea != nil)
                {
                    self.locationInformation.setValue(pm.administrativeArea, forKey: "state")
                }
                
                if (self.currentLocation?.coordinate != nil )
                {
                    self.locationInformation.setValue(self.currentLocation.coordinate.latitude as Double, forKey: "latitude")
                    self.locationInformation.setValue(self.currentLocation.coordinate.longitude as Double, forKey: "longitude")
                    
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "locationInformation"), object: nil)
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Update Location Error : \(error)")
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
            
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
            break
        case .denied:
            //handle denied
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
}

