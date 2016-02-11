//
//  ccda_patient_importer.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class HDSImport_CCDA_PatientImporter: HDSImport_C32_PatientImporter {

  override init(check_usable: Bool = true) {

    super.init(check_usable: check_usable) //NOTE: original Ruby does NOT call super
    
    section_importers["encounters"] = HDSImport_CCDA_EncounterImporter()
    section_importers["procedures"] = HDSImport_CCDA_ProcedureImporter()
    section_importers["results"] = HDSImport_CCDA_ResultImporter()
    section_importers["vital_signs"] = HDSImport_CCDA_VitalSignImporter()
    section_importers["medications"] = HDSImport_CCDA_MedicationImporter()
    section_importers["conditions"] = HDSImport_CCDA_ConditionImporter()
    section_importers["social_history"] = HDSImport_CDA_SectionImporter(entry_finder: HDSImport_CDA_EntryFinder(entry_xpath: "//cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.38' or cda:templateId/@root='2.16.840.1.113883.10.20.15.3.8']"))
    section_importers["care_goals"] = HDSImport_CCDA_CareGoalImporter()
    section_importers["medical_equipment"] = HDSImport_CCDA_MedicalEquipmentImporter()
    section_importers["allergies"] = HDSImport_CCDA_AllergyImporter()
    section_importers["immunizations"] = HDSImport_CCDA_ImmunizationImporter()
    section_importers["insurance_providers"] = HDSImport_CCDA_InsuranceProviderImporter()
  }
  
  
  func parse_ccda(doc: XMLDocument) -> HDSRecord {
    return parse_c32(doc)
  }

}