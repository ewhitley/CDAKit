//
//  DateShiftTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/10/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit


class DateShiftTest: XCTestCase {
  
  let ENTRY_VALUES : [[String:Any?]] = [
    ["start_time" : nil, "end_time" : nil, "time" : nil],
    ["start_time" : 1, "end_time" : 1, "time" : 1],
    ["start_time" : 1, "end_time" : nil, "time" : nil],
    ["start_time" : nil, "end_time" : 1, "time" : nil],
    ["start_time" : nil, "end_time" : nil, "time" : 1],
    ["start_time" : 1, "end_time" : 1, "time" : nil],
    ["start_time" : 1, "end_time" : nil, "time" : 1],
    ["start_time" : nil, "end_time" : 1, "time" : 1],
  ]
  
  override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }
  
  func test_entry_shift() {

    let date_shift: Double = 1
    let values = ENTRY_VALUES // dict is a struct, so it's a copy
    
    for vals in values {
      let entry = CDAKEntry(event: vals)
      entry.shift_dates(date_shift)
      entry_shift_assertions(vals, shift: date_shift, entry: entry)
    }
    
  }

  func test_condition_shift() {
    
    let date_shift: Double = 13
    let values = ENTRY_VALUES // dict is a struct, so it's a copy
    let con_values: [[String:Any?]] = [["time_of_death":nil],["time_of_death": 10]]
    
    for vals in values {
      for con_val in con_values {
        var e_vals = vals
        e_vals.merge(con_val)
        let entry = CDAKCondition(event: e_vals)
        entry.shift_dates(date_shift)
        entry_shift_assertions(vals, shift: date_shift, entry: entry)
      }
    }

    
  }

  func test_encounter_shift() {
    
    let date_shift: Double = 10
    let values = ENTRY_VALUES // dict is a struct, so it's a copy
    let encounter_values: [[String:Any?]] = [
      ["admitTime": nil], ["dischargeTime": nil],
      ["admitTime": nil], ["dischargeTime": nil],
      ["admitTime": nil], ["dischargeTime": nil],
      ["admitTime": nil], ["dischargeTime": nil]
    ]

    let facility_values: [[String:Any?]] = [["start_time": nil, "end_time": 20]]
    
    
    for vals in values {
      for enc_vals in encounter_values {
        for fac_vals in facility_values {
          var e_vals = vals
          e_vals.merge(enc_vals)
          let entry = CDAKEncounter(event: e_vals)
          entry.facility = CDAKFacility(event: fac_vals)
          entry.shift_dates(date_shift)
          let block: ()->() = {
            self.entry_shift_assertions(fac_vals, shift: date_shift, entry: entry.facility!)
          }
          entry_shift_assertions(e_vals, shift: date_shift, entry: entry, block: block)
        }
      }
    }
    
  }

  func test_facility_shift() {
    
    let date_shift: Double = 20
    let facility_values: [[String:Any?]] = [
      ["start_time": nil, "end_time": nil],
      ["start_time": 1, "end_time": nil],
      ["start_time": nil, "end_time": 1],
      ["start_time": 1, "end_time": 1]
    ]

    for fac_vals in facility_values {
      let facility = CDAKFacility(event: fac_vals)
      facility.shift_dates(date_shift)
      entry_shift_assertions(fac_vals, shift: date_shift, entry: facility)
    }
    
  }

  func test_fullfillment_shift() {

    let date_shift: Double = 12
    let full_values: [[String:Any?]] = [
      ["dispense_date": nil], ["dispense_date": 15]
    ]
    
    for vals in full_values {
      let fullfillment = CDAKFulfillmentHistory(event: vals)
      fullfillment.shift_dates(date_shift)
      entry_shift_assertions(vals, shift: date_shift, entry: fullfillment)
    }

  
  }

  func test_guarantor_shift() {
    let date_shift: Double = 20
    let values: [[String:Any?]] = [
      ["start_time": nil, "end_time": nil],
      ["start_time": 1, "end_time": nil],
      ["start_time": nil, "end_time": 1],
      ["start_time": 1, "end_time": 1]
    ]
    
    for vals in values {
      let entry = CDAKGuarantor(event: vals)
      entry.shift_dates(date_shift)
      entry_shift_assertions(vals, shift: date_shift, entry: entry)
    }
  }

  func test_insurance_provider_shift() {

    let date_shift: Double = 20
    let values: [[String:Any?]] = [
      ["start_time": nil, "end_time": nil],
      ["start_time": 1, "end_time": nil],
      ["start_time": nil, "end_time": 1],
      ["start_time": 1, "end_time": 1]
    ]
    
    for vals in values {
      let entry = CDAKInsuranceProvider(event: vals)
      let g_vals: [String:Any?] = ["start_time": nil, "end_time": 1]
      let g = CDAKGuarantor(event: g_vals)
      entry.guarantors.append(g)
      
      entry.shift_dates(date_shift)
      entry_shift_assertions(vals, shift: date_shift, entry: entry)

      let block: ()->() = {
        self.entry_shift_assertions(g_vals, shift: date_shift, entry: entry.guarantors.first!)
      }
      entry_shift_assertions(vals, shift: date_shift, entry: entry, block: block)

    }
  
  }

  func test_medical_equipment_shift() {
    
    let date_shift: Double = 13
    let values = ENTRY_VALUES // dict is a struct, so it's a copy
    let con_values: [[String:Any?]] = [["removalTime":nil],["removalTime": 10]]
    
    for vals in values {
      for con_val in con_values {
        var e_vals = vals
        e_vals.merge(con_val)
        let entry = CDAKMedicalEquipment(event: e_vals)
        entry.shift_dates(date_shift)
        entry_shift_assertions(vals, shift: date_shift, entry: entry)
      }
    }
    
  }

  func test_medication_shift() {
    
    let date_shift: Double = 13
    let values = ENTRY_VALUES // dict is a struct, so it's a copy
    let ful_hist: [String:Any?] = ["dispense_date":15]
    let order_inf: [String:Any?] = ["orderDateTime":nil, "orderExpirationDateTime": 10]
    
    for vals in values {
      let entry = CDAKMedication(event: vals)
      entry.fulfillment_history.append(CDAKFulfillmentHistory(event: ful_hist))
      entry.order_information.append(CDAKOrderInformation(event: order_inf))
      entry.shift_dates(date_shift)
      
      let block: ()->() = {
        self.entry_shift_assertions(ful_hist, shift: date_shift, entry: entry.fulfillment_history.first!)
        self.entry_shift_assertions(order_inf, shift: date_shift, entry: entry.order_information.first!)
      }
      entry_shift_assertions(vals, shift: date_shift, entry: entry, block: block)
    }

    
  }

  func test_order_information_shift() {
    let date_shift: Double = 20
    let values: [[String:Any?]] = [
      ["orderDateTime":nil, "orderExpirationDateTime": nil],
      ["orderDateTime":nil, "orderExpirationDateTime": 10],
      ["orderDateTime":10, "orderExpirationDateTime": nil],
      ["orderDateTime":12, "orderExpirationDateTime": 10],
    ]
    
    for vals in values {
      let entry = CDAKOrderInformation(event: vals)
      entry.shift_dates(date_shift)
      entry_shift_assertions(vals, shift: date_shift, entry: entry)
    }
  }

  func test_procedure_shift() {
    let date_shift: Double = 13
    let values = ENTRY_VALUES // dict is a struct, so it's a copy
    let pro_values: [[String:Any?]] = [["incisionTime":nil],["incisionTime": 10]]
    
    for vals in values {
      for pro_val in pro_values {
        var e_vals = vals
        e_vals.merge(pro_val)
        let entry = CDAKProcedure(event: e_vals)
        entry.shift_dates(date_shift)
        entry_shift_assertions(vals, shift: date_shift, entry: entry)
      }
    }
  }

  func test_provider_performance_shift() {
    
    let date_shift: Double = 20
    let values: [[String:Any?]] = [
      ["start_date": nil, "end_date": nil],
      ["start_date": 1, "end_date": nil],
      ["start_date": nil, "end_date": 1],
      ["start_date": 1, "end_date": 1]
    ]
    
    for vals in values {
      let entry = CDAKProviderPerformance(event: vals)
      entry.shift_dates(date_shift)
      entry_shift_assertions(vals, shift: date_shift, entry: entry)
    }
    
  }

  func test_record_shift() {
    let date_shift: Double = 99
    let values: [[String:Any?]] = [
      ["birthdate": nil, "deathdate": nil],
      ["birthdate": 1, "deathdate": nil],
      ["birthdate": nil, "deathdate": 1],
      ["birthdate": 1, "deathdate": 1]
    ]
    
    for vals in values {
      let entry = CDAKRecord(event: vals)
      entry.shift_dates(date_shift)
      entry_shift_assertions(vals, shift: date_shift, entry: entry)
    }
  }

  //helper method for other tests
  //field_values appear to be things like ["start_time":1] or ["start_time":nil]
  func entry_shift_assertions(_ field_values:[String:Any?], shift: Double, entry: CDAKPropertyAddressable, block: (()->())? = nil ) {

    for (field, value) in field_values {
      //get the value from the entry
      //    entry_value = entry.send field.to_sym
      var entry_value: Double?
      
      //OK... so we can't do reflection in Swift.
      // So... to get by this we're going to do something bad and just write a sort of fake static accessor
      if let a_value = CDAKUtility.getProperty(entry, property: field) as? Double {
        entry_value = a_value
      }

      //note - swapping order of things here
      if let value = value as? Double {
        XCTAssertEqual(value + shift, entry_value, "Field \(field) should equal initial value \(value) plus the shift \(shift)")
      } else {
        XCTAssertEqual(nil, entry_value, "Field should be nil as it was not set before shift")
      }
    }
    
    if let block = block {
      //    #allow a block to be passed in to test embeeded fields of entries like facility
      //    yield field_values, shift, entry if block_given?
      block()
    }
  }

  
}
