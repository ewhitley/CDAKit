//
//  immunization.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class HDSImmunization: HDSEntry {
  
  public var seriesNumber: Int? //, type: Integer
  public var reaction: HDSCodedEntries = HDSCodedEntries() //, type: Hash
  
  //belongs_to :performer, class_name: "HDSProvider"
  public var performer: HDSProvider?
  
  public var medication_product: HDSMedication?

  public var refusal_ind: Bool? {
    get { return negation_ind }
    set (value) { negation_ind = value }
  }
  
  public var refusal_reason: HDSCodedEntries {
    get {return negation_reason }
    set (value) {negation_reason = value}
  }

  public var series_number: Int? {
    get {return seriesNumber }
    set (value) {seriesNumber = value}
  }

}

