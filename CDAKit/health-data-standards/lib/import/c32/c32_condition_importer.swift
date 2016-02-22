//
//  immunization_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/21/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class CDAKImport_C32_ConditionImporter: CDAKImport_CDA_ConditionImporter {
  
  
  let death_xpath = "./cda:entryRelationship[@typeCode='CAUS']/cda:observation"
  var cod_xpath: String = ""
  var time_of_death_xpath: String = ""
  
  override init(entry_finder: CDAKImport_CDA_EntryFinder = CDAKImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.103']/cda:entry/cda:act/cda:entryRelationship/cda:observation")) {

    cod_xpath = "\(death_xpath)/cda:code[@code='419620001']"
    time_of_death_xpath = "\(death_xpath)/cda:effectiveTime/@value"
    
    //NOTE - this method originally had no argument for entry-finder (not good), so I'm duplicating the entry_xpath from the CDA Condition Importer (since this is a subclass)
    super.init(entry_finder: entry_finder)
    entry_class = CDAKCondition.self
  }
  
  override func create_entry(entry_element: XMLElement, nrh: CDAKImport_CDA_NarrativeReferenceHandler = CDAKImport_CDA_NarrativeReferenceHandler()) -> CDAKCondition? {
    
    if let condition = super.create_entry(entry_element, nrh: nrh) {
      extract_cause_of_death(entry_element, condition: condition)
      extract_type(entry_element, condition: condition)
      
      return condition
    }
    
    return nil
    
  }
  
  private func extract_cause_of_death(entry_element: XMLElement, condition: CDAKCondition) {
    
    if let _ = entry_element.xpath(cod_xpath).first {
      condition.cause_of_death = true
    }
    if let time_of_death = entry_element.xpath(time_of_death_xpath).first?.stringValue {
      condition.time_of_death = CDAKHL7Helper.timestamp_to_integer(time_of_death)
    }
    
  }

  //we should move this out of here. Having these reference codes here seems restrictive.
  private func extract_type(entry_element: XMLElement, condition: CDAKCondition) {
    if let code_element = entry_element.xpath("./cda:code").first, code = code_element["code"] {
      switch code {
      case "404684003": condition.type = "Finding"
      case "418799008": condition.type = "Symptom"
      case "55607006" : condition.type = "Problem"
      case "409586006": condition.type = "Complaint"
      case "64572001" : condition.type = "CDAKCondition"
      case "282291009": condition.type = "Diagnosis"
      case "248536006": condition.type = "Functional limitation"
      default: break
      }
    }
  }
  
  
}




