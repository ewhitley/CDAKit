//
//  CDAKQRDACustodian.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKQRDACustodian {
  public var ids: [CDAKQRDAId] = []
  public var person: CDAKQRDAPerson?
  public var organization: CDAKQRDAOrganization?
}

extension CDAKQRDACustodian: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDACustodian => ids:\(ids), person:\(person), organization:\(organization)"
  }
}
