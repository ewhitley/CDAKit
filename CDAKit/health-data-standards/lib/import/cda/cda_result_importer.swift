//
//  allergy_importer.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/13/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class HDSImport_CDA_ResultImporter: HDSImport_CDA_SectionImporter {
  var ordinality_xpath = "./cda:priorityCode"
  
  override init(entry_finder: HDSImport_CDA_EntryFinder = HDSImport_CDA_EntryFinder(entry_xpath: "//cda:observation[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.15.1'] | //cda:observation[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.15']")) {
    super.init(entry_finder: entry_finder)
    entry_class = HDSLabResult.self
  }
  
  override func create_entry(entry_element: XMLElement, nrh: HDSImport_CDA_NarrativeReferenceHandler = HDSImport_CDA_NarrativeReferenceHandler()) -> HDSLabResult? {
    
    if let result = super.create_entry(entry_element, nrh: nrh) as? HDSLabResult {

      extract_interpretation(entry_element, result: result)
      extract_reference_range(entry_element, result: result)
      extract_negation(entry_element, entry: result)
      extract_reason_description(entry_element, entry: result, nrh: nrh)
      return result
    }
    
    return nil

  }
  
  private func extract_interpretation(parent_element: XMLElement, result: HDSLabResult) {
    if let interpretation_element = parent_element.xpath("./cda:interpretationCode").first {
      if let code = interpretation_element["code"], code_system_oid = interpretation_element["codeSystem"] {
        if let codeSystemName = interpretation_element["codeSystemName"] {
          HDSCodeSystemHelper.addCodeSystem(codeSystemName, oid: code_system_oid)
        }
        let code_system = HDSCodeSystemHelper.code_system_for(code_system_oid)
        let ce = HDSCodedEntries(entries: HDSCodedEntry(codeSystem: code_system, codes: code))
        result.interpretation = ce
      }
    }
  }

  private func extract_reference_range(parent_element: XMLElement, result: HDSLabResult) {
    if let reference_range = parent_element.xpath("./cda:referenceRange/cda:observationRange/cda:text").first?.stringValue {
      result.reference_range = reference_range
    }
  }

  
}