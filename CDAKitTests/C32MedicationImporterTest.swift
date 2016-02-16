//
//  C32MedicationImporterTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import Fuzi

class C32MedicationImporterTest: XCTestCase {
    
  override func setUp() {
    super.setUp()
    TestHelpers.collections.providers.load_providers()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
    
  func test_medication_importing() {
    
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("NISTExampleC32")
    var doc: XMLDocument!
    
    do {
      doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      let pi = CDAKImport_C32_PatientImporter()
      let patient = pi.parse_c32(doc)
      
      let medication = patient.medications[0]
      XCTAssertEqual(medication.codes.containsCode("RxNorm", withCode: "307782"), true)
      XCTAssertEqual(medication.administration_timing.period.value, 6)
      XCTAssertEqual(medication.route.containsCode("HL7 RouteOfAdministration", withCode: "IPINHL"), true)
      XCTAssertEqual(medication.dose.value, 2)

      XCTAssertEqual(medication.anatomical_approach.containsCode("SNOMED-CT", withCode: "127945006"), true)
      
      XCTAssertEqual(5, medication.dose_restriction.numerator.value)
      XCTAssertEqual(10, medication.dose_restriction.denominator.value)

      XCTAssertEqual("415215001", medication.product_form.codes.first?.code)
      XCTAssertEqual("334980009", medication.delivery_method.codes.first?.code)
      XCTAssertEqual("73639000", medication.type_of_medication.codes.first?.code)
      XCTAssertEqual("DrugVehicleCode", medication.vehicle.codes.first?.code)
      XCTAssertEqual("eleventeen", medication.fulfillment_history[0].prescription_number)
      XCTAssertEqual("Pseudo", medication.fulfillment_history[0].provider?.given_name)
      XCTAssertEqual("100 Bureau Drive", medication.fulfillment_history[0].provider?.addresses[0].street[0])
      XCTAssertEqual(1316476800, medication.fulfillment_history[0].dispense_date)
      XCTAssertEqual(30, medication.fulfillment_history[0].quantity_dispensed.value)
      XCTAssertEqual(4, medication.fulfillment_history[0].fill_number)

      let medication3 = patient.medications[3]
      XCTAssertEqual("VA/KPproblemList", medication3.indication.codes.first?.code)
      XCTAssertEqual(1, medication3.order_information.count)
      XCTAssertEqual(1, medication3.order_information.first?.fills)
      XCTAssertEqual(1, medication3.order_information.first?.quantity_ordered.value)
      XCTAssertEqual("tablet", medication3.order_information.first?.quantity_ordered.unit)

      
    } catch {
      print("boom")
    }
  }
}
