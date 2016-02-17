//
//  lab_result.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKLabResult: CDAKEntry {
  public var reference_range: String? //as reference_range
  public var reference_range_high: String? //as reference_range_high
  public var reference_range_low: String? //as reference_range_low
  public var interpretation: CDAKCodedEntries = CDAKCodedEntries()
  public var reaction: CDAKCodedEntries = CDAKCodedEntries()
  public var method: CDAKCodedEntries = CDAKCodedEntries()
  
  override public var description: String {
    return super.description + " reference_range: \(reference_range), reference_range_high: \(reference_range_high), reference_range_low: \(reference_range_low), interpretation: \(interpretation), reaction: \(reaction), method: \(method)"
  }

  
}

extension CDAKLabResult {
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let reference_range = reference_range {
      dict["reference_range"] = reference_range
    }
    if let reference_range_high = reference_range_high {
      dict["reference_range_high"] = reference_range_high
    }
    if let reference_range_low = reference_range_low {
      dict["reference_range_low"] = reference_range_low
    }

    if interpretation.count > 0 {
      dict["interpretation"] = interpretation.codes.map({$0.jsonDict})
    }
    if reaction.count > 0 {
      dict["reaction"] = reaction.codes.map({$0.jsonDict})
    }
    if method.count > 0 {
      dict["method"] = method.codes.map({$0.jsonDict})
    }

    
    return dict
  }
}