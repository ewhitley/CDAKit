//
//  lab_result.swift
//  CCDAccess
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

class HDSLabResult: HDSEntry {
  var reference_range: String? //as reference_range
  var reference_range_high: String? //as reference_range_high
  var reference_range_low: String? //as reference_range_low
  var interpretation: HDSCodedEntries = HDSCodedEntries()
  var reaction: HDSCodedEntries = HDSCodedEntries()
  var method: HDSCodedEntries = HDSCodedEntries()
  
  override var description: String {
    return super.description + " reference_range: \(reference_range), reference_range_high: \(reference_range_high), reference_range_low: \(reference_range_low), interpretation: \(interpretation), reaction: \(reaction), method: \(method)"
  }

  
}