//
//  allergy_importer.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/13/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class HDSImport_CDA_ConditionImporter: HDSImport_CDA_SectionImporter {
  let ordinality_xpath = "./cda:priorityCode"
  let provider_xpath = "./cda:act[cda:templateId/@root='2.16.840.1.113883.10.20.1.27']/cda:performer"
  
  override init(entry_finder: HDSImport_CDA_EntryFinder = HDSImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.103']/cda:entry/cda:act/cda:entryRelationship/cda:observation")) {
    super.init(entry_finder: entry_finder)
    //NOTE: super.init() was NOT called for this class in the original Ruby
    code_xpath = "./cda:value"
    status_xpath = "./cda:entryRelationship/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.1.50']/cda:value"
    description_xpath = "./cda:text/cda:reference[@value]"
    priority_xpath = "../cda:sequenceNumber"
    entry_class = HDSCondition.self
    value_xpath = nil

    //NOTE: this took ages to sort out, but... in Ruby the original code does NOT call super.init()
    // I should probably NOT be doing this, but instead just go back to the way the Ruby code was originally set up
    check_for_usable = false

  }


  override func create_entry(entry_element: XMLElement, nrh: HDSImport_CDA_NarrativeReferenceHandler = HDSImport_CDA_NarrativeReferenceHandler()) -> HDSCondition? {
    
    if let condition = super.create_entry(entry_element, nrh: nrh) as? HDSCondition {

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
  
  private func extract_ordinality(parent_element: XMLElement, condition: HDSCondition) {
    if let ordinality_element = parent_element.xpath(ordinality_xpath).first {
      if let code = ordinality_element["code"], code_system_oid = ordinality_element["codeSystem"] {
        if let codeSystemName = ordinality_element["codeSystemName"] {
          HDSCodeSystemHelper.addCodeSystem(codeSystemName, oid: code_system_oid)
        }
        let code_system = HDSCodeSystemHelper.code_system_for(code_system_oid)
        let ce = HDSCodedEntries(entries: HDSCodedEntry(codeSystem: code_system, codes: code))
        condition.ordinality = ce
      }
      
    }
  }

  private func extract_priority(parent_element: XMLElement, condition: HDSCondition) {
    if let priority_xpath = priority_xpath, priority_element = parent_element.xpath(priority_xpath).first, priority_value = priority_element["value"], priority_int = Int(priority_value) {
      condition.priority = priority_int
    }
  }

  
}
