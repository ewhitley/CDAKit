//
//  organization_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/12/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class CDAKImport_CDA_OrganizationImporter {
  
  class func extract_organization(_ org_element: XMLElement?) -> CDAKOrganization? {
    guard let org_element = org_element else {
      return nil
    }
    let org = CDAKOrganization()
    org.name = org_element.xpath("./cda:name | ./cda:representedOrganization/cda:name").first?.stringValue
    org.addresses = org_element.xpath("./cda:addr").flatMap { addr in CDAKImport_CDA_LocatableImportUtils.import_address(addr) }
    org.telecoms = org_element.xpath("./cda:telecom").flatMap { tele in CDAKImport_CDA_LocatableImportUtils.import_telecom(tele) }
    
    return org
  }
  
}

