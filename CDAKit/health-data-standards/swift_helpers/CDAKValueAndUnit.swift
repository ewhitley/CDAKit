//
//  CDAKValueAndUnit.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/4/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

public struct CDAKValueAndUnit {
  var value: Double?
  var unit: String?
}

extension CDAKValueAndUnit: MustacheBoxable {
  // MARK: - Mustache marshalling
  var boxedValues: [String:MustacheBox] {
    var vals : [String:MustacheBox] = [:]
    
    if let unit = unit {
      vals["unit"] = Box(unit)
    }
    if let value = value {
      vals["value"] = Box(value)
    }
    
    return vals
  }
  
  public var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }

}

extension CDAKValueAndUnit: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    if let value = value {
      dict["value"] = value
    }
    if let unit = unit {
      dict["unit"] = unit
    }
    
    return dict
  }
}
