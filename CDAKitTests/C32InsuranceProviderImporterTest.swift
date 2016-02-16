//
//  C32InsuranceProviderImporterTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import Fuzi

class C32InsuranceProviderImporterTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
  func test_immunization_importing() {
    
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("NISTExampleC32")
    var doc: XMLDocument!
    
    do {
      doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      let pi = CDAKImport_C32_PatientImporter()
      let patient = pi.parse_c32(doc)
      
      let ip = patient.insurance_providers.first
      XCTAssertTrue(ip != nil)
      let g = ip!.guarantors.first
      XCTAssertTrue(g != nil)

      XCTAssertEqual(1260316800, g!.start_time)
      XCTAssertEqual(1355011200, g!.end_time)
      
    } catch {
      print("boom")
    }
    
  }
}
