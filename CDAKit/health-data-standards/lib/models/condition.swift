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
open class CDAKCondition: CDAKEntry {
  
  // MARK: CDA properties
  ///Type
  open var type          : String?
  ///Was this the cause of death?
  open var cause_of_death  : Bool? = false
  ///Time of death
  open var time_of_death : Double?
  ///Priority, if available.  "Primary," "Secondary," etc. in numeric form
  open var priority      : Int?
  ///Name of condition
  open var name          : String?
  ///Ordinality
  open var ordinality    : CDAKCodedEntries = CDAKCodedEntries()
  ///Severity
  open var severity      : CDAKCodedEntries = CDAKCodedEntries() //# Currently unsupported by any importers
  ///Laterality
  open var laterality    : CDAKCodedEntries = CDAKCodedEntries()
  ///Anatomical Taret
  open var anatomical_target : CDAKCodedEntries = CDAKCodedEntries()
  ///Anatomical Location
  open var anatomical_location : CDAKCodedEntries = CDAKCodedEntries()
  ///Age at onset (if documented)
  open var age_at_onset: Int? //an actual age - like "20"
  
  ///Treating provider (if documented)
  open var treating_provider: [CDAKProvider] = [CDAKProvider]()
  
  ///renders display version of code based on preferred code set
  override open var code_display : String {
    return ViewHelper.code_display(self, options: ["preferred_code_sets":self.preferred_code_sets, "tag_name": "value", "extra_content": "xsi:type=\"CD\""])
  }
  
  // MARK: Health-Data-Standards Functions
  ///Offset all dates
  override func shift_dates(_ date_diff: Double) {
    super.shift_dates(date_diff)
    if let time_of_death = time_of_death {
      self.time_of_death = time_of_death + date_diff
    }
  }
  
  // MARK: Standard properties
  ///Debugging description
  override open var description: String {
    return super.description + " name: \(name), type: \(type), cause_of_death: \(cause_of_death), time_of_death: \(time_of_death), priority: \(priority), ordinality: \(ordinality), severity: \(severity), laterality: \(laterality), anatomical_target: \(anatomical_target), anatomical_location: \(anatomical_location)"
  }
  
}

extension CDAKCondition {
  // MARK: - Mustache marshalling
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
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let type = type {
      dict["type"] = type as AnyObject?
    }
    if let cause_of_death = cause_of_death {
      dict["cause_of_death"] = cause_of_death as AnyObject?
    }
    if let time_of_death = time_of_death {
      dict["time_of_death"] = time_of_death as AnyObject?
    }
    if let priority = priority {
      dict["priority"] = priority as AnyObject?
    }
    if let name = name {
      dict["name"] = name as AnyObject?
    }
    if ordinality.count > 0 {
      dict["ordinality"] = ordinality.codes.map({$0.jsonDict}) as AnyObject?
    }
    if severity.count > 0 {
      dict["severity"] = severity.codes.map({$0.jsonDict}) as AnyObject?
    }
    if laterality.count > 0 {
      dict["laterality"] = laterality.codes.map({$0.jsonDict}) as AnyObject?
    }
    if anatomical_target.count > 0 {
      dict["anatomical_target"] = anatomical_target.codes.map({$0.jsonDict}) as AnyObject?
    }
    if anatomical_location.count > 0 {
      dict["anatomical_location"] = anatomical_location.codes.map({$0.jsonDict}) as AnyObject?
    }
    if let age_at_onset = age_at_onset {
      dict["age_at_onset"] = age_at_onset as AnyObject?
    }
    if treating_provider.count > 0 {
      dict["treating_provider"] = treating_provider.map({$0.jsonDict}) as AnyObject?
    }
    
    
    return dict
  }
}
