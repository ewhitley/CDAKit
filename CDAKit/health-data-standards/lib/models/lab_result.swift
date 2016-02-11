//
//  lab_result.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class HDSLabResult: HDSEntry {
  public var reference_range: String? //as reference_range
  public var reference_range_high: String? //as reference_range_high
  public var reference_range_low: String? //as reference_range_low
  public var interpretation: HDSCodedEntries = HDSCodedEntries()
  public var reaction: HDSCodedEntries = HDSCodedEntries()
  public var method: HDSCodedEntries = HDSCodedEntries()
  
  override public var description: String {
    return super.description + " reference_range: \(reference_range), reference_range_high: \(reference_range_high), reference_range_low: \(reference_range_low), interpretation: \(interpretation), reaction: \(reaction), method: \(method)"
  }

  
}