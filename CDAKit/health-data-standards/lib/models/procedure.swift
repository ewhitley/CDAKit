//
//  procedure.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class HDSProcedure: HDSEntry {
  
  public var incisionTime : Double? //,        type: Integer,      as: :incision_time
  public var ordinality: HDSCodedEntries = HDSCodedEntries() //,          type: Hash
  public var source: HDSCodedEntries = HDSCodedEntries() //,              type: Hash
  public var anatomical_approach: HDSCodedEntries = HDSCodedEntries() //
  public var anatomical_target: HDSCodedEntries = HDSCodedEntries() //
  public var method: HDSCodedEntries = HDSCodedEntries() //
  public var reaction: HDSCodedEntries = HDSCodedEntries() //
  
  public var radiation_dose: HDSCodedEntries = HDSCodedEntries() //
  public var radiation_duration: HDSCodedEntries = HDSCodedEntries() //
  
  public var facility: HDSFacility?
  
  //belongs_to :performer, class_name: "HDSProvider"
  public var performer: HDSProvider?
  
  override func shift_dates(date_diff: Double) {
    super.shift_dates(date_diff)

    if let incisionTime = incisionTime {
      self.incisionTime = incisionTime + date_diff
    }
  }
  
  public var incision_time: Double? {
    get {return incisionTime }
    set {incisionTime = newValue}
  }

}