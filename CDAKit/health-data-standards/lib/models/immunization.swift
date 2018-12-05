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
open class CDAKImmunization: CDAKEntry {
  
  // MARK: CDA properties

  ///Vaccine series number
  open var series_number: Int? //, type: Integer
  ///Reaction to vaccine
  open var reaction: CDAKCodedEntries = CDAKCodedEntries() //, type: Hash
  ///Provider who performed administration
  open var performer: CDAKProvider?
  ///Vaccine medication product
  open var medication_product: CDAKMedication?

  ///Was this immunization refused by the patient?
  open var refusal_ind: Bool? {
    get { return negation_ind }
    set (value) { negation_ind = value }
  }
  
  ///If the patient refused the vaccine, why did they refuse?
  open var refusal_reason: CDAKCodedEntries {
    get {return negation_reason }
    set (value) {negation_reason = value}
  }

}

extension CDAKImmunization {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let series_number = series_number {
      dict["series_number"] = series_number as AnyObject?
    }
    if reaction.count > 0 {
      dict["reaction"] = reaction.codes.map({$0.jsonDict}) as AnyObject?
    }
    if let performer = performer {
      dict["performer"] = performer.jsonDict as AnyObject?
    }
    if let medication_product = medication_product {
      dict["medication_product"] = medication_product.jsonDict as AnyObject?
    }
    
    return dict
  }
}
