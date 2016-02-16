//
//  CDAProcedureImporterTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/21/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import Fuzi

class CDAProcedureImporterTest: XCTestCase {
  
  let si = CDAKImport_CDA_SectionImporter(entry_finder: CDAKImport_CDA_EntryFinder(entry_xpath: "/cda:simple/cda:entry"))
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
  
  func test_extracting_scalars() {
    let entries = si.create_entries(doc)
    let entry = entries[3]
    let pq_value = CDAKPhysicalQuantityResultValue(scalar: "eleventeen", units: nil)
    XCTAssertEqual(pq_value.scalar, (entry.values[0] as? CDAKPhysicalQuantityResultValue)!.scalar)
    XCTAssertEqual(pq_value.units, (entry.values[0] as? CDAKPhysicalQuantityResultValue)!.units)
  }

  func test_extracting_values() {
    let entries = si.create_entries(doc)
    let entry = entries[2]
    let pq_value = CDAKPhysicalQuantityResultValue(scalar: "eleventeen", units: nil)
    XCTAssertEqual(pq_value.scalar, (entry.values[0] as? CDAKPhysicalQuantityResultValue)!.scalar)
    XCTAssertEqual(pq_value.units, (entry.values[0] as? CDAKPhysicalQuantityResultValue)!.units)
  }

}
