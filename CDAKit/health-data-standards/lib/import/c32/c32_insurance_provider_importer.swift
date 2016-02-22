//
//  immunization_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/21/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class CDAKImport_C32_InsuranceProviderImporter: CDAKImport_CDA_SectionImporter {
  override init(entry_finder: CDAKImport_CDA_EntryFinder = CDAKImport_CDA_EntryFinder(entry_xpath: "//cda:act[cda:templateId/@root='2.16.840.1.113883.10.20.1.26']")) {
    super.init(entry_finder: entry_finder)
    
    check_for_usable = false //# needs to be this way becase CDAKInsuranceProvider does not respond to usable?
    
    entry_class = CDAKInsuranceProvider.self
    
  }
  
  override func create_entry(payer_element: XMLElement, nrh: CDAKImport_CDA_NarrativeReferenceHandler = CDAKImport_CDA_NarrativeReferenceHandler()) -> CDAKInsuranceProvider? {
    
    let ip = CDAKInsuranceProvider()
    if let type = CDAKImport_CDA_SectionImporter.extract_code(payer_element, code_xpath: "./cda:code") {
      ip.type = type.code
    }
    
    if let payer = payer_element.xpath("./cda:performer/cda:assignedEntity[cda:code[@code='PAYOR']]").first {
      ip.payer = import_organization(payer)
    }
    ip.guarantors = extract_guarantors(payer_element.xpath("./cda:performer[cda:assignedEntity[cda:code[@code='GUAR']]]"))
    if let subscriber = payer_element.xpath("./cda:participant[@typeCode='HLD']/cda:participantRole").first {
      ip.subscriber = import_person(subscriber)
    }

    if let member_info_element = payer_element.xpath("cda:participant[@typeCode='COV']").first {
      extract_dates(member_info_element, entry: ip, element_name: "time")
      if let patient_element = member_info_element.xpath("./cda:participantRole[@classCode='PAT']").first {
        ip.member_id = patient_element.xpath("./cda:id").first?.stringValue //not sure this is right
        ip.relationship.addCodes(CDAKImport_CDA_SectionImporter.extract_code(patient_element, code_xpath: "./cda:code"))
      }
    }
    
    if let name = payer_element.xpath("./cda:entryRelationship[@typeCode='REFR']/cda:act[@classCode='ACT' and @moodCode='DEF']/cda:text").first {
      ip.name = name.stringValue
    }

    
    ip.financial_responsibility_type.addCodes(CDAKImport_CDA_SectionImporter.extract_code(payer_element, code_xpath: "./cda:performer/cda:assignedEntity/cda:code"))
    
    return ip
    
  }
  
  func extract_guarantors(guarantor_elements: XPathNodeSet) -> [CDAKGuarantor] {
    var guarantors: [CDAKGuarantor] = []
    for guarantor_element in guarantor_elements {
      let guarantor = CDAKGuarantor()
      extract_dates(guarantor_element, entry: guarantor, element_name: "time")
      if let guarantor_entity = guarantor_element.xpath("./cda:assignedEntity").first {
        if let person_element = guarantor_entity.xpath("./cda:assignedPerson").first {
          guarantor.person = import_person(person_element)
        }
        if let org_element = guarantor_entity.xpath("./cda:representedOrganization").first {
          guarantor.organization = import_organization(org_element)
        }
      }
      guarantors.append(guarantor)
    }
    return guarantors
  }
  
}