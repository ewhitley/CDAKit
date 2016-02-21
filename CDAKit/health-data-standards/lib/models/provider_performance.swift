//
//  provider_performance.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//NOTE: changing type to CDAKEntry
/**
  Performance entry for provider

NOTE: we're never going to use this. It's for QRDA III and we have no measure engine, no measures, etc. so this is never going to be utilized.
*/
public class CDAKProviderPerformance: CDAKEntry {


  // MARK: CDA properties

  ///start date for period
  public var start_date: Double?
  ///end date for period
  public var end_date: Double?
  ///provider
  public var provider: CDAKProvider?

  
  // MARK: Health-Data-Standards Functions
  ///Offset all dates by specified double
  override func shift_dates(date_diff: Double) {
    super.shift_dates(date_diff)

    if let start_date = start_date {
      self.start_date = start_date + date_diff
    }
    if let end_date = end_date {
      self.end_date = end_date + date_diff
    }
  }
  
}

extension CDAKProviderPerformance {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let start_date = start_date {
      dict["start_date"] = start_date
    }
    if let end_date = end_date {
      dict["end_date"] = end_date
    }
    if let provider = provider {
      dict["provider"] = provider
    }
    
    return dict
  }
}