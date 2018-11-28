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
//    DestinationLocationClass.annotateArray[0].coordinate
    var b:[MKAnnotation] = (DestinationLocationClass.annotateArray)
    var a:[String] = []
    var c:[String] = []
    

    @IBAction func deleteAll(_ sender: Any) {
        let  alert  =  UIAlertController(title:  "Alert",  message:  "Are you sure you want to delete everything",  preferredStyle:  .alert)
        alert.addAction(UIAlertAction(title:  "Cancel",  style:  .default,  handler: nil))
        alert.addAction(UIAlertAction(title:  "Delete",  style:  .default,  handler:
            {
                action in DestinationLocationClass.annotateArray = []
                self.tableView.reloadData()

        }
        ))
         self.present(alert,  animated:  true,  completion:  nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DestinationLocationClass.annotateArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pinCells", for: indexPath)

        cell.textLabel?.text = ((DestinationLocationClass.annotateArray[indexPath.row].title)!!)
        cell.detailTextLabel?.text = ("\(DestinationLocationClass.annotateArray[indexPath.row].subtitle!!)) \(Int((DestinationLocationClass.distanceVar ?? 0)*100)/100)")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  alert  =  UIAlertController(title:  "Alert",  message:  "Do you want to delete this",  preferredStyle:  .alert)
        alert.addAction(UIAlertAction(title:  "Cancel",  style:  .default,  handler: nil))
        alert.addAction(UIAlertAction(title:  "Delete",  style:  .default,  handler:
            {
            action in     DestinationLocationClass.annotateArray.remove(at: indexPath.item )
            tableView.reloadData()

        }
        ))
        self.present(alert,  animated:  true,  completion:  nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }


    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
 
           
            let  alert  =  UIAlertController(title:  "Alert",  message:  "Do you want to delete this",  preferredStyle:  .alert)
            alert.addAction(UIAlertAction(title:  "Cancel",  style:  .default,  handler: nil))
            alert.addAction(UIAlertAction(title:  "Delete",  style:  .default,  handler:
                {
                    action in     DestinationLocationClass.annotateArray.remove(at: indexPath.item )
                    tableView.reloadData()
                    
            }
            ))
            DestinationLocationClass.annotateArray.remove(at: indexPath.row )
             completionHandler(true)
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
}
