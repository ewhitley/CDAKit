//
//  immunization_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/21/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class CDAKImport_C32_ImmunizationImporter: CDAKImport_CDA_SectionImporter {
  
  override init(entry_finder: CDAKImport_CDA_EntryFinder = CDAKImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.117']/cda:entry/cda:substanceAdministration")) {
    super.init(entry_finder: entry_finder)
    
    code_xpath = "./cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code"
    description_xpath = "./cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code/cda:originalText/cda:reference[@value]"
    
    entry_class = CDAKImmunization.self
    
  }
  
  override func create_entry(_ entry_element: XMLElement, nrh: CDAKImport_CDA_NarrativeReferenceHandler = CDAKImport_CDA_NarrativeReferenceHandler()) -> CDAKImmunization? {
    
    if let immunization = super.create_entry(entry_element, nrh: nrh) as? CDAKImmunization {
      extract_negation(entry_element, entry: immunization)
      extract_performer(entry_element, immunization: immunization)
      return immunization
    }
    
    return nil
  }
  
  fileprivate func extract_performer(_ parent_element: XMLElement, immunization: CDAKImmunization) {
    if let performer_element = parent_element.xpath("./cda:performer").first {
      immunization.performer = import_actor(performer_element)
    }
  }

  
}

