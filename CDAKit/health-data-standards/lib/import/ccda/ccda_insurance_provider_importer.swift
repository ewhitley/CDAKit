//
//  ccda_insurance_provider_importer.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

class HDSImport_CCDA_InsuranceProviderImporter: HDSImport_C32_InsuranceProviderImporter {
  
  override init(entry_finder: HDSImport_CDA_EntryFinder = HDSImport_CDA_EntryFinder(entry_xpath: "//cda:act[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.61']")) {
    super.init(entry_finder: entry_finder)
    
  }
  
}