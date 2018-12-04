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

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate {

    let locationManager = CLLocationManager()
    var destinationLocationVar:CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.7565, 83.9705) //giving default values to destination location
    var currentLocationVar:CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.7565, 83.9705) //giving default values to current location
    var annotationIndex = 1
    let intialLocationRadius: CLLocationDistance = 2000 //initail view radius of mapview
    var distanceSourceToDst = 0.0
    
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
            
            if response != nil {
                // if latitude and longitude are legitamate then place a pin
                
                if let latitude = response?.boundingRegion.center.latitude,let longitude = response?.boundingRegion.center.longitude{
                    let givenLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                // Creating Annotation
                    let  annotate = MKPointAnnotation()
                    annotate.title = "A\(self.annotationIndex)" // annotations will be A1, A2, A3 etc.

                    self.annotationIndex += 1
                  
                    annotate.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    self.myMapView.addAnnotation(annotate) //add mapview the annotation
                    self.distanceSourceToDst = Double((MKMapPoint(self.currentLocationVar)).distance(to: MKMapPoint((annotate.coordinate))))
                    
                    // calculaing distance and converting into miles
                    annotate.subtitle = "\(searchBar.text!) \(String(format: "%0.3f",self.distanceSourceToDst*0.000621371) ) miles"
                    //adding elements into annotation array
                    DestinationLocationClass.annotateArray.append(annotate)
                    
                    self.myMapView.removeAnnotations(self.myMapView.annotations)
                    self.myMapView.addAnnotations(DestinationLocationClass.annotateArray)
                    
                    //calling mapview did select func
                    self.mapView(mapView: self.myMapView, didSelectAnnotationView: MKAnnotationView.init(annotation: annotate, reuseIdentifier: "empty"))
                }
            }
            else{
                let  alert = UIAlertController(title:  "Alert",  message:  "Invalid address",  preferredStyle:  .alert)
                alert.addAction(UIAlertAction(title:  "OK",  style:  .default,  handler:  nil))
                self.present(alert,  animated:  true,  completion:  nil)
            }
        }
    }

    // Annotation view callout
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        // let locationRadius: CLLocationDistance = 2000
        let location = locations[0]
        let span = MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1)
        let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        currentLocationVar = myLocation
        // Setting the zoom that current location always visible in the mapview
        
        if !myMapView.isUserLocationVisible{
        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation,span: span)
        myMapView.setRegion(region, animated: true)
            
        }
        self.myMapView.showsUserLocation = true
      
    }
    
    // set region of view
 
    func centerLocation(location:CLLocation){
        let locationRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: intialLocationRadius, longitudinalMeters: intialLocationRadius)
        myMapView.setRegion(locationRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Location manager to get the user current location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //obtaining the best accuracy
        locationManager.requestWhenInUseAuthorization() // request the location from user only when app is being used
        locationManager.startUpdatingLocation() // Auto update users current location
        
        myMapView.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Remove all the annotations and only add existing pins in the array
        self.myMapView.removeAnnotations(self.myMapView.annotations)
        self.myMapView.addAnnotations(DestinationLocationClass.annotateArray)
        self.myMapView.reloadInputViews()
        self.viewDidLoad()
        if DestinationLocationClass.annotateArray.count == 0{
            myMapView.removeOverlays(myMapView.overlays)
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
    
    //clicking on map view
    private func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
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
        let imagePin = UIImage(named: "pin.png")
        
        annotationView?.leftCalloutAccessoryView = UIImageView.init(image: imagePin)
        annotationView!.rightCalloutAccessoryView = callBTN
//        annotationView?.glyphText = String(format: "%0.1f",self.distanceSourceToDst*0.000621371)
        annotationView!.markerTintColor = UIColor.red
        annotationView!.annotation = annotation
        
        
       
        return annotationView
        }
    @objc
    func clickMe(sender:UIButton){
        self.present(UIViewController(), animated: true, completion: nil) // probably not quite what we want ;-(
    }
    
    //tapped on button in callout

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.destinationLocationVar = (view.annotation?.coordinate)!
        print("annotation is tapped")
      
        // calculate the distance betwen current location and destination
        let distance = Double((MKMapPoint(self.destinationLocationVar)).distance(to: MKMapPoint(self.currentLocationVar)))
        
        DestinationLocationClass.distanceVar = distance*0.000621371
        myMapView.removeOverlays(myMapView.overlays)
        
        // Routes on destinations
        let sourcePlaceMark = MKPlacemark(coordinate: self.currentLocationVar)
        let destinationPlaceMark = MKPlacemark(coordinate: self.destinationLocationVar)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destItem = MKMapItem(placemark: destinationPlaceMark)
        
        //setting the global variables source and destination
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = MKDirectionsTransportType.automobile
        
        
        let directions = MKDirections(request: directionRequest)
        
        //if directions are available then show routes else display error
        directions.calculate(completionHandler: {
            response, error in
            guard let response = response
                else{ if error != nil{
                    print("Something went wrong")
                    }
                    return
            }
            let route = response.routes[0]
            self.myMapView.addOverlay(route.polyline, level: .aboveRoads) // add overlays about mapview
            
            //setting the driving view
            let rectangle = route.polyline.boundingMapRect
            self.myMapView.setRegion(MKCoordinateRegion(rectangle), animated: true)
        })
    }
    
    // adding the overlays and setting the color
    func mapView(_ mapView: MKMapView, rendererFor overlay:MKOverlay) -> MKOverlayRenderer{

        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.orange
        renderer.lineWidth = 7.0
        return renderer
    }
}







