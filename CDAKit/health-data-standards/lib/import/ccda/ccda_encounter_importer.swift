//
//  ccda_encounter_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

class CDAKImport_CCDA_EncounterImporter: CDAKImport_CDA_EncounterImporter {
  
  override init(entry_finder: CDAKImport_CDA_EntryFinder = CDAKImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.10.20.22.2.22' or cda:templateId/@root='2.16.840.1.113883.10.20.22.2.22.1']/cda:entry/cda:encounter")) {
    super.init(entry_finder: entry_finder)
    
    reason_xpath = "./cda:entryRelationship[@typeCode='RSON']/cda:observation"
    
  }
  
}