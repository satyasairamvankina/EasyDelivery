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
extension Notification.Name  {
    static let  Pinned = Notification.Name("Pinned")
    static let  NotPinned = Notification.Name("NotPinned")
}

class DestinationLocationClass:NSObject, MKAnnotation{
   
    static var destinationLocation:DestinationLocationClass = DestinationLocationClass()
    
    static var annotateArray:[MKAnnotation] = []
    var annotationIndex = 1
    var qrOutput:[CLLocationCoordinate2D] = []
    var  initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    var coordinate: CLLocationCoordinate2D
    
    static var distanceVar:Double?
    
//    convert output from Qrcode to  latitude and longitude
    func convertToCoordinates(address: String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: Error!) -> Void in
            if let placemark = placemarks?[0]
            {
                self.initialLocation = (placemark.location ?? nil)!
                self.qrOutput.append(self.initialLocation.coordinate)
                let  annotate = MKPointAnnotation()
                //Setting annotations for Qr output
                annotate.title = "Q\(self.annotationIndex)" // annotations will be Q1, Q2, Q3 etc.
                annotate.subtitle = address
                annotate.coordinate = self.initialLocation.coordinate
                //verify for duplicate and add if not already added
                var duplicate = true;
                var ti:[String : String] = ["Pin" : ""] ;
                
                for i in 0 ..< DestinationLocationClass.annotateArray.count {
                    print("Dest array: \(DestinationLocationClass.annotateArray[i].coordinate)")
                    print("Read obj: \(annotate.coordinate)")
                    if (annotate.coordinate.latitude == DestinationLocationClass.annotateArray[i].coordinate.latitude) && (annotate.coordinate.longitude == DestinationLocationClass.annotateArray[i].coordinate.longitude) {
                            duplicate = false;
                        ti.updateValue(DestinationLocationClass.annotateArray[i].title as! String, forKey: "Pin")
                        }
                }
                if duplicate {
                    DestinationLocationClass.annotateArray.append(annotate)
                    self.annotationIndex += 1
                    DispatchQueue.main.async(){
                        NotificationCenter.default.post(name:  .Pinned,  object:  nil)}
                } else {
                    DispatchQueue.main.async(){
                        NotificationCenter.default.post(name:  .NotPinned,  object:  nil, userInfo: ti)}
                }
                print("Total pins after appending: \(DestinationLocationClass.annotateArray.count)")
                
            }
        })
        print("Total pins: \(DestinationLocationClass.annotateArray.count)")
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
