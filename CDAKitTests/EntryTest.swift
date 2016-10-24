//
//  EntryTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/14/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit


class EntryTest: XCTestCase {
  
  var entry: CDAKEntry!
  
  override func setUp() {
      super.setUp()
    
//    let entry = CDAKEntry()
    entry = CDAKEntry()
    var codes = CDAKCodedEntries()
    let entries: [String:[String]] = [
    "SNOMED-CT" : ["1234", "5678", "AABB"],
    "LOINC" : ["CCDD", "EEFF"],
    "ICD-9-CM" : ["GGHH"]
    ]
    for (system, code_list) in entries {
      for code in code_list {
        codes.addCodes(system, code: code)
      }
    }
    
    entry.codes = codes
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }
  
  func test_preferred_code() {
    
    //print(entry.codes)
    var preferred_code = entry.preferred_code(["ICD-9-CM"])
    XCTAssertEqual("ICD-9-CM", preferred_code!.codeSystem)
    XCTAssertEqual("GGHH", preferred_code!.code)
    
    preferred_code = entry.preferred_code(["LOINC"])
    XCTAssertEqual("LOINC", preferred_code!.codeSystem)
    XCTAssert(["CCDD", "EEFF"].contains(preferred_code!.code))

    //sample from the view helper test case
    let fields: [String:Any?] = [
      "description" : "bacon > cheese",
      "time" : 1234,
      "codes" : ["CPT" : ["1234"]]
    ]
    let entry_with_no_codes = CDAKEntry(event: fields)
    print("preferred codes: ")
    print(entry_with_no_codes.preferred_code([], codes_attribute: "codes", value_set_map: []))
    print("end")
    
  }

  func test_translation_codes() {

    let translation_codes = entry.translation_codes(["ICD-9-CM"])
    print("test_translation_codes -> translation_codes: \(translation_codes)")
    XCTAssertEqual(5, translation_codes.numberOfDistinctCodes)
    //print("translation_codes = '\(translation_codes)'")
//    XCTAssert(translation_codes.contains({ $0 == ["code_set" : "LOINC", "code" : "CCDD"] }))
//    XCTAssert(!translation_codes.contains({ $0 == ["code_set" : "ICD-9-CM", "code" : "GGHH"] }))
    XCTAssert(translation_codes.containsCode(withCodeSystem: "LOINC", andCode: "CCDD"))
    XCTAssert(!translation_codes.containsCode(withCodeSystem: "ICD-9-CM", andCode: "GGHH"))
    
  }

  func test_is_usable() {
    let entry = CDAKEntry()
    entry.time = 1270598400
    entry.add_code("314443004", code_system: "SNOMED-CT")
    XCTAssert(entry.usable())
  }

//  func test_Entry_redo() {
//    let hash: [String:Any?] = [
//      "code" : 123, "code_set" : "RxNorm",
//      "value" : 50, "unit" : "mm",
//      "description" : "Test",
//      "specifics" : "Specific",
//      "status" : "active"
//    ]
//    
//    let entry = CDAKEntry(from_hash: hash)
//    print(entry)
//
//  }
  
  func test_from_event_hash() {
    
    let hash: [String:Any?] = [
      "code" : 123, "code_set" : "RxNorm",
      "value" : 50, "unit" : "mm",
      "description" : "Test",
      "specifics" : "Specific",
      "status" : "active"
    ]
    
    
    let entry = CDAKEntry(from_hash: hash)
//    print(String(hash["code"]!!))
//    print(entry.codes[String(hash["code_set"]!!)]!)
//    XCTAssertEqual([String(hash["code"]!)], entry.codes[String(hash["code_set"]!!)]!)
    XCTAssertEqual([String(describing: hash["code"]!)], [entry.codes["RxNorm"]!.first!.code])
    XCTAssertEqual(String(describing: hash["value"]!!), (entry.values.first as! CDAKPhysicalQuantityResultValue).scalar)
    XCTAssertEqual(String(describing: hash["unit"]!!), (entry.values.first as! CDAKPhysicalQuantityResultValue).units)
    XCTAssertEqual(String(describing: hash["specifics"]!!), entry.specifics)
    XCTAssertEqual(String(describing: hash["status"]!!), entry.status)
  }

  func test_unusable_without_time() {
    let entry = CDAKEntry()
    entry.add_code("314443004", code_system: "SNOMED-CT")
    XCTAssert(!entry.usable())
  }

  func test_unusable_without_code() {
    let entry = CDAKEntry()
    entry.time = 1270598400
    XCTAssert(!entry.usable())
  }

  func test_is_in_code_set() {
    let entry = CDAKEntry()
    entry.add_code("854935", code_system: "RxNorm")
    entry.add_code("44556699", code_system: "RxNorm")
    entry.add_code("1245", code_system: "Junk")
    var some_codes = CDAKCodedEntries()
    some_codes.addCodes("RxNorm", code: "854935")
    some_codes.addCodes("RxNorm", code: "5440")
    some_codes.addCodes("SNOMED-CT", code: "24601")
    XCTAssert(entry.is_in_code_set([some_codes]))
//    XCTAssert(entry.is_in_code_set([
//      CDAKCodedEntries(entries: ["RxNorm": ["854935", "5440"], "SNOMED-CT" : ["24601"]])
//    ]))
  }

  func test_is_not_in_code_set() {
    let entry = CDAKEntry()
    entry.add_code("44556699", code_system: "RxNorm")
    entry.add_code("1245", code_system: "Junk")
    var some_codes = CDAKCodedEntries()
    some_codes.addCodes("RxNorm", code: "854935")
    some_codes.addCodes("RxNorm", code: "5440")
    some_codes.addCodes("SNOMED-CT", code: "24601")
    XCTAssert(!entry.is_in_code_set([some_codes]))

//    XCTAssert(!entry.is_in_code_set([
//      CDAKCodedEntries(entries: ["RxNorm": ["854935", "5440"], "SNOMED-CT" : ["24601"]])
//    ]))
  }

  func test_equality() {
    let entry1 = CDAKEntry()
    entry1.add_code("44556699", code_system: "RxNorm")
    entry1.time = 1270598400
    
    let entry2 = CDAKEntry()
    entry2.add_code("44556699", code_system: "RxNorm")
    entry2.time = 1270598400
    
    let entry3 = CDAKEntry()
    entry3.add_code("44556699", code_system: "RxNorm")
    entry3.time = 1270598401
    
    XCTAssertEqual(entry1, entry2)
    XCTAssertEqual(entry2, entry1)
    XCTAssert(entry2 != entry3)
    XCTAssert(entry1 != entry3)
  }

  //removing this - will be removing this functionality and moving to JSON
  /*
  func test_to_hash() {
    
    let entry = CDAKEntry()
    entry.add_code("44556699", code_system: "RxNorm")
    entry.time = 1270598400
    entry.specifics = "specific"
    
    let h = entry.to_hash()
    print("test_to_hash h: \(h)")
    XCTAssertEqual(1270598400, h["time"]! as? Double)
    XCTAssert((h["codes"]! as! [String:[String]])["RxNorm"]!.contains("44556699"))
//    XCTAssert((h["codes"]! as! [String:[String]])["RxNorm"]!.contains("44556699"))
    
  }
*/

  func test_identifier_id() {
    let entry = CDAKEntry()
    XCTAssertEqual(entry.id, entry.identifier as? String)
  }

  func test_identifier_cda_identifier() {
    let identifier = CDAKCDAIdentifier(root: "1.2.3.4")
    entry.cda_identifier = identifier
    XCTAssertEqual(identifier, entry.identifier as? CDAKCDAIdentifier)
  }

  
}
