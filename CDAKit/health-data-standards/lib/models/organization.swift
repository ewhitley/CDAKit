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
public class CDAKOrganization: CDAKJSONInstantiable, CustomStringConvertible, Equatable, Hashable {
  
  // MARK: CDA properties
  ///organization name
  public var name: String?
  ///OIds etc. for organization
  public var ids: [CDAKCDAIdentifier] = [] //not used in original model. Merged from QRDA ORG model
  ///physical address
  public var addresses: [CDAKAddress] = [CDAKAddress]()
  ///telecoms
  public var telecoms: [CDAKTelecom] = [CDAKTelecom]()

  
  // MARK: - Initializers
  public init() {
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
  
  // MARK: Standard properties
  ///Debugging description
  public var description: String {
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
    return [
      "name" :  Box(name),
      "addresses": Box(addresses),
      "telecoms" : Box(telecoms),
      "ids": Box(ids)
    ]
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
      dict["name"] = name
    }
    if ids.count > 0 {
      dict["ids"] = ids.map({$0.jsonDict})
    }
    if telecoms.count > 0 {
      dict["telecoms"] = telecoms.map({$0.jsonDict})
    }
    if addresses.count > 0 {
      dict["addresses"] = addresses.map({$0.jsonDict})
    }
    
    return dict
  }
}

