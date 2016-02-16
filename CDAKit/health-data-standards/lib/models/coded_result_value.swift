//
//  result_value.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKCodedResultValue: CDAKResultValue, CDAKThingWithCodes {
  public var item_description: String?
  public var codes: CDAKCodedEntries = CDAKCodedEntries()
//  var codes: [String:Any] = [String:Any]()
  
  override public var description: String {
    return "\(self.dynamicType) => attributes: \(attributes), time: \(time), start_time: \(start_time), end_time: \(end_time), item_description: \(item_description), codes: \(codes)"
  }

}