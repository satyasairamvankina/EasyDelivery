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
    var coordinate: CLLocationCoordinate2D
    
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
    var subtitle: String?{
        return descriptionVar! + addressVar!
        
    }
//    var des:String?{
//        return addressVar
//    }

 
}
