//
//  DataLoader.swift
//  CodeSample
//
//  Created by Alexandre Laurin on 12/9/17.
//  Copyright © 2017 Snacktime. All rights reserved.
//

import Foundation


class DataLoader {
    
    func loadData(withFileName:String) -> [Recording] {
        
        var recordings:[Recording] = []
        
        // load text file as data
        let bundle = Bundle.main
        let path = bundle.path(forResource: withFileName, ofType: "txt")
        var data: String?
        
        // turn data into a String
        do {
            data = try String(contentsOfFile:path!, encoding:String.Encoding.utf8)
        } catch _ as NSError {
            data = "Oct 11 2017,Linear Kinetic Energy,1,10,45"
        }
        
        // split in rows
        let rows = data!.components(separatedBy: "\r\n")
        for row in rows {
            let recording = Recording()
            let elements = row.components(separatedBy: ",")
            
            // go through the row and set recording variables from input
            for elemIndex in 0..<elements.count {
                switch elemIndex {
                    case 0:
                        recording.date = recordingDate(fromString: elements[elemIndex])
                    case 1:
                        recording.name = elements[elemIndex]
                    case 2:
                        recording.numberOfSets = Int(elements[elemIndex])
                    case 3:
                        if let numberOfReps = Int(elements[elemIndex]) {
                            recording.numberOfReps.append(numberOfReps)
                        } else {
                            print("problem with number of reps in data loader")
                        }
                    case 4:
                        if let weight = Int(elements[elemIndex]) {
                            recording.weights.append(weight)
                        } else {
                            print("problem with weight in data loader")
                        }
                    default:
                        print("no preset translation for element \(elements[elemIndex]) at index \(elemIndex)")
                }
            }
            if let _ = recording.name, let _ = recording.date, let _ = recording.numberOfSets {
                recordings.append(recording)
            }
        }
        return recordings
    }
    
    func parseRecordings(_ recordings:[Recording]) -> [Measurement] {
        var measurements:[Measurement] = []
        for recording in recordings {
            if measurements.count > 0 {
                // check if that kind of measurement has already been logged
                var measurementDidExist:Bool = false
                for measurement in measurements {
                    if measurement.name == recording.name {
                        measurementDidExist = true
                        measurement.recordings.append(recording)
                    }
                }
                // if no such measurement exists, create one
                if !measurementDidExist && recording.name != nil {
                    print("found new recording with name \(recording.name ?? "no name")")
                    let measurement = Measurement()
                    measurement.name = recording.name
                    if measurement.name == "Cardiac Output" {
                        measurement.detail = "One Rep Max ● ml"
                    }
                    measurement.recordings = []
                    measurement.recordings.append(recording)
                    measurements.append(measurement)
                }
            } else if recording.name != nil {
                // create the first measurement
                print("found first recording with name \(recording.name ?? "no name")")
                let measurement = Measurement()
                measurement.name = recording.name
                if measurement.name == "Cardiac Output" {
                    measurement.detail = "One Rep Max ● ml"
                }
                measurement.recordings = []
                measurement.recordings.append(recording)
                measurements.append(measurement)
            }
        }
        return measurements
    }
    
    private func recordingDate(fromString:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = recordingDateFormat
        let date = dateFormatter.date(from: fromString)
        return date
    }
}
