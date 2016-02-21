//
//  fulfillment_history.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//NOTE: was not originally: CDAKEntry - changing type
/**
CDA Fulfillment History
*/
public class CDAKFulfillmentHistory: CDAKEntry {
  
  // MARK: CDA properties
  
  ///Prescription number
  public var prescription_number: String? //, as: :prescription_number, type: String
  ///Dispense Date
  public var dispense_date: Double? //, as: :dispense_date, type: Integer
  ///Quantity dispensed
  public var quantity_dispensed = CDAKValueAndUnit() //, as: :quantity_dispensed, type: Hash
  ///Fill number if available
  public var fill_number: Int? //, as: :fill_number, type: Integer
  ///Fill status
  public var fill_status: String? //, as: :fill_status, type: String

  ///Ordering provider
  public var provider: CDAKProvider?
  
  // MARK: Health-Data-Standards Functions
  ///Offset all dates by specified double
  override func shift_dates(date_diff: Double) {
    
    super.shift_dates(date_diff)
    
    if let dispense_date = dispense_date {
      self.dispense_date = dispense_date + date_diff
    }
  }
  
  // MARK: Standard properties
  ///Debugging description
  override public var description: String {
    return super.description + " , prescription_number: \(prescription_number), dispense_date: \(dispense_date), fill_number: \(fill_number), fill_status: \(fill_status), quantity_dispensed: \(quantity_dispensed)"
  }

}

extension CDAKFulfillmentHistory {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let prescription_number = prescription_number {
      dict["prescription_number"] = prescription_number
    }
    if quantity_dispensed.jsonDict.count > 0 {
      dict["quantity_dispensed"] = quantity_dispensed.jsonDict
    }
    if let dispense_date = dispense_date {
      dict["dispense_date"] = dispense_date
    }
    if let fill_number = fill_number {
      dict["fill_number"] = fill_number
    }
    if let fill_status = fill_status {
      dict["fill_status"] = fill_status
    }
    if let provider = provider {
      dict["provider"] = provider
    }
    
    return dict
  }
}