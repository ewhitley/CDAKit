//
//  CDAProviderImporterTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/20/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import Fuzi

class CDAProviderImporterTest: XCTestCase {

  override func setUp() {
    super.setUp()
    HDSProviders.removeAll()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
    HDSProviders.removeAll()
  }
  
  /*
    OK - this test looks weird so I'm going to explain
    The original Ruby used Mongo for data storage
    When you created a Provider or HDSRecord it was stored in a collection
    In Provider there's a method to "find or create" a record - using keys like NPI to resolve the record
  
    In this test case what's happening is:
    1) Provider with NPI 808401234567893 is created
    2) Behind the scenes, that provider is stored
    3) When we restore the provider data from the XML in one_provider_with_npi, it also has NPI 808401234567893
    4) Because of this, the importer will actually find the EXISTING provider (with NPI 808401234567893) and return that INSTEAD of creating a new provider
  
    What this means: even if the second provider has "more" data available, the initial one wins. FIFO.
  
    This makes sense in Mongo.  Not sure it makes sense in how we're using it, but... complete the port first.
  */
  func test_import_existing_npi() {
    let provider = HDSProvider()
    provider.npi = "808401234567893"
    XCTAssertEqual("808401234567893", provider.npi, "Expected provider npi number to be 808401234567893")
    
    let xmlFileName = "one_provider_with_npi"
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file(xmlFileName)
    do {
      let doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      
      let providers = HDSImport_CDA_ProviderImporter.extract_providers(doc)
      //you'll actually get the INITIAL provider here - a new one will NOT be created
      
      XCTAssertEqual(1, providers.count, "Should have found 1 provider in the file")
      XCTAssertEqual(provider, providers[0].provider!, "Provider in file should have been the same one in the db")
    } catch {
      print("Failed to load XML file : \(xmlFileName)")
    }
  }
  
  func test_import_non_existant_npi() {
    XCTAssertEqual(0, HDSProviders.count, "Should be 0 providers in the DB")

    let xmlFileName = "one_provider_with_npi"
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file(xmlFileName)
    do {
      let doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      
      let providers = HDSImport_CDA_ProviderImporter.extract_providers(doc)
      //should get a new provider here - none should exist in the "system"
      
      XCTAssertEqual(1, providers.count, "Should have found 1 provider in the file")
      XCTAssertEqual(1, HDSProviders.count, "Should be 1 provider in database")
      XCTAssertEqual("808401234567893", HDSProviders.first?.npi, "Expected provider npi number to be 808401234567893")

    } catch {
      print("Failed to load XML file : \(xmlFileName)")
    }
  }
  
  func test_import_no_npi() {
    let xmlFileName = "one_provider_no_npi"
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file(xmlFileName)
    do {
      let doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      
      let providers = HDSImport_CDA_ProviderImporter.extract_providers(doc)

      XCTAssertEqual(1, providers.count, "should have found 1 provider in the file")
      XCTAssertEqual(HDSProviders.count, providers.count, "should be as many providers in db as parsed")

      let providers2 = HDSImport_CDA_ProviderImporter.extract_providers(doc)
      
      XCTAssertEqual(HDSProviders.count, providers2.count, "should not have created any new providers")

      //I'm going to add in this test case because it's in the original - and apparently we should be "safe"
      // with ordering because we're loading sequentially from the XML
      // Swift kept crashing (sourcekit) when I attempted to do this in one line, so I'm splitting up the lines
      let some_providers = providers2.map({$0.provider!})
      XCTAssertEqual(HDSProviders.map({$0}), some_providers, "should be the same providers after repatsing")

    } catch {
      print("Failed to load XML file : \(xmlFileName)")
    }
    
  }
  
  func test_import_of_cda_identifier() {
    XCTAssertEqual(0, HDSProviders.count, "Should be 0 providers in the DB")
    let xmlFileName = "one_provider_cda_ident"
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file(xmlFileName)
    do {
      let doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      
      let providers = HDSImport_CDA_ProviderImporter.extract_providers(doc)
      
      XCTAssertEqual(1, providers.count, "Should be 1 providers in the file")

      XCTAssertEqual(HDSProviders.count, providers.count, "should be as many providers in db as parsed")
      XCTAssertEqual(1, HDSProviders.filter({
        p in
        p.cda_identifiers.contains({
          c in
          c.root == "Division" && c.extension_id == "12345"
        })
      }).count)

      
    } catch {
      print("Failed to load XML file : \(xmlFileName)")
    }

  }
  
  //MARK: FIXME
  //we really can't do this test without changing Provider to a singleton and resolve_provider to an instance method
  // but that doesn't make sense in our case because Provider isn't something we want treated as a Singleton
  // we sort of want to be able to set an instance property to our new "resolve" function and then use that for the duration of the exercise
  // we're not really all that likely to use the resolve functionality like this, so...
  func test_import_resolve_provider() {
    
    func my_resolve_provider(provider_hash: [String:Any], patient: HDSPerson? = nil) -> HDSProvider? {
      return HDSProviders.first
    }

    XCTAssertEqual(0, HDSProviders.count, "Should be 0 providers in the DB")
    let provider = HDSProvider()
    provider.npi = "808401234567893"
    
    XCTAssertEqual(1, HDSProviders.count, "Should be 1 providers in the DB")
    
    let xmlFileName = "two_providers"
    let xmlString = TestHelpers.fileHelpers.load_xml_string_from_file(xmlFileName)
    do {
      let doc = try XMLDocument(string: xmlString)
      doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
      
      let providers = HDSImport_CDA_ProviderImporter.extract_providers(doc)
      
      print(providers.map({$0.provider}))
//      print(Providers)
      
    } catch {
      print("Failed to load XML file : \(xmlFileName)")
    }

    
  }

}
