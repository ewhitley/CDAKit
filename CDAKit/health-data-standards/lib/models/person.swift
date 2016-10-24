//
//  person.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

/**
 Person.  Generic person container.  Should not use for a provider.
*/
open class CDAKPerson: CDAKPersonable, CDAKJSONInstantiable {
  
  // MARK: CDA properties
  ///Prefix (Mrs., MD., etc.) (was Title)
  open var prefix: String?
  ///First / given name
  open var given_name: String?
  ///Family / last name
  open var family_name: String?
  ///Suffix
  open var suffix: String?
  ///addresses
  open var addresses: [CDAKAddress] = [CDAKAddress]()
  ///telecoms
  open var telecoms: [CDAKTelecom] = [CDAKTelecom]()

  // MARK: - Initializers
  public init(prefix: String? = nil, given_name: String? = nil, family_name: String? = nil, suffix: String? = nil, addresses: [CDAKAddress] = [], telecoms: [CDAKTelecom] = []){
    self.prefix = prefix
    self.given_name = given_name
    self.family_name = family_name
    self.suffix = suffix
    self.addresses = addresses
    self.telecoms = telecoms
  }
  
  // MARK: - Deprecated - Do not use
  ///Do not use - will be removed. Was used in HDS Ruby.
  required public init(event: [String:Any?]) {
    initFromEventList(event)
  }
  
}

extension CDAKPerson: MustacheBoxable {
  // MARK: - Mustache marshalling
  var boxedValues: [String:MustacheBox] {
    
    var vals: [String:MustacheBox] = [:]
    vals = [
      "prefix" :  Box(prefix),
      "given_name" :  Box(given_name),
      "family_name" :  Box(family_name),
      "suffix" :  Box(suffix)
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

extension CDAKPerson: CDAKJSONExportable {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    if let prefix = prefix {
      dict["prefix"] = prefix as AnyObject?
    }
    if let given_name = given_name {
      dict["given"] = given_name as AnyObject?
    }
    if let family_name = family_name {
      dict["family_name"] = family_name as AnyObject?
    }
    if let suffix = suffix {
      dict["suffix"] = suffix as AnyObject?
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
