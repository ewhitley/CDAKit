//
//  cda_identifier.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

/**
CDA Identifier
 
Usually takes the form of a "root" (required) and an "extension" (identifier) (optional).
 
[Additional information](http://www.cdapro.com/know/24985)
*/
public class CDAKCDAIdentifier: Equatable, Hashable, CDAKJSONInstantiable, CustomStringConvertible {

  ///CDA Root
  public var root: String?
  ///CDA Extension
  public var extension_id: String?
  
  public var hashValue: Int {
    return "\(root)\(extension_id)".hashValue
  }
  
  // MARK: Standard properties
  ///Debugging description
  public var description: String {
    return "CDAKCDAIdentifier => root: \(root), extension_id: \(extension_id)"
  }
  
  // MARK: - Initializers
  required public init(event: [String:Any?]) {
    initFromEventList(event)
  }
  
  private func initFromEventList(event: [String:Any?]) {
    for (key, value) in event {
      CDAKUtility.setProperty(self, property: key, value: value)
    }
  }
  
  public init(root: String? = nil, extension_id: String? = nil) {
    self.root = root
    self.extension_id = extension_id
  }
  
  // MARK: CDA properties
  ///Attempts to return a simplified compound version of the Root and Extension
  public var as_string: String {
    get {
      var r = ""
      var e = ""
      if let root = root {
        r = root
      }
      if let extension_id = extension_id {
        e = extension_id
      }
      return "\(r)\(r.characters.count > 0 && e.characters.count > 0 ? " " : "")\(e)"
    }
  }
  
}

public func == (lhs: CDAKCDAIdentifier, rhs: CDAKCDAIdentifier) -> Bool {
  return lhs.hashValue == rhs.hashValue
  //self.root == comparison_object.root && self.extension == comparison_object.extension
}

// MARK: - Mustache marshalling
extension CDAKCDAIdentifier: MustacheBoxable {
  public var mustacheBox: MustacheBox {
      return Box([
        "root": self.root,
        "extension": self.extension_id,
        "as_string": self.as_string
      ])
  }
}

// MARK: - JSON Generation
extension CDAKCDAIdentifier: CDAKJSONExportable {
  ///Dictionary for JSON data
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    if let root = root {
      dict["root"] = root
    }
    if let extension_id = extension_id {
      dict["extension"] = extension_id
    }
    
    return dict
  }
}