//
//  immunization_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/21/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class CDAKImport_C32_CareGoalImporter: CDAKImport_CDA_SectionImporter {
  
  override init(entry_finder: CDAKImport_CDA_EntryFinder = CDAKImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.124']/cda:entry/cda:*[cda:templateId/@root='2.16.840.1.113883.10.20.1.25']")) {
    super.init(entry_finder: entry_finder)
    entry_class = CDAKEntry.self
  }

  // NOTE this returns a generic "CDAKEntry" - but it could be any number of sub-types
  override func create_entry(goal_element: XMLElement, nrh: CDAKImport_CDA_NarrativeReferenceHandler = CDAKImport_CDA_NarrativeReferenceHandler()) -> CDAKEntry? {
    
    //original Ruby used "name" - which is "node_name"
    //looks like Fuzi calls this "tag"
    var importer: CDAKImport_CDA_SectionImporter
    //print("TAG = \(goal_element.tag)")
    //print("ELEMENT = \(goal_element)")
    switch goal_element.tag! {
      case "observation": importer = CDAKImport_CDA_ResultImporter()
      case "supply": importer = CDAKImport_CDA_MedicalEquipmentImporter()
      case "substanceAdministration": importer = CDAKImport_CDA_MedicationImporter()
      case "encounter": importer = CDAKImport_CDA_EncounterImporter()
      case "procedure": importer = CDAKImport_CDA_ProcedureImporter()
      //this bit here - not in the original Ruby - added our own entry_finder into the mix...
      //was originally sending nil arguments
    default: importer = CDAKImport_CDA_SectionImporter(entry_finder: self.entry_finder) //#don't need entry xpath, since we already have the entry
    }
    
    if let care_goal = importer.create_entry(goal_element, nrh: nrh) {
      extract_negation(goal_element, entry: care_goal)
      return care_goal
    }
    
    return nil
    
  }
}