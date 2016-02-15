//
//  HealthKitRecordTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/27/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import HealthKit
import Fuzi

class HealthKitRecordTest: XCTestCase {
    
  override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }
  
  func testHealthKitTermMap() {
    
    //HDSHealthKitCodeReference.sharedInstance.loadHealthKitTermMap(withPlist: <#T##NSDictionary#>)

  }

  func testRoundTrip() {
    let aRecord = HDSRecord()
    aRecord.title = "Mr."
    aRecord.first = "Jimbo"
    aRecord.last = "Jones"
    
    let anAllergy = HDSAllergy()
    anAllergy.codes.addCodes("LOINC", codes: ["abc123"])
    
    let aVital = HDSVitalSign()
    aVital.codes.addCodes("LOINC", codes: ["3141-9"]) //weight
    aVital.values.append(HDSPhysicalQuantityResultValue(scalar: 155.0, units: "lb"))
    aVital.start_time = NSDate().timeIntervalSince1970
    aVital.end_time = NSDate().timeIntervalSince1970
    
    //let xmlString = aRecord.export(inFormat: .ccda)
    //print(xmlString)
    
    let hkRecord = HDSHKRecord(fromHDSRecord: aRecord)
    
    XCTAssertEqual(hkRecord.healthKitSamples.count, aRecord.vital_signs.count)
    
    //HKQuantityTypeIdentifierHeight
    let aUnit = HKUnit(fromString: "in")
    let aQty = HKQuantity(unit: aUnit, doubleValue: 72 )
    let aQtyType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
    let hkHeight = HKQuantitySample(type: aQtyType!, quantity: aQty, startDate: NSDate(), endDate: NSDate())
    hkRecord.healthKitSamples.append(hkHeight)
    //print(hkRecord)
    
    //NOTE: for now you need to make sure you set the units before you import the record
    // the unit types, etc. are set on the way _in_
    HDSHealthKitCodeReference.sharedInstance.HDSHKQuantityTypeDefaultUnits["HKQuantityTypeIdentifierHeight"] = "cm"
    let aSecondRecord = hkRecord.exportAsHDSRecord()
    //HDSHKQuantityTypeDefaultUnits
    //HDSHealthKitCodeReference.sharedInstance.HDSHKQuantityTypeDefaultUnits)
    print(aSecondRecord.export(inFormat: .c32))
    
    XCTAssertEqual(hkRecord.healthKitSamples.count, aSecondRecord.vital_signs.count)
  }
  
  //trying our failable HKUnit constructor for weird CDA string variants
  func testBogusHKUnit() {
    
    let badUnitString = "bogusUnit"
    let aBadUnit = HDSHealthKitBridge.unitForCDAString(badUnitString)
    
    let goodUnitString = "%"
    let aGoodUnit = HDSHealthKitBridge.unitForCDAString(badUnitString)
    
  }
  
  func testSampleTypes() {
    let bmi: Double = 24.1
    let bmiType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)
    let bmiQuantity = HKQuantity(unit: HKUnit.countUnit(), doubleValue: bmi)
    let bmiSample = HKQuantitySample(type: bmiType!, quantity: bmiQuantity, startDate: NSDate(), endDate: NSDate())
    print(bmiSample)
  }
  
  func testImportingFromCCD() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Patient-673")
    do {
      let record = try HDSImport_BulkRecordImporter.importRecord(doc)
      let hkRecord = HDSHKRecord(fromHDSRecord: record)
      print(hkRecord.healthKitSamplesDescription)
      
      let hdsRecord = hkRecord.exportAsHDSRecord()
      print(hdsRecord)
    }
    catch {
      XCTFail()
    }

  }

  func testImportingFromCCD_2() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Vitera_CCDA_SMART_Sample")

    
    do {
      let record = try HDSImport_BulkRecordImporter.importRecord(doc)
      let hkRecord = HDSHKRecord(fromHDSRecord: record)
      print(hkRecord.healthKitSamplesDescription)
      
      let hdsRecord = hkRecord.exportAsHDSRecord()
      print(hdsRecord)
      
      print(hdsRecord.export(inFormat: .ccda))
    }
    catch {
      XCTFail()
    }

  }


  func testImportingFromCCD_4() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Rosa.ccda")
    do {
      let record = try HDSImport_BulkRecordImporter.importRecord(doc)
      //print(record)
      //  print(HDSHealthKitCodeReference.sharedInstance.HDSHKTypeConceptsImport["HKQuantityTypeIdentifierBodyMassIndex"])
      let hkRecord = HDSHKRecord(fromHDSRecord: record)
      print(hkRecord.healthKitSamplesDescription)
      
      let hdsRecord = hkRecord.exportAsHDSRecord()
      print(hdsRecord)
      
    }
    catch {
      XCTFail()
    }

    
  }

  
  func testCreatingHKRecord() {
    
    let patient = HDSRecord()
    patient.first = "Jimbo"
    patient.last = "Jones"
    patient.gender = "M"
    
    let dates: [Double] = [1390666620, 1453824900, 1453825020]
    
    for x in dates {
      let hds_hrEntry = HDSVitalSign()
      hds_hrEntry.start_time = x
      hds_hrEntry.end_time = x
      hds_hrEntry.values.append(HDSPhysicalQuantityResultValue(scalar: 86, units: "count/min"))
      hds_hrEntry.codes.addCodes("LOINC", codes: "8867-4")
      patient.vital_signs.append(hds_hrEntry)
    }
    
    let hkRecord = HDSHKRecord(fromHDSRecord: patient)
    print(hkRecord)
    
    
    // we want to define a heart rate
    //  as a unit - count/min
    //  and a value - 86
    let hr_value: Double = 86
    let hr_unit = "count/min"
    
    // we can construct an HDS representation of that value
    let hds_hr = HDSPhysicalQuantityResultValue(scalar: 86, units: hr_unit)
    
    // and we can build a HealthKit version
    let hk_hr: HKQuantity = HKQuantity(unit: HKUnit(fromString: hr_unit), doubleValue: hr_value)
    
    
    
    
    print(hds_hr)
    print(hk_hr)
    
    //HDSHealthKitBridge.heartRate
  }

  
  func testCreatingHKVital() {
    let hds_hrEntry = HDSVitalSign()
    hds_hrEntry.start_time = 1390666620
    hds_hrEntry.end_time = 1390666620
    hds_hrEntry.values.append(HDSPhysicalQuantityResultValue(scalar: 86, units: "count/min"))
    hds_hrEntry.codes.addCodes("LOINC", codes: "8867-4")
    
    //let hk_hrEntry = HDSHealthKitBridge.heartRate(hds_hrEntry)
    let hk_hrEntry = HDSHealthKitBridge.sampleForEntry(hds_hrEntry, forSampleType: HDSHealthKitBridge.HDSHKQuantityIdentifiers.HKQuantityTypeIdentifierHeartRate)
    print("hk_hrEntry is set to \(hk_hrEntry)")
    
    //HDSHealthKitBridge.heartRate
  }

  func testDefaults_HKSampleType_units() {
    print(HDSHealthKitCodeReference.sharedInstance.HDSHKQuantityTypeDefaultUnits)
  }

  func testDefaults_HKSampleType_descriptions() {
    print(HDSHealthKitCodeReference.sharedInstance.HDSHKQuantityTypeDescriptions)
  }


  
}
