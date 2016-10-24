//
//  allergy_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/13/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class CDAKImport_CDA_AllergyImporter: CDAKImport_CDA_SectionImporter {
  var type_xpath = "./cda:code"
//  var reaction_xpath = "./cda:entryRelationship[@typeCode='MFST']/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.1.54']/cda:value"
//  var severity_xpath = "./cda:entryRelationship[@typeCode='SUBJ']/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.1.55']/cda:value"
  var reaction_xpath = "./cda:entryRelationship[@typeCode='MFST']/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.1.54']"
  var severity_xpath = "./cda:entryRelationship[@typeCode='SUBJ']/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.1.55']"
  
  
  override init(entry_finder: CDAKImport_CDA_EntryFinder = CDAKImport_CDA_EntryFinder(entry_xpath: "//cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.1.18']")) {
    super.init(entry_finder: entry_finder)
    //NOTE: super.init() was NOT called for this class in the original Ruby
    code_xpath = "./cda:participant/cda:participantRole/cda:playingEntity/cda:code"
    description_xpath = "./cda:code/cda:originalText/cda:reference[@value] | ./cda:text/cda:reference[@value]"
    status_xpath   = "./cda:entryRelationship[@typeCode='REFR']/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.1.39']/cda:value"
    entry_class = CDAKAllergy.self

    //NOTE: this took ages to sort out (code blindness on my part), but... in Ruby the original code does NOT call super.init()
    // I should probably NOT be doing this, but instead just go back to the way the Ruby code was originally set up
    check_for_usable = false
  }

  override func create_entry(_ entry_element: XMLElement, nrh: CDAKImport_CDA_NarrativeReferenceHandler = CDAKImport_CDA_NarrativeReferenceHandler()) -> CDAKAllergy? {
    
    if let allergy = super.create_entry(entry_element, nrh: nrh) as? CDAKAllergy {

      extract_negation(entry_element, entry: allergy)

      allergy.type.addCodes(CDAKImport_CDA_SectionImporter.extract_code(entry_element, code_xpath: type_xpath))
      
//      allergy.reaction.addCodes(CDAKImport_CDA_SectionImporter.extract_code(entry_element, code_xpath: reaction_xpath))
//      allergy.severity.addCodes(CDAKImport_CDA_SectionImporter.extract_code(entry_element, code_xpath: severity_xpath))
      allergy.reaction = extract_entry_detail(entry_element, xpath: reaction_xpath)
      allergy.reaction?.codes.preferred_code_sets = ["SNOMED-CT"]
      allergy.severity = extract_entry_detail(entry_element, xpath: severity_xpath)
      allergy.severity?.codes.preferred_code_sets = ["SNOMED-CT"]
      
      //extract_entry_detail
      print(allergy.reaction)
      
      return allergy
    }
    
    return nil

  }
  
}
