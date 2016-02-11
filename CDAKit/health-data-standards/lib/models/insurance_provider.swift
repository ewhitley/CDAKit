//
//  medication.swift
//  CCDAccess
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

class HDSInsuranceProvider: HDSEntry {

  var payer: HDSOrganization? //, class_name: "HDSOrganization"
  var guarantors = [HDSGuarantor]()//, class_name: "HDSGuarantor"
  var subscriber: HDSPerson? //, class_name: "HDSPerson"
  
  var type: String?
  var member_id: String?
  var relationship : HDSCodedEntries = HDSCodedEntries() //, type: Hash
  var financial_responsibility_type : HDSCodedEntries = HDSCodedEntries() //, type: Hash
  var name: String?
  
  override func shift_dates(date_diff: Double) {
    //super.shift_dates(date_diff)

    if let start_time = start_time {
      self.start_time = start_time + date_diff
    }
    if let end_time = end_time {
      self.end_time = end_time + date_diff
    }
    if let time = time {
      self.time = time + date_diff
    }
    
    for g in guarantors {
      g.shift_dates(date_diff)
    }
  }
  
  override var description: String {
    return super.description + ", name: \(name), type: \(type), member_id: \(member_id), relationship: \(relationship), financial_responsibility_type: \(financial_responsibility_type), financial_responsibility_type: \(financial_responsibility_type), payer: \(payer), guarantors: \(guarantors), subscriber: \(subscriber)"
  }

  
}