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
    set_confidentiality_code(header, doc: doc) //done
    set_creation_date(header, doc: doc) //done
    set_custodian(header, doc: doc) //done
    set_authors(header, doc: doc) //done
    set_legal_authenticator(header, doc: doc) //done
    
    if let id_elem = doc.xpath("./cda:id").first {
      header.identifier = import_ids(id_elem).first
    }
    
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

  class func set_authors(header: CDAKQRDAHeader, doc: XMLDocument) {
    header.authors = doc.xpath("./cda:author").map({author in get_authors(author)})
  }
  
  class func get_authors(elem: XMLElement) -> CDAKQRDAAuthor {
    let author = CDAKQRDAAuthor()
    
    if let time = get_time(elem) {
      author.time = time
    }
    if let assignedAuthor = elem.xpath("./cda:assignedAuthor").first {
      
      author.ids = import_ids(assignedAuthor)
      author.addresses = assignedAuthor.xpath("./cda:addr").map({addr in CDAKImport_CDA_LocatableImportUtils.import_address(addr)})
      author.telecoms = assignedAuthor.xpath("./cda:telecom").map({tele in CDAKImport_CDA_LocatableImportUtils.import_telecom(tele)})
      
      if let person_info = assignedAuthor.xpath("./cda:assignedPerson/cda:name").first {
        author.person = CDAKQRDAPerson(given: person_info["given"], family: person_info["family"])
      }
      if let device_elem = assignedAuthor.xpath("assignedAuthoringDevice").first {
        author.device = get_device(device_elem)
      }
      if let org = assignedAuthor.xpath("/cda:representedOrganization").first {
        author.organization = import_organization(org)
      }
    }
    
    return author
  }

  class func get_device(elem: XMLElement) -> CDAKQRDADevice {
    let device = CDAKQRDADevice()
    device.model = elem.xpath("manufacturerModelName").first?.stringValue
    device.name = elem.xpath("softwareName").first?.stringValue
    return device
  }
  
  class func set_custodian(header: CDAKQRDAHeader, doc: XMLDocument) {
    
    if let custodian_elem = doc.xpath("/cda:ClinicalDocument/cda:custodian/cda:assignedCustodian").first {
      let aCustodian = CDAKQRDACustodian()
      aCustodian.ids = import_ids(custodian_elem)
      if let org = custodian_elem.xpath("/cda:representedCustodianOrganization").first {
        aCustodian.organization = import_organization(org)
      }
      //FIXME: I see no cases of "person" living under assignedCustodian
      // need examples if this is to be found
      if let person_info = custodian_elem.xpath("./cda:representedPerson").first {
        aCustodian.person = CDAKQRDAPerson(given: person_info["given"], family: person_info["family"])
      }
      header.custodian = aCustodian
    }
    
  }
  
  class func import_ids (elem: XMLElement) -> [CDAKQRDAId] {
    return elem.xpath("./cda:id").map({id_entry in CDAKQRDAId(root: id_entry["root"], extension_id: id_entry["extension"])})
  }
  
  class func set_legal_authenticator(header: CDAKQRDAHeader, doc: XMLDocument) {
    if let auth_info = doc.xpath("/cda:ClinicalDocument/cda:legalAuthenticator").first {
      let legal = CDAKQRDALegalAuthenticator()
      if let time = get_time(auth_info) {
        legal.time = time
      }
      //according to the examples, this seems correct
      if let assignedEntity = auth_info.xpath("./cda:assignedEntity").first {
        legal.ids = import_ids(assignedEntity)
        legal.addresses = assignedEntity.xpath("./cda:addr").map({addr in CDAKImport_CDA_LocatableImportUtils.import_address(addr)})
        legal.telecoms = assignedEntity.xpath("./cda:telecom").map({tele in CDAKImport_CDA_LocatableImportUtils.import_telecom(tele)})
      }
      if let org_info = auth_info.xpath("./cda:assignedPerson/cda:name").first {
        legal.person = CDAKQRDAPerson(given: org_info["given"], family: org_info["family"])
      }
      if let org_info = auth_info.xpath("./cda:representedOrganization").first {
        if let org = import_organization(org_info) {
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
      cdaOrg.ids = import_ids(organization_element)
      return cdaOrg
    }
    return nil
  }

  
  class func set_person(header: CDAKQRDAHeader, doc: XMLDocument) {
  }
  
}

