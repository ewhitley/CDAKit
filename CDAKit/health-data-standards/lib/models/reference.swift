//
//  reference.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class HDSReference: HDSJSONInstantiable {
  
  public var type: String?
  public var referenced_type: String = ""
  public var referenced_id: String = ""
  
  public var entry: HDSEntry?
  
  //MARK: FIXME: Can't resolve any of this since it's using Mongo
  
  //embedded_in :entry
  
  public init(entry: HDSEntry) {
    self.entry = entry
  }
  
  public init(type: String?, referenced_type: String, referenced_id: String?, entry: HDSEntry? = nil ) {
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
      HDSUtility.setProperty(self, property: key, value: value)
    }
  }

  
  
  // this is a problem...
  //  I can't tell if this returns one entry or multiple
  //  Appears to be one...
  func resolve_reference() -> HDSEntry? {
    var an_entry: HDSEntry?
    
    if let entry = self.entry {
      //print("found an entry")
      if let record = entry.record {
        //print("found a record")
        //for e in record.entries {
          //print("reference_type = '\(referenced_type)', referenced_id = '\(referenced_id)', entry = \(e) is of type '\(e.dynamicType)' with identifier '\(e.identifier_as_string)' ")
        //}
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