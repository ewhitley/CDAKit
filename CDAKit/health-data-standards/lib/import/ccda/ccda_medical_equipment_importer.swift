//
//  ccda_medical_equipment_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

class CDAKImport_CCDA_MedicalEquipmentImporter: CDAKImport_CDA_MedicalEquipmentImporter {
  
  override init(entry_finder: CDAKImport_CDA_EntryFinder = CDAKImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.10.20.22.2.23']/cda:entry/cda:supply")) {
    super.init(entry_finder: entry_finder)
    
  }
  
}
