//
//  medication.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKInsuranceProvider: CDAKEntry {

  public var payer: CDAKOrganization? //, class_name: "CDAKOrganization"
  public var guarantors = [CDAKGuarantor]()//, class_name: "CDAKGuarantor"
  public var subscriber: CDAKPerson? //, class_name: "CDAKPerson"
  
  public var type: String?
  public var member_id: String?
  public var relationship : CDAKCodedEntries = CDAKCodedEntries() //, type: Hash
  public var financial_responsibility_type : CDAKCodedEntries = CDAKCodedEntries() //, type: Hash
  public var name: String?
  
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
  
  override public var description: String {
    return super.description + ", name: \(name), type: \(type), member_id: \(member_id), relationship: \(relationship), financial_responsibility_type: \(financial_responsibility_type), financial_responsibility_type: \(financial_responsibility_type), payer: \(payer), guarantors: \(guarantors), subscriber: \(subscriber)"
  }

  
}