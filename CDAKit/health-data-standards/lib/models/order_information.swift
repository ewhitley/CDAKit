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
public class CDAKOrderInformation: CDAKEntry {
  
  
  // MARK: CDA properties
  ///order number
  public var order_number: String? //, as: :order_number, type: String
  ///number of filles
  public var fills: Int? //, type: Integer
  ///number of units ordered
  public var quantity_ordered = CDAKValueAndUnit()
  ///date/time of order expiration
  public var order_expiration_date_time: Double? //, as: :order_expiration_date_time, type: Integer
  ///date/time of creation of order
  public var order_date_time: Double? //, as: :order_date_time, type: Integer
  
  ///ordering provider
  public var provider: CDAKProvider?
  
  // MARK: Health-Data-Standards Functions
  ///Offset all dates by specified double
  override func shift_dates(date_diff: Double) {
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
      dict["order_number"] = order_number
    }
    if let fills = fills {
      dict["fills"] = fills
    }
    if quantity_ordered.jsonDict.count > 0 {
      dict["quantity_ordered"] = quantity_ordered.jsonDict
    }
    if let order_expiration_date_time = order_expiration_date_time {
      dict["order_expiration_date_time"] = order_expiration_date_time
    }
    if let order_date_time = order_date_time {
      dict["order_date_time"] = order_date_time
    }
    if let provider = provider {
      dict["provider"] = provider.jsonDict
    }
    
    return dict
  }
}