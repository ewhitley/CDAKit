//
//  result_value.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

/**
CDA Coded Result Value
*/
open class CDAKCodedResultValue: CDAKResultValue, CDAKThingWithCodes {
  
  // MARK: CDA properties

  ///CDA description
  open var item_description: String?
  ///Any codes associated with the result value
  open var codes: CDAKCodedEntries = CDAKCodedEntries()
  
  // MARK: Standard properties
  ///Debugging description
  override open var description: String {
    return "\(type(of: self)) => attributes: \(attributes), time: \(time), start_time: \(start_time), end_time: \(end_time), item_description: \(item_description), codes: \(codes)"
  }

}


extension CDAKCodedResultValue {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let item_description = item_description {
      dict["description"] = item_description as AnyObject?
    }
    if codes.count > 0 {
      dict["codes"] = codes.codes.map({$0.jsonDict}) as AnyObject?
    }
    
    return dict
  }
}

