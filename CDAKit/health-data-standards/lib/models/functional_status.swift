//
//  functional_status.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

/**
This class can be used to represnt a functional status for a patient. Currently, it is not a very close representation of functional status as it is represented in the HL7 CCD, HITSP C32 or Consolidated CDA.

In the previously mentioned specifications, functional status may represented using either a condition or result. Having "mixed" types of entries in a section is currently not well supported in the existing CDAKRecord class

Additionally, there is a mismatch between the data needed to calculate Stage 2 Meaningful Use Quailty Measures and the data contained in patient summary standards. The CQMs are checking to see if a functional status represented by a result was patient supplied. Right now, results do not have a source, and even if we were to use Provider as a source, it would need to be extended to support patients.

To avoid this, the patient sumamry style functional status has been "flattened" into this class. This model supports the information needed to calculate Stage 2 MU CQMs. If importers are created from C32 or CCDA, the information can be stored here, but it will be a lossy transformation.
*/
public class CDAKFunctionalStatus: CDAKEntry {
  
  /// Either "condition" or "result"
  public var type: String?
  
  /// A coded value. Like a code for patient supplied.
  public var source = [String:String]() //, type: Hash
  
}

extension CDAKFunctionalStatus {
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let type = type {
      dict["type"] = type
    }
    if source.count > 0 {
      dict["source"] = source
    }
    
    return dict
  }
}