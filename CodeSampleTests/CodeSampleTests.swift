//
//  CodeSampleTests.swift
//  CodeSampleTests
//
//  Created by Alexandre Laurin on 12/10/17.
//  Copyright © 2017 Snacktime. All rights reserved.
//

import XCTest
@testable import CodeSample

class CodeSampleTests: XCTestCase {
    
    var dataLoaderUnderTest: DataLoader!
    var measurementTableViewControllerUnderTest: MeasurementTableViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //        let bundle = Bundle.main
        //        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        
        dataLoaderUnderTest = DataLoader()
        measurementTableViewControllerUnderTest = MeasurementTableViewController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        dataLoaderUnderTest = nil
        measurementTableViewControllerUnderTest = nil
    }
    
    func testRecordingDataIsLoaded() {
        let numberOfAddedRecordings:Int = 582
        let recordings = dataLoaderUnderTest.loadData(withFileName: "Data")
        XCTAssertEqual(recordings.count,numberOfAddedRecordings,"The number of recordings from data is wrong.")
        
        for recording in recordings {
            XCTAssertNotNil(recording.name,"Name missing for a recording with date \(recording.date ?? Date())")
            XCTAssertNotNil(recording.date,"Date missing for a recording with name \(recording.name ?? "no name")")
            XCTAssertNotNil(recording.numberOfReps,"Missing number of reps for a recording with name \(recording.name ?? "no name")")
            XCTAssertNotNil(recording.numberOfSets,"Missing number of sets for a recording with name \(recording.name ?? "no name")")
            XCTAssertNotNil(recording.weights,"Missing weights for a recording with name \(recording.name ?? "no name")")
        }
    }
    
    func testMeasurementsAreCreated() {
        let numberOfAddedMeasurements:Int = 3
        let measurementNames = ["Linear Kinetic Energy","Rotational Kinetic Energy","Linear Kinetic Energy"]
        let recordings = dataLoaderUnderTest.loadData(withFileName: "Data")
        let measurements = dataLoaderUnderTest.parseRecordings(recordings)
        XCTAssertEqual(measurements.count,numberOfAddedMeasurements,"The measurements are not getting created properly by the recordings.")
        for measurementIndex in 0..<measurements.count {
            XCTAssertNotNil(measurementNames.index(of: measurementNames[measurementIndex]),"Measurement names are getting misplaced.")
        }
    }
    
    func testMergeDailyValues() {
        let numberOfAddedMeasurements:Int = 3
        let measurementNumberOfDays = ["Linear Kinetic Energy":30, "Rotational Kinetic Energy":30, "Cardiac Output":28]
        let recordings = dataLoaderUnderTest.loadData(withFileName: "Data")
        let measurements = dataLoaderUnderTest.parseRecordings(recordings)
        for measurement in measurements {
            measurement.mergeDailyValues()
        }
        XCTAssertEqual(measurements.count,numberOfAddedMeasurements,"Number of measurements should not be altered from merging.")
        for measurement in measurements {
            XCTAssertEqual(measurement.recordings.count, measurementNumberOfDays[measurement.name!], "number of recording days for \(measurement.name ?? "unkown name") is wrong.")
        }
    }
    
    func testComputeOneRepMax() {
        let measurementValuesDict = ["Linear Kinetic Energy":217, "Rotational Kinetic Energy":179, "Cardiac Output":254]
        let recordings = dataLoaderUnderTest.loadData(withFileName: "Data")
        let measurements = dataLoaderUnderTest.parseRecordings(recordings)
        for measurement in measurements {
            measurement.mergeDailyValues()
            measurement.computeOneRepMax()
        }
        
        for measurement in measurements {
            XCTAssertEqual(measurement.value, measurementValuesDict[measurement.name!], "one rep max not computing correctly for \(measurement.name ?? "unknown name")")
        }
    }
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}

