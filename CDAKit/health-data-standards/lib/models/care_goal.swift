//
//  care_goal.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

public class CDAKCareGoal: CDAKEntry {

  var related_to: [String:String] = [String:String]()
  var target_outcome: [String:String] = [String:String]()
  
}

extension CDAKCareGoal {
  override var boxedValues: [String:MustacheBox] {
    var vals = super.boxedValues
    
    vals["related_to"] = Box(self.related_to)
    vals["target_outcome"] = Box(self.target_outcome)
    
    return vals
  }
}

extension CDAKCareGoal {
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if related_to.count > 0 {
      dict["related_to"] = related_to
    }
    if target_outcome.count > 0 {
      dict["target_outcome"] = target_outcome
    }
    
    return dict
  }
}
