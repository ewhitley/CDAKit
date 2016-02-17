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
  public var ids: [CDAKCDAIdentifier] = []
  public var addresses: [CDAKAddress] = []
  public var telecoms: [CDAKTelecom] = []
  public var person: CDAKPerson?
  public var device: CDAKQRDADevice?
  public var organization: CDAKOrganization?
}

extension CDAKQRDAAuthor: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDAAuthor => time:\(time), ids:\(ids), addresses:\(addresses), telecoms:\(telecoms), person:\(person), device:\(device), organization: \(organization)"
  }
}


extension CDAKQRDAAuthor: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    dict["time"] = time.description
    if ids.count > 0 {
      dict["ids"] = ids.map({$0.jsonDict})
    }
    if addresses.count > 0 {
      dict["addresses"] = addresses.map({$0.jsonDict})
    }
    if telecoms.count > 0 {
      dict["telecoms"] = telecoms.map({$0.jsonDict})
    }
    if let person = person {
      dict["person"] = person.jsonDict
    }
    if let device = device {
      dict["device"] = device.jsonDict
    }
    if let organization = organization {
      dict["organization"] = organization.jsonDict
    }
    return dict
  }
}
