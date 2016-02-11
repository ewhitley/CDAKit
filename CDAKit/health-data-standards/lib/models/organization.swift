//
//  organization.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

class HDSOrganization: HDSJSONInstantiable, CustomStringConvertible, Equatable, Hashable {
  
  var name: String?
  
  var addresses: [HDSAddress] = [HDSAddress]()
  var telecoms: [HDSTelecom] = [HDSTelecom]()

  //embeds_many :addresses, as: :locatable
  //embeds_many :telecoms, as: :contactable
  
  init() {
  }
  
  required init(event: [String:Any?]) {
    initFromEventList(event)
  }
  
  private func initFromEventList(event: [String:Any?]) {
    for (key, value) in event {
      HDSUtility.setProperty(self, property: key, value: value)
    }
  }
  
  var description: String {
    return "HDSOrganization => name: \(name), addresses: \(addresses), telecoms: \(telecoms)"
  }
  
}

extension HDSOrganization {
  var hashValue: Int {
    
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

func == (lhs: HDSOrganization, rhs: HDSOrganization) -> Bool {
  return lhs.hashValue == rhs.hashValue && HDSCommonUtility.classNameAsString(lhs) == HDSCommonUtility.classNameAsString(rhs)
}


extension HDSOrganization: MustacheBoxable {
  var boxedValues: [String:MustacheBox] {
    return [
      "name" :  Box(name),
      "addresses": Box(addresses),
      "telecoms" : Box(telecoms)
    ]
  }
  
  var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
}