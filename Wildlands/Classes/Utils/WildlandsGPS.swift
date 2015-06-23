//
//  WildlandsGPS.swift
//  Wildlands
//
//  Created by Jan Doornbos on 14-04-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import Foundation
import CoreLocation

protocol WildlandsGPSDelegate {
    
    /**
        Convert GPS coordinates to X and Y points for our Wildlands Map.
        
        :param: latitude        The latitude from the GPS
        :param: longitude       The longitude from the GPS
        
        :returns:               The X and Y position for the Wildlands Map
    */
    func didReceiveNewCoordinates(x: Int, y: Int)
    
}

class WildlandsGPS: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var delegate: WildlandsGPSDelegate?

    // Coordinates from Wildlands Map
    let top = 52.783688
    let left = 6.881025
    
    let bottom = 52.776225
    let right = 6.893921
    
    // Size from the map in the App
    let internalMapWidth = 2500.00
    let internalMapHeight = 2392.00
    
    override init() {
        
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
            
        case .AuthorizedAlways:
            locationManager.startUpdatingLocation()
            break
        
        default:
        break
        
        }
    
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let location = locations.last as! CLLocation
        
        let position = convertPositionData(location.coordinate.latitude, longitude: location.coordinate.longitude)
        delegate?.didReceiveNewCoordinates(position.x, y: position.y)
        
    }
    
    /**
        Converts the GPS coordinates to a position on the Wildlansd map.

        :param: latitude            The GPS latitude
        :param: longitude           The GPS longitude
        
        :returns: An X and Y position on the Wildlands map.
     */
    func convertPositionData (latitude : Double, longitude : Double) -> (x: Int, y: Int) {
        
        var x = ((longitude - left) / (right - left)) * internalMapWidth
        var y = ((latitude - top) / (bottom - top)) * internalMapHeight
        
        return (Int(x), Int(y))
    
    }

}
