//
//  allergy_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/13/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class CDAKImport_CDA_MedicalEquipmentImporter: CDAKImport_CDA_SectionImporter {

  let anatomical_xpath = "./cda:targetSiteCode"
  
  override init(entry_finder: CDAKImport_CDA_EntryFinder = CDAKImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.128']/cda:entry/cda:supply")) {
    super.init(entry_finder: entry_finder)
    code_xpath = "./cda:participant/cda:participantRole/cda:playingDevice/cda:code"
    entry_class = CDAKMedicalEquipment.self
  }


  override func create_entry(_ entry_element: XMLElement, nrh: CDAKImport_CDA_NarrativeReferenceHandler = CDAKImport_CDA_NarrativeReferenceHandler()) -> CDAKMedicalEquipment? {
    
    if let medical_equipment = super.create_entry(entry_element, nrh: nrh) as? CDAKMedicalEquipment {

      extract_manufacturer(entry_element, entry: medical_equipment)
      extract_anatomical_structure(entry_element, entry: medical_equipment)
      extract_removal_time(entry_element, entry: medical_equipment)
      
      return medical_equipment
    }
    
    return nil

  }
  
  fileprivate func extract_manufacturer(_ entry_element: XMLElement, entry: CDAKMedicalEquipment) {
    if let manufacturer = entry_element.xpath("./cda:participant/cda:participantRole/cda:scopingEntity/cda:desc").first?.stringValue {
      entry.manufacturer = manufacturer.trimmingCharacters(in: .whitespaces)
    }
  }

  fileprivate func extract_removal_time(_ entry_element: XMLElement, entry: CDAKMedicalEquipment) {
    if let removal_time_entry = entry_element.xpath("cda:effectiveTime/cda:high").first, let removal_time_value = removal_time_entry["value"] {
      entry.removal_time = CDAKHL7Helper.timestamp_to_integer(removal_time_value)
    }
  }

  fileprivate func extract_anatomical_structure(_ entry_element: XMLElement, entry: CDAKMedicalEquipment) {
    if let site = entry_element.xpath(anatomical_xpath).first {
      entry.anatomical_structure.addCodes(CDAKImport_CDA_SectionImporter.extract_code(site, code_xpath: "."))
    }
  }
  

  
}
