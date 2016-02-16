//
//  CDAKQRDAAuthor.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKQRDAAuthor {
  public var time = NSDate()
  public var ids: [CDAKQRDAId] = []
  public var addresses: [CDAKAddress] = []
  public var telecoms: [CDAKTelecom] = []
  public var person: CDAKQRDAPerson?
  public var device: CDAKQRDADevice?
  public var organization: CDAKQRDAOrganization?
}

extension CDAKQRDAAuthor: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDAAuthor => time:\(time), ids:\(ids), addresses:\(addresses), telecoms:\(telecoms), person:\(person), device:\(device), organization: \(organization)"
  }
}
