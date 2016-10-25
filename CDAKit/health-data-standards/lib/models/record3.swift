//
//  record3.swift
//  CDAKit
//
//  Created by Jim on 10/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

extension CDAKRecord: CDAKJSONExportable {
    // MARK: - JSON Generation
    ///Dictionary for JSON data

    //public var jsonDict: [String: AnyObject] = [:]


    public var jsonDict: [String: AnyObject] {
        var dict: [String: AnyObject] = [:]

        if identifiers.count > 0 {
            dict["identifiers"] = identifiers.map({$0.jsonDict}) as AnyObject?
        }

        if let prefix = prefix {
            dict["prefix"] = prefix as AnyObject?
        }
        if let first = first {
            dict["first"] = first as AnyObject?
        }
        if let last = last {
            dict["last"] = last as AnyObject?
        }
        if let suffix = suffix {
            dict["suffix"] = suffix as AnyObject?
        }
        if let gender = gender {
            dict["gender"] = gender as AnyObject?
        }
        if let birthdate = birthdate {
            dict["birthdate"] = birthdate as AnyObject?
        }
        if let deathdate = deathdate {
            dict["deathdate"] = deathdate as AnyObject?
        }

        if religious_affiliation.count > 0 {
            dict["religious_affiliation"] = religious_affiliation.codes.map({$0.jsonDict}) as AnyObject?
        }

        if let effective_time = effective_time {
            dict["effective_time"] = effective_time as AnyObject?
        }

        dict["id"] = _id as AnyObject?

        if let header = header {
            dict["header"] = header.jsonDict as AnyObject?
        }

        if pregnancies.count > 0 {
            dict["pregnancies"] = pregnancies.map({$0.jsonDict}) as AnyObject?
        }
        if race.count > 0 {
            dict["race"] = race.codes.map({$0.jsonDict}) as AnyObject?
        }
        if ethnicity.count > 0 {
            dict["ethnicity"] = ethnicity.codes.map({$0.jsonDict}) as AnyObject?
        }

        if languages.count > 0 {
            dict["languages"] = languages.map({$0.jsonDict}) as AnyObject?
        }

        if marital_status.count > 0 {
            dict["marital_status"] = marital_status.codes.map({$0.jsonDict}) as AnyObject?
        }

        if let medical_record_number = medical_record_number {
            dict["medical_record_number"] = medical_record_number as AnyObject?
        }

        if let medical_record_assigner = medical_record_assigner {
            dict["medical_record_assigner"] = medical_record_assigner as AnyObject?
        }

        if let expired = expired {
            dict["expired"] = expired as AnyObject?
        }

        if let clinicalTrialParticipant = clinicalTrialParticipant {
            dict["clinicalTrialParticipant"] = clinicalTrialParticipant as AnyObject?
        }

        if let custodian = custodian {
            dict["custodian"] = custodian as AnyObject?
        }

        if allergies.count > 0 { dict["allergies"] = allergies.map({$0.jsonDict}) as AnyObject? }
        if care_goals.count > 0 { dict["care_goals"] = care_goals.map({$0.jsonDict})  as AnyObject?}
        if conditions.count > 0 { dict["conditions"] = conditions.map({$0.jsonDict}) as AnyObject? }
        if encounters.count > 0 { dict["encounters"] = encounters.map({$0.jsonDict}) as AnyObject? }
        if communications.count > 0 { dict["communications"] = communications.map({$0.jsonDict}) as AnyObject? }
        if family_history.count > 0 { dict["family_history"] = family_history.map({$0.jsonDict}) as AnyObject? }
        if immunizations.count > 0 { dict["immunizations"] = immunizations.map({$0.jsonDict}) as AnyObject? }
        if medical_equipment.count > 0 { dict["medical_equipment"] = medical_equipment.map({$0.jsonDict})  as AnyObject?}
        if medications.count > 0 { dict["medications"] = medications.map({$0.jsonDict}) as AnyObject? }
        if procedures.count > 0 { dict["procedures"] = procedures.map({$0.jsonDict}) as AnyObject? }
        if results.count > 0 { dict["results"] = results.map({$0.jsonDict}) as AnyObject? }
        if social_history.count > 0 { dict["social_history"] = social_history.map({$0.jsonDict}) as AnyObject? }
        if vital_signs.count > 0 { dict["vital_signs"] = vital_signs.map({$0.jsonDict}) as AnyObject? }
        if support.count > 0 { dict["support"] = support.map({$0.jsonDict}) as AnyObject? }
        if advance_directives.count > 0 { dict["advance_directives"] = advance_directives.map({$0.jsonDict}) as AnyObject? }
        if insurance_providers.count > 0 { dict["insurance_providers"] = insurance_providers.map({$0.jsonDict})  as AnyObject?}
        if functional_statuses.count > 0 { dict["functional_statuses"] = functional_statuses.map({$0.jsonDict})  as AnyObject?}
        if provider_performances.count > 0 { dict["provider_performances"] = provider_performances.map({$0.jsonDict})  as AnyObject?}
        if addresses.count > 0 { dict["addresses"] = addresses.map({$0.jsonDict}) as AnyObject? }
        if telecoms.count > 0 { dict["telecoms"] = telecoms.map({$0.jsonDict})  as AnyObject?}
        
        
        return dict
    }
}
