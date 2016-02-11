//
//  condition.swift
//  CCDAccess
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache




class HDSCondition: HDSEntry {
  
  var type          : String?
  var cause_of_death  : Bool? = false
  var time_of_death : Double?
  var priority      : Int?
  var name          : String?
  var ordinality    : HDSCodedEntries = HDSCodedEntries()
  var severity      : HDSCodedEntries = HDSCodedEntries() //# Currently unsupported by any importers
  var laterality    : HDSCodedEntries = HDSCodedEntries()
  var anatomical_target : HDSCodedEntries = HDSCodedEntries()
  var anatomical_location : HDSCodedEntries = HDSCodedEntries()
  var age_at_onset: Int? //an actual age - like "20"
  
  var treating_provider: [HDSProvider] = [HDSProvider]()
  
  override func shift_dates(date_diff: Double) {
    super.shift_dates(date_diff)
    if let time_of_death = time_of_death {
      self.time_of_death = time_of_death + date_diff
    }
  }
  
  override var description: String {
    return super.description + " name: \(name), type: \(type), cause_of_death: \(cause_of_death), time_of_death: \(time_of_death), priority: \(priority), ordinality: \(ordinality), severity: \(severity), laterality: \(laterality), anatomical_target: \(anatomical_target), anatomical_location: \(anatomical_location)"
  }
  
}

extension HDSCondition {
  
  override var code_display : String {
    return ViewHelper.code_display(self, options: ["preferred_code_sets":self.preferred_code_sets, "tag_name": "value", "extra_content": "xsi:type=\"CD\""])
  }
  
  override var boxedValues: [String:MustacheBox] {
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
