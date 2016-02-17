//
//  CDAKQRDACustodian.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKQRDACustodian {
  public var ids: [CDAKCDAIdentifier] = []
  public var person: CDAKPerson? //I see no cases where this is used in CDA
  public var organization: CDAKOrganization?
}

extension CDAKQRDACustodian: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDACustodian => ids:\(ids), person:\(person), organization:\(organization)"
  }
}


extension CDAKQRDACustodian: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    if ids.count > 0 {
      dict["ids"] = ids.map({$0.jsonDict})
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