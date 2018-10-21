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

    
    
   let a = ["p1","p2","p3","p4","p5"]
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
        let model = DestinationLocationClass.destinationLocation.address()
        cell.textLabel?.text = a[indexPath.row]
        cell.detailTextLabel?.text = "\(String(describing: model))"
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }


}
