//
//  reference.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKReference: CDAKJSONInstantiable {
  
  public var type: String?
  public var referenced_type: String = ""
  public var referenced_id: String = ""
  
  public var entry: CDAKEntry?
  
  //FIXME: Can't resolve any of this since it's using Mongo
  public init(entry: CDAKEntry) {
    self.entry = entry
  }
  
  public init(type: String?, referenced_type: String, referenced_id: String?, entry: CDAKEntry? = nil ) {
    self.type = type
    self.referenced_type = referenced_type
    if let referenced_id = referenced_id {
      self.referenced_id = referenced_id
    } else {
      self.referenced_id = ""
    }
    self.entry = entry
  }

  required public init(event: [String:Any?]) {
    initFromEventList(event)
  }
  
  private func initFromEventList(event: [String:Any?]) {
    for (key, value) in event {
      CDAKUtility.setProperty(self, property: key, value: value)
    }
  }

  
  
  // this is a problem...
  //  I can't tell if this returns one entry or multiple
  //  Appears to be one...
  func resolve_reference() -> CDAKEntry? {
    var an_entry: CDAKEntry?
    
    if let entry = self.entry {
      if let record = entry.record {
        an_entry = (record.entries.filter({ e in
          String(e.dynamicType) == referenced_type &&
          e.identifier_as_string == referenced_id
        })).first
      }
    }    
    return an_entry
  }

  
  func resolve_referenced_id()  {
    if let entry = self.entry {
      if let record = entry.record {
        let resolved_reference = (record.entries.filter({ e in
          String(e.dynamicType) == referenced_type &&
            e.identifier_as_string == referenced_id
        })).first
        if let resolved_reference = resolved_reference {
          self.referenced_id = resolved_reference.id == nil ? "" : (resolved_reference.id)!
        }
      }
    }
  }
}