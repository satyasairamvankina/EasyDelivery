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
//      var currentLocation:CLLocationCoordinate2D
//    init(currentLocation:CLLocationCoordinate2D) {
//        self.currentLocation = currentLocation
//    }
    

    @IBOutlet weak var mapView: MKMapView!
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
                var a =  self.mapView.annotations
                a.removeAll()
                
                //if latitude and longitude are legitamate then place a pin
                if let latitude = response?.boundingRegion.center.latitude,let longitude = response?.boundingRegion.center.longitude{
                let givenLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    
                // Adding annotation
                   let  annotate = MKPointAnnotation()
                    annotate.title = "Take from user"
                    annotate.subtitle = searchBar.text
                    annotate.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    self.mapView.addAnnotation(annotate)
                    
                //adding elemeents into annotation array
                    DestinationLocationClass.annotateArray.append(annotate)
                    print(DestinationLocationClass.annotateArray)
                    
                  //calling mapview did select func
                    self.mapView(mapView: self.mapView, didSelectAnnotationView: MKAnnotationView.init(annotation: annotate, reuseIdentifier: "empty"))
                    
// working on directions
//                    let sourcePlaceMark = MKPlacemark(coordinate: self.currentLocation)
                    let sourcePlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2DMake(latitude, longitude))
                    let destinationPlaceMark = MKPlacemark(coordinate: givenLocation)

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
                        self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                        
                        let rectangle = route.polyline.boundingMapRect
                        self.mapView.setRegion(MKCoordinateRegion(rectangle), animated: true)
                    })
                }
                func mapView(_ mapView: MKMapView, rendererFor overlay:MKOverlay) -> MKOverlayRenderer{
                    let renderer = MKPolylineRenderer(overlay: overlay)
                    renderer.strokeColor = UIColor.blue
                    renderer.lineWidth = 5.0
                    
                    return renderer
                }
            }
            else{
                let  alert  =  UIAlertController(title:  "Alert",  message:  "Invalid address",  preferredStyle:  .alert)
                alert.addAction(UIAlertAction(title:  "OK",  style:  .default,  handler:  nil))
                self.present(alert,  animated:  true,  completion:  nil)
            }
        }
        
    }

    


    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
//            let locationRadius: CLLocationDistance = 2000
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1)
//                centerLocation(location: location)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
//
//        let region:MKCoordinateRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: locationRadius, longitudinalMeters: locationRadius)
//         let currentLocation = DestinationLocationClass(title: "Current Location", coordinate: myLocation)


        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation,span: span)
        mapView.setRegion(region, animated: true)

        self.mapView.showsUserLocation = true
        
//        func currentLocation() -> CLLocationCoordinate2D{
//            return myLocation
//        }
//        currentLocation = myLocation

    }
        
 // set region of view
            let locationRadius: CLLocationDistance = 2000
        func centerLocation(location:CLLocation){
            let locationRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: locationRadius, longitudinalMeters: locationRadius)
            mapView.setRegion(locationRegion, animated: true)
            
            
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
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
        print("selected Annotation")
    }

}

//
//let regionDistance:CLLocationDistance = 1000;
//let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
//let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
//
//let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
//
//let placemark = MKPlacemark(coordinate: coordinates)
//let mapItem = MKMapItem(placemark: placemark)
//mapItem.name = "My House"
//mapItem.openInMaps(launchOptions: options)
//

