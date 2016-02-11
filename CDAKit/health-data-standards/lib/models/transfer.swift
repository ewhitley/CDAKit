//
//  transfer.swift
//  CCDAccess
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

class HDSTransfer: HDSThingWithCodes, CustomStringConvertible {
  
  var time: Double?
  var codes = HDSCodedEntries()
//  var codes = [String:Any]()
  
  //embedded_in :encounter, class_name: "HDSEncounter"
  var description : String {
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
  
  var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
}