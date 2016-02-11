//
//  result_value.swift
//  CCDAccess
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

class HDSCodedResultValue: HDSResultValue, HDSThingWithCodes {
  var item_description: String?
  var codes: HDSCodedEntries = HDSCodedEntries()
//  var codes: [String:Any] = [String:Any]()
  
  override var description: String {
    return "\(self.dynamicType) => attributes: \(attributes), time: \(time), start_time: \(start_time), end_time: \(end_time), item_description: \(item_description), codes: \(codes)"
  }

}