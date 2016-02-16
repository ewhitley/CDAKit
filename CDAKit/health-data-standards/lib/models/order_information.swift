//
//  order_information.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//NOTE: Changing class to CDAKEntry
public class CDAKOrderInformation: CDAKEntry {
  
  public var order_number: String? //, as: :order_number, type: String
  public var fills: Int? //, type: Integer
  public var quantity_ordered = CDAKValueAndUnit()
  public var order_expiration_date_time: Double? //, as: :order_expiration_date_time, type: Integer
  public var order_date_time: Double? //, as: :order_date_time, type: Integer
  
  //MARK: FIXME - handle getting order_information by CDAKProvider
  public var provider: CDAKProvider?
  
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