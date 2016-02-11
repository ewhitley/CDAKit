//
//  medical_equipment.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

class HDSMedicalEquipment: HDSEntry {
  
  var manufacturer: String?
  var anatomical_structure: HDSCodedEntries = HDSCodedEntries() //, as: :anatomical_structure, type: Hash
  var removal_time: Double? //, as: :removal_time, type: Integer
  var anatomical_approach: HDSCodedEntries = HDSCodedEntries()
  var reaction: HDSCodedEntries = HDSCodedEntries()
  
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