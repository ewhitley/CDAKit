//
//  ccda_condition_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

class HDSImport_CCDA_ConditionImporter: HDSImport_C32_ConditionImporter {

  override init(entry_finder: HDSImport_CDA_EntryFinder = HDSImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.10.20.22.2.5' or cda:templateId/@root='2.16.840.1.113883.10.20.22.2.5.1']/cda:entry/cda:act/cda:entryRelationship/cda:observation")) {
    super.init(entry_finder: entry_finder)

    status_xpath = "./cda:entryRelationship/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.6']/cda:value"
    
  }
  
}