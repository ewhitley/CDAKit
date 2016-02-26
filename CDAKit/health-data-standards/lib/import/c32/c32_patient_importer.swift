//
//  patient_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/11/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi



/**
 This class is the central location for taking a HITSP C32 XML document and converting it into the processed form we store in MongoDB. The class does this by running each measure independently on the XML document
 
 Creates a new PatientImporter with the following XPath expressions used to find content in a HITSP C32:
 
 * CDAKEncounter entries
   * //cda:section[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.127']/cda:entry/cda:encounter
 * Procedure entries
   * //cda:procedure[cda:templateId/@root='2.16.840.1.113883.10.20.1.29']
 * Result entries - There seems to be some confusion around the correct templateId, so the code checks for both
   * //cda:observation[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.15.1'] | //cda:observation[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.15']
 * Vital sign entries
   * //cda:observation[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.14']
 * Medication entries
   * //cda:section[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.112']/cda:entry/cda:substanceAdministration
 * Codes for medications are found in the substanceAdministration with the following relative XPath
   * ./cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code
 * Condition entries
   * //cda:section[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.103']/cda:entry/cda:act/cda:entryRelationship/cda:observation
 
 Codes for conditions are determined by examining the value child element as opposed to the code child element

 * Social History entries (non-C32 section, specified in the HL7 CCD)
   * //cda:observation[cda:templateId/@root='2.16.840.1.113883.3.88.11.83.19']
 * Care Goal entries(non-C32 section, specified in the HL7 CCD)
   * //cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.1.25']
 * CDAKAllergy entries
   * //cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.1.18']
 * CDAKImmunization entries
   * //cda:substanceAdministration[cda:templateId/@root='2.16.840.1.113883.10.20.1.24']
 * Codes for immunizations are found in the substanceAdministration with the following relative XPath
   * ./cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code
 
*/
class CDAKImport_C32_PatientImporter {
  // Original Ruby: This class is a Singleton. It should be accessed by calling PatientImporter.instance
  
  var section_importers: [String:CDAKImport_CDA_SectionImporter] = [:]

  init(check_usable: Bool = true) {
    
    section_importers["encounters"] = CDAKImport_CDA_EncounterImporter()
    section_importers["procedures"] = CDAKImport_CDA_ProcedureImporter()
    section_importers["results"] = CDAKImport_CDA_ResultImporter()
    section_importers["vital_signs"] = CDAKImport_CDA_VitalSignImporter()
    section_importers["medications"] = CDAKImport_CDA_MedicationImporter()
    section_importers["conditions"] = CDAKImport_C32_ConditionImporter()
    //section_importers["social_history"] = CDAKImport_CDA_SectionImporter(entry_finder: CDAKImport_CDA_EntryFinder(entry_xpath: "//cda:observation[cda:templateId/root='2.16.840.1.113883.3.88.11.83.19']"))
    section_importers["social_history"] = CDAKImport_CDA_SocialHistoryImporter()

    section_importers["care_goals"] = CDAKImport_C32_CareGoalImporter()
    section_importers["medical_equipment"] = CDAKImport_CDA_MedicalEquipmentImporter()
    section_importers["allergies"] = CDAKImport_CDA_AllergyImporter()
    section_importers["immunizations"] = CDAKImport_C32_ImmunizationImporter()
    section_importers["insurance_providers"] = CDAKImport_C32_InsuranceProviderImporter()
  }


  /**
   - parameter check_usable_entries: value for check_usable_entries...importer uses true, stats uses false
   */
  func check_usable(check_usable_entries: Bool) {
    for (_, importer) in section_importers {
      importer.check_for_usable = check_usable_entries
    }
  }
  
  
  /**
   Parses a HITSP C32 document and returns a Hash of of the patient.
   
   - parameter doc: It is expected that the root node of this document
   will have the "cda" namespace registered to "urn:hl7-org:v3"
   - returns: a Mongoid model representing the patient
   */
  func parse_c32(doc: XMLDocument) -> CDAKRecord {
    let c32_patient = CDAKRecord()
    get_demographics(c32_patient, doc: doc)
    if let patient_role_element = doc.xpath("/cda:ClinicalDocument/cda:recordTarget/cda:patientRole").first {
      c32_patient.identifiers = get_ids(patient_role_element)
    }

    create_c32_hash(c32_patient, doc: doc)
    check_for_cause_of_death(c32_patient)

    c32_patient.provider_performances = CDAKImport_CDA_ProviderImporter.extract_providers(doc)
    
    return c32_patient
  }
  
  /**
   Checks the conditions to see if any of them have a cause of death set. If they do, it will set the expired field on the CDAKRecord. This is done here rather than replacing the expried method on CDAKRecord because other formats may actully tell you whether
   a patient is dead or not.
   
   - parameter c32_patient: to check the conditions on and set the expired property if applicable
   */
  func check_for_cause_of_death(c32_patient: CDAKRecord) {
    if let cause_of_death = c32_patient.conditions.filter({$0.cause_of_death == true}).first {
      c32_patient.expired = true
      c32_patient.deathdate = cause_of_death.time_of_death
    }
  }

  
  /**
   Create a simple representation of the patient from a HITSP C32

   - parameter record: Mongoid model to append the CDAKEntry objects to
   
   - parameter doc: It is expected that the root node of this document
   will have the "cda" namespace registered to "urn:hl7-org:v3"
   
   - returns:a representation of the patient with symbols as keys for each section
   
   Attention: Changed original Ruby
  */
  func create_c32_hash(record: CDAKRecord, doc: XMLDocument) {
    // original Ruby was using "send" - which we can't really do.  So I'm not doing that...
    // I'm going to inspect the section type and then just manually say "oh, you're a Condition" etc.
    // and set things that way.  Not super elegant, but - at least I'll know what's going on
    
    let nrh = CDAKImport_CDA_NarrativeReferenceHandler()
    nrh.build_id_map(doc)
    for (section, importer) in section_importers {
      let sections = importer.create_entries(doc, nrh: nrh)
      
      switch section {
      case "encounters": if let sections = sections as? [CDAKEncounter] { record.encounters = sections }
      case "procedures": if let sections = sections as? [CDAKProcedure] { record.procedures = sections }
      case "results": if let sections = sections as? [CDAKLabResult] { record.results = sections }
      case "vital_signs": if let sections = sections as? [CDAKVitalSign] { record.vital_signs = sections }
      case "medications": if let sections = sections as? [CDAKMedication] { record.medications = sections }
      case "conditions": if let sections = sections as? [CDAKCondition] { record.conditions = sections }
      case "social_history": if let sections = sections as? [CDAKSocialHistory] { record.social_history = sections }
      case "care_goals": if let sections = sections as? [CDAKEntry] { record.care_goals = sections } //these are CDAKEntry records
      case "medical_equipment": if let sections = sections as? [CDAKMedicalEquipment] { record.medical_equipment = sections }
      case "allergies": if let sections = sections as? [CDAKAllergy] { record.allergies = sections }
      case "immunizations": if let sections = sections as? [CDAKImmunization] { record.immunizations = sections }
      case "insurance_providers": if let sections = sections as? [CDAKInsuranceProvider] { record.insurance_providers = sections }
      default: break
      }

    }
  }
  
  func get_ids (elem: XMLElement) -> [CDAKCDAIdentifier] {
    return elem.xpath("./cda:id").map({id_entry in CDAKCDAIdentifier(root: id_entry["root"], extension_id: id_entry["extension"])})
  }

  
  /**
    Inspects a C32 document and populates the patient Hash with first name, last name, birth date, gender and the effectiveTime.

    - parameter patient:  A hash that is used to represent the patient
    - parameter doc: The C32 document parsed by Nokogiri
  */
  func get_demographics(patient: CDAKRecord, doc: XMLDocument) {
    let effective_date = doc.xpath("/cda:ClinicalDocument/cda:effectiveTime").first?["value"]
    patient.effective_time = CDAKHL7Helper.timestamp_to_integer(effective_date)
    
    guard let patient_role_element = doc.xpath("/cda:ClinicalDocument/cda:recordTarget/cda:patientRole").first else {
      return
    }
    guard let patient_element = patient_role_element.xpath("./cda:patient").first else {
      return
    }

    patient.prefix = patient_element.xpath("cda:name/cda:prefix").first?.stringValue
    patient.first = patient_element.xpath("cda:name/cda:given").first?.stringValue
    patient.last = patient_element.xpath("cda:name/cda:family").first?.stringValue
    patient.suffix = patient_element.xpath("cda:name/cda:suffix").first?.stringValue

    if let birthdate_in_hl7ts_node = patient_element.xpath("cda:birthTime").first, birthdate_in_hl7ts = birthdate_in_hl7ts_node["value"] {
      patient.birthdate = CDAKHL7Helper.timestamp_to_integer(birthdate_in_hl7ts)
    }

    if let gender_node = patient_element.xpath("cda:administrativeGenderCode").first {
      patient.gender = gender_node["code"]
    }
    if let id_node = patient_role_element.xpath("./cda:id").first {
      patient.medical_record_number = id_node["extension"]
    }

    //# parse race, ethnicity, and spoken language
    // NOTE: changing this from original CDAK Ruby to support multiple races, ethnicities, and languages
    for race_node in patient_element.xpath("cda:raceCode") {
      if let an_entry = CDAKImport_CDA_SectionImporter.extract_code(race_node, code_xpath: ".", code_system: "CDC Race") {
        patient.race.addCodes(an_entry)
      }
    }
    for ethnicity_node in patient_element.xpath("cda:ethnicGroupCode") {
      if let an_entry = CDAKImport_CDA_SectionImporter.extract_code(ethnicity_node, code_xpath: ".", code_system: "CDC Race") {
        patient.ethnicity.addCodes(an_entry)
      }
    }

    if let marital_status_node = patient_element.xpath("./cda:maritalStatusCode").first, code = marital_status_node["code"] {
      patient.marital_status = CDAKCodedEntries(codeSystem: "HL7 Marital Status", code: code)
    }
    if let ra_node = patient_element.xpath("./cda:religiousAffiliationCode").first, code = ra_node["code"] {
      patient.religious_affiliation = CDAKCodedEntries(codeSystem: "Religious Affiliation", code: code)
    }
    
    // USHIK info on language CDA https://ushik.ahrq.gov/ViewItemDetails?system=mdr&itemKey=83131002
    // Name Language Value Set -> http://www.ietf.org/rfc/rfc4646.txt
    for lc in patient_element.xpath("//cda:languageCommunication") {
      if let code = lc.xpath("cda:languageCode").first?["code"] {
        //NOTE - I'm making up the code system here... 
        // I'm also throwing in displayName
        let displayName = lc.xpath("cda:languageCode").first?["displayName"]
        let lang = CDAKCodedEntry(codeSystem: "RFC_4646", code: code, displayName: displayName)
        var entries = CDAKCodedEntries()
        entries.addCodes(lang)
        patient.languages.append(entries)
      }
    }


    patient.addresses = patient_role_element.xpath("./cda:addr").flatMap({addr in CDAKImport_CDA_LocatableImportUtils.import_address(addr)})
    patient.telecoms = patient_role_element.xpath("./cda:telecom").flatMap({telecom in CDAKImport_CDA_LocatableImportUtils.import_telecom(telecom)})
  }
  
}
