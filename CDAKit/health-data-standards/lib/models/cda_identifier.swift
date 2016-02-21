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
 

 **Examples:**

 [Source](https://github.com/chb/sample_ccdas/blob/master/EMERGE/Patient-673.xml)

 ```
 <id root="db734647-fc99-424c-a864-7e3cda82e703"/>
 ``` 
 
 or
 
 ```
 <!-- Fake ID using HL7 example OID. -->
 
 <id extension="998991" root="2.16.840.1.113883.19.5.99999.2"/>
 
 <!-- Fake Social Security Number using the actual SSN OID. -->

 <id extension="111-00-2330" root="2.16.840.1.113883.4.1"/>
 ```
*/
public class CDAKCDAIdentifier: Equatable, Hashable, CDAKJSONInstantiable, CustomStringConvertible {

  // MARK: CDA properties
  ///CDA Root
  public var root: String?
  ///CDA Extension
  public var extension_id: String?
  
  public var hashValue: Int {
    return "\(root)\(extension_id)".hashValue
  }
  
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
  
  // MARK: Standard properties
  ///Debugging description
  public var description: String {
    return "CDAKCDAIdentifier => root: \(root), extension_id: \(extension_id)"
  }
  
  // MARK: - Initializers
  public init(root: String? = nil, extension_id: String? = nil) {
    self.root = root
    self.extension_id = extension_id
  }

  // MARK: - Deprecated - Do not use
  ///Do not use - will be removed. Was used in HDS Ruby.
  required public init(event: [String:Any?]) {
    initFromEventList(event)
  }
  
  ///Do not use - will be removed. Was used in HDS Ruby.
  private func initFromEventList(event: [String:Any?]) {
    for (key, value) in event {
      CDAKUtility.setProperty(self, property: key, value: value)
    }
  }
  
  
  
}

public func == (lhs: CDAKCDAIdentifier, rhs: CDAKCDAIdentifier) -> Bool {
  return lhs.hashValue == rhs.hashValue
  //self.root == comparison_object.root && self.extension == comparison_object.extension
}

extension CDAKCDAIdentifier: MustacheBoxable {
  // MARK: - Mustache marshalling
  public var mustacheBox: MustacheBox {
      return Box([
        "root": self.root,
        "extension": self.extension_id,
        "as_string": self.as_string
      ])
  }
}

extension CDAKCDAIdentifier: CDAKJSONExportable {
  // MARK: - JSON Generation
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