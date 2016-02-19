//
//  condition.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache



/**
CDA Condition
 
Most frequently considerd a "problem" or "diagnosis."
 
*/
public class CDAKCondition: CDAKEntry {
  
  // MARK: CDA properties
  ///Type
  public var type          : String?
  ///Was this the cause of death?
  public var cause_of_death  : Bool? = false
  ///Time of death
  public var time_of_death : Double?
  ///Priority, if available.  "Primary," "Secondary," etc. in numeric form
  public var priority      : Int?
  ///Name of condition
  public var name          : String?
  ///Ordinality
  public var ordinality    : CDAKCodedEntries = CDAKCodedEntries()
  ///Severity
  public var severity      : CDAKCodedEntries = CDAKCodedEntries() //# Currently unsupported by any importers
  ///Laterality
  public var laterality    : CDAKCodedEntries = CDAKCodedEntries()
  ///Anatomical Taret
  public var anatomical_target : CDAKCodedEntries = CDAKCodedEntries()
  ///Anatomical Location
  public var anatomical_location : CDAKCodedEntries = CDAKCodedEntries()
  ///Age at onset (if documented)
  public var age_at_onset: Int? //an actual age - like "20"
  
  ///Treating provider (if documented)
  public var treating_provider: [CDAKProvider] = [CDAKProvider]()
  
  // MARK: Health-Data-Standards Functions
  ///Offset all dates
  override func shift_dates(date_diff: Double) {
    super.shift_dates(date_diff)
    if let time_of_death = time_of_death {
      self.time_of_death = time_of_death + date_diff
    }
  }
  
  // MARK: Standard properties
  ///Debugging description
  override public var description: String {
    return super.description + " name: \(name), type: \(type), cause_of_death: \(cause_of_death), time_of_death: \(time_of_death), priority: \(priority), ordinality: \(ordinality), severity: \(severity), laterality: \(laterality), anatomical_target: \(anatomical_target), anatomical_location: \(anatomical_location)"
  }
  
}

extension CDAKCondition {
  
  override public var code_display : String {
    return ViewHelper.code_display(self, options: ["preferred_code_sets":self.preferred_code_sets, "tag_name": "value", "extra_content": "xsi:type=\"CD\""])
  }
  
  override public var boxedValues: [String:MustacheBox] {
    var vals = super.boxedValues
    
    vals["type"] = Box(self.type)
    vals["cause_of_death"] = Box(self.cause_of_death)
    
    vals["time_of_death"] = Box(self.time_of_death)
    vals["priority"] = Box(self.priority)
    vals["name"] = Box(self.name)
    vals["ordinality"] = Box(self.ordinality)
    vals["severity"] = Box(self.severity)
    vals["laterality"] = Box(self.laterality)
    vals["anatomical_target"] = Box(self.anatomical_target)
    vals["anatomical_location"] = Box(self.anatomical_location)
    
    return vals
  }
}

extension CDAKCondition {
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let type = type {
      dict["type"] = type
    }
    if let cause_of_death = cause_of_death {
      dict["cause_of_death"] = cause_of_death
    }
    if let time_of_death = time_of_death {
      dict["time_of_death"] = time_of_death
    }
    if let priority = priority {
      dict["priority"] = priority
    }
    if let name = name {
      dict["name"] = name
    }
    if ordinality.count > 0 {
      dict["ordinality"] = ordinality.codes.map({$0.jsonDict})
    }
    if severity.count > 0 {
      dict["severity"] = severity.codes.map({$0.jsonDict})
    }
    if laterality.count > 0 {
      dict["laterality"] = laterality.codes.map({$0.jsonDict})
    }
    if anatomical_target.count > 0 {
      dict["anatomical_target"] = anatomical_target.codes.map({$0.jsonDict})
    }
    if anatomical_location.count > 0 {
      dict["anatomical_location"] = anatomical_location.codes.map({$0.jsonDict})
    }
    if let age_at_onset = age_at_onset {
      dict["age_at_onset"] = age_at_onset
    }
    if treating_provider.count > 0 {
      dict["treating_provider"] = treating_provider.map({$0.jsonDict})
    }
    
    
    return dict
  }
}
