//
//  guarantor.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//NOTE: making this an CDAKEntry subclass - This is a change to the Ruby code
public class CDAKGuarantor: CDAKEntry {
  
  public var organization: CDAKOrganization?
  public var person: CDAKPerson?
  
  override public var description: String {
    return super.description + " person: \(person), organization: \(organization)"
  }
  
}