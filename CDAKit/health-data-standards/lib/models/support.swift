//
//  support.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

/**
 Support
*/
open class CDAKSupport: CDAKEntry {

  // MARK: CDA properties

  ///types of support available
  open static let Types = ["Guardian", "Next of Kin", "Caregiver", "Emergency Contact"]
  
  ///address
  open var address: CDAKAddress?
  ///telecom
  open var telecom: CDAKTelecom?
  ///prefix (was Title)
  open var prefix: String?
  ///first / given name
  open var given_name: String?
  ///family / past name
  open var family_name: String?
  ///suffix
  open var suffix: String?
  ///mother's maiden name
  open var mothers_maiden_name: String?
  ///type (see types)
  open var type: String?
  ///relationship
  open var relationship: String?
  
  //# validates_inclusion_of :type, :in => Types
  
}

extension CDAKSupport {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let address = address {
      dict["address"] = address.jsonDict as AnyObject?
    }
    if let telecom = telecom {
      dict["telecom"] = telecom.jsonDict as AnyObject?
    }
    
    if let prefix = prefix {
      dict["prefix"] = prefix as AnyObject?
    }
    if let given_name = given_name {
      dict["given_name"] = given_name as AnyObject?
    }
    if let family_name = family_name {
      dict["family_name"] = family_name as AnyObject?
    }
    if let suffix = suffix {
      dict["suffix"] = suffix as AnyObject?
    }
    if let mothers_maiden_name = mothers_maiden_name {
      dict["mothers_maiden_name"] = mothers_maiden_name as AnyObject?
    }
    if let type = type {
      dict["type"] = type as AnyObject?
    }
    if let relationship = relationship {
      dict["relationship"] = relationship as AnyObject?
    }
    
    return dict
  }
}
