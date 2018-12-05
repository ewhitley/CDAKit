//
//  organization.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

/**
Organization
*/
open class CDAKOrganization: CDAKJSONInstantiable, CustomStringConvertible, Equatable, Hashable {
  
  // MARK: CDA properties
  ///organization name
  open var name: String?
  ///OIds etc. for organization
  open var ids: [CDAKCDAIdentifier] = [] //not used in original model. Merged from QRDA ORG model
  ///physical address
  open var addresses: [CDAKAddress] = [CDAKAddress]()
  ///telecoms
  open var telecoms: [CDAKTelecom] = [CDAKTelecom]()

  
  // MARK: - Initializers
  public init() {
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
  
  // MARK: Standard properties
  ///Debugging description
  open var description: String {
    return "CDAKOrganization => name: \(name), addresses: \(addresses), telecoms: \(telecoms)"
  }
  
}

extension CDAKOrganization {
  public var hashValue: Int {
    
    var hv: Int
    
    hv = "\(name)".hashValue
    
    if addresses.count > 0 {
      hv = hv ^ "\(addresses)".hashValue
    }
    if telecoms.count > 0 {
      hv = hv ^ "\(telecoms)".hashValue
    }
    
    return hv
  }
}

public func == (lhs: CDAKOrganization, rhs: CDAKOrganization) -> Bool {
  return lhs.hashValue == rhs.hashValue && CDAKCommonUtility.classNameAsString(lhs) == CDAKCommonUtility.classNameAsString(rhs)
}


extension CDAKOrganization: MustacheBoxable {
  // MARK: - Mustache marshalling
  var boxedValues: [String:MustacheBox] {
    
    var vals: [String:MustacheBox] = [:]
    vals = [
      "name" :  Box(name),
      "ids": Box(ids)
    ]
    
    if addresses.count > 0 {
      vals["addresses"] = Box(addresses)
    }
    if telecoms.count > 0 {
      vals["telecoms"] = Box(telecoms)
    }
    return vals
  }
  
  public var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
}

extension CDAKOrganization: CDAKJSONExportable {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    if let name = name {
      dict["name"] = name as AnyObject?
    }
    if ids.count > 0 {
      dict["ids"] = ids.map({$0.jsonDict}) as AnyObject?
    }
    if telecoms.count > 0 {
      dict["telecoms"] = telecoms.map({$0.jsonDict}) as AnyObject?
    }
    if addresses.count > 0 {
      dict["addresses"] = addresses.map({$0.jsonDict}) as AnyObject?
    }
    
    return dict
  }
}

