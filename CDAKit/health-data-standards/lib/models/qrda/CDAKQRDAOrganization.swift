//
//  CDAKQRDAOrganization.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKQRDAOrganization {
  public var name: String?
  public var ids: [CDAKQRDAId] = []
  public var addresses: [CDAKAddress] = []
  public var telecoms: [CDAKTelecom] = []

}

extension CDAKQRDAOrganization: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDAOrganization => name:\(name), ids:\(ids), addresses:\(addresses), telecoms:\(telecoms)"
  }
}
