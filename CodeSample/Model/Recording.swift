//
//  Recording.swift
//  CodeSample
//
//  Created by Alexandre Laurin on 12/9/17.
//  Copyright © 2017 Snacktime. All rights reserved.
//

import Foundation

let recordingDateFormat = "MMM dd yyyy"

class Recording {
    var date:Date?
    var name:String?
    var numberOfSets:Int?
    var numberOfReps:[Int] = []
    var weights:[Int] = []
    var oneRepMax:Int?
    
    func computeOneRepMax() {
        if let _numberOfSets = numberOfSets {
            if _numberOfSets > 0 {
                var oneRepMaxArray:[Double] = []
                for setIndex in 0..<_numberOfSets {
                    
                    if setIndex < weights.count && setIndex < numberOfReps.count {
                        oneRepMaxArray.append(Double(weights[setIndex])*36/(37 - Double(numberOfReps[setIndex]))) // Brzycki formula
                    } else {
                        print("There was either not enough weights or not enough number of reps when computing one rep max for \(name ?? "unkown recording")")
                    }
                }
                // daily value taken as mean of individual values
                if oneRepMaxArray.count > 0 {
                    oneRepMax = Int(oneRepMaxArray.reduce(0,+)/Double(oneRepMaxArray.count))
                }
            } else {
                print("The number of sets was 0")
            }
        }
    }
}
