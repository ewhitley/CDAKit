//
//  immunization.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
/**
Record of immunization
*/
public class CDAKImmunization: CDAKEntry {
  
  // MARK: CDA properties

  ///Vaccine series number
  public var series_number: Int? //, type: Integer
  ///Reaction to vaccine
  public var reaction: CDAKCodedEntries = CDAKCodedEntries() //, type: Hash
  ///Provider who performed administration
  public var performer: CDAKProvider?
  ///Vaccine medication product
  public var medication_product: CDAKMedication?

  ///Was this immunization refused by the patient?
  public var refusal_ind: Bool? {
    get { return negation_ind }
    set (value) { negation_ind = value }
  }
  
  ///If the patient refused the vaccine, why did they refuse?
  public var refusal_reason: CDAKCodedEntries {
    get {return negation_reason }
    set (value) {negation_reason = value}
  }

}

// MARK: - JSON Generation
extension CDAKImmunization {
  ///Dictionary for JSON data
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
