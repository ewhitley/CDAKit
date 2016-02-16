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