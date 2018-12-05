//
//  procedure.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

/**
 Medical procedure.  Commonly used for things like surgical procedures.
*/
open class CDAKProcedure: CDAKEntry {
  
  // MARK: CDA properties
  ///date/time of first incision. NOT start of case.  First incision.
  open var incision_time : Double? //,        type: Integer,      as: :incision_time
  ///ordinality
  open var ordinality: CDAKCodedEntries = CDAKCodedEntries() //,          type: Hash
  ///source
  open var source: CDAKCodedEntries = CDAKCodedEntries() //,              type: Hash
  ///anatomical approach
  open var anatomical_approach: CDAKCodedEntries = CDAKCodedEntries() //
  ///anatomical target
  open var anatomical_target: CDAKCodedEntries = CDAKCodedEntries() //
  ///method
  open var method: CDAKCodedEntries = CDAKCodedEntries() //
  ///reaction
  open var reaction: CDAKCodedEntries = CDAKCodedEntries() //
  ///radiation dost
  open var radiation_dose: CDAKCodedEntries = CDAKCodedEntries() //this is probably wrong
  ///radiation duration.  It is currently unclear how this should be represented
  open var radiation_duration: CDAKCodedEntries = CDAKCodedEntries() //this is probably wrong
  ///facility where procedure occurred
  open var facility: CDAKFacility?
  ///provider who was primary actor
  open var performer: CDAKProvider?
  

  // MARK: Health-Data-Standards Functions
  ///Offset all dates by specified double
  override func shift_dates(_ date_diff: Double) {
    super.shift_dates(date_diff)

    if let incision_time = incision_time {
      self.incision_time = incision_time + date_diff
    }
  }

}


extension CDAKProcedure {
  // MARK: - Mustache marshalling
  override var boxedValues: [String:MustacheBox] {
    var vals = super.boxedValues
    
    vals["incision_time"] = Box(self.incision_time)
    vals["ordinality"] = Box(self.ordinality)
    vals["source"] = Box(self.source)
    vals["anatomical_approach"] = Box(self.anatomical_approach)
    vals["anatomical_target"] = Box(self.anatomical_target)
    vals["method"] = Box(self.method)
    vals["reaction"] = Box(self.reaction)
    vals["radiation_dose"] = Box(self.radiation_dose)
    vals["radiation_duration"] = Box(self.radiation_duration)
    vals["facility"] = Box(self.facility)
    vals["performer"] = Box(self.performer)
    
    return vals
  }
}


extension CDAKProcedure {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let incision_time = incision_time {
      dict["incision_time"] = incision_time as AnyObject?
    }
    if ordinality.count > 0 {
      dict["ordinality"] = ordinality.codes.map({$0.jsonDict}) as AnyObject?
    }
    if source.count > 0 {
      dict["source"] = source.codes.map({$0.jsonDict}) as AnyObject?
    }
    if anatomical_approach.count > 0 {
      dict["anatomical_approach"] = anatomical_approach.codes.map({$0.jsonDict}) as AnyObject?
    }
    if anatomical_target.count > 0 {
      dict["anatomical_target"] = anatomical_target.codes.map({$0.jsonDict}) as AnyObject?
    }
    if method.count > 0 {
      dict["method"] = method.codes.map({$0.jsonDict}) as AnyObject?
    }
    if reaction.count > 0 {
      dict["reaction"] = reaction.codes.map({$0.jsonDict}) as AnyObject?
    }
    if radiation_dose.count > 0 {
      dict["radiation_dose"] = radiation_dose.codes.map({$0.jsonDict}) as AnyObject?
    }
    if radiation_duration.count > 0 {
      dict["radiation_duration"] = radiation_duration.codes.map({$0.jsonDict}) as AnyObject?
    }
    if let facility = facility {
      dict["facility"] = facility.jsonDict as AnyObject?
    }
    if let performer = performer {
      dict["performer"] = performer.jsonDict as AnyObject?
    }
    
    return dict
  }
}
