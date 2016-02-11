//
//  guarantor.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//NOTE: making this an HDSEntry subclass - This is a change to the Ruby code
public class HDSGuarantor: HDSEntry {
  
  //include Mongoid::Attributes::Dynamic
  
  public var organization: HDSOrganization?
  public var person: HDSPerson?
  
  override public var description: String {
    return super.description + " person: \(person), organization: \(organization)"
  }

  
//  var time: Int?
//  var start_time: Int?
//  var end_time: Int?
//  
//  func shift_dates(date_diff: Int) {
//    if let start_time = start_time {
//      self.start_time = start_time + date_diff
//    }
//    if let end_time = end_time {
//      self.end_time = end_time + date_diff
//    }
//  }
  
//  init(event: [String:Any?]) {
//    
//    let times = [
//      "end_time",
//      "start_time",
//      "time"
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
//        case "end_time": self.end_time = a_new_time
//        case "start_time": self.start_time = a_new_time
//        case "time": self.time = a_new_time
//        default: print("HDSEntry.init() undefined value setter for key \(time_key)")
//        }
//      }
//    }
//    
//  }
  
}