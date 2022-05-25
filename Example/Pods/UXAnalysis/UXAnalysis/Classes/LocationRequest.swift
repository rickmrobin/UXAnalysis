//
//  LocationRequest.swift
//  eventsMonitor
//
//  Created by vspl on 16/05/22.
//

import Foundation
import CoreLocation

class LocationRequest: NSObject, CLLocationManagerDelegate {

    static let shared = LocationRequest()
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
    }
    
    func startLocationUpdate() {
        if CLLocationManager.locationServicesEnabled() {
               print("before setting delegate")
               locationManager.delegate = self
               locationManager.requestWhenInUseAuthorization()
               print("after setting delegate")
               locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
               locationManager.startUpdatingLocation()
           }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdate")
        if let location: CLLocationCoordinate2D = manager.location?.coordinate {
            print(location.latitude)
            print(location.longitude)
            UserDefaults.standard.set(location.latitude, forKey: "EventLatitude")
            UserDefaults.standard.set(location.longitude, forKey: "EventLongitude")
              }
           }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFail")
        print(error.localizedDescription)
          }
       
    func hasLocationPermission() -> Bool {
           var hasPermission = false
           if CLLocationManager.locationServicesEnabled() {
               switch CLLocationManager.authorizationStatus() {
               case .notDetermined, .restricted, .denied:
                   hasPermission = false
               case .authorizedAlways, .authorizedWhenInUse:
                   hasPermission = true
               }
           } else {
               hasPermission = false
           }
           
           return hasPermission
       }
   
}
