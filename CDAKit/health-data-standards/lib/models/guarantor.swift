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
public class CDAKGuarantor: CDAKEntry {

  // MARK: CDA properties
  
  ///Organization
  public var organization: CDAKOrganization?
  ///Person
  public var person: CDAKPerson?
  

  // MARK: Standard properties
  ///Debugging description
  override public var description: String {
    return super.description + " person: \(person), organization: \(organization)"
  }
  
}

// MARK: - JSON Generation
extension CDAKGuarantor {
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let organization = organization {
      dict["organization"] = organization.jsonDict
    }
    if let person = person {
      dict["person"] = person.jsonDict
    }
    
    return dict
  }
}