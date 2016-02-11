//
//  procedure.swift
//  CCDAccess
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

class HDSProcedure: HDSEntry {
  
  var incisionTime : Double? //,        type: Integer,      as: :incision_time
  var ordinality: HDSCodedEntries = HDSCodedEntries() //,          type: Hash
  var source: HDSCodedEntries = HDSCodedEntries() //,              type: Hash
  var anatomical_approach: HDSCodedEntries = HDSCodedEntries() //
  var anatomical_target: HDSCodedEntries = HDSCodedEntries() //
  var method: HDSCodedEntries = HDSCodedEntries() //
  var reaction: HDSCodedEntries = HDSCodedEntries() //
  
  var radiation_dose: HDSCodedEntries = HDSCodedEntries() //
  var radiation_duration: HDSCodedEntries = HDSCodedEntries() //
  
  var facility: HDSFacility?
  
  //belongs_to :performer, class_name: "HDSProvider"
  var performer: HDSProvider?
  
  override func shift_dates(date_diff: Double) {
    super.shift_dates(date_diff)

    if let incisionTime = incisionTime {
      self.incisionTime = incisionTime + date_diff
    }
  }
  
  var incision_time: Double? {
    get {return incisionTime }
    set {incisionTime = newValue}
  }

}