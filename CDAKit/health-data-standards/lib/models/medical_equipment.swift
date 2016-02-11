//
//  medical_equipment.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class HDSMedicalEquipment: HDSEntry {
  
  public var manufacturer: String?
  public var anatomical_structure: HDSCodedEntries = HDSCodedEntries() //, as: :anatomical_structure, type: Hash
  public var removal_time: Double? //, as: :removal_time, type: Integer
  public var anatomical_approach: HDSCodedEntries = HDSCodedEntries()
  public var reaction: HDSCodedEntries = HDSCodedEntries()
  
//  var removal_time : Double? {
//    get { return removalTime }
//    set { removalTime = newValue }
//  }
  
  override func shift_dates(date_diff: Double) {
    super.shift_dates(date_diff)

    if let removal_time = removal_time {
      self.removal_time = removal_time + date_diff
    }
  }
  
}