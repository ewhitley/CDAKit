//
//  organization.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

public class CDAKOrganization: CDAKJSONInstantiable, CustomStringConvertible, Equatable, Hashable {
  
  public var name: String?
  
  public var addresses: [CDAKAddress] = [CDAKAddress]()
  public var telecoms: [CDAKTelecom] = [CDAKTelecom]()

  //embeds_many :addresses, as: :locatable
  //embeds_many :telecoms, as: :contactable
  
  public init() {
  }
  
  required public init(event: [String:Any?]) {
    initFromEventList(event)
  }
  
  private func initFromEventList(event: [String:Any?]) {
    for (key, value) in event {
      CDAKUtility.setProperty(self, property: key, value: value)
    }
  }
  
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
  var boxedValues: [String:MustacheBox] {
    return [
      "name" :  Box(name),
      "addresses": Box(addresses),
      "telecoms" : Box(telecoms)
    ]
  }
  
  public var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
}