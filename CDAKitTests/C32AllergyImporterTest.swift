//
//  C32AllergyImporterTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/22/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import Fuzi

class C32AllergyImporterTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
  func test_allergy_importing() {
    
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("NISTExampleC32")
    var doc: XMLDocument!
    
    do {
      doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      let pi = HDSImport_C32_PatientImporter()
      let patient = pi.parse_c32(doc)
            
      let allergy0 = patient.allergies[0]
      XCTAssertEqual("247472004", allergy0.reaction.codes.first?.code)
      
      let allergy2 = patient.allergies[2]
      XCTAssertEqual("73879007", allergy2.reaction.codes.first?.code)
      XCTAssertEqual("6736007", allergy2.severity.codes.first?.code)
      
      
    } catch {
      print("boom")
    }
    
  }
    
}
