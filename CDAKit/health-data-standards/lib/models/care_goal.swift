//
//  care_goal.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

class HDSCareGoal: HDSEntry {

  var relatedTo: [String:String] = [String:String]()
  var targetOutcome: [String:String] = [String:String]()

  var related_to: [String:String] {
    get {
      return relatedTo
    }
    set(value) {
      relatedTo = value
    }
  }

  var target_outcome: [String:String] {
    get {
      return targetOutcome
    }
    set(value) {
      targetOutcome = value
    }
  }

  
}

extension HDSCareGoal {
  override var boxedValues: [String:MustacheBox] {
    var vals = super.boxedValues
    
    vals["related_to"] = Box(self.related_to)
    vals["target_outcome"] = Box(self.target_outcome)
    
    return vals
  }
}

