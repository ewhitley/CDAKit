//
//  person.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

class HDSPerson: HDSPersonable, HDSJSONInstantiable {
  
  var title: String?
  var given_name: String?
  var family_name: String?
  
  var addresses: [HDSAddress] = [HDSAddress]()
  var telecoms: [HDSTelecom] = [HDSTelecom]()

  init() {
  }
  
  required init(event: [String:Any?]) {
    initFromEventList(event)
  }
  
}

extension HDSPerson: MustacheBoxable {
  var boxedValues: [String:MustacheBox] {
    return [
      "title" :  Box(title),
      "given_name" :  Box(given_name),
      "family_name" :  Box(family_name),
      "addresses" :  Box(addresses),
      "telecoms" :  Box(telecoms)
    ]
  }
  
  var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
}