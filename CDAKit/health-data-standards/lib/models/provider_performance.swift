//
//  provider_performance.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//NOTE: changing type to CDAKEntry
public class CDAKProviderPerformance: CDAKEntry {
  //include Mongoid::Attributes::Dynamic
  
//  var record: CDAKRecord?
  
  public var start_date: Double?
  public var end_date: Double?
  
  //MARK: FIXME - model relationship issues here
  //belongs_to :provider
  //embedded_in :record
  public var provider: CDAKProvider?
  
  override func shift_dates(date_diff: Double) {
    super.shift_dates(date_diff)

    if let start_date = start_date {
      self.start_date = start_date + date_diff
    }
    if let end_date = end_date {
      self.end_date = end_date + date_diff
    }
  }
  
//  init(event: [String:Any?]) {
//    for (key, value) in event {
//      CDAKCommonUtility.setProperty(self, property: key, value: value)
//    }
//  }
  
//  init(event: [String:Any?]) {
//    
//    let times = [
//      "end_date",
//      "start_date"
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
//        case "end_date": self.end_date = a_new_time
//        case "start_date": self.start_date = a_new_time
//        default: print("CDAKEntry.init() undefined value setter for key \(time_key)")
//        }
//      }
//    }
//    
//  }
  
}