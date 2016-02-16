//
//  allergy.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache


public class CDAKAllergy: CDAKEntry {
  public var type: CDAKCodedEntries = CDAKCodedEntries()
  public var reaction: CDAKCodedEntries = CDAKCodedEntries() //flat code list
  public var severity: CDAKCodedEntries = CDAKCodedEntries() //flat code list
  
  public init(type:CDAKCodedEntries, reaction: CDAKCodedEntries = CDAKCodedEntries(), severity: CDAKCodedEntries = CDAKCodedEntries()) {
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

extension CDAKAllergy {
  override var boxedValues: [String:MustacheBox] {
    var vals = super.boxedValues
    
    vals["type"] = Box(self.type)
    vals["reaction"] = Box(self.reaction)
    vals["severity"] = Box(self.severity)
    
    return vals
  }
}