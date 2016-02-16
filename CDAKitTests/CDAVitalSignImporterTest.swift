//
//  CDAVitalSignImporterTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/21/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import Fuzi

class CDAVitalSignImporterTest: XCTestCase {
    
  override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }
  
  func test_vital_sign_importing() {
    
    //let si = CDAKImport_CDA_SectionImporter(entry_finder: CDAKImport_CDA_EntryFinder(entry_xpath: "/cda:simple/cda:entry"))

    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("NISTExampleC32")
    var doc: XMLDocument!
    
    do {
      doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      let pi = CDAKImport_C32_PatientImporter()
      let patient = pi.parse_c32(doc)
//      print(patient)
      
      let vital_sign = patient.vital_signs[0]
      print(vital_sign)

      XCTAssertEqual("N", vital_sign.interpretation.codes.first?.code)
      XCTAssertEqual("177", (vital_sign.values.first as? CDAKPhysicalQuantityResultValue)?.scalar)
      XCTAssertEqual("cm", (vital_sign.values.first as? CDAKPhysicalQuantityResultValue)?.units)
      XCTAssertEqual("HITSP C80 Observation Status", vital_sign.interpretation.codes.first?.codeSystem)
      
    } catch {
      print("boom")
    }

  }
    
    
}
