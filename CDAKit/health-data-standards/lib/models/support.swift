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
public class CDAKSupport: CDAKEntry {

  // MARK: CDA properties

  ///types of support available
  public static let Types = ["Guardian", "Next of Kin", "Caregiver", "Emergency Contact"]
  
  ///address
  public var address: CDAKAddress?
  ///telecom
  public var telecom: CDAKTelecom?
  ///title
  public var title: String?
  ///first / given name
  public var given_name: String?
  ///family / past name
  public var family_name: String?
  ///mother's maiden name
  public var mothers_maiden_name: String?
  ///type (see types)
  public var type: String?
  ///relationship
  public var relationship: String?
  
  //# validates_inclusion_of :type, :in => Types
  
}

extension CDAKSupport {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let address = address {
      dict["address"] = address.jsonDict
    }
    if let telecom = telecom {
      dict["telecom"] = telecom.jsonDict
    }
    
    if let title = title {
      dict["title"] = title
    }
    if let given_name = given_name {
      dict["given_name"] = given_name
    }
    if let family_name = family_name {
      dict["family_name"] = family_name
    }
    if let mothers_maiden_name = mothers_maiden_name {
      dict["mothers_maiden_name"] = mothers_maiden_name
    }
    if let type = type {
      dict["type"] = type
    }
    if let relationship = relationship {
      dict["relationship"] = relationship
    }
    
    return dict
  }
}