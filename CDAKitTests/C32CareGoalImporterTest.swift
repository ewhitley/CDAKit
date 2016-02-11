//
//  C32CareGoalImporterTest.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/22/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
import Fuzi

class C32CareGoalImporterTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
  func test_import_of_result() {
    
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("plan_of_care")
    var doc: XMLDocument!
    
    do {
      doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      let pi = HDSImport_C32_PatientImporter()
      let patient = pi.parse_c32(doc)
      
      XCTAssertEqual(2, patient.care_goals.count)
      
    } catch {
      print("boom")
    }
    
  }

}
