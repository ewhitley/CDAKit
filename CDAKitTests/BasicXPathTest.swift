//
//  BasicXPathTest.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/11/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
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
    
    if let record = HDSImport_BulkRecordImporter.importRecord(c32Doc) {
      //print(record)
    }
  }

  func testImportWithTypeDetection_CCDA() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("sample_ccda")
    if let record = HDSImport_BulkRecordImporter.importRecord(doc) {
      //print(record)
    }
  }

  func testImportWithTypeDetection_C32() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("NISTExampleC32")
    if let record = HDSImport_BulkRecordImporter.importRecord(doc) {
      //print(record)
    }
  }

  func testImportWithExternalRecord() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("DOC0001")
    if let record = HDSImport_BulkRecordImporter.importRecord(doc) {
      //print(record)
      //print(HDS_EXTENDED_CODE_SYSTEMS)
    }
  }

  func testImportWithExternalRecord_GithubCCD() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Vitera_CCDA_SMART_Sample")
    if let record = HDSImport_BulkRecordImporter.importRecord(doc) {
      //print(record)
      //print("vitals: \(record.vital_signs.count)")
      //print(HDS_EXTENDED_CODE_SYSTEMS)
    }
  }

  func testImportWithExternalRecord_HealthKitCDA() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("export_cda")
    if let record = HDSImport_BulkRecordImporter.importRecord(doc) {
      //print(record)
      //print("vitals: \(record.vital_signs.count)")
      //print(HDS_EXTENDED_CODE_SYSTEMS)
    }
  }
  
  
  func testRecordXMLInitializer_VALID() {
    
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("DOC0001")
    if let record = HDSRecord.init(fromXML: doc) {
      //print(record)
      //print(HDS_EXTENDED_CODE_SYSTEMS)
    } else {
      XCTFail()
    }
    
  }

  func testRecordXMLInitializer_NOT_VALID() {
    
    let doc = "<?xml version=\"1.0\"?>NOPE"
    if let record = HDSRecord.init(fromXML: doc) {
      XCTFail()
    }
    
  }

  
  func testExport() {

    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("DOC0001")
    let record = HDSImport_BulkRecordImporter.importRecord(doc)!

    let myOut = record.export(inFormat: .ccda)
    //print(myOut)
    
  }
  
}
