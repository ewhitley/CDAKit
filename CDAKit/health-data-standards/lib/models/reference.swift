//
//  reference.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation


/**
CDA Reference
*/
open class CDAKReference: CDAKJSONInstantiable {
  
  // MARK: CDA properties

  ///type
  open var type: String?
  ///referenced type
  open var referenced_type: String = ""
  ///reference
  open var referenced_id: String = ""
  ///Entry
  open var entry: CDAKEntry?

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

  // MARK: - Deprecated - Do not use
  ///Do not use - will be removed. Was used in HDS Ruby.
  required public init(event: [String:Any?]) {
    initFromEventList(event)
  }
  
  ///Do not use - will be removed. Was used in HDS Ruby.
  fileprivate func initFromEventList(_ event: [String:Any?]) {
    for (key, value) in event {
      CDAKUtility.setProperty(self, property: key, value: value)
    }
  }

  
  // MARK: Health-Data-Standards Functions
  internal func resolve_reference() -> CDAKEntry? {
    var an_entry: CDAKEntry?
    
    if let entry = self.entry {
      if let record = entry.record {
        an_entry = (record.entries.filter({ e in
          String(describing: type(of: e)) == referenced_type &&
          e.identifier_as_string == referenced_id
        })).first
      }
    }    
    return an_entry
  }

  
  internal func resolve_referenced_id()  {
    if let entry = self.entry {
      if let record = entry.record {
        let resolved_reference = (record.entries.filter({ e in
          String(describing: type(of: e)) == referenced_type &&
            e.identifier_as_string == referenced_id
        })).first
        if let resolved_reference = resolved_reference {
          self.referenced_id = resolved_reference.id == nil ? "" : (resolved_reference.id)!
        }
      }
    }
  }
}


extension CDAKReference: CDAKJSONExportable {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    if let type = type {
      dict["type"] = type as AnyObject?
    }
    dict["referenced_type"] = referenced_type as AnyObject?
    dict["referenced_id"] = referenced_id as AnyObject?
    if let entry = entry {
      dict["entry"] = entry.jsonDict as AnyObject?
    }
    
    return dict
  }
}
