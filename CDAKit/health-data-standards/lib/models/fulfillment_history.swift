//
//  fulfillment_history.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//NOTE: was not originally: CDAKEntry - changing type
public class CDAKFulfillmentHistory: CDAKEntry {
  
  public var prescription_number: String? //, as: :prescription_number, type: String
  public var dispense_date: Double? //, as: :dispense_date, type: Integer
  public var quantity_dispensed = CDAKValueAndUnit() //, as: :quantity_dispensed, type: Hash
  public var fill_number: Int? //, as: :fill_number, type: Integer
  public var fill_status: String? //, as: :fill_status, type: String

  public var provider: CDAKProvider?
  
  override func shift_dates(date_diff: Double) {
    
    super.shift_dates(date_diff)
    
    if let dispense_date = dispense_date {
      self.dispense_date = dispense_date + date_diff
    }
  }
  
  override public var description: String {
    return super.description + " , prescription_number: \(prescription_number), dispense_date: \(dispense_date), fill_number: \(fill_number), fill_status: \(fill_status), quantity_dispensed: \(quantity_dispensed)"
  }

}
