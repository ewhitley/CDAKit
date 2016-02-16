//
//  BasicXPathTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/11/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import Mustache

class BasicXPathTest: XCTestCase {
    
  override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }
  
  func testLoadingFile() {
    let a_file = TestHelpers.fileHelpers.load_xml_string_from_file("Rosa.c32")
  }

  func testC32RecordImport() {
    let c32Doc = TestHelpers.fileHelpers.load_xml_string_from_file("Rosa.c32")
    
    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(c32Doc)
      //print(record)
    }
    catch {
      XCTFail()
    }
  }

  func testImportWithTypeDetection_CCDA() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("sample_ccda")

    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      //print(record)
    }
    catch {
      XCTFail()
    }

  }

  func testImportWithTypeDetection_C32() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("NISTExampleC32")
    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      //print(record)
    }
    catch {
      XCTFail()
    }
  }

  func testImportWithExternalRecord_GithubCCD() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Vitera_CCDA_SMART_Sample")
    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      //print(record)
    }
    catch {
      XCTFail()
    }
  }

  func testImportWithExternalRecord_HealthKitCDA() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("export_cda")
    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      //print(record)
    }
    catch {
      XCTFail()
    }
  }
  
  
  func testRecordXMLInitializer_VALID() {
    
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Vitera_CCDA_SMART_Sample")
    do {
      let record = try CDAKRecord.init(fromXML: doc)
        //print(record)
      //print(CDAKGlobals.sharedInstance.CDAK_EXTENDED_CODE_SYSTEMS)
    } catch {
      XCTFail()
      
    }
    
//    if let record = CDAKRecord.init(fromXML: doc) {
//    } else {
//      XCTFail()
//    }
    
  }
  

  func testRecordXMLInitializer_NOT_VALID() {
    
    let doc = "<?xml version=\"1.0\"?>NOPE"
    do {
      let record = try CDAKRecord.init(fromXML: doc)
      XCTFail() // we shouldn't get here
    }
    catch {
    }
    
  }

  
  func testExport() {

    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Vitera_CCDA_SMART_Sample")
    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      let myOut = record.export(inFormat: .ccda)
      //print(record)
    }
    catch {
      XCTFail()
    }
    //print(myOut)
    
  }
  
}
