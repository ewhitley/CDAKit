//
//  immunization_importer.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/21/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class HDSImport_C32_CareGoalImporter: HDSImport_CDA_SectionImporter {
  
  override init(entry_finder: HDSImport_CDA_EntryFinder = HDSImport_CDA_EntryFinder(entry_xpath: "//cda:section[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.124']/cda:entry/cda:*[cda:templateId/@root='2.16.840.1.113883.10.20.1.25']")) {
    super.init(entry_finder: entry_finder)
    entry_class = HDSEntry.self
  }

  // NOTE this returns a generic "HDSEntry" - but it could be any number of sub-types
  override func create_entry(goal_element: XMLElement, nrh: HDSImport_CDA_NarrativeReferenceHandler = HDSImport_CDA_NarrativeReferenceHandler()) -> HDSEntry? {
    
    //original Ruby used "name" - which is "node_name"
    //looks like Fuzi calls this "tag"
    var importer: HDSImport_CDA_SectionImporter
    //print("TAG = \(goal_element.tag)")
    //print("ELEMENT = \(goal_element)")
    switch goal_element.tag! {
      case "observation": importer = HDSImport_CDA_ResultImporter()
      case "supply": importer = HDSImport_CDA_MedicalEquipmentImporter()
      case "substanceAdministration": importer = HDSImport_CDA_MedicationImporter()
      case "encounter": importer = HDSImport_CDA_EncounterImporter()
      case "procedure": importer = HDSImport_CDA_ProcedureImporter()
      //this bit here - not in the original Ruby - added our own entry_finder into the mix...
      //was originally sending nil arguments
    default: importer = HDSImport_CDA_SectionImporter(entry_finder: self.entry_finder) //#don't need entry xpath, since we already have the entry
    }
    
    if let care_goal = importer.create_entry(goal_element, nrh: nrh) {
      extract_negation(goal_element, entry: care_goal)
      return care_goal
    }
    
    return nil
    
  }
}