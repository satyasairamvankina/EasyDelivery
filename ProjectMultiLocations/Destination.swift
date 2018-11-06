//
//  Destination.swift
//  ProjectMultiLocations
//
//  Created by Vankina,Satya Sai Ram on 9/26/18.
//  Copyright © 2018 Vankina,Satya Sai Ram. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class DestinationLocationClass:NSObject, MKAnnotation{
    
    
    
    static var destinationLocation:DestinationLocationClass = DestinationLocationClass()
    
    static var annotateArray:[MKAnnotation] = []
    var annotationIndex = 1
    var qrOutput:[CLLocationCoordinate2D] = []
    var  initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    var coordinate: CLLocationCoordinate2D
    
    func convertToCoordinates(address: String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: Error!) -> Void in
            if let placemark = placemarks?[0]
            {
                self.initialLocation = (placemark.location ?? nil)!
                self.qrOutput.append(self.initialLocation.coordinate)
                let  annotate = MKPointAnnotation()
                annotate.title = "Q\(self.annotationIndex)" // annotations will be Q1, Q2, Q3 etc.
                self.annotationIndex += 1
                annotate.subtitle = address
                annotate.coordinate = self.initialLocation.coordinate
                DestinationLocationClass.annotateArray.append(annotate)
                
            }
        })
    }
    
    let  title:String?
    let addressVar:String?
    let descriptionVar:String?
    init(title:String,addressVar:String,coordinate: CLLocationCoordinate2D,descriptionVar: String) {
        self.title = title
        self.addressVar = addressVar
        self.coordinate = coordinate
        self.descriptionVar = descriptionVar
        super.init()
    }
    
    convenience init(title:String,coordinate: CLLocationCoordinate2D) {
        self.init(title:title,addressVar:"",coordinate: coordinate,descriptionVar: "")
    }
    
    convenience override init() {
        self.init(title:"",addressVar:"",coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),descriptionVar: "")
    }
    func address() -> String?{
        return self.addressVar
    }
    var subtitle: String?{
        return descriptionVar! + addressVar!
    }
}
