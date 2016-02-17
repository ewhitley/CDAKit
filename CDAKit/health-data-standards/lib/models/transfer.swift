//
//  transfer.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

public class CDAKTransfer: CDAKThingWithCodes, CustomStringConvertible {
  
  public var time: Double?
  public var codes = CDAKCodedEntries()

  public var description : String {
    return "CDAKTransfer => time: \(time), codes: \(codes)"
  }
}

extension CDAKTransfer: MustacheBoxable {
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
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    if codes.count > 0 {
      dict["codes"] = codes.codes.map({$0.jsonDict})
    }
    
    if let time = time {
      dict["time"] = time
    }
    
    return dict
  }
}