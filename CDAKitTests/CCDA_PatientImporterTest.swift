//
//  CCDA_PatientImporterTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import Fuzi

class CCDA_PatientImporterTest: XCTestCase {
    
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }

  
  func test_parse_ccda() {
    
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("sample_ccda")
    var doc: XMLDocument!
    
    do {
      doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      doc.definePrefix("sdtc", defaultNamespace: "urn:hl7-org:sdtc")
      let pi = CDAKImport_CCDA_PatientImporter()
      let patient = pi.parse_ccda(doc)
      
      print(patient)
      
      XCTAssertEqual(3, patient.allergies.count)

      let allergy = patient.allergies.first
      XCTAssertNotNil(allergy)
      XCTAssertEqual("247472004", allergy?.reaction.codes.first?.code)
      XCTAssertEqual("371924009", allergy?.severity.codes.first?.code)
      XCTAssertEqual("416098002", allergy?.type.codes.first?.code)
      XCTAssertEqual("active", allergy?.status)

      let condition = patient.conditions.first
      XCTAssertNotNil(condition)
      XCTAssertEqual("Complaint", condition?.type)

      XCTAssertEqual(0, patient.encounters.count)
      XCTAssertEqual(4, patient.immunizations.count)

      let medication = patient.medications.first
      XCTAssertNotNil(medication)
      XCTAssertEqual("5955009", medication?.vehicle.codes.first?.code)
      XCTAssertNotNil(medication?.order_information.first)
      XCTAssertNotNil(medication?.fulfillment_history.first)

      XCTAssertEqual(3, patient.procedures.count)
      
    } catch {
      print("boom")
    }
  }

    
}
