//
//  allergy.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache


class HDSAllergy: HDSEntry {
  var type: HDSCodedEntries = HDSCodedEntries()
  var reaction: HDSCodedEntries = HDSCodedEntries() //flat code list
  var severity: HDSCodedEntries = HDSCodedEntries() //flat code list
  
  init(type:HDSCodedEntries, reaction: HDSCodedEntries = HDSCodedEntries(), severity: HDSCodedEntries = HDSCodedEntries()) {
    super.init()
    self.type = type
    self.reaction = reaction
    self.severity = severity
  }

  required init(){
    super.init()
  }
  
  required init(event: [String : Any?]) {
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