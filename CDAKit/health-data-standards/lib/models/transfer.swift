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
//  var codes = [String:Any]()
  
  //embedded_in :encounter, class_name: "CDAKEncounter"
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