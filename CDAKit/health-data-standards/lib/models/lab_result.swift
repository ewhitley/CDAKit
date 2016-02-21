//
//  lab_result.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
/**
CDA template for "result-like" things.  Primarily lab results.
*/
public class CDAKLabResult: CDAKEntry {
  
  // MARK: CDA properties
  ///reference range for the result
  public var reference_range: String? //as reference_range
  ///fixed reference high
  public var reference_range_high: String? //as reference_range_high
  ///fixed reference low
  public var reference_range_low: String? //as reference_range_low
  ///Interpretation (coded form)
  public var interpretation: CDAKCodedEntries = CDAKCodedEntries()
  ///Reaction
  public var reaction: CDAKCodedEntries = CDAKCodedEntries()
  ///Method
  public var method: CDAKCodedEntries = CDAKCodedEntries()

  
  // MARK: Standard properties
  ///Debugging description
  override public var description: String {
    return super.description + " reference_range: \(reference_range), reference_range_high: \(reference_range_high), reference_range_low: \(reference_range_low), interpretation: \(interpretation), reaction: \(reaction), method: \(method)"
  }

  
}

extension CDAKLabResult {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
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