//
//  MeasurementTableViewController.swift
//  CodeSample
//
//  Created by Alexandre Laurin on 12/9/17.
//  Copyright © 2017 Snacktime. All rights reserved.
//

import UIKit

class MeasurementTableViewController: UITableViewController {

    var measurements:[Measurement] = []
    let dataLoader = DataLoader()
    var selectedCell:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load cell nibs
        tableView.register(UINib(nibName: "MeasurementCellNib", bundle: nil), forCellReuseIdentifier: "measurementCell")
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentChangedNotification(_:)),
            name: NSNotification.Name(rawValue: dataManagerMeasurementsChangedNotification),
            object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataManager.shared.measurements.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "measurementCell", for: indexPath) as! MeasurementTableViewCell
        // Configure the cell...
        let measurements = DataManager.shared.measurements
        let measurement = measurements[indexPath.row]
        
        cell.measurementView.nameLabel.text = measurement.name
        cell.measurementView.detailLabel.text = measurement.detail
        cell.measurementView.valueLabel.text = "\(measurement.value ?? 0)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath
        self.performSegue(withIdentifier: "measurementDetailsSegue", sender: self.tableView(self.tableView, cellForRowAt: indexPath))
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "measurementDetailsSegue"{
            if let detailsViewController = segue.destination as? DetailsViewController, let indexPath = selectedCell {
                let measurements = DataManager.shared.measurements
                let measurement = measurements[indexPath.row]
                detailsViewController.measurement = measurement
            }
        }
    }

}

extension MeasurementTableViewController {
    @objc func contentChangedNotification(_ notification: Notification!) {
        tableView.reloadData()
    }
}
