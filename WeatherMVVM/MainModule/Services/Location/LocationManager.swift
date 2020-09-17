//
//  LocationManager.swift
//  WeatherMVVM
//
//  Created by Родион Ковалевский on 9/14/20.
//  Copyright © 2020 Родион Ковалевский. All rights reserved.
//

import UIKit
import MapKit

class LocationManager: NSObject,CLLocationManagerDelegate {
    
    enum LocationErrors: String {
        case denied = "Locations are turned off. Please turn it on in Settings"
        case notFetched = "Unable to fetch location"
    }
    
    private var locationFetchTimeInSeconds = 1.0
    
    typealias LocationClosure = ((_ location:CLLocation?,_ error: NSError?)->Void)
    
    private var locationCompletionHandler: LocationClosure?
    
    private var locationManager:CLLocationManager?
   
    private var lastLocation:CLLocation?
    
    static let sharedInstance: LocationManager = {
        let instance = LocationManager()
        return instance
    }()
    

    deinit {
        destroyLocationManager()
    }
    
    //MARK:- Private Methods
    private func setupLocationManager() {

        locationManager = nil
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
    }
    
    private func destroyLocationManager() {
        locationManager?.delegate = nil
        locationManager = nil
        lastLocation = nil
    }
    
    private func startThread() {
        self.perform(#selector(sendLocation), with: nil, afterDelay: locationFetchTimeInSeconds)
    }
    
    @objc private func sendLocation() {
        guard let _ = lastLocation else {
            self.didComplete(location: nil,error: NSError(
                domain: self.classForCoder.description(),
                code:Int(CLAuthorizationStatus.denied.rawValue),
                userInfo:
                [NSLocalizedDescriptionKey:LocationErrors.notFetched.rawValue,
                 NSLocalizedFailureReasonErrorKey:LocationErrors.notFetched.rawValue,
                 NSLocalizedRecoverySuggestionErrorKey:LocationErrors.notFetched.rawValue]))
            lastLocation = nil
            return
        }
        self.didComplete(location: lastLocation,error: nil)
        lastLocation = nil
    }
    

    func getLocation(completionHandler:@escaping LocationClosure) {
        
        //Cancelling the previous selector handlers if any
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
    
        lastLocation = nil
        
        self.locationCompletionHandler = completionHandler
        
        setupLocationManager()
    }

    
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .authorizedWhenInUse,.authorizedAlways:
            self.locationManager?.startUpdatingLocation()
                startThread()
        case .denied:
            let deniedError = NSError(
                domain: self.classForCoder.description(),
                code:Int(CLAuthorizationStatus.denied.rawValue),
                userInfo:
                [NSLocalizedDescriptionKey:LocationErrors.denied.rawValue,
                 NSLocalizedFailureReasonErrorKey:LocationErrors.denied.rawValue,
                 NSLocalizedRecoverySuggestionErrorKey:LocationErrors.denied.rawValue])
                didComplete(location: nil,error: deniedError)
        case .restricted:
                didComplete(location: nil,error: NSError(
                    domain: self.classForCoder.description(),
                    code:Int(CLAuthorizationStatus.restricted.rawValue),
                    userInfo: nil))
            break
            
        case .notDetermined:
            self.locationManager?.requestWhenInUseAuthorization()
            break
    }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        self.didComplete(location: nil, error: error as NSError?)
    }
    
    //MARK:- Final closure/callback
    private func didComplete(location: CLLocation?,error: NSError?) {
        locationManager?.stopUpdatingLocation()
        locationCompletionHandler?(location,error)
        locationManager?.delegate = nil
        locationManager = nil
    }

}
