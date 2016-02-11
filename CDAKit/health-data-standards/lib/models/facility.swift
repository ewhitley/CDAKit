//
//  facility.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//NOTE: This is NOT en "HDSEntry" type in the original Ruby
// however... it is treated like an entry type in various parts of the code and repeats certain variables and methods
// found in the HDSEntry class.  I am electing to make this an HDSEntry subclass (probably not a good idea, either...)
class HDSFacility: HDSEntry {
  
  //include Mongoid::Attributes::Dynamic
  
  var name: String?
  
  //var code: HDSCodedEntries = HDSCodedEntries()
  // originally (before making this an HDSEntry), this was "code"
  // I'm leaving this, but commenting it out - I'm going to deviate from the orgiinal Ruby
  // by making this "codes" since it's an HDSEntry now
  
//  var start_time: Int?
//  var end_time: Int?
  
  var addresses = [HDSAddress]() //, as: :locatable
  var telecoms = [HDSTelecom]() //, as: :contactable
  
  override var description: String {
    return super.description + " name: \(name), addresss: \(addresses), telecoms: \(telecoms)"
  }
  
}


