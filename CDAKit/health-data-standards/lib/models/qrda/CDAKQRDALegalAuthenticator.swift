//
//  CDAKQRDALegalAuthenticator.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKQRDALegalAuthenticator {
  public var time = NSDate()
  public var telecoms: [CDAKTelecom] = []
  public var ids: [CDAKQRDAId] = []
  public var addresses: [CDAKAddress] = []
  public var person: CDAKQRDAPerson?
  public var organization: CDAKQRDAOrganization?
}

extension CDAKQRDALegalAuthenticator: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDALegalAuthenticator => time:\(time), ids:\(ids), addresses:\(addresses), telecoms:\(telecoms), person:\(person), organization: \(organization)"
  }
}
