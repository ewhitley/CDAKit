//
//  C32MedicalEquipmentImporterTest.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
import Fuzi

class C32MedicalEquipmentImporterTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
  func test_me_importing() {
    
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("NISTExampleC32")
    var doc: XMLDocument!
    
    do {
      doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      let pi = HDSImport_C32_PatientImporter()
      let patient = pi.parse_c32(doc)
      
      XCTAssertEqual(3, patient.medical_equipment.count)
      
      let me = patient.medical_equipment[0]
      XCTAssertEqual(me.codes, HDSCodedEntries(codeSystem: "SNOMED-CT", code: "72506001"))

      let me2 = patient.medical_equipment[1]
      XCTAssertEqual(me2.codes, HDSCodedEntries(codeSystem: "SNOMED-CT", code: "304120007"))
      XCTAssertEqual("Good Health Prostheses Company", me2.manufacturer)

    } catch {
      print("boom")
    }
    
  }

    
}
