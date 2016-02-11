//
//  fulfillment_history.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//NOTE: was not originally: HDSEntry - changing type
class HDSFulfillmentHistory: HDSEntry {
  
  //include Mongoid::Attributes::Dynamic
  
  var prescription_number: String? //, as: :prescription_number, type: String
  var dispense_date: Double? //, as: :dispense_date, type: Integer
//  var quantityDispensed = [String:String]() //, as: :quantity_dispensed, type: Hash
  var quantity_dispensed = HDSValueAndUnit() //, as: :quantity_dispensed, type: Hash
  
  var fill_number: Int? //, as: :fill_number, type: Integer
  var fill_status: String? //, as: :fill_status, type: String
  
//  var prescription_number: String? {
//    get {return prescriptionNumber}
//    set {prescriptionNumber = newValue}
//  }
//
//  var dispense_date: Double? {
//    get {return dispenseDate}
//    set {dispenseDate = newValue}
//  }
//
//  var fill_number: Int? {
//    get {return fillNumber}
//    set {fillNumber = newValue}
//  }

//  var quantity_dispensed: [String:String] {
//    get {return quantityDispensed}
//    set {quantityDispensed = newValue}
//  }
//  
//  var fill_status: String? {
//    get {return fillStatus}
//    set {fillStatus = newValue}
//  }

  
  //belongs_to :provider, class_name: "HDSProvider"
  var provider: HDSProvider?
  
  override func shift_dates(date_diff: Double) {
    
    super.shift_dates(date_diff)
    
    if let dispense_date = dispense_date {
      self.dispense_date = dispense_date + date_diff
    }
  }
  
  override var description: String {
    return super.description + " , prescription_number: \(prescription_number), dispense_date: \(dispense_date), fill_number: \(fill_number), fill_status: \(fill_status), quantity_dispensed: \(quantity_dispensed)"
  }

  
//  init() {
//  }
//  
//  init(event: [String:Any?]) {
//    
//    let times = [
//      "dispense_date"
//    ]
//    
//    for time_key in times {
//      if event.keys.contains(time_key) {
//        var a_new_time: Int?
//        if let time = event[time_key] as? Int {
//          a_new_time = time
//        }
//        if let time = event[time_key] as? String {
//          if let time = Int(time) {
//            a_new_time = time
//          }
//        }
//        switch time_key {
//        case "dispense_date": self.dispense_date = a_new_time
//        default: print("HDSEntry.init() undefined value setter for key \(time_key)")
//        }
//      }
//    }
//    
//  }
  
}
