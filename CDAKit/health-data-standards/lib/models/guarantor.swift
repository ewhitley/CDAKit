//
//  guarantor.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//NOTE: making this an CDAKEntry subclass - This is a change to the Ruby code
/**
CDA Guarantor.
Individual legally responsible for all patient charges
*/
open class CDAKGuarantor: CDAKEntry {

  // MARK: CDA properties
  
  ///Organization
  open var organization: CDAKOrganization?
  ///Person
  open var person: CDAKPerson?
  

  // MARK: Standard properties
  ///Debugging description
  override open var description: String {
    return super.description + " person: \(person), organization: \(organization)"
  }
  
}

extension CDAKGuarantor {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let organization = organization {
      dict["organization"] = organization.jsonDict as AnyObject?
    }
    if let person = person {
      dict["person"] = person.jsonDict as AnyObject?
    }
    
    return dict
  }
}
