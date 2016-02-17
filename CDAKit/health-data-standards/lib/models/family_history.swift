//
//  family_history.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKFamilyHistory: CDAKEntry {
  
  public var relationshipToPatient = [String:String]()
  public var onsetAge = [String:String]()
    
}

extension CDAKFamilyHistory {
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