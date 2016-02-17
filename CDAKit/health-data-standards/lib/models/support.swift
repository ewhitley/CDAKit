//
//  support.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKSupport: CDAKEntry {
  
  public static let Types = ["Guardian", "Next of Kin", "Caregiver", "Emergency Contact"]
  
  public var address: CDAKAddress?
  public var telecom: CDAKTelecom?
  
  public var title: String?
  public var given_name: String?
  public var family_name: String?
  public var mothers_maiden_name: String?
  public var type: String?
  public var relationship: String?
  
  //# validates_inclusion_of :type, :in => Types
  
}

extension CDAKSupport {
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