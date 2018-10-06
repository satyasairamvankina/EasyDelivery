//
//  FirstViewController.swift
//  ProjectMultiLocations
//
//  Created by Vankina,Satya Sai Ram on 9/26/18.
//  Copyright © 2018 Vankina,Satya Sai Ram. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
//            let locationRadius: CLLocationDistance = 2000
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
//                centerLocation(location: location)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
//
//        let region:MKCoordinateRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: locationRadius, longitudinalMeters: locationRadius)
//         let currentLocation = DestinationLocationClass(title: "Current Location", coordinate: myLocation)

//                  mapView.addAnnotation(currentLocation)

        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation,span: span)
        mapView.setRegion(region, animated: true)

        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        self.mapView.showsUserLocation = true


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let initialLocation = CLLocation(latitude: 40.345493, longitude: -94.874588)
        
        centerLocation(location: initialLocation)
        
        let destinationVar = DestinationLocationClass(title: "Home", addressVar: "322,N WallNut", coordinate: CLLocationCoordinate2D(latitude: 40.345493, longitude: -94.874588), descriptionVar: "First Location")
        let location2 = DestinationLocationClass(title: "Horizons", addressVar: "Walmurt", coordinate: CLLocationCoordinate2D(latitude: 40.330026, longitude: -94.870115), descriptionVar: "Second Location")
       
//        mapView.addAnnotation(destinationVar)
//        mapView.addAnnotation(location2)
        var allLocation:[DestinationLocationClass] = []
        allLocation += [destinationVar,location2]
        mapView.addAnnotations(allLocation)
        
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
         }
    
    let locationRadius: CLLocationDistance = 2000
    
    func centerLocation(location:CLLocation){
        let locationRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: locationRadius, longitudinalMeters: locationRadius)
        mapView.setRegion(locationRegion, animated: true)
        }


}

