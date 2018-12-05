//
//  result_value.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

/**
Result Value
*/
open class CDAKResultValue: NSObject, CDAKThingWithTimes {

  // MARK: CDA properties
  ///Ad-hoc attributes
  open var attributes: [String:String] = [String:String]()

  ///time
  open var time: Double?
  //this is not originally in the model, but found instances where dynamic properties
  // were being referfenced for this - see protocol ThingWithTimes
  ///start time
  open var start_time: Double?
  ///end time
  open var end_time: Double?
  
  // MARK: Standard properties
  ///Debugging description
  override open var description: String {
    return "\(type(of: self)) => attributes: \(attributes), time: \(time), start_time: \(start_time), end_time: \(end_time)"
  }
  
}

extension CDAKResultValue: CDAKJSONExportable {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    if let time = time {
      dict["time"] = time as AnyObject?
    }
    if let start_time = start_time {
      dict["start_time"] = start_time as AnyObject?
    }
    if let end_time = end_time {
      dict["end_time"] = end_time as AnyObject?
    }
    
    return dict
  }
}

