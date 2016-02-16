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

  public init() {
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