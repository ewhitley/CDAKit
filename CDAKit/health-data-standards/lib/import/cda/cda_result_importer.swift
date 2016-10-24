//
//  allergy_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/13/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class CDAKImport_CDA_ResultImporter: CDAKImport_CDA_SectionImporter {
  var ordinality_xpath = "./cda:priorityCode"
  
  override init(entry_finder: CDAKImport_CDA_EntryFinder = CDAKImport_CDA_EntryFinder(entry_xpath: "//cda:observation[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.15.1'] | //cda:observation[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.15']")) {
    super.init(entry_finder: entry_finder)
    entry_class = CDAKLabResult.self
  }
  
  override func create_entry(_ entry_element: XMLElement, nrh: CDAKImport_CDA_NarrativeReferenceHandler = CDAKImport_CDA_NarrativeReferenceHandler()) -> CDAKLabResult? {
    
    if let result = super.create_entry(entry_element, nrh: nrh) as? CDAKLabResult {

      extract_interpretation(entry_element, result: result)
      extract_reference_range(entry_element, result: result)
      extract_negation(entry_element, entry: result)
      extract_reason_description(entry_element, entry: result, nrh: nrh)
      return result
    }
    
    return nil

  }
  
  fileprivate func extract_interpretation(_ parent_element: XMLElement, result: CDAKLabResult) {
    if let interpretation_element = parent_element.xpath("./cda:interpretationCode").first {
      result.interpretation.addCodes(CDAKImport_CDA_SectionImporter.extract_code(interpretation_element, code_xpath: "."))
    }
  }

  fileprivate func extract_reference_range(_ parent_element: XMLElement, result: CDAKLabResult) {
    if let reference_range = parent_element.xpath("./cda:referenceRange/cda:observationRange/cda:text").first?.stringValue {
      result.reference_range = reference_range
    }
  }

  
}
