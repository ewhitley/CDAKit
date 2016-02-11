//
//  ccda_medication_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

class HDSImport_CCDA_MedicationImporter: HDSImport_CDA_MedicationImporter {
  
  override init(entry_finder: HDSImport_CDA_EntryFinder = HDSImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.10.20.22.2.1' or cda:templateId/@root='2.16.840.1.113883.10.20.22.2.1.1']/cda:entry/cda:substanceAdministration")) {
    super.init(entry_finder: entry_finder)
    
    indication_xpath = "./cda:entryRelationship[@typeCode='RSON']/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.19']/cda:code"
    vehicle_xpath = "./cda:participant/cda:participantRole[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.24']/cda:playingEntity/cda:code"
    fill_number_xpath = "./cda:repeatNumber"
    
  }
  
}
