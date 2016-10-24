//
//  Mustache+Filters.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/22/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

class MustacheFilters {

  static let UUID_generate = Filter { (value: Any? ) in
    let uuid_string = NSUUID().uuidString
    return Box(uuid_string)
  }

  //Ruby -> :number -> 20081225143505
  static let DateAsNumber = Filter { (box: MustacheBox) in
    
    if box.value == nil {
      return Box(Date().stringFormattedAsHDSDateNumber)
    }
    
    switch box.value {
    case let int as Int:
      let d = Date(timeIntervalSince1970: Double(int))
      return Box(d.stringFormattedAsHDSDateNumber)
    case let double as Double:
      let d = Date(timeIntervalSince1970: double)
      return Box(d.stringFormattedAsHDSDateNumber)
    case let date as Date:
      return Box(date.stringFormattedAsHDSDateNumber)
    default:
      return nil
    }
  }

  static let DateAsHDSString = Filter { (box: MustacheBox) in
    
    if box.value == nil {
      return Box(Date().stringFormattedAsHDSDate)
    }
    
    switch box.value {
    case let int as Int:
      let d = Date(timeIntervalSince1970: Double(int))
      return Box(d.stringFormattedAsHDSDate)
    case let double as Double:
      let d = Date(timeIntervalSince1970: double)
      return Box(d.stringFormattedAsHDSDate)
    case let date as Date:
      return Box(date.stringFormattedAsHDSDate)
    default:
      return nil
    }
  }
  
  static let value_or_null_flavor = Filter { (box: MustacheBox) in

    switch box.value {
    case let int as Int:
      let d = ViewHelper.value_or_null_flavor(Double(int))
      return Box(d)
    case let int as Double:
      let d = ViewHelper.value_or_null_flavor(int)
      return Box(d)
    default:
      return Box(ViewHelper.value_or_null_flavor(box.value))
    }

  }

  static let oid_for_code_system = Filter { (box: MustacheBox) in
    
    switch box.value {
    case let code_system as String:
      let d = CDAKCodeSystemHelper.oid_for_code_system(code_system)
      return Box(d)
    default:
      return nil
    }
    
  }
  
  static let is_bool = Filter { (box: MustacheBox) in
    
    switch box.value {
    case let val as Bool:
      return Box(true)
    case let val as Bool?:
      return Box(true)
    case let val as String:
      if val.lowercased() == "true" || val.lowercased() == "false" {
        return Box(true)
      }
      return Box(false)
    default:
      return Box(false)
    }
    
  }

  static let is_numeric = Filter { (box: MustacheBox) in
    
    switch box.value {
    case let val as Int:
      return Box(true)
    case let val as Int?:
      return Box(true)
    case let val as Double:
      return Box(true)
    case let val as Double?:
      return Box(true)
    case let val as String:
      if let val = Double(val) {
        return Box(true)
      }
      return Box(false)
    default:
      return Box(false)
    }

  }
  
}
