//
//  CDAKValueAndUnit.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/4/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

public struct CDAKValueAndUnit {
  var value: Double?
  var unit: String?
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
