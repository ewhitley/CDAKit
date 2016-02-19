//
//  allergy.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

/**
Represents an Allergy entry
*/
public class CDAKAllergy: CDAKEntry {

  // MARK: CDA properties
  ///type
  public var type: CDAKCodedEntries = CDAKCodedEntries()
  ///reaction
  public var reaction: CDAKCodedEntries = CDAKCodedEntries() //flat code list
  ///severity
  public var severity: CDAKCodedEntries = CDAKCodedEntries() //flat code list
  
  // MARK: - Initializers
  public init(type:CDAKCodedEntries, reaction: CDAKCodedEntries = CDAKCodedEntries(), severity: CDAKCodedEntries = CDAKCodedEntries()) {
    super.init()
    self.type = type
    self.reaction = reaction
    self.severity = severity
  }

  public required init(){
    super.init()
  }
  
  ///do not use - will be removed
  public required init(event: [String : Any?]) {
     super.init(event: event)
  }
  
}

// MARK: - Mustache marshalling
extension CDAKAllergy {
  override var boxedValues: [String:MustacheBox] {
    var vals = super.boxedValues
    
    vals["type"] = Box(self.type)
    vals["reaction"] = Box(self.reaction)
    vals["severity"] = Box(self.severity)
    
    return vals
  }
}

// MARK: - JSON Generation
extension CDAKAllergy {
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if type.count > 0 {
      dict["type"] = type.codes.map({$0.jsonDict})
    }
    if reaction.count > 0 {
      dict["reaction"] = reaction.codes.map({$0.jsonDict})
    }
    if severity.count > 0 {
      dict["severity"] = severity.codes.map({$0.jsonDict})
    }
    
    return dict
  }
}

