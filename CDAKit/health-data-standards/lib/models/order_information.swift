//
//  order_information.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//NOTE: Changing class to CDAKEntry
/**
Order information
*/
open class CDAKOrderInformation: CDAKEntry {
  
  
  // MARK: CDA properties
  ///order number
  open var order_number: String? //, as: :order_number, type: String
  ///number of filles
  open var fills: Int? //, type: Integer
  ///number of units ordered
  open var quantity_ordered = CDAKValueAndUnit()
  ///date/time of order expiration
  open var order_expiration_date_time: Double? //, as: :order_expiration_date_time, type: Integer
  ///date/time of creation of order
  open var order_date_time: Double? //, as: :order_date_time, type: Integer
  
  ///ordering provider
  open var provider: CDAKProvider?
  
  // MARK: Health-Data-Standards Functions
  ///Offset all dates by specified double
  override func shift_dates(_ date_diff: Double) {
    super.shift_dates(date_diff)
    
    if let order_date_time = order_date_time {
      self.order_date_time = order_date_time + date_diff
    }
    if let order_expiration_date_time = order_expiration_date_time {
      self.order_expiration_date_time = order_expiration_date_time + date_diff
    }
  }
  
}

extension CDAKOrderInformation {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let order_number = order_number {
      dict["order_number"] = order_number as AnyObject?
    }
    if let fills = fills {
      dict["fills"] = fills as AnyObject?
    }
    if quantity_ordered.jsonDict.count > 0 {
      dict["quantity_ordered"] = quantity_ordered.jsonDict as AnyObject?
    }
    if let order_expiration_date_time = order_expiration_date_time {
      dict["order_expiration_date_time"] = order_expiration_date_time as AnyObject?
    }
    if let order_date_time = order_date_time {
      dict["order_date_time"] = order_date_time as AnyObject?
    }
    if let provider = provider {
      dict["provider"] = provider.jsonDict as AnyObject?
    }
    
    return dict
  }
}
