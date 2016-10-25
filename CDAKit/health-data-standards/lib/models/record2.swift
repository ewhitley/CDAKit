//
//  record2.swift
//  CDAKit
//
//  Created by Jim on 10/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation


extension CDAKRecord {
    //MARK: Primary CDA import / export Methods
    /**
     Master public convenience method for exporting record to CDA

     Formats defined in: CDAKExport.CDAKExportFormat

     EX: .ccda or .c32

     */
    public func export(inFormat format: CDAKExport.CDAKExportFormat) -> String {
        return CDAKExport.export(patientRecord: self, inFormat: format)
    }

    /**
     Creates a new record from CDA XML
     */
    public convenience init(fromXML doc: String) throws   {
        let x = try CDAKImport_BulkRecordImporter.importRecord(doc)
        self.init(copyFrom: x)
    }

    //MARK: Convenience copying
    public convenience init(copyFrom record: CDAKRecord) {
        self.init()

        self.prefix = record.prefix
        self.first = record.first
        self.last = record.last
        self.suffix = record.suffix
        self.gender = record.gender
        self.birthdate = record.birthdate
        self.deathdate = record.deathdate
        self.religious_affiliation = record.religious_affiliation
        self.effective_time = record.effective_time
        self.race = record.race
        self.ethnicity = record.ethnicity
        self.languages = record.languages
        self.marital_status = record.marital_status
        self.medical_record_number = record.medical_record_number
        self.medical_record_assigner = record.medical_record_assigner
        self.expired = record.expired
        self.allergies = record.allergies
        self.care_goals = record.care_goals
        self.conditions = record.conditions
        self.encounters = record.encounters
        self.communications = record.communications
        self.family_history = record.family_history
        self.immunizations = record.immunizations
        self.medical_equipment = record.medical_equipment
        self.medications = record.medications
        self.procedures = record.procedures
        self.results = record.results
        self.socialhistories = record.socialhistories
        self.vital_signs = record.vital_signs
        self.support = record.support
        self.advance_directives = record.advance_directives
        self.insurance_providers = record.insurance_providers
        self.functional_statuses = record.functional_statuses
        self.provider_performances = record.provider_performances
        self.addresses = record.addresses
        self.telecoms = record.telecoms
        self.identifiers = record.identifiers
        self.custodian = record.custodian
        self.clinicalTrialParticipant = record.clinicalTrialParticipant
    }
    
    
}
