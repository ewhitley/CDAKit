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
open class CDAKAllergy: CDAKEntry {

  // MARK: CDA properties
  ///type
  open var type: CDAKCodedEntries = CDAKCodedEntries()
  ///reaction
  open var reaction: CDAKEntryDetail?// = CDAKCodedEntries() //flat code list
  ///severity
  open var severity: CDAKEntryDetail?// = CDAKCodedEntries() //flat code list
  
  // MARK: - Initializers
  public init(type:CDAKCodedEntries, reaction: CDAKEntryDetail? = nil, severity: CDAKEntryDetail? = nil) {
//  public init(type:CDAKCodedEntries, reaction: CDAKCodedEntries = CDAKCodedEntries(), severity: CDAKCodedEntries = CDAKCodedEntries()) {
    super.init()
    self.type = type
    self.reaction = reaction
    self.severity = severity
  }

  public required init(){
    super.init()
  }
  
  // MARK: - Deprecated - Do not use
  ///Do not use - will be removed. Was used in HDS Ruby.
  public required init(event: [String : Any?]) {
     super.init(event: event)
  }
  
}

extension CDAKAllergy {
  // MARK: - Mustache marshalling
  override var boxedValues: [String:MustacheBox] {
    var vals = super.boxedValues
    
    vals["type"] = Box(self.type)
    vals["reaction"] = Box(self.reaction)
    vals["severity"] = Box(self.severity)
    
    return vals
  }
}

extension CDAKAllergy {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if type.count > 0 {
      dict["type"] = type.codes.map({$0.jsonDict}) as AnyObject?
    }
//    if reaction.count > 0 {
//      dict["reaction"] = reaction.codes.map({$0.jsonDict})
//    }
//    if severity.count > 0 {
//      dict["severity"] = severity.codes.map({$0.jsonDict})
//    }
    if let reaction = reaction {
      dict["reaction"] = reaction.jsonDict as AnyObject?
    }
    if let severity = severity {
      dict["severity"] = severity.jsonDict as AnyObject?
    }
    
    return dict
  }
}

