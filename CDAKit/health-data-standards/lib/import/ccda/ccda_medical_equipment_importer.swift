//
//  ccda_medical_equipment_importer.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

class HDSImport_CCDA_MedicalEquipmentImporter: HDSImport_CDA_MedicalEquipmentImporter {
  
  override init(entry_finder: HDSImport_CDA_EntryFinder = HDSImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.10.20.22.2.23']/cda:entry/cda:supply")) {
    super.init(entry_finder: entry_finder)
    
  }
  
}
