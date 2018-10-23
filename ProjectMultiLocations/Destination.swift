//
//  Destination.swift
//  ProjectMultiLocations
//
//  Created by Vankina,Satya Sai Ram on 9/26/18.
//  Copyright © 2018 Vankina,Satya Sai Ram. All rights reserved.
//

import Foundation
import MapKit

class DestinationLocationClass:NSObject, MKAnnotation{
    
    
    
    static var destinationLocation:DestinationLocationClass = DestinationLocationClass()
//        var a = ["p1","p2","p3","p4","p5"]
    
    static var annotateArray:[MKAnnotation] = []

    
    var coordinate: CLLocationCoordinate2D
    
    func getCoordinates()->String{
        let geocoder = CLGeocoder()
        let address = "/(messageLabel.text!)"
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                let coordinate:CLLocationCoordinate2D = placemark.location!.coordinate
                print("Lat: \(coordinate.latitude) -- Long: \(coordinate.longitude)")
            }
        })
        return ("Lat: \(coordinate.latitude) -- Long: \(coordinate.longitude)")
    }
    
    let  title:String?
    let addressVar:String?
//    let latitudeVar:Double?
//    let longitudeVar:Double?
    let descriptionVar:String?
    init(title:String,addressVar:String,/*latitudeVar:Double,longitudeVar:Double,*/coordinate: CLLocationCoordinate2D,descriptionVar: String) {
        self.title = title
        self.addressVar = addressVar
//        self.latitudeVar = latitudeVar
//        self.longitudeVar = longitudeVar
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
//    var des:String?{
//        return addressVar
//    }

 
}
