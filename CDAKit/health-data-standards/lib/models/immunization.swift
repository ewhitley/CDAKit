//
//  immunization.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKImmunization: CDAKEntry {
  
  public var series_number: Int? //, type: Integer
  public var reaction: CDAKCodedEntries = CDAKCodedEntries() //, type: Hash
  
  public var performer: CDAKProvider?
  
  public var medication_product: CDAKMedication?

  public var refusal_ind: Bool? {
    get { return negation_ind }
    set (value) { negation_ind = value }
  }
  
  public var refusal_reason: CDAKCodedEntries {
    get {return negation_reason }
    set (value) {negation_reason = value}
  }

}

extension CDAKImmunization {
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let series_number = series_number {
      dict["series_number"] = series_number
    }
    if reaction.count > 0 {
      dict["reaction"] = reaction.codes.map({$0.jsonDict})
    }
    if let performer = performer {
      dict["performer"] = performer.jsonDict
    }
    if let medication_product = medication_product {
      dict["medication_product"] = medication_product.jsonDict
    }
    
    return dict
  }
}
