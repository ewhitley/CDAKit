//
//  family_history.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

/**
CDA Family History
*/
public class CDAKFamilyHistory: CDAKEntry {
  
  // MARK: CDA properties
  ///CDA relationship to patient
  public var relationshipToPatient = [String:String]()
  ///CDA onset age
  public var onsetAge = [String:String]()
    
}

extension CDAKFamilyHistory {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if relationshipToPatient.count > 0 {
      dict["relationshipToPatient"] = relationshipToPatient
    }
    if onsetAge.count > 0 {
      dict["onsetAge"] = onsetAge
    }
    
    return dict
  }
}