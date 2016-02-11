//
//  allergy.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache


public class HDSAllergy: HDSEntry {
  public var type: HDSCodedEntries = HDSCodedEntries()
  public var reaction: HDSCodedEntries = HDSCodedEntries() //flat code list
  public var severity: HDSCodedEntries = HDSCodedEntries() //flat code list
  
  public init(type:HDSCodedEntries, reaction: HDSCodedEntries = HDSCodedEntries(), severity: HDSCodedEntries = HDSCodedEntries()) {
    super.init()
    self.type = type
    self.reaction = reaction
    self.severity = severity
  }

  public required init(){
    super.init()
  }
  
  public required init(event: [String : Any?]) {
     super.init(event: event)
  }
  
}

extension HDSAllergy {
  override var boxedValues: [String:MustacheBox] {
    var vals = super.boxedValues
    
    vals["type"] = Box(self.type)
    vals["reaction"] = Box(self.reaction)
    vals["severity"] = Box(self.severity)
    
    return vals
  }
}