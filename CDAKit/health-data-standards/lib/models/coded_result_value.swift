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
  
  override public var description: String {
    return "\(self.dynamicType) => attributes: \(attributes), time: \(time), start_time: \(start_time), end_time: \(end_time), item_description: \(item_description), codes: \(codes)"
  }

}


extension CDAKCodedResultValue {
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let item_description = item_description {
      dict["description"] = item_description
    }
    if codes.count > 0 {
      dict["codes"] = codes.codes.map({$0.jsonDict})
    }
    
    return dict
  }
}

