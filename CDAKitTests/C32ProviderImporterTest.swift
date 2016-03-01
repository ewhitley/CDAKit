//
//  C32ProviderImporterTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import Fuzi

class C32ProviderImporterTest: XCTestCase {

  var doc: XMLDocument!
  var nist_doc: XMLDocument!
  let importer = CDAKImport_CDA_ProviderImporter()
  
  override func setUp() {
    super.setUp()
    
    //TestHelpers.collections.providers.load_providers()
    
    //print(CDAKGlobals.sharedInstance.CDAKProviders)
    CDAKGlobals.sharedInstance.CDAKProviders.removeAll()
    
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("provider_importer_sample")
    do {
      doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
    } catch {
      print("Failed to find or parse provider_importer_sample.xml")
    }

    let nist_xmlString = TestHelpers.fileHelpers.load_xml_string_from_file("NISTExampleC32")
    do {
      nist_doc = try XMLDocument(string: nist_xmlString)
      nist_doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
    } catch {
      print("Failed to find or parse NISTExampleC32.xml")
    }

    
  }
  
  override func tearDown() {
    super.tearDown()
  }

  func test_document_provider_extraction() {
    
    print(CDAKGlobals.sharedInstance.CDAKProviders)
    
    let providers = CDAKImport_CDA_ProviderImporter.extract_providers(doc)
    
    print(providers)
    print(CDAKGlobals.sharedInstance.CDAKProviders)
    
    XCTAssertEqual(2, providers.count)
    
    let provider_perf = providers.first
    let provider = provider_perf!.provider
    XCTAssertNotNil(provider)
    
    XCTAssertEqual("Dr.", provider?.prefix)
    XCTAssertEqual("Stanley", provider?.given_name)
    XCTAssertEqual("Strangelove", provider?.family_name)
    
    //NOTE: changing test case
    // original said "refute nil," but while that's _technically_ true and the object is non-nil, it's also totally empty (no street, state, country, etc.).  During the import we're now treating those as 'nil' (no valid address elements = nil), so I'm changing the test case to reflect that
    XCTAssertNil(provider?.addresses.first)
    XCTAssertEqual("808401234567893", provider?.npi)
    //# XCTAssertEqual("Kubrick Permanente", provider?.organization)
    XCTAssertEqual("200000000X", provider?.specialty)
    
    let provider_perf2 = providers.last
    let provider2 = provider_perf2!.provider
    XCTAssertNotNil(provider2)
    
    XCTAssertEqual("Dr.", provider2?.prefix)
    XCTAssertEqual("Teddy", provider2?.given_name)
    XCTAssertEqual("Seuss", provider2?.family_name)
    XCTAssertEqual("1234567893", provider2?.npi)
    //# XCTAssertEqual("Redfish Labs", provider2?.organization)
    XCTAssertEqual("230000000X", provider2?.specialty)
    XCTAssertNil(provider2?.phone)
    
  }

  func test_nist_example_provider_extraction() {
    let providers = CDAKImport_CDA_ProviderImporter.extract_providers(nist_doc)
    
    print(providers)
    print(CDAKGlobals.sharedInstance.CDAKProviders)
    
    XCTAssertEqual(2, providers.count)
    
    let provider_perf = providers.first
    let provider = provider_perf?.provider
    XCTAssertNotNil( provider )
    
    XCTAssertEqual("Dr.", provider?.prefix)
    XCTAssertEqual("Pseudo", provider?.given_name)
    XCTAssertEqual("Physician-1", provider?.family_name)
    XCTAssertEqual("808401234567893", provider?.npi)
    //# XCTAssertEqual("NIST HL7 Test Laboratory", provider.organization)
    XCTAssertEqual("200000000X", provider?.specialty)
    
    let provider_perf2 = providers.last
    let provider2 = provider_perf2?.provider
    XCTAssertNotNil( provider2)
      
    XCTAssertEqual("Dr.", provider2?.prefix)
    XCTAssertEqual("Pseudo", provider2?.given_name)
    XCTAssertEqual("Physician-3", provider2?.family_name)
    //# XCTAssertEqual("NIST HL7 Test Laboratory", provider2.organization)
    XCTAssertEqual("200000000X", provider2?.specialty)
    
    //the Physician-3 NPI is "PseudoMD-3" which should be considered a "bad" NPI per the 
    // NOTE: I'm turning off this test.  While I agree the NPI is "bad," I don't feel it appropriate
    //  for us to actually remove the NPI during the import process
    // XCTAssertNil(provider2?.npi)
  }


}
