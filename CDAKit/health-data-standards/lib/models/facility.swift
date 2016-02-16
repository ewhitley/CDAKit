//
//  facility.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//NOTE: This is NOT en "CDAKEntry" type in the original Ruby
// however... it is treated like an entry type in various parts of the code and repeats certain variables and methods
// found in the CDAKEntry class.  I am electing to make this an CDAKEntry subclass (probably not a good idea, either...)
public class CDAKFacility: CDAKEntry {
  
  //include Mongoid::Attributes::Dynamic
  
  public var name: String?
  
  //var code: CDAKCodedEntries = CDAKCodedEntries()
  // originally (before making this an CDAKEntry), this was "code"
  // I'm leaving this, but commenting it out - I'm going to deviate from the orgiinal Ruby
  // by making this "codes" since it's an CDAKEntry now
  
//  var start_time: Int?
//  var end_time: Int?
  
  public var addresses = [CDAKAddress]() //, as: :locatable
  public var telecoms = [CDAKTelecom]() //, as: :contactable
  
  override public var description: String {
    return super.description + " name: \(name), addresss: \(addresses), telecoms: \(telecoms)"
  }
  
}


