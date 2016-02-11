//
//  immunization.swift
//  CCDAccess
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

class HDSImmunization: HDSEntry {
  
  var seriesNumber: Int? //, type: Integer
  var reaction: HDSCodedEntries = HDSCodedEntries() //, type: Hash
  
  //belongs_to :performer, class_name: "HDSProvider"
  var performer: HDSProvider?
  
  var medication_product: HDSMedication?

  var refusal_ind: Bool? {
    get { return negation_ind }
    set (value) { negation_ind = value }
  }
  
  var refusal_reason: HDSCodedEntries {
    get {return negation_reason }
    set (value) {negation_reason = value}
  }

  var series_number: Int? {
    get {return seriesNumber }
    set (value) {seriesNumber = value}
  }

}

