//
//  physical_quantity_result_value.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

// this is sort of annoying
// I get that this should be its own class, but the way ResultValue is used in the CDAKRecord makes this cumbersome to use
//  because you have to cast ResultValue to PhysicalResultValue to access the scalars
/**
Subclass of CDAKResultValue.  Represents a known fixed physical result value (PQ, etc.)
*/
open class CDAKPhysicalQuantityResultValue: CDAKResultValue {
  // MARK: CDA properties
  ///scalar value like "6" or "true"
  open var scalar: String? //no clue what this type should be, so sticking with String for now
  ///units.  Most commonly UCUM units, but there is no restriction
  open var units: String?

  // MARK: - Initializers
  public init(scalar: Any?, units: String? = nil) {
    super.init()
    if let scalar = scalar as? Int {
      self.scalar = String(scalar)
    } else if let scalar = scalar as? Double {
      self.scalar = String(scalar)
    } else if let scalar = scalar as? String {
      self.scalar = scalar
    } else if let scalar = scalar as? Bool {
      self.scalar = String(scalar)
    }
    self.units = units
  }

  // MARK: Standard properties
  ///hash value for comparing objects
  override open var hashValue: Int {
    return "\(scalar)\(units)".hashValue
  }
  
  ///Debugging description
  override open var description: String {
    return "\(type(of: self)) => attributes: \(attributes), time: \(time), start_time: \(start_time), end_time: \(end_time), scalar: \(scalar), units: \(units)"
  }

  
}

public func == (lhs: CDAKPhysicalQuantityResultValue, rhs: CDAKPhysicalQuantityResultValue) -> Bool {
  return lhs.hashValue == rhs.hashValue
}



extension CDAKPhysicalQuantityResultValue {
  // MARK: - Mustache marshalling  
  var boxedValues: [String:MustacheBox] {
    return [
      "scalar" :  Box(scalar),
      "units" :  Box(units)
    ]
  }
  
  override open var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
  
}

extension CDAKPhysicalQuantityResultValue {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let scalar = scalar {
      dict["scalar"] = scalar as AnyObject?
    }
    if let units = units {
      dict["units"] = units as AnyObject?
    }
    
    return dict
  }
}
