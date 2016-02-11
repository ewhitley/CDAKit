//
//  family_history.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class HDSFamilyHistory: HDSEntry {
  
  //field :relationshipToPatient, as: :relationship_to_patient, type: Hash
  public var relationshipToPatient = [String:String]()
  
  //field :onsetAge, as: :onset_age, type: Hash
  public var onsetAge = [String:String]()
    
}