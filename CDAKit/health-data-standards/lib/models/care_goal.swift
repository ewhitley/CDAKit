//
//  care_goal.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

/**
Represents a Care Goal.  May be any of a variety of entries.
*/
public class CDAKCareGoal: CDAKEntry {

  // MARK: CDA properties
  var related_to: CDAKCodedEntries = CDAKCodedEntries()
  var target_outcome: CDAKCodedEntries = CDAKCodedEntries()
  
}

// MARK: - Mustache marshalling
extension CDAKCareGoal {
  override var boxedValues: [String:MustacheBox] {
    var vals = super.boxedValues
    
    vals["related_to"] = Box(self.related_to)
    vals["target_outcome"] = Box(self.target_outcome)
    
    return vals
  }
}

// MARK: - JSON Generation
extension CDAKCareGoal {
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if related_to.count > 0 {
      dict["related_to"] = related_to.jsonDict
    }
    if target_outcome.count > 0 {
      dict["target_outcome"] = target_outcome.jsonDict
    }
    
    return dict
  }
}
