//
//  allergy_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/13/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class CDAKImport_CDA_ProcedureImporter: CDAKImport_CDA_SectionImporter {
  var ordinality_xpath = "./cda:priorityCode"
  
  override init(entry_finder: CDAKImport_CDA_EntryFinder = CDAKImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root!='2.16.840.1.113883.3.88.11.83.124']//cda:procedure")) {
    super.init(entry_finder: entry_finder)
    value_xpath = "./cda:value | ./cda:entryRelationship[@typeCode='REFR']/cda:observation/cda:value"
    entry_class = CDAKProcedure.self
  }
  
  override func create_entry(entry_element: XMLElement, nrh: CDAKImport_CDA_NarrativeReferenceHandler = CDAKImport_CDA_NarrativeReferenceHandler()) -> CDAKEntry? {
    
    if let procedure = super.create_entry(entry_element, nrh: nrh) as? CDAKProcedure {

      extract_ordinality(entry_element, procedure: procedure)
      extract_performer(entry_element, procedure: procedure)
      extract_anatomical_target(entry_element, procedure: procedure)
      extract_negation(entry_element, entry: procedure)
      extract_scalar(entry_element, procedure: procedure)
      
      return procedure
    }
    
    return nil

  }
  
  
  private func extract_ordinality(parent_element: XMLElement, procedure: CDAKProcedure) {
    if let ordinality_element = parent_element.xpath(ordinality_xpath).first {
      procedure.ordinality.addCodes(CDAKImport_CDA_SectionImporter.extract_code(ordinality_element, code_xpath: "."))
    }
  }
  
  private func extract_performer(parent_element: XMLElement, procedure: CDAKProcedure) {
    if let performer_element = parent_element.xpath("./cda:performer").first {
      procedure.performer = import_actor(performer_element)
    }
  }

  private func extract_anatomical_target(parent_element: XMLElement, procedure: CDAKProcedure) {
    procedure.anatomical_target.addCodes(CDAKImport_CDA_SectionImporter.extract_code(parent_element, code_xpath: "./cda:targetSiteCode"))
  }

  private func extract_scalar(parent_element: XMLElement, procedure: CDAKProcedure) {
    if let scalar_element = parent_element.xpath("./cda:value").first, scalar_type = scalar_element["xsi:type"] {
      switch scalar_type {
        case "PQ":
          procedure.set_value(scalar_element["value"], units: scalar_element["unit"])
        case "BL":
          procedure.set_value(scalar_element["value"], units: nil)
        case "ST":
          procedure.set_value(scalar_element.stringValue, units: nil)
      default:
        print("CDAKProcedure importer -> extract_scalar() unknown scalar element detected \(scalar_element["xsi:type"])")
      }
    }
  }
  
}