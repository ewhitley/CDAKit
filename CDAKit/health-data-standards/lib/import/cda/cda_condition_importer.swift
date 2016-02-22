//
//  allergy_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/13/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class CDAKImport_CDA_ConditionImporter: CDAKImport_CDA_SectionImporter {
  let ordinality_xpath = "./cda:priorityCode"
  let provider_xpath = "./cda:act[cda:templateId/@root='2.16.840.1.113883.10.20.1.27']/cda:performer"
  
  override init(entry_finder: CDAKImport_CDA_EntryFinder = CDAKImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.103']/cda:entry/cda:act/cda:entryRelationship/cda:observation")) {
    super.init(entry_finder: entry_finder)
    //NOTE: super.init() was NOT called for this class in the original Ruby
    code_xpath = "./cda:value"
    status_xpath = "./cda:entryRelationship/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.1.50']/cda:value"
    description_xpath = "./cda:text/cda:reference[@value]"
    priority_xpath = "../cda:sequenceNumber"
    entry_class = CDAKCondition.self
    value_xpath = nil

    //NOTE: this took ages to sort out (code blindness on my part), but... in Ruby the original code does NOT call super.init()
    // I should probably NOT be doing this, but instead just go back to the way the Ruby code was originally set up
    check_for_usable = false

  }


  override func create_entry(entry_element: XMLElement, nrh: CDAKImport_CDA_NarrativeReferenceHandler = CDAKImport_CDA_NarrativeReferenceHandler()) -> CDAKCondition? {
    
    if let condition = super.create_entry(entry_element, nrh: nrh) as? CDAKCondition {

      extract_ordinality(entry_element, condition: condition)
      extract_negation(entry_element, entry: condition)
      extract_priority(entry_element, condition: condition)
      
      for provider_element in entry_element.xpath(provider_xpath) {
        condition.treating_provider.append(import_actor(provider_element))
      }
      
      return condition
    }
    
    return nil

  }
  
  private func extract_ordinality(parent_element: XMLElement, condition: CDAKCondition) {
    if let ordinality_element = parent_element.xpath(ordinality_xpath).first {
      condition.ordinality.addCodes(CDAKImport_CDA_SectionImporter.extract_code(ordinality_element, code_xpath: "."))
    }
  }

  private func extract_priority(parent_element: XMLElement, condition: CDAKCondition) {
    if let priority_xpath = priority_xpath, priority_element = parent_element.xpath(priority_xpath).first, priority_value = priority_element["value"], priority_int = Int(priority_value) {
      condition.priority = priority_int
    }
  }

  
}
