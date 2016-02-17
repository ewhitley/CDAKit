//
//  person.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

public class CDAKPerson: CDAKPersonable, CDAKJSONInstantiable {
  
  public var title: String?
  public var given_name: String?
  public var family_name: String?
  
  public var addresses: [CDAKAddress] = [CDAKAddress]()
  public var telecoms: [CDAKTelecom] = [CDAKTelecom]()

  public init(title: String? = nil, given_name: String? = nil, family_name: String? = nil, addresses: [CDAKAddress] = [], telecoms: [CDAKTelecom] = []){
    self.title = title
    self.given_name = given_name
    self.family_name = family_name
    self.addresses = addresses
    self.telecoms = telecoms
  }
  
  required public init(event: [String:Any?]) {
    initFromEventList(event)
  }
  
}

extension CDAKPerson: MustacheBoxable {
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