//
//  procedure.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKProcedure: CDAKEntry {
  
  public var incisionTime : Double? //,        type: Integer,      as: :incision_time
  public var ordinality: CDAKCodedEntries = CDAKCodedEntries() //,          type: Hash
  public var source: CDAKCodedEntries = CDAKCodedEntries() //,              type: Hash
  public var anatomical_approach: CDAKCodedEntries = CDAKCodedEntries() //
  public var anatomical_target: CDAKCodedEntries = CDAKCodedEntries() //
  public var method: CDAKCodedEntries = CDAKCodedEntries() //
  public var reaction: CDAKCodedEntries = CDAKCodedEntries() //
  
  public var radiation_dose: CDAKCodedEntries = CDAKCodedEntries() //
  public var radiation_duration: CDAKCodedEntries = CDAKCodedEntries() //
  
  public var facility: CDAKFacility?
  
  public var performer: CDAKProvider?
  
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