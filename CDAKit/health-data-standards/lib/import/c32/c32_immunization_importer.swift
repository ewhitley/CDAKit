//
//  immunization_importer.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/21/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class HDSImport_C32_ImmunizationImporter: HDSImport_CDA_SectionImporter {
  
  override init(entry_finder: HDSImport_CDA_EntryFinder = HDSImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.117']/cda:entry/cda:substanceAdministration")) {
    super.init(entry_finder: entry_finder)
    
    code_xpath = "./cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code"
    description_xpath = "./cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code/cda:originalText/cda:reference[@value]"
    
    entry_class = HDSImmunization.self
    
  }
  
  override func create_entry(entry_element: XMLElement, nrh: HDSImport_CDA_NarrativeReferenceHandler = HDSImport_CDA_NarrativeReferenceHandler()) -> HDSImmunization? {
    
    if let immunization = super.create_entry(entry_element, nrh: nrh) as? HDSImmunization {
      extract_negation(entry_element, entry: immunization)
      extract_performer(entry_element, immunization: immunization)
      return immunization
    }
    
    return nil
  }
  
  private func extract_performer(parent_element: XMLElement, immunization: HDSImmunization) {
    if let performer_element = parent_element.xpath("./cda:performer").first {
      immunization.performer = import_actor(performer_element)
    }
  }

  
}

