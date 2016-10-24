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
open class CDAKCareGoal: CDAKEntry {

  // MARK: CDA properties
  ///Relaeted To (coded)
  open var related_to: CDAKCodedEntries = CDAKCodedEntries()
  ///Target Outcome (coded)
  open var target_outcome: CDAKCodedEntries = CDAKCodedEntries()
  
}

extension CDAKCareGoal {
  // MARK: - Mustache marshalling
  override var boxedValues: [String:MustacheBox] {
    var vals = super.boxedValues
    
    vals["related_to"] = Box(self.related_to)
    vals["target_outcome"] = Box(self.target_outcome)
    
    return vals
  }
}

extension CDAKCareGoal {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if related_to.count > 0 {
      dict["related_to"] = related_to.jsonDict as AnyObject?
    }
    if target_outcome.count > 0 {
      dict["target_outcome"] = target_outcome.jsonDict as AnyObject?
    }
    
    return dict
  }
}
