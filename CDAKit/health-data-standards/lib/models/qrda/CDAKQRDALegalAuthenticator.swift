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
  public var ids: [CDAKCDAIdentifier] = []
  public var addresses: [CDAKAddress] = []
  public var person: CDAKPerson?
  public var organization: CDAKOrganization?
}

extension CDAKQRDALegalAuthenticator: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDALegalAuthenticator => time:\(time), ids:\(ids), addresses:\(addresses), telecoms:\(telecoms), person:\(person), organization: \(organization)"
  }
}

extension CDAKQRDALegalAuthenticator: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    dict["time"] = time.description
    if let person = person {
      dict["person"] = person.jsonDict
    }
    if ids.count > 0 {
      dict["ids"] = ids.map({$0.jsonDict})
    }
    if telecoms.count > 0 {
      dict["telecoms"] = telecoms.map({$0.jsonDict})
    }
    if addresses.count > 0 {
      dict["addresses"] = addresses.map({$0.jsonDict})
    }
    if let person = person {
      dict["person"] = person.jsonDict
    }
    if let organization = organization {
      dict["organization"] = organization.jsonDict
    }
    return dict
  }
}