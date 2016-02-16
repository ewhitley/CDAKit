//
//  cat1_header.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

//NOTE: this class does NOT existing in the Ruby version
// mimic-ing their approach to get the CDA header information

//something.heaer = CDAKImport_cat1_HeaderImporter.import_header(doc: doc)

class CDAKImport_cat1_HeaderImporter {
  
  class func import_header(doc: XMLDocument) -> CDAKQRDAHeader {
    let header = CDAKQRDAHeader()
    set_header(header, doc: doc)
    return header
  }
  
  class func set_header(header: CDAKQRDAHeader, doc: XMLDocument) {
    set_confidentiality_code(header, doc: doc)
    set_creation_date(header, doc: doc)
    set_custodian(header, doc: doc)
    set_author(header, doc: doc)
    set_device(header, doc: doc)
    set_legal_authenticator(header, doc: doc)
  }

  class func set_creation_date(header: CDAKQRDAHeader, doc: XMLDocument) {
    let effective_date = doc.xpath("/cda:ClinicalDocument/cda:effectiveTime").first?["value"]
    if let a_time = HL7Helper.timestamp_to_integer(effective_date) {
      header.time = NSDate(timeIntervalSince1970: a_time)
    }
  }

  class func set_confidentiality_code(header: CDAKQRDAHeader, doc: XMLDocument) {
    let confidentialityCode = doc.xpath("/cda:ClinicalDocument/cda:confidentialityCode").first?["code"]
    if let confidentialityCode = confidentialityCode, confidentiality = CDAKConfidentialityCodes(rawValue: confidentialityCode) {
      header.confidentiality = confidentiality
    }
  }

  class func set_author(header: CDAKQRDAHeader, doc: XMLDocument) {
  }

  class func set_custodian(header: CDAKQRDAHeader, doc: XMLDocument) {
    //FIXME: not currently pulling in IDs - need an example
    if let custodian = doc.xpath("/cda:ClinicalDocument/cda:custodian/cda:assignedCustodian/cda:representedCustodianOrganization").first {
      let aCustodian = CDAKQRDACustodian()
      aCustodian.organization = import_organization(custodian)
      //FIXME: may want to go back and figure out where these should really apply.
      // this is being tagged to the custodian, but that isn't the "organization" - and it feels like it should be
      if let org = aCustodian.organization {
        org.ids = import_ids(custodian)
      }
      header.custodian = aCustodian
    }
  }
  
  class func import_ids (elem: XMLElement) -> [CDAKQRDAId] {
    //<id root="2.16.840.1.113883.19.5" extension="something"/>
    return elem.xpath("./cda:id").map({id_entry in CDAKQRDAId(root: id_entry["root"], extension_id: id_entry["extension"])})
  }

  class func set_device(header: CDAKQRDAHeader, doc: XMLDocument) {
  }
  
  class func set_id(header: CDAKQRDAHeader, doc: XMLDocument) {
  }

  class func set_legal_authenticator(header: CDAKQRDAHeader, doc: XMLDocument) {
    //FIXME: not addressing assignedPerson
    //https://github.com/chb/sample_ccdas/blob/master/EMERGE/Patient-673.xml#L225
    if let auth_info = doc.xpath("/cda:ClinicalDocument/cda:legalAuthenticator").first {
      let legal = CDAKQRDALegalAuthenticator()
      if let time = get_time(auth_info) {
        legal.time = time
      }
      if let org_info = auth_info.xpath("./cda:assignedEntity").first {
        if let org = import_organization(org_info) {
          org.ids = import_ids(org_info)
          legal.organization = org
        }
      }
      header.legal_authenticator = legal
    }
  }

  class func get_time(elem: XMLElement) -> NSDate? {
    if let time_info = elem.xpath("./cda:time").first?["value"] {
      //20130418090000+0500 ... ewwwwwwwww
      //https://github.com/chb/sample_ccdas/blob/master/EMERGE/Patient-673.xml#L226
      if let a_time = HL7Helper.timestamp_to_integer(time_info) {
        return NSDate(timeIntervalSince1970: a_time)
      }
    }
    return nil
  }
  
  class func import_organization(organization_element: XMLElement) -> CDAKQRDAOrganization? {
    if let org = CDAKImport_CDA_OrganizationImporter.extract_organization(organization_element) {
      let cdaOrg = CDAKQRDAOrganization()
      cdaOrg.addresses = org.addresses
      cdaOrg.name = org.name
      cdaOrg.telecoms = org.telecoms
      return cdaOrg
    }
    return nil
  }

  
  class func set_person(header: CDAKQRDAHeader, doc: XMLDocument) {
  }
  
}

