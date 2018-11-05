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

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate,MKMapViewDelegate {
    
//      var selectedDestinationLocation:CLLocationCoordinate2D
//    init(selectedDestinationLocation:CLLocationCoordinate2D) {
//        self.selectedDestinationLocation = selectedDestinationLocation
//    }
    
  let locationManager = CLLocationManager()
    var destinationLocationVar:CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.7565, 83.9705)
    var currentLocationVar:CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.7565, 83.9705)

    var annotationName = ["A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12","A13",]
    var i = 0
    
    
    @IBOutlet weak var myMapView: MKMapView!
    
    @IBAction func searchBarBTN(_ sender: Any) {
       
        //inserting search bar
        let searchController =  UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)

        
        }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        activityIndicatorFNC()
        
        //resign keyborad
        searchBar.resignFirstResponder()
        
        //Search address in maps
        let searchAddress = MKLocalSearch.Request()
        searchAddress.naturalLanguageQuery = searchBar.text
        let searchOutput = MKLocalSearch(request: searchAddress)
        
        searchOutput.start { (response, Error) in
            if let address = response {
                //  remove all annotations/pins
                var a =  self.myMapView.annotations
                a.removeAll()
                
                //if latitude and longitude are legitamate then place a pin
                if let latitude = response?.boundingRegion.center.latitude,let longitude = response?.boundingRegion.center.longitude{
                let givenLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    self.destinationLocationVar = givenLocation
                // Adding annotation
                   let  annotate = MKPointAnnotation()
                    annotate.title = self.annotationName[self.i]
                    self.i += 1
                    annotate.subtitle = searchBar.text
                    annotate.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    self.myMapView.addAnnotation(annotate)
//
//                //adding elemeents into annotation array
                    DestinationLocationClass.annotateArray.append(annotate)
                    print(DestinationLocationClass.annotateArray.description)
                    
                  //calling mapview did select func
                    self.mapView(mapView: self.myMapView, didSelectAnnotationView: MKAnnotationView.init(annotation: annotate, reuseIdentifier: "empty"))
  
            }
            }
            else{
                let  alert  =  UIAlertController(title:  "Alert",  message:  "Invalid address",  preferredStyle:  .alert)
                alert.addAction(UIAlertAction(title:  "OK",  style:  .default,  handler:  nil))
                self.present(alert,  animated:  true,  completion:  nil)
            }
            
        }
        
    }

// annotation view callout


    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
//            let locationRadius: CLLocationDistance = 2000
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1)
//                centerLocation(location: location)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        currentLocationVar = myLocation
//
//        let region:MKCoordinateRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: locationRadius, longitudinalMeters: locationRadius)
//         let currentLocation = DestinationLocationClass(title: "Current Location", coordinate: myLocation)


        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation,span: span)
        myMapView.setRegion(region, animated: true)

        self.myMapView.showsUserLocation = true
        
//        func currentLocation() -> CLLocationCoordinate2D{
//            return myLocation
//        }
//        currentLocation = myLocation

    }
        
 // set region of view
            let locationRadius: CLLocationDistance = 2000
        func centerLocation(location:CLLocation){
            let locationRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: locationRadius, longitudinalMeters: locationRadius)
            myMapView.setRegion(locationRegion, animated: true)
            
            
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        myMapView.delegate = self
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

         }

    func activityIndicatorFNC(){
        //Ignore user once search button is clicked
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //activity controller to ignore user while loading and showing activity on process
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        //show activity indicator on screen
        self.view.addSubview(activityIndicator)
        
        //hide searchbar
        dismiss(animated: true, completion: nil)
        
        //remove activity indicator and stop user interaction
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
        
        }
    
    //clicking on mapp view
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        //        self.selectedAnnotation = view.annotation as?
//        annotate.title = "chnged"
        
        //adding elemeents into annotation array
//        DestinationLocationClass.annotateArray.append(annotate)
//        print(DestinationLocationClass.annotateArray)

        //Need to reload tableview data
        
        print("New Annotation is marked")
    }
    
    //annotaton view make
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "anno") as? MKMarkerAnnotationView

            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "anno")
            annotationView!.canShowCallout = true
            let callBTN = UIButton(type: .detailDisclosure)
//            callBTN.addTarget(self, action: #selector(clickMe(sender:)), for: UIControl.Event.touchUpInside)
        
            let imagePin = UIImage(named: "pin.png")
            annotationView?.leftCalloutAccessoryView = UIImageView.init(image: imagePin)
        
            annotationView!.rightCalloutAccessoryView = callBTN
            annotationView!.markerTintColor = UIColor.red
            annotationView!.annotation = annotation
//        }
        return annotationView
    }
    @objc
    func clickMe(sender:UIButton){
        self.present(UIViewController(), animated: true, completion: nil) // probably not quite what we want ;-(
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("annotation is tapped")
        // working on directions
        let sourcePlaceMark = MKPlacemark(coordinate: self.currentLocationVar)
        //                    let sourcePlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2DMake(latitude, longitude))
        let destinationPlaceMark = MKPlacemark(coordinate: self.destinationLocationVar)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destItem = MKMapItem(placemark: destinationPlaceMark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = MKDirectionsTransportType.automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate(completionHandler: {
            response, error in
            guard let response = response
                else{ if let error = error{
                    print("Something went wrong")
                    }
                    return
            }
            let route = response.routes[0]
            self.myMapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rectangle = route.polyline.boundingMapRect
            self.myMapView.setRegion(MKCoordinateRegion(rectangle), animated: true)
        })
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay:MKOverlay) -> MKOverlayRenderer{
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.brown
        renderer.lineWidth = 7.0
        return renderer
    }
}
    
    





