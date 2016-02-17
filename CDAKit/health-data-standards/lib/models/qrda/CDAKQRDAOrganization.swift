//
//  CDAKQRDAOrganization.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

//Removing this class - redundant
//This class is identical to the existing CDAKOrganization class, so I'm getting rid of this one

/*
public class CDAKQRDAOrganization {
  public var name: String?
  public var ids: [CDAKCDAIdentifier] = []
  public var addresses: [CDAKAddress] = []
  public var telecoms: [CDAKTelecom] = []

}

extension CDAKQRDAOrganization: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDAOrganization => name:\(name), ids:\(ids), addresses:\(addresses), telecoms:\(telecoms)"
  }
}

extension CDAKQRDAOrganization: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    if let name = name {
      dict["name"] = name
    }
    dict["ids"] = ids.map({$0.jsonDict})
    dict["telecoms"] = telecoms.map({$0.jsonDict})
    dict["addresses"] = addresses.map({$0.jsonDict})
    return dict
  }
}
*/