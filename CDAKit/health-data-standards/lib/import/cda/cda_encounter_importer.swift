//
//  allergy_importer.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/13/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class HDSImport_CDA_EncounterImporter: HDSImport_CDA_SectionImporter {
  
  var reason_xpath = "./cda:entryRelationship[@typeCode='RSON']/cda:act"
  override init(entry_finder: HDSImport_CDA_EntryFinder = HDSImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.127']/cda:entry/cda:encounter")) {
    super.init(entry_finder: entry_finder)
    entry_class = HDSEncounter.self
  }
  
  //# TODO Extract Discharge Disposition
    
  override func create_entry(entry_element: XMLElement, nrh: HDSImport_CDA_NarrativeReferenceHandler = HDSImport_CDA_NarrativeReferenceHandler()) -> HDSEncounter? {
    
    
    if let encounter = super.create_entry(entry_element, nrh: nrh) as? HDSEncounter {
      
      extract_performer(entry_element, encounter: encounter)
      extract_facility(entry_element, encounter: encounter)
      extract_reason(entry_element, encounter: encounter, nrh: nrh)
      extract_negation(entry_element, entry: encounter)
      extract_admission(entry_element, encounter: encounter)
      extract_discharge_disposition(entry_element, encounter: encounter)
      extract_transfers(entry_element, encounter: encounter)
      
      return encounter
    }
    
    return nil
    
  }

  
  private func extract_performer(parent_element: XMLElement, encounter: HDSEncounter) {
    if let performer_element = parent_element.xpath("./cda:performer").first {
      encounter.performer = import_actor(performer_element)
    }
  }
  
  private func extract_facility(parent_element: XMLElement, encounter: HDSEncounter) {
    if let participant_element = parent_element.xpath("./cda:participant[@typeCode='LOC']/cda:participantRole[@classCode='SDLOC']").first {
      
      let facility = HDSFacility()
      facility.name = participant_element.xpath("./cda:playingEntity/cda:name").first?.stringValue
      
      facility.addresses = participant_element.xpath("./cda:addr").map { ae in HDSImport_CDA_LocatableImportUtils.import_address(ae)}
      facility.telecoms = participant_element.xpath("./cda:telecom").map { te in HDSImport_CDA_LocatableImportUtils.import_telecom(te)}
      
      facility.codes = HDSCodedEntries(entries: extract_code(participant_element, code_xpath: "./cda:code"))
      
      //does this actually work? can we refer back out to the parent from an inner child like this?
      if let parent = participant_element.parent {
        extract_dates(parent, entry: facility, element_name: "time")
      }
      encounter.facility = facility
      
    }
  }
  
  private func extract_reason(parent_element: XMLElement, encounter: HDSEncounter, nrh: HDSImport_CDA_NarrativeReferenceHandler) {
    if let reason_element = parent_element.xpath(reason_xpath).first {
      let reason = HDSReason() //NOTE: was originally HDSEntry - we made it a "HDSReason" since it was a dedicated type
      extract_codes(reason_element, entry: reason)
      extract_reason_description(reason_element, entry: reason, nrh: nrh)
      extract_status(reason_element, entry: reason)
      extract_dates(reason_element, entry: reason)
      encounter.reason = reason
    }
  }
  
  private func extract_admission(parent_element: XMLElement, encounter: HDSEncounter) {
    encounter.admit_type = HDSCodedEntries(entries: extract_code(parent_element, code_xpath: "./cda:priorityCode"))
  }
  
  private func extract_discharge_disposition(parent_element: XMLElement, encounter: HDSEncounter) {
    encounter.discharge_time = encounter.end_time
    encounter.discharge_disposition = HDSCodedEntries(entries: extract_code(parent_element, code_xpath: "./sdtc:dischargeDispositionCode"))
  }
  
  private func extract_transfers(parent_element: XMLElement, encounter: HDSEncounter) {
    
    
    if let transfer_from_element = parent_element.xpath("./cda:participant[@typeCode='ORG']").first {
      let transfer_from = HDSTransfer()
      if let a_time = transfer_from_element.xpath("./cda:time").first, time_value = a_time["value"] {
        transfer_from.time = Double(time_value)
      }
      if let transfer_from_subelement = transfer_from_element.xpath("./cda:participantRole[@classCode='LOCE']").first {
        let raw_tf_code = extract_code(transfer_from_subelement, code_xpath: "./cda:code")
        transfer_from.codes = HDSCodedEntries(entries: raw_tf_code)
      }
      encounter.transfer_from = transfer_from
    }
    
    if let transfer_to_element = parent_element.xpath("./cda:participant[@typeCode='DST']").first {
      let transfer_to = HDSTransfer()
      if let a_time = transfer_to_element.xpath("./cda:time").first, time_value = a_time["value"] {
        transfer_to.time = Double(time_value)
      }
      if let transfer_from_subelement = transfer_to_element.xpath("./cda:participantRole[@classCode='LOCE']").first {
        let raw_tf_code = extract_code(transfer_from_subelement, code_xpath: "./cda:code")
        transfer_to.codes = HDSCodedEntries(entries: raw_tf_code)
      }
      encounter.transfer_to = transfer_to
    }
  }


  
}
