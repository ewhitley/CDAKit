//
//  ccda_medication_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

class CDAKImport_CCDA_SocialHistoryImporter: CDAKImport_CDA_SocialHistoryImporter {
  
  override init(entry_finder: CDAKImport_CDA_EntryFinder = CDAKImport_CDA_EntryFinder(entry_xpath: "//cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.38' or cda:templateId/@root='2.16.840.1.113883.10.20.15.3.8']")) {
    super.init(entry_finder: entry_finder)    
  }
  
}
