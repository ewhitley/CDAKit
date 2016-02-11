//
//  ccda_care_goal_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

class HDSImport_CCDA_CareGoalImporter: HDSImport_C32_CareGoalImporter {
  override init(entry_finder: HDSImport_CDA_EntryFinder = HDSImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.10.20.22.2.10']/cda:entry/cda:*")) {
    super.init(entry_finder: entry_finder)
    
  }
  
}