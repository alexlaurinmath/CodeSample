//
//  MeasurementManager.swift
//  CodeSample
//
//  Created by Alexandre Laurin on 12/11/17.
//  Copyright © 2017 Snacktime. All rights reserved.
//

import Foundation

let recordingDataFileName: String = "Data"

// Notification when measurements are modified
let dataManagerMeasurementsChangedNotification = "dataManagerMeasurementsChanged"

// Measurement Manager singleton
private let _shared = DataManager()

final class DataManager {
    
    class var shared: DataManager {
        return _shared
    }
    
    fileprivate var _measurements: [Measurement] = []
    
    fileprivate let measurementQueue =
        DispatchQueue(
            label: "measurementQueue",
            attributes: .concurrent)
    
    var measurements: [Measurement] {
        // handling readers, writers problem
        var measurementsCopy: [Measurement]!
        measurementQueue.sync {
            measurementsCopy = self._measurements
        }
        return measurementsCopy
    }
    
    let dataLoader = DataLoader()
    
    init() {
        loadAllRecordings()
    }
    
    func updateMeasurements(with:[Measurement]) {
        
        measurementQueue.async(flags: .barrier) {
            self._measurements = with
            DispatchQueue.main.async {
                self.postMeasurementsChangedNotification()
            }
        }
    }
    
    func loadAllRecordings() {
        print("Loading Recordings.")
        self._measurements = []
            // read recording data text file
            let recordings = self.dataLoader.loadData(withFileName: recordingDataFileName)
            // parse recording data to obtain measurements
            var tempMeasurements = self.dataLoader.parseRecordings(recordings)
            updateMeasurements(with: tempMeasurements)
            tempMeasurements = self.mergeMeasurements(tempMeasurements)
            updateMeasurements(with: tempMeasurements)
            tempMeasurements = self.computeOneRepMaxForAll(tempMeasurements)
            updateMeasurements(with: tempMeasurements)
    }
    
    private func mergeMeasurements(_ mergeMeasurements:[Measurement]) -> [Measurement] {
        print("merging daily values")
        // merge all recordings that were done the same day
        for measurement in mergeMeasurements {
            measurement.mergeDailyValues()
        }
        return mergeMeasurements
    }
    
    private func computeOneRepMaxForAll(_ oneRepMaxMeasurements:[Measurement]) -> [Measurement] {
        print("computing one rep max")
        for measurement in oneRepMaxMeasurements {
            measurement.computeOneRepMax()
        }
        
        return oneRepMaxMeasurements
    }
    
    fileprivate func postMeasurementsChangedNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: dataManagerMeasurementsChangedNotification), object: nil)
    }
}

/*
 ______________$$$$$$$$$$____________________
 _____________$$__$_____$$$$$________________
 _____________$$_$$__$$____$$$$$$$$__________
 ____________$$_$$__$$$$$________$$$_________
 ___________$$_$$__$$__$$_$$$__$$__$$________
 ___________$$_$$__$__$$__$$$$$$$$__$$_______
 ____________$$$$$_$$_$$$_$$$$$$$$_$$$_______
 _____________$$$$$$$$$$$$$_$$___$_$$$$______
 ________________$$_$$$______$$$$$_$$$$______
 _________________$$$$_______$$$$$___$$$_____
 ___________________________$$_$$____$$$$____
 ___________________________$$_$$____$$$$$___
 __________________________$$$$$_____$$$$$$__
 _________________________$__$$_______$$$$$__
 ________________________$$$_$$________$$$$$_
 ________________________$$$___________$$$$$_
 _________________$$$$___$$____________$$$$$$
 __$$$$$$$$____$$$$$$$$$$_$____________$$$_$$
 _$$$$$$$$$$$$$$$______$$$$$$$___$$____$$_$$$
 $$________$$$$__________$_$$$___$$$_____$$$$
 $$______$$$_____________$$$$$$$$$$$$$$$$$_$$
 $$______$$_______________$$_$$$$$$$$$$$$$$$_
 $$_____$_$$$$$__________$$$_$$$$$$$$$$$$$$$_
 $$___$$$__$$$$$$$$$$$$$$$$$__$$$$$$$$$$$$$__
 $$_$$$$_____$$$$$$$$$$$$________$$$$$$__$___
 $$$$$$$$$$$$$$_________$$$$$______$$$$$$$___
 $$$$_$$$$$______________$$$$$$$$$$$$$$$$____
 $$__$$$$_____$$___________$$$$$$$$$$$$$_____
 $$_$$$$$$$$$$$$____________$$$$$$$$$$_______
 $$_$$$$$$$hg$$$____$$$$$$$$__$$$____________
 $$$$__$$$$$$$$$$$$$$$$$$$$$$$$______________
 $$_________$$$$$$$$$$$$$$$__________________
 */
