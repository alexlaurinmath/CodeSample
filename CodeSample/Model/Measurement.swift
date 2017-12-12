//
//  Erercise.swift
//  CodeSample
//
//  Created by Alexandre Laurin on 12/9/17.
//  Copyright © 2017 Snacktime. All rights reserved.
//

import Foundation

class Measurement {
    var name: String?
    var detail: String = "One Rep Max ● mJ"
    var recordings:[Recording] = []
    var value: Int?
    
    func mergeDailyValues() {
        // all recordings that were done on the same day should actually be the same recording
        sortRecordings()
        if recordings.count > 0 {
            var tempRecordings:[Recording] = [recordings[0]]
            for recordingIndex in 1..<recordings.count {
                let _recording = recordings[recordingIndex]
                // check for same date, only check last because they are sorted
                if _recording.date == tempRecordings.last!.date {
                    if let minCount = [_recording.numberOfReps.count,_recording.weights.count].min() {
                        // deal with number of sets
                        if let _numberOfSets = _recording.numberOfSets {
                            for _ in 0..<_numberOfSets {
                            //update number of sets
                                if let _ = tempRecordings.last!.numberOfSets {
                                    tempRecordings.last!.numberOfSets! += minCount
                                } else {
                                    tempRecordings.last!.numberOfSets = minCount
                                }
                                // update number of reps and weights
                                for count in 0..<minCount {
                                    tempRecordings.last!.numberOfReps.append(_recording.numberOfReps[count])
                                    tempRecordings.last!.weights.append(_recording.weights[count])
                                }
                            }
                        }
                    }
                } else {
                    // create recording, deal with number of sets
                    if let _numberOfSets = _recording.numberOfSets {
                        for _ in 0..<_numberOfSets {
                            let singleSetRecording = _recording
                            singleSetRecording.numberOfSets = 1
                            tempRecordings.append(singleSetRecording)
                        }
                    }
                }
            }
            recordings = tempRecordings
        }
    }
    
    func computeOneRepMax() {
        var allValues:[Int] = []
        // obtain
        for recording in self.recordings{
            recording.computeOneRepMax()
            if recording.oneRepMax != nil {
                allValues.append(recording.oneRepMax!)
            }
        }
        if allValues.count > 0 {
            self.value = allValues.reduce(0,+)/allValues.count
        }
    }
    
    // sort all recordings according to date
    func sortRecordings(){
        var dates:[Double] = []
        for recording in recordings {
            if let _date = recording.date {
                dates.append(_date.timeIntervalSince1970)
            } else {
                print("No date for recording with name \(recording.name ?? "unkown name")")
            }
        }
        // use zip to combine the two arrays and sort that based on the first
        let combined = zip(dates, recordings).sorted {$0.0 < $1.0}
        recordings = combined.map {$0.1}
    }
}
