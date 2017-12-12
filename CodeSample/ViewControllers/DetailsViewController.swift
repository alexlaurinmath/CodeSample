//
//  DetailsViewController.swift
//  CodeSample
//
//  Created by Alexandre Laurin on 12/9/17.
//  Copyright © 2017 Snacktime. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var measurement:Measurement?
    @IBOutlet weak var measurementView: MeasurementView!
    
    @IBOutlet weak var trendsView: TrendsView!
    @IBOutlet weak var date1: UILabel!
    @IBOutlet weak var date2: UILabel!
    @IBOutlet weak var date3: UILabel!
    @IBOutlet weak var date4: UILabel!
    @IBOutlet weak var date5: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var graphYData:[Double] = []
        var graphXData:[Double] = []
        
        if let _measurement = measurement {
            measurementView.nameLabel.text = _measurement.name
            measurementView.detailLabel.text = _measurement.detail
            measurementView.valueLabel.text = "\(_measurement.value ?? 0)"
            
            for recording in _measurement.recordings {
                if let oneRepMax = recording.oneRepMax, let date = recording.date {
                    graphYData.append(Double(oneRepMax))
                    graphXData.append(date.timeIntervalSince1970)
                }
            }
        }
        
        trendsView.graphXData = graphXData
        trendsView.graphYData = graphYData
        trendsView.setWidth = self.view.frame.width
        trendsView.setupGraph()
        trendsView.addSegment(x: trendsView.graphXData, y: trendsView.graphYData)
        trendsView.setNeedsDisplay()
        
        // min and max labels
        if let maxValue = trendsView.graphYData.max() {
            maxLabel.text = "\(Int(maxValue))"
        }
        if let minValue = trendsView.graphYData.min(){
            minLabel.text = "\(Int(minValue))"
        }
        
        // date labels
        handleDateInterval()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        date3.center.y = date1.center.y
        date3.center.x = (date1.center.x + date5.center.x)/2 + date3.frame.width/2
        date2.center.x = (date1.center.x + date3.center.x)/2
        date4.center.x = (date3.center.x + date5.center.x)/2 + date4.frame.width/2
        
        date2.textColor = UIColor.clear
        date3.textColor = UIColor.clear
        date4.textColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleDateInterval() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = recordingDateFormat
        var dates:[Date] = []
        if let _measurement = measurement {
            for recording in _measurement.recordings {
                if let date = recording.date {
                    dates.append(date)
                }
            }
        }
        if dates.count > 0 {
            if let firstDate =  dates.first, let lastDate = dates.last {
                
                // check if the year is the same
                dateFormatter.dateFormat = "yyyy"
                let firstYear = dateFormatter.string(from: firstDate)
                let lastYear = dateFormatter.string(from: lastDate)
                if firstYear  == lastYear {
                    // check if the month is the same
                    dateFormatter.dateFormat = "MMM"
                    let firstMonth = dateFormatter.string(from: firstDate)
                    let lastMonth = dateFormatter.string(from: lastDate)
                    if firstMonth == lastMonth {
                        
                        // check if the day is the same
                        dateFormatter.dateFormat = "dd MMM"
                        let firstDay = dateFormatter.string(from: firstDate)
                        let lastDay = dateFormatter.string(from: lastDate)
                        if firstDay == lastDay {
                            
                            // check if the day is the same
                            dateFormatter.dateFormat = "hh:mm"
                            let firstMinute = dateFormatter.string(from: firstDate)
                            let lastMinute = dateFormatter.string(from: lastDate)
                            
                            date1.text = firstMinute
                            date5.text = lastMinute
                            
                        } else {
                            date1.text = firstDay
                            date5.text = lastDay
                        }
                    } else {
                        date1.text = firstMonth
                        date5.text = lastMonth
                    }
                } else {
                    dateFormatter.dateFormat = "MMM yyyy"
                    let firstYear = dateFormatter.string(from: firstDate)
                    let lastYear = dateFormatter.string(from: lastDate)
                    date1.text = firstYear
                    date5.text = lastYear
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
