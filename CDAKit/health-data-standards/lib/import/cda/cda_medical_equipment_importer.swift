//
//  allergy_importer.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/13/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class HDSImport_CDA_MedicalEquipmentImporter: HDSImport_CDA_SectionImporter {

  let anatomical_xpath = "./cda:targetSiteCode"
  
  override init(entry_finder: HDSImport_CDA_EntryFinder = HDSImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.128']/cda:entry/cda:supply")) {
    super.init(entry_finder: entry_finder)
    code_xpath = "./cda:participant/cda:participantRole/cda:playingDevice/cda:code"
    entry_class = HDSMedicalEquipment.self
  }


  override func create_entry(entry_element: XMLElement, nrh: HDSImport_CDA_NarrativeReferenceHandler = HDSImport_CDA_NarrativeReferenceHandler()) -> HDSMedicalEquipment? {
    
    if let medical_equipment = super.create_entry(entry_element, nrh: nrh) as? HDSMedicalEquipment {

      extract_manufacturer(entry_element, entry: medical_equipment)
      extract_anatomical_structure(entry_element, entry: medical_equipment)
      extract_removal_time(entry_element, entry: medical_equipment)
      
      return medical_equipment
    }
    
    return nil

  }
  
  private func extract_manufacturer(entry_element: XMLElement, entry: HDSMedicalEquipment) {
    if let manufacturer = entry_element.xpath("./cda:participant/cda:participantRole/cda:scopingEntity/cda:desc").first?.stringValue {
      entry.manufacturer = manufacturer.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
  }

  private func extract_removal_time(entry_element: XMLElement, entry: HDSMedicalEquipment) {
    if let removal_time_entry = entry_element.xpath("cda:effectiveTime/cda:high").first, removal_time_value = removal_time_entry["value"] {
      entry.removal_time = HL7Helper.timestamp_to_integer(removal_time_value)
    }
  }

  private func extract_anatomical_structure(entry_element: XMLElement, entry: HDSMedicalEquipment) {
    if let site = entry_element.xpath(anatomical_xpath).first {
      if let code = site["code"], code_system_oid = site["codeSystem"] {
        if let codeSystemName = site["codeSystemName"] {
          HDSCodeSystemHelper.addCodeSystem(codeSystemName, oid: code_system_oid)
        }
        let code_system = HDSCodeSystemHelper.code_system_for(code_system_oid)
        let ce = HDSCodedEntries(entries: HDSCodedEntry(codeSystem: code_system, codes: code))
        entry.anatomical_structure = ce
      }
    }
  }
  

  
}
