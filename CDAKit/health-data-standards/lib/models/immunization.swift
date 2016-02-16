//
//  immunization.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKImmunization: CDAKEntry {
  
  public var seriesNumber: Int? //, type: Integer
  public var reaction: CDAKCodedEntries = CDAKCodedEntries() //, type: Hash
  
  public var performer: CDAKProvider?
  
  public var medication_product: CDAKMedication?

  public var refusal_ind: Bool? {
    get { return negation_ind }
    set (value) { negation_ind = value }
  }
  
  public var refusal_reason: CDAKCodedEntries {
    get {return negation_reason }
    set (value) {negation_reason = value}
  }

  public var series_number: Int? {
    get {return seriesNumber }
    set (value) {seriesNumber = value}
  }

}

