//
//  ccda_immunization_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

class CDAKImport_CCDA_ImmunizationImporter: CDAKImport_C32_ImmunizationImporter {

  //this doesn't appear to be used anywhere (yet?)
  let refusal_reason_xpath = "./cda:entryRelationship[@typeCode='MFST']/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.9']/cda:value"

  override init(entry_finder: CDAKImport_CDA_EntryFinder = CDAKImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.10.20.22.2.2' or cda:templateId/@root='2.16.840.1.113883.10.20.22.2.2.1']/cda:entry/cda:substanceAdministration")) {
    super.init(entry_finder: entry_finder)
    
  }
  
}

