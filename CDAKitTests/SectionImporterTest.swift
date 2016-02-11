//
//  SectionImporterTest.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/19/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
import Fuzi

//https://github.com/projectcypress/health-data-standards/blob/master/test/unit/import/cda/section_importer_test.rb

class CDASectionImporterTest: XCTestCase {

  let si = HDSImport_CDA_SectionImporter(entry_finder: HDSImport_CDA_EntryFinder(entry_xpath: "/cda:simple/cda:entry"))
  let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("section_importer")
  var doc: XMLDocument!

  override func setUp() {
    super.setUp()

    si.status_xpath = "./cda:status"
    do {
      doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
    } catch {
      print("boom")
    }

  }
  
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }
  
  func test_create_entries_with_date() {
    let entries = si.create_entries(doc)
    let entry = entries[1]
    XCTAssertEqual(1026777600, entry.time)
    XCTAssert(entry.codes["SNOMED-CT"]?.codes.contains("314443004") == true)
  }
  
  func test_create_entries_with_date_values() {
    let entries = si.create_entries(doc)
    let entry = entries[2]
    XCTAssertEqual(1026777600, entry.time)
    XCTAssert(entry.codes["SNOMED-CT"]?.codes.contains("314443004") == true)
    XCTAssertEqual("eleventeen", (entry.values.first as? HDSPhysicalQuantityResultValue)?.scalar)
    XCTAssertEqual("active", entry.status)
  }
  
  func test_create_entries_with_date_ranges() {
    let entries = si.create_entries(doc)
    let entry = entries[0]
    XCTAssertEqual(1026777600, entry.start_time)
    XCTAssertEqual(1189814400, entry.end_time)
    XCTAssert(entry.is_date_range == true)
  }
  
  func test_extracting_translations() {
    let entries = si.create_entries(doc)
    let entry = entries[1]
    XCTAssertEqual(1026777600, entry.time)
    XCTAssert(entry.codes["SNOMED-CT"]?.codes.contains("12345") == true)
  }
  
  func test_dealing_with_center_times() {
    let entries = si.create_entries(doc)
    let entry = entries[3]
    XCTAssertEqual(1026777600, entry.time)
  }
  
  func test_extracting_identifiers() {
    let entries = si.create_entries(doc)
    let entry = entries[0]
    XCTAssertEqual("1.2.3.4", entry.cda_identifier?.root)
    XCTAssertEqual("abcdef", entry.cda_identifier?.extension_id)
  }
  
}
