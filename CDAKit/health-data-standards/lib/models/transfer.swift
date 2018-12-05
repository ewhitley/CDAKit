//
//  transfer.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

/**
Represents a transfer event.  EX: "transferred to federal holding"
*/
open class CDAKTransfer: CDAKThingWithCodes, CustomStringConvertible {
  
  // MARK: CDA properties
  ///time of transfer
  open var time: Double?
  ///codes that define transfer
  open var codes = CDAKCodedEntries()

  // MARK: Standard properties
  ///Debugging description
  open var description : String {
    return "CDAKTransfer => time: \(time), codes: \(codes)"
  }
}

extension CDAKTransfer: MustacheBoxable {
  // MARK: - Mustache marshalling
  var boxedValues: [String:MustacheBox] {
    return [
      "time" :  Box(time),
      "codes" :  Box(codes)
    ]
  }
  
  public var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
}


extension CDAKTransfer: CDAKJSONExportable {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    if codes.count > 0 {
      dict["codes"] = codes.codes.map({$0.jsonDict}) as AnyObject?
    }
    
    if let time = time {
      dict["time"] = time as AnyObject?
    }
    
    return dict
  }
}
