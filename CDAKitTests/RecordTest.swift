//
//  HDSRecordTest.swift
//  CCDAccess
//
//  Created by Eric Whitley on 12/8/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import XCTest

class HDSRecordTest: XCTestCase {
  
  let testRecord = TestRecord()
  
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

  
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_entries_for_oid() {
      let record: HDSRecord = testRecord.bigger_record()
      XCTAssertEqual(3, record.conditions.count)
//      # Make sure that the sequence hasn't gone past 3 in the conditions oid
//      XCTAssert((record.conditions.map({c in c.oid}) as! [String]).contains("1.2.3.3"))
      
      XCTAssert((record.conditions.map({
        (c) -> String in
        if let oid = c.oid {
          return oid
        } else {
          return ""
        }
      })).contains("1.2.3.3"))

      let entries = record.entries_for_oid("1.2.3.3")
      XCTAssertEqual(2, entries.count)

      //XCTAssert((entries.map({e in e.description}) as! [String]).contains("Tobacco user"))
      XCTAssert((entries.map({
        (c) -> String in
        if let item_description = c.item_description {
          return item_description
        } else {
          return ""
        }
      })).contains("Tobacco user"))
      
      
      //XCTAssert((entries.map({e in e.description}) as! [String]).contains("Sample HDSEncounter"))
      XCTAssert((entries.map({
        (c) -> String in
        if let item_description = c.item_description {
          return item_description
        } else {
          return ""
        }
      })).contains("Sample Encounter"))
      
    }
  
  func test_dedup_section() {

    let record = HDSRecord()
    let identifier = HDSCDAIdentifier(root: "1.2.3.4")
    
    record.encounters.append(HDSEncounter())
    record.encounters.append(HDSEncounter(cda_identifier: identifier))
    record.encounters.append(HDSEncounter(cda_identifier: identifier))
    record.encounters.append(HDSEncounter(cda_identifier: HDSCDAIdentifier(root: "abcd")))

    XCTAssertEqual(4, record.encounters.count)
    
    record.dedup_section("encounters")

    XCTAssertEqual(3, record.encounters.count)

  }
  
  //NOTE: altering the test case
  func test_dedup_encounters_section() {
    
    let record = HDSRecord()
    let identifier = HDSCDAIdentifier(root: "1.2.3.4")
    
    let value_a = HDSPhysicalQuantityResultValue(scalar: 10)
    let value_b = HDSPhysicalQuantityResultValue(scalar: 20)
    
//    let code_a = ["x" : ["y" : "z", "z" : ["c"]]]
//    let x = HDSEncounter(cda_identifier: identifier, codes: code_a, values: [value_a])

    //NOTE: altering the test case.  The original test case uses Ruby hashes (:codes) for the test case
    // This is difficult to do in Swift and in reviewing the code, it appears this is only ever a [String:[String]]
    // type - I am changing the test cases to better conform with this assumption
    record.encounters.append(HDSEncounter(cda_identifier: identifier, codes: HDSCodedEntries(entries: ["x":["y", "z"]]), values: [value_a]))
    record.encounters.append(HDSEncounter(cda_identifier: identifier, codes: HDSCodedEntries(entries: ["a":["b"], "x":["y"]]), values: [value_b]))

    XCTAssertEqual(2, record.encounters.count)

    record.dedup_section("encounters")
    
    XCTAssertEqual(1, record.encounters.count)

    XCTAssertEqual(HDSCodedEntries(entries: ["x":["y", "z"], "a":["b"]]), record.encounters[0].codes)

    let z: [HDSPhysicalQuantityResultValue] = [value_a, value_b]
    XCTAssertEqual(z, record.encounters[0].values as! [HDSPhysicalQuantityResultValue])

    
  }
  
  //NOTE: altering the test case
  func test_dedup_procedures_section() {
    let record = HDSRecord()
    let identifier = HDSCDAIdentifier(root: "1.2.3.4")
    
    let value_a = HDSPhysicalQuantityResultValue(scalar: 10)
    let value_b = HDSPhysicalQuantityResultValue(scalar: 20)
    
    record.procedures.append(HDSProcedure(cda_identifier: identifier, codes: HDSCodedEntries(entries:["x":["y", "z"]]), values: [value_a]))
    record.procedures.append(HDSProcedure(cda_identifier: identifier, codes: HDSCodedEntries(entries:["a":["b"], "x":["y"]]), values: [value_b]))
    
    XCTAssertEqual(2, record.procedures.count)
    
    record.dedup_section("procedures")
    
    XCTAssertEqual(1, record.procedures.count)
    
    XCTAssertEqual(HDSCodedEntries(entries:["x":["y", "z"], "a":["b"]]), record.procedures[0].codes)
    
    let z: [HDSPhysicalQuantityResultValue] = [value_a, value_b]
    XCTAssertEqual(z, record.procedures[0].values as! [HDSPhysicalQuantityResultValue])

  }

  //NOTE: altering the test case
  func test_dedup_results_section() {
    let record = HDSRecord()
    let identifier = HDSCDAIdentifier(root: "1.2.3.4")
    
    let value_a = HDSPhysicalQuantityResultValue(scalar: 10)
    let value_b = HDSPhysicalQuantityResultValue(scalar: 20)
    
    record.results.append(HDSLabResult(cda_identifier: identifier, codes: HDSCodedEntries(entries:["x":["y", "z"]]), values: [value_a]))
    record.results.append(HDSLabResult(cda_identifier: identifier, codes: HDSCodedEntries(entries:["a":["b"], "x":["y"]]), values: [value_b]))
    
    XCTAssertEqual(2, record.results.count)
    
    record.dedup_section("results")
    
    XCTAssertEqual(1, record.results.count)
    
    XCTAssertEqual(HDSCodedEntries(entries:["x":["y", "z"], "a":["b"]]), record.results[0].codes)
    
    let z: [HDSPhysicalQuantityResultValue] = [value_a, value_b]
    XCTAssertEqual(z, record.results[0].values as! [HDSPhysicalQuantityResultValue])
    
  }
 
  func test_dedup_record() {
    let record = HDSRecord()
    let identifier = HDSCDAIdentifier(root: "1.2.3.4")

    record.encounters.append(HDSEncounter())
    record.encounters.append(HDSEncounter(cda_identifier: identifier))
    record.encounters.append(HDSEncounter(cda_identifier: identifier))
    record.encounters.append(HDSEncounter(cda_identifier: HDSCDAIdentifier(root: "abcd")))
    
    XCTAssertEqual(4, record.encounters.count)
    
    record.dedup_record()
    
    XCTAssertEqual(3, record.encounters.count)
    
  }
  
}
