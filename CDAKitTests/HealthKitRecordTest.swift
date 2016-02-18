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
    
    //CDAKHealthKitBridge.sharedInstance.loadHealthKitTermMap(withPlist: <#T##NSDictionary#>)

  }

  
  func testCCDAToHealthKitToCCDAWithUnitConversion() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Patient-673")
    do {
      
      //let's try to import from CDA
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      
      //let's create a new vital
      // use the coded values to govern "meaning" (height, weight, BMI, BP items, etc.)
      let aVital = CDAKVitalSign()
      aVital.codes.addCodes("LOINC", codes: ["3141-9"]) //weight
      aVital.values.append(CDAKPhysicalQuantityResultValue(scalar: 155.0, units: "lb"))
      aVital.start_time = NSDate().timeIntervalSince1970
      aVital.end_time = NSDate().timeIntervalSince1970

      //append our height to our record
      record.vital_signs.append(aVital)

      //OK, let's convert our HDS record to HealthKit
      let hkRecord = CDAKHKRecord(fromCDAKRecord: record)
      
      //let's explicitly set our preferred units to metric for a few things
      CDAKHealthKitBridge.sharedInstance.CDAKHKQuantityTypeDefaultUnits[.HKQuantityTypeIdentifierHeight] = "cm"
      CDAKHealthKitBridge.sharedInstance.CDAKHKQuantityTypeDefaultUnits[.HKQuantityTypeIdentifierBodyMass] = "kg"
      
      for sample in hkRecord.samples {
        print(sample.metadata)
      }
      
      //now let's convert back from HealthKit to our model
      let hdsRecord = hkRecord.exportAsCDAKRecord()
      
      //render from our model to CDA - format set to .ccda (could also do .c32)
      //print(hdsRecord.export(inFormat: .ccda))
    }
    catch {
      XCTFail()
    }
  }
  
  func testRoundTrip() {
    let aRecord = CDAKRecord()
    aRecord.title = "Mr."
    aRecord.first = "Jimbo"
    aRecord.last = "Jones"
    
    let anAllergy = CDAKAllergy()
    anAllergy.codes.addCodes("LOINC", codes: ["abc123"])
    
    let aVital = CDAKVitalSign()
    aVital.codes.addCodes("LOINC", codes: ["3141-9"]) //weight
    aVital.values.append(CDAKPhysicalQuantityResultValue(scalar: 155.0, units: "lb"))
    aVital.start_time = NSDate().timeIntervalSince1970
    aVital.end_time = NSDate().timeIntervalSince1970
    
    //let xmlString = aRecord.export(inFormat: .ccda)
    //print(xmlString)
    
    let hkRecord = CDAKHKRecord(fromCDAKRecord: aRecord)
    
    XCTAssertEqual(hkRecord.samples.count, aRecord.vital_signs.count)
    
    //HKQuantityTypeIdentifierHeight
    let aUnit = HKUnit(fromString: "in")
    let aQty = HKQuantity(unit: aUnit, doubleValue: 72 )
    let aQtyType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
    let hkHeight = HKQuantitySample(type: aQtyType!, quantity: aQty, startDate: NSDate(), endDate: NSDate())
    hkRecord.samples.append(hkHeight)
    //print(hkRecord)
    
    //NOTE: for now you need to make sure you set the units before you import the record
    // the unit types, etc. are set on the way _in_
    CDAKHealthKitBridge.sharedInstance.CDAKHKQuantityTypeDefaultUnits[.HKQuantityTypeIdentifierHeight] = "cm"
    let aSecondRecord = hkRecord.exportAsCDAKRecord()
    //CDAKHKQuantityTypeDefaultUnits
    //CDAKHealthKitBridge.sharedInstance.CDAKHKQuantityTypeDefaultUnits)
    print(aSecondRecord.export(inFormat: .ccda))
    
    XCTAssertEqual(hkRecord.samples.count, aSecondRecord.vital_signs.count)
  }
  
  //trying our failable HKUnit constructor for weird CDA string variants
  func testBogusHKUnit() {
    
    let badUnitString = "bogusUnit"
    let aBadUnit = CDAKHealthKitBridge.sharedInstance.unitForCDAString(badUnitString)
    
    let goodUnitString = "%"
    let aGoodUnit = CDAKHealthKitBridge.sharedInstance.unitForCDAString(badUnitString)
    
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
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      let hkRecord = CDAKHKRecord(fromCDAKRecord: record)
      print(hkRecord.samplesDescription)
      
      let hdsRecord = hkRecord.exportAsCDAKRecord()
      print(hdsRecord)
    }
    catch {
      XCTFail()
    }

  }

  func testImportingFromCCD_2() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Vitera_CCDA_SMART_Sample")

    
    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      let hkRecord = CDAKHKRecord(fromCDAKRecord: record)
      print(hkRecord.samplesDescription)
      
      let hdsRecord = hkRecord.exportAsCDAKRecord()
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
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      //print(record)
      //  print(CDAKHealthKitBridge.sharedInstance.CDAKHKTypeConceptsImport["HKQuantityTypeIdentifierBodyMassIndex"])
      let hkRecord = CDAKHKRecord(fromCDAKRecord: record)
      print(hkRecord.samplesDescription)
      
      let hdsRecord = hkRecord.exportAsCDAKRecord()
      print(hdsRecord)
      
    }
    catch {
      XCTFail()
    }

    
  }

  
  func testCreatingHKRecord() {
    
    let patient = CDAKRecord()
    patient.first = "Jimbo"
    patient.last = "Jones"
    patient.gender = "M"
    
    let dates: [Double] = [1390666620, 1453824900, 1453825020]
    
    for x in dates {
      let hds_hrEntry = CDAKVitalSign()
      hds_hrEntry.start_time = x
      hds_hrEntry.end_time = x
      hds_hrEntry.values.append(CDAKPhysicalQuantityResultValue(scalar: 86, units: "count/min"))
      hds_hrEntry.codes.addCodes("LOINC", codes: "8867-4")
      patient.vital_signs.append(hds_hrEntry)
    }
    
    let hkRecord = CDAKHKRecord(fromCDAKRecord: patient)
    print(hkRecord)
    
    
    // we want to define a heart rate
    //  as a unit - count/min
    //  and a value - 86
    let hr_value: Double = 86
    let hr_unit = "count/min"
    
    // we can construct an CDAK representation of that value
    let hds_hr = CDAKPhysicalQuantityResultValue(scalar: 86, units: hr_unit)
    
    // and we can build a HealthKit version
    let hk_hr: HKQuantity = HKQuantity(unit: HKUnit(fromString: hr_unit), doubleValue: hr_value)
    
    
    
    
    print(hds_hr)
    print(hk_hr)
    
    //CDAKHealthKitBridge.heartRate
  }

  
  func testCreatingHKVital() {
    let hds_hrEntry = CDAKVitalSign()
    hds_hrEntry.start_time = 1390666620
    hds_hrEntry.end_time = 1390666620
    hds_hrEntry.values.append(CDAKPhysicalQuantityResultValue(scalar: 86, units: "count/min"))
    hds_hrEntry.codes.addCodes("LOINC", codes: "8867-4")
    
    //let hk_hrEntry = CDAKHealthKitBridge.heartRate(hds_hrEntry)
    let hk_hrEntry = CDAKHealthKitBridge.sharedInstance.sampleForEntry(hds_hrEntry, forSampleType: CDAKHealthKitBridge.CDAKHKQuantityIdentifiers.HKQuantityTypeIdentifierHeartRate)
    print("hk_hrEntry is set to \(hk_hrEntry)")
    
    //CDAKHealthKitBridge.heartRate
  }

  func testDefaults_HKSampleType_units() {
    print(CDAKHealthKitBridge.sharedInstance.CDAKHKQuantityTypeDefaultUnits)
  }
  
  func testDefaults_HKSampleType_types() {
    print(CDAKHealthKitBridge.sharedInstance.CDAKHKQuantityTypeDefaultTypes)
  }

  func testDefaults_HKSampleType_descriptions() {
    print(CDAKHealthKitBridge.sharedInstance.CDAKHKQuantityTypeDescriptions)
  }


  func testCustomBridgeCDAStringFinder() {
    //var cdaStringUnitFinder : ((unit_string: String?, typeIdentifier: String? ) -> HKUnit?)?
    
    var cdaStringUnitFinder_nil : ((unit_string: String?, typeIdentifier: String? ) -> HKUnit?) = {
      (unit_string: String?, typeIdentifier: String?) -> HKUnit? in
      
      return nil
    }
    
    CDAKHealthKitBridge.sharedInstance.cdaStringUnitFinder = cdaStringUnitFinder_nil
    
    let hds_hrEntry = CDAKVitalSign()
    hds_hrEntry.start_time = 1390666620
    hds_hrEntry.end_time = 1390666620
    hds_hrEntry.values.append(CDAKPhysicalQuantityResultValue(scalar: 86, units: "beats"))//count/min
    hds_hrEntry.codes.addCodes("LOINC", codes: "8867-4")
    
    let hk_hrEntry_nil = CDAKHealthKitBridge.sharedInstance.sampleForEntry(hds_hrEntry, forSampleType: CDAKHealthKitBridge.CDAKHKQuantityIdentifiers.HKQuantityTypeIdentifierHeartRate)

    XCTAssertNil(hk_hrEntry_nil)
    
    var cdaStringUnitFinder : ((unit_string: String?, typeIdentifier: String? ) -> HKUnit?) = {
      (unit_string: String?, typeIdentifier: String?) -> HKUnit? in
      
      if unit_string == "beats" {
        return HKUnit(fromString: "count/min")
      }
      
      return nil
    }
    CDAKHealthKitBridge.sharedInstance.cdaStringUnitFinder = cdaStringUnitFinder

    let hk_hrEntry = CDAKHealthKitBridge.sharedInstance.sampleForEntry(hds_hrEntry, forSampleType: CDAKHealthKitBridge.CDAKHKQuantityIdentifiers.HKQuantityTypeIdentifierHeartRate)

    XCTAssert(hk_hrEntry != nil)
    
    CDAKHealthKitBridge.sharedInstance.cdaStringUnitFinder = nil
    
    
  }
  
  
}
