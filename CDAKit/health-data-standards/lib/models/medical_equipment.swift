//
//  medical_equipment.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
/**
CDA Medical Equipment
*/
public class CDAKMedicalEquipment: CDAKEntry {
  
  ///Dictionary for JSON data

  ///Device manufacturer
  public var manufacturer: String?
  ///Anatomical Structure
  public var anatomical_structure: CDAKCodedEntries = CDAKCodedEntries() //, as: :anatomical_structure, type: Hash
  ///Time of device removal
  public var removal_time: Double? //, as: :removal_time, type: Integer
  ///Anatomical approach
  public var anatomical_approach: CDAKCodedEntries = CDAKCodedEntries()
  ///Reaction
  public var reaction: CDAKCodedEntries = CDAKCodedEntries()
  

  // MARK: Health-Data-Standards Functions
  ///Offset all dates by specified double
  override func shift_dates(date_diff: Double) {
    super.shift_dates(date_diff)

    if let removal_time = removal_time {
      self.removal_time = removal_time + date_diff
    }
  }
  
}


// MARK: - JSON Generation
extension CDAKMedicalEquipment {
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let manufacturer = manufacturer {
      dict["manufacturer"] = manufacturer
    }
    if let removal_time = removal_time {
      dict["removal_time"] = removal_time
    }
    
    if anatomical_structure.count > 0 {
      dict["anatomical_structure"] = anatomical_structure.codes.map({$0.jsonDict})
    }
    if anatomical_approach.count > 0 {
      dict["anatomical_approach"] = anatomical_approach.codes.map({$0.jsonDict})
    }
    if reaction.count > 0 {
      dict["reaction"] = reaction.codes.map({$0.jsonDict})
    }
    
    return dict
  }
}