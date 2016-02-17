//
//  provider_performance.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//NOTE: changing type to CDAKEntry
public class CDAKProviderPerformance: CDAKEntry {
  
  public var start_date: Double?
  public var end_date: Double?
  
  //MARK: FIXME - model relationship issues here
  //belongs_to :provider
  //embedded_in :record
  public var provider: CDAKProvider?
  
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