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
public class CDAKPerson: CDAKPersonable, CDAKJSONInstantiable {
  
  // MARK: CDA properties
  ///Title (Mrs., MD., etc.)
  public var title: String?
  ///First / given name
  public var given_name: String?
  ///Family / last name
  public var family_name: String?
  ///addresses
  public var addresses: [CDAKAddress] = [CDAKAddress]()
  ///telecoms
  public var telecoms: [CDAKTelecom] = [CDAKTelecom]()

  // MARK: - Initializers
  public init(title: String? = nil, given_name: String? = nil, family_name: String? = nil, addresses: [CDAKAddress] = [], telecoms: [CDAKTelecom] = []){
    self.title = title
    self.given_name = given_name
    self.family_name = family_name
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
    return [
      "title" :  Box(title),
      "given_name" :  Box(given_name),
      "family_name" :  Box(family_name),
      "addresses" :  Box(addresses),
      "telecoms" :  Box(telecoms)
    ]
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
    if let title = title {
      dict["title"] = title
    }
    if let given_name = given_name {
      dict["given"] = given_name
    }
    if let family_name = family_name {
      dict["family_name"] = family_name
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