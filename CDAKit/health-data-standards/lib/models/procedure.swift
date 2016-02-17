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
  
  public var radiation_dose: CDAKCodedEntries = CDAKCodedEntries() //this is probably wrong
  public var radiation_duration: CDAKCodedEntries = CDAKCodedEntries() //this is probably wrong
  
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

extension CDAKProcedure {
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let incision_time = incision_time {
      dict["incision_time"] = incision_time
    }
    if ordinality.count > 0 {
      dict["ordinality"] = ordinality.codes.map({$0.jsonDict})
    }
    if source.count > 0 {
      dict["source"] = source.codes.map({$0.jsonDict})
    }
    if anatomical_approach.count > 0 {
      dict["anatomical_approach"] = anatomical_approach.codes.map({$0.jsonDict})
    }
    if anatomical_target.count > 0 {
      dict["anatomical_target"] = anatomical_target.codes.map({$0.jsonDict})
    }
    if method.count > 0 {
      dict["method"] = method.codes.map({$0.jsonDict})
    }
    if reaction.count > 0 {
      dict["reaction"] = reaction.codes.map({$0.jsonDict})
    }
    if radiation_dose.count > 0 {
      dict["radiation_dose"] = radiation_dose.codes.map({$0.jsonDict})
    }
    if radiation_duration.count > 0 {
      dict["radiation_duration"] = radiation_duration.codes.map({$0.jsonDict})
    }
    if let facility = facility {
      dict["facility"] = facility
    }
    if let performer = performer {
      dict["performer"] = performer
    }
    
    return dict
  }
}