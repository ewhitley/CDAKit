//
//  allergy_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/13/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class HDSImport_CDA_ProcedureImporter: HDSImport_CDA_SectionImporter {
  var ordinality_xpath = "./cda:priorityCode"
  
  override init(entry_finder: HDSImport_CDA_EntryFinder = HDSImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root!='2.16.840.1.113883.3.88.11.83.124']//cda:procedure")) {
    super.init(entry_finder: entry_finder)
    value_xpath = "./cda:value | ./cda:entryRelationship[@typeCode='REFR']/cda:observation/cda:value"
    entry_class = HDSProcedure.self
  }
  
  override func create_entry(entry_element: XMLElement, nrh: HDSImport_CDA_NarrativeReferenceHandler = HDSImport_CDA_NarrativeReferenceHandler()) -> HDSEntry? {
    
    if let procedure = super.create_entry(entry_element, nrh: nrh) as? HDSProcedure {

      extract_ordinality(entry_element, procedure: procedure)
      extract_performer(entry_element, procedure: procedure)
      extract_anatomical_target(entry_element, procedure: procedure)
      extract_negation(entry_element, entry: procedure)
      extract_scalar(entry_element, procedure: procedure)
      
      return procedure
    }
    
    return nil

  }
  
  
  private func extract_ordinality(parent_element: XMLElement, procedure: HDSProcedure) {
    if let ordinality_element = parent_element.xpath(ordinality_xpath).first {
      /*
      Original Ruby
      Looks like there's issues with inconsistent use of the code_system / codeSystemName hash, so they're flooding
      the hash with keys
      
      {
        "code" => ordinality_element['code'], 
        "code_system" => HDSCodeSystemHelper.code_system_for(ordinality_element['codeSystem']), 
        "codeSystemName" => HDSCodeSystemHelper.code_system_for(ordinality_element['codeSystem']),
        HDSCodeSystemHelper.code_system_for(ordinality_element['codeSystem']) => [ordinality_element['code']]
      }
      */
      if let code = ordinality_element["code"], code_system_oid = ordinality_element["codeSystem"] {
        if let codeSystemName = ordinality_element["codeSystemName"] {
          HDSCodeSystemHelper.addCodeSystem(codeSystemName, oid: code_system_oid)
        }
        let code_system = HDSCodeSystemHelper.code_system_for(code_system_oid)
        let ce = HDSCodedEntries(entries: HDSCodedEntry(codeSystem: code_system, codes: code))
          procedure.ordinality = ce
      }
      
    }
  }
  
  private func extract_performer(parent_element: XMLElement, procedure: HDSProcedure) {
    if let performer_element = parent_element.xpath("./cda:performer").first {
      procedure.performer = import_actor(performer_element)
    }
  }

  private func extract_anatomical_target(parent_element: XMLElement, procedure: HDSProcedure) {
    procedure.anatomical_target = HDSCodedEntries(entries: extract_code(parent_element, code_xpath: "./cda:targetSiteCode"))
  }

  private func extract_scalar(parent_element: XMLElement, procedure: HDSProcedure) {
    if let scalar_element = parent_element.xpath("./cda:value").first, scalar_type = scalar_element["xsi:type"] {
      switch scalar_type {
        case "PQ":
          procedure.set_value(scalar_element["value"], units: scalar_element["unit"])
        case "BL":
          procedure.set_value(scalar_element["value"], units: nil)
        case "ST":
          procedure.set_value(scalar_element.stringValue, units: nil)
      default:
        print("HDSProcedure importer -> extract_scalar() unknown scalar element detected \(scalar_element["xsi:type"])")
      }
    }
  }
  
}