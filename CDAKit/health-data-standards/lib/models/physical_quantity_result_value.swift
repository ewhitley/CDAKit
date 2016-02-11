//
//  physical_quantity_result_value.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

//this is sort of annoying
// I get that this should be its own class, but the way ResultValue is used in the HDSRecord makes this cumbersome to use
//  because you have to cast ResultValue to PhysicalResultValue to access the scalars

class HDSPhysicalQuantityResultValue: HDSResultValue {
  //, Equatable, Hashable
  var scalar: String? //no clue what this type should be, so sticking with String for now
  var units: String?
  
  init(scalar: Any?, units: String? = nil) {
    super.init()
    if let scalar = scalar as? Int {
      self.scalar = String(scalar)
    } else if let scalar = scalar as? Double {
      self.scalar = String(scalar)
//    } else if let scalar = scalar as? Float {
//      self.scalar = String(scalar)
    } else if let scalar = scalar as? String {
      self.scalar = scalar
    } else if let scalar = scalar as? Bool {
      self.scalar = String(scalar)
    }
    self.units = units
  }
  
//  init(scalar: String?, units: String? = nil) {
//    super.init()
//    self.scalar = scalar
//    self.units = units
//  }
//
//  init(scalar: Int, units: String? = nil) {
//    super.init()
//    self.scalar = String(scalar)
//    self.units = units
//  }

  override var hashValue: Int {
    return "\(scalar)\(units)".hashValue
  }
  
  override var description: String {
    return "\(self.dynamicType) => attributes: \(attributes), time: \(time), start_time: \(start_time), end_time: \(end_time), scalar: \(scalar), units: \(units)"
  }

  
}

func == (lhs: HDSPhysicalQuantityResultValue, rhs: HDSPhysicalQuantityResultValue) -> Bool {
  return lhs.hashValue == rhs.hashValue
}



extension HDSPhysicalQuantityResultValue {
  
  var boxedValues: [String:MustacheBox] {
    return [
      "scalar" :  Box(scalar),
      "units" :  Box(units)
    ]
  }
  
  override var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
  
}