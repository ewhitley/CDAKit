//
//  CDAKQRDACustodian.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

open class CDAKQRDACustodian {
  open var ids: [CDAKCDAIdentifier] = []
  open var person: CDAKPerson? //I see no cases where this is used in CDA
  open var organization: CDAKOrganization?
}

extension CDAKQRDACustodian: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDACustodian => ids:\(ids), person:\(person), organization:\(organization)"
  }
}

extension CDAKQRDACustodian: MustacheBoxable {
  var boxedValues: [String:MustacheBox] {
    return [
      "ids" :  Box(ids),
      "person" :  Box(person),
      "organization" :  Box(organization)
    ]
  }
  
  public var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
}

extension CDAKQRDACustodian: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    if ids.count > 0 {
      dict["ids"] = ids.map({$0.jsonDict}) as AnyObject?
    }
    if let person = person {
      dict["person"] = person.jsonDict as AnyObject?
    }
    if let organization = organization {
      dict["organization"] = organization.jsonDict as AnyObject?
    }
    return dict
  }
}
