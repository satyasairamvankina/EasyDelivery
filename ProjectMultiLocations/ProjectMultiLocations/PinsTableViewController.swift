//
//  PinsTableViewController.swift
//  ProjectMultiLocations
//
//  Created by Vankina,Satya Sai Ram on 10/5/18.
//  Copyright © 2018 Vankina,Satya Sai Ram. All rights reserved.
//

import UIKit
import MapKit

class PinsTableViewController: UITableViewController {
    var i:[MKAnnotation] = []
    var b:[MKAnnotation] = (DestinationLocationClass.annotateArray)
    var a:[String] = []
    var c:[String] = []
    
//    var i:[MKAnnotation] = []
//    var b:[MKAnnotation] = (DestinationLocationClass.annotateArray)
//    var a:[String] = []
//        var c:[String] = []
////    init(i:[MKAnnotation]) {
////        self.i = i
//        for i in b {
//            a.append((i.title!)!)
//            c.append((i.subtitle!)!)
//        }
////    }

    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return a.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pinCells", for: indexPath)
        //let model = DestinationLocationClass.destinationLocation.address()
        cell.textLabel?.text = a[indexPath.row]
        cell.detailTextLabel?.text = c[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        tableView.reloadData()
        var p1 = DestinationLocationClass(title: "Horizons",addressVar: "Apartments",coordinate: CLLocationCoordinate2D(latitude: 40.356219, longitude: -94.881954),descriptionVar: "living zone ")
        b.append(p1)
        a.append(b[0].title!!)
        c.append(b[0].subtitle!!)
        var p2 = DestinationLocationClass(title: "Walmart",addressVar: "Super market",coordinate: CLLocationCoordinate2D(latitude: 40.356219, longitude: -94.881954),descriptionVar: "shopping ")
        b.append(p2)
        a.append(b[1].title!!)
        c.append(b[1].subtitle!!)
        var p3 = DestinationLocationClass(title: "Hy-Vee",addressVar: "Shopping",coordinate: CLLocationCoordinate2D(latitude: 40.356219, longitude: -94.881954),descriptionVar: "Groceries ")
        b.append(p3)
        a.append(b[2].title!!)
        c.append(b[2].subtitle!!)
    }
    
}
