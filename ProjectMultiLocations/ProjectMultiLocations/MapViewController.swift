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

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
        @IBOutlet weak var mapView: MKMapView!
    @IBAction func searchBarBTN(_ sender: Any) {
        
        //inserting search bar
        let searchController =  UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        
        }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Ignore user once search button is clicked
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //activity controller to ignore user while loading and showing activity on process
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        //show activity indicator on screen
        self.view.addSubview(activityIndicator)
        
        //resign keyborad
        searchBar.resignFirstResponder()
        //hide searchbar
        dismiss(animated: true, completion: nil)
        
//remove activity indicator
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
 //Search address in maps
        let searchAddress = MKLocalSearch.Request()
        searchAddress.naturalLanguageQuery = searchBar.text
        let searchOutput = MKLocalSearch(request: searchAddress)
        searchOutput.start { (response, Error) in
            if let address = response {
//                remove all annotations/pins
               var a =  self.mapView.annotations
                a.removeAll()
//                a.removeAll(where: { (a) -> Bool inmhg
//                    true
//                })
                
                
                if let latitude = response?.boundingRegion.center.latitude,let longitude = response?.boundingRegion.center.longitude{
                 let givenLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                   let  annotate = MKPointAnnotation()
                    annotate.title = searchBar.text
                    annotate.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    self.mapView.addAnnotation(annotate)

                }
            }
            else{
                let  alert  =  UIAlertController(title:  "Alert",  message:  "Invalid address",  preferredStyle:  .alert)
                alert.addAction(UIAlertAction(title:  "OK",  style:  .default,  handler:  nil))
                self.present(alert,  animated:  true,  completion:  nil)
            }
           

        }
        
//        if let searchOutput.start()
//        }
    }

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
        
        // set region of view
            let locationRadius: CLLocationDistance = 2000
        func centerLocation(location:CLLocation){
            let locationRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: locationRadius, longitudinalMeters: locationRadius)
            mapView.setRegion(locationRegion, animated: true)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let initialLocation = CLLocation(latitude: 40.345493, longitude: -94.874588)
//
//        centerLocation(location: initialLocation)
//
//        let destinationVar = DestinationLocationClass(title: "Home", addressVar: "322,N WallNut", coordinate: CLLocationCoordinate2D(latitude: 40.345493, longitude: -94.874588), descriptionVar: "First Location")
//        let location2 = DestinationLocationClass(title: "Horizons", addressVar: "Walmurt", coordinate: CLLocationCoordinate2D(latitude: 40.330026, longitude: -94.870115), descriptionVar: "Second Location")
//
//
//        var allLocation:[DestinationLocationClass] = []
//        allLocation += [destinationVar,location2]
//        mapView.addAnnotations(allLocation)
        
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
         }
    

    



}


