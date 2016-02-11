//
//  transfer.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

public class HDSTransfer: HDSThingWithCodes, CustomStringConvertible {
  
  public var time: Double?
  public var codes = HDSCodedEntries()
//  var codes = [String:Any]()
  
  //embedded_in :encounter, class_name: "HDSEncounter"
  public var description : String {
    return "HDSTransfer => time: \(time), codes: \(codes)"
  }
}

extension HDSTransfer: MustacheBoxable {
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