//
//  record1.swift
//  CDAKit
//
//  Created by Jim on 10/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache


extension CDAKRecord {

    // MARK: - Mustache marshalling
    override open var mustacheBox: MustacheBox {

        //var vals: [String:MustacheBox] = [:] // [String:MustacheBox]()
        var defaultLanguage: CDAKCodedEntries = CDAKCodedEntries()
        defaultLanguage.addCodes("IETF", code: "en-US")
        let defaultLanguages: [CDAKCodedEntries] = [defaultLanguage]

        var vals: [String:MustacheBox] = [
            "id": Box(self._id),
            "prefix": Box(self.prefix),
            "first": Box(self.first),
            "last": Box(self.last),
            "suffix": Box(self.suffix),
            "gender": Box(self.gender),
            "birthdate": Box(self.birthdate),
            "deathdate": Box(self.deathdate),
            "religious_affiliation": Box(self.religious_affiliation),
            "effective_time": Box(self.effective_time),
            "race": Box(self.race),
            "ethnicity": Box(self.ethnicity),
            "languages": self.languages.count > 0 ? Box(self.languages) : Box(defaultLanguages),
            "marital_status": Box(self.marital_status),
            "medical_record_number": Box(self.medical_record_number),
            "medical_record_assigner": Box(self.medical_record_assigner),
            "expired": Box(self.expired),
            "addresses": Box(self.addresses),
            "telecoms": Box(self.telecoms)
        ]

        if identifiers.count > 0 {
            vals["identifiers"] = Box(self.identifiers)
        }


        // we can't pass locals into mustache like we can with erb, so we're cheating
        //  when we marshall the data, we're setting up template block values here instead
        //  you can use template values from here
        /*
         key, section, entries, status, value
         */
        if let entries = boxEntries(allergies, section: "allergies") {
            vals["allergies"] = entries
        }
        if let entries = boxEntries(results, section: "results", value: true) {
            vals["results"] = entries
        }
        if let entries = boxEntries(medications, section: "medications") {
            vals["medications"] = entries
        }
        if let entries = boxEntries(care_goals, section: "plan_of_care") {
            vals["care_goals"] = entries
        }
        if let entries = boxEntries(conditions, section: "conditions", status: true) {
            vals["conditions"] = entries
        }
        if let entries = boxEntries(social_history, section: "social_history") {
            vals["social_history"] = entries
        }
        if let entries = boxEntries(immunizations, section: "immunizations") {
            vals["immunizations"] = entries
        }
        if let entries = boxEntries(medical_equipment, section: "medical_equipment") {
            vals["medical_equipment"] = entries
        }
        if let entries = boxEntries(encounters, section: "encounters") {
            vals["encounters"] = entries
        }
        if let entries = boxEntries(procedures, section: "procedures") {
            vals["procedures"] = entries
        }
        if let entries = boxEntries(vital_signs, section: "vitals", value: true) {
            vals["vital_signs"] = entries
        }

        if let header = header {
            vals["header"] = Box(header)
        }

        if provider_performances.count > 0 {
            vals["provider_performances"] = Box(provider_performances)
        }


        return Box(vals)
    }

    func boxEntries(_ entries: [CDAKEntry], section: String, status: Bool = false, value: Bool = false) -> MustacheBox? {

        if entries.count > 0 {
            
            let toBox = [
                "section" : Box(section),
                "status" : Box(status),
                "value" : Box(value),
                "entries": Box(entries)
            ]

            return Box(toBox)
        }

        return nil
    }

}



