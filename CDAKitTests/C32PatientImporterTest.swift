//
//  C32PatientImporterTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import Fuzi

class C32PatientImporterTest: XCTestCase {
    
  override func setUp() {
      super.setUp()
  }
  
  override func tearDown() {
      super.tearDown()
  }

  
  func test_get_demographics() {
    
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("demographics")
    var doc: XMLDocument!
    
    do {
      doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")

      let patient = CDAKRecord()
      let pi = CDAKImport_C32_PatientImporter()
      pi.get_demographics(patient, doc: doc)
      print(patient)
      
      XCTAssertEqual("Joe", patient.first)
      XCTAssertEqual("Smith", patient.last)
      XCTAssertEqual(-87696000, patient.birthdate)
      XCTAssertEqual("M", patient.gender)
      XCTAssertEqual("24602", patient.medical_record_number)
      XCTAssertEqual(1199189385, patient.effective_time)      
      XCTAssertEqual("en-US", patient.languages.first?.codes.first?.code)
      XCTAssertTrue(patient.race.containsCode("CDC-RE", withCode: "2108-9"))
      XCTAssertTrue(patient.ethnicity.containsCode("CDC-RE", withCode: "2137-8"))
      XCTAssertEqual(1, patient.addresses.count)
      XCTAssertEqual("HP", patient.addresses[0].use)
      XCTAssertEqual(1, patient.addresses[0].street.count)
      XCTAssertEqual("1600 Rockville Pike", patient.addresses[0].street[0])
      XCTAssertEqual("Rockville", patient.addresses[0].city)
      XCTAssertEqual("MD", patient.addresses[0].state)
      XCTAssertEqual("20847", patient.addresses[0].zip)
      XCTAssertEqual("US", patient.addresses[0].country)
      XCTAssertEqual(1, patient.telecoms.count)
      XCTAssertEqual("HP", patient.telecoms[0].use)
      XCTAssertEqual("tel:+1(312)555-1234", patient.telecoms[0].value)
      
    } catch {
      print("boom")
    }
  }

  func test_parse_c32() {
    
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("numerator") //test/fixtures/c32_fragments/expired_person.xml
    var doc: XMLDocument!
    
    do {
      doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      
      let pi = CDAKImport_C32_PatientImporter()
      let patient = pi.parse_c32(doc)
      
      XCTAssertEqual("FirstName", patient.first)
      XCTAssertEqual(1, patient.encounters.count)
      XCTAssertTrue(patient.expired != true)
      
      XCTAssertEqual(1270598400, patient.encounters.first?.time)
      
    } catch {
      print("boom")
    }
  }
  
  func test_expired() {
    
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("expired_person") //test/fixtures/c32_fragments/expired_person.xml
    var doc: XMLDocument!
    
    do {
      doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      
      let pi = CDAKImport_C32_PatientImporter()
      let patient = pi.parse_c32(doc)
      
      XCTAssertEqual(1, patient.conditions.count)
      XCTAssertTrue(patient.expired!)
      
      XCTAssertEqual(1241937553, patient.deathdate)
      
    } catch {
      print("boom")
    }
  }


}
