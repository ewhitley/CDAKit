//
//  CDAKQRDAPerson.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

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
