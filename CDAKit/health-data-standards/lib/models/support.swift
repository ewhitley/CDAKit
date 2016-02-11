//
//  support.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

class HDSSupport: HDSEntry {
  
  static let Types = ["Guardian", "Next of Kin", "Caregiver", "Emergency Contact"]
  
  var address: HDSAddress?
  var telecom: HDSTelecom?
  
  var title: String?
  var given_name: String?
  var family_name: String?
  var mothers_maiden_name: String?
  var type: String?
  var relationship: String?
  
  //# validates_inclusion_of :type, :in => Types
  
}