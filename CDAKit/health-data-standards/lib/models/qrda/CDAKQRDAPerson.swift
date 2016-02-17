//
//  CDAKQRDAPerson.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

//import Foundation

// Use CDAKPerson
// Removing this class - redundant
// This class is identical to the existing CDAKPerson class, so I'm getting rid of this one
/*
public class CDAKQRDAPerson {
  public var given: String?
  public var family: String?
  
  init(){}
  
  init(given: String?, family: String?) {
    self.given = given
    self.family = family
  }
  
}

extension CDAKQRDAPerson: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDAPerson => given:\(given), family:\(family)"
  }
}

extension CDAKQRDAPerson: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    if let given = given {
      dict["given"] = given
    }
    if let family = family {
      dict["family"] = family
    }
    return dict
  }
}
*/