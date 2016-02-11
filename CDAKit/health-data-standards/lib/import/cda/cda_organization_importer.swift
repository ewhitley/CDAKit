//
//  organization_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/12/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class HDSImport_CDA_OrganizationImporter {
  
  class func extract_organization(org_element: XMLElement?) -> HDSOrganization? {
    guard let org_element = org_element else {
      return nil
    }
    let org = HDSOrganization()
    org.name = org_element.xpath("./cda:name | ./cda:representedOrganization/cda:name").first?.stringValue
    org.addresses = org_element.xpath("./cda:addr").map { addr in HDSImport_CDA_LocatableImportUtils.import_address(addr) }
    org.telecoms = org_element.xpath("./cda:telecom").map { tele in HDSImport_CDA_LocatableImportUtils.import_telecom(tele) }
    
    return org
  }
  
}

