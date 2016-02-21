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
/**
CDA Facility
*/
public class CDAKFacility: CDAKEntry {
  
  // MARK: CDA properties

  ///Facility name
  public var name: String?
  
  ///Facility addresses
  public var addresses = [CDAKAddress]() //, as: :locatable
  ///Facility telecoms
  public var telecoms = [CDAKTelecom]() //, as: :contactable
  
  // MARK: Standard properties
  ///Debugging description
  override public var description: String {
    return super.description + " name: \(name), addresss: \(addresses), telecoms: \(telecoms)"
  }
  
}

extension CDAKFacility {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict

    if let name = name {
      dict["name"] = name
    }
    if addresses.count > 0 {
      dict["addresses"] = addresses.map({$0.jsonDict})
    }
    if telecoms.count > 0 {
      dict["telecoms"] = telecoms.map({$0.jsonDict})
    }
    
    return dict
  }
}

