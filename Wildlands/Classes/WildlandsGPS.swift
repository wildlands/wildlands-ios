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
    
    func didReceiveNewCoordinates(x: Int, y: Int)
    
}

class WildlandsGPS: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var delegate: WildlandsGPSDelegate?

    let top = 52.778749
    let left = 6.910379
    
    let bottom = 52.777664
    let right = 6.913659
    
    let internalMapWidth = 2450.00
    let internalMapHeight = 1342.00
    
    override init() {
        
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
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
    
    func convertPositionData (latitude : Double, longitude : Double) -> (x: Int, y: Int) {
        
        var x = ((longitude - left) / (right - left)) * internalMapWidth
        var y = ((latitude - top) / (bottom - top)) * internalMapHeight
        
        return (Int(x), Int(y))
    
    }

}
