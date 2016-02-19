//
//  procedure.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

/**
 Medical procedure.  Commonly used for things like surgical procedures.
*/
public class CDAKProcedure: CDAKEntry {
  
  // MARK: CDA properties
  ///date/time of first incision. NOT start of case.  First incision.
  public var incision_time : Double? //,        type: Integer,      as: :incision_time
  ///ordinality
  public var ordinality: CDAKCodedEntries = CDAKCodedEntries() //,          type: Hash
  ///source
  public var source: CDAKCodedEntries = CDAKCodedEntries() //,              type: Hash
  ///anatomical approach
  public var anatomical_approach: CDAKCodedEntries = CDAKCodedEntries() //
  ///anatomical target
  public var anatomical_target: CDAKCodedEntries = CDAKCodedEntries() //
  ///method
  public var method: CDAKCodedEntries = CDAKCodedEntries() //
  ///reaction
  public var reaction: CDAKCodedEntries = CDAKCodedEntries() //
  ///radiation dost
  public var radiation_dose: CDAKCodedEntries = CDAKCodedEntries() //this is probably wrong
  ///radiation duration.  It is currently unclear how this should be represented
  public var radiation_duration: CDAKCodedEntries = CDAKCodedEntries() //this is probably wrong
  ///facility where procedure occurred
  public var facility: CDAKFacility?
  ///provider who was primary actor
  public var performer: CDAKProvider?
  

  // MARK: Health-Data-Standards Functions
  ///Offset all dates by specified double
  override func shift_dates(date_diff: Double) {
    super.shift_dates(date_diff)

    if let incision_time = incision_time {
      self.incision_time = incision_time + date_diff
    }
  }

}

// MARK: - JSON Generation
extension CDAKProcedure {
  ///Dictionary for JSON data
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