//
//  code_system_helper.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/17/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//# General helpers for working with codes and code system

public class CDAKCodeSystemHelper {
  
  static let CODE_SYSTEMS: [String:String] = [
    "2.16.840.1.113883.6.1" :    "LOINC",
    "2.16.840.1.113883.6.96" :   "SNOMED-CT",
    "2.16.840.1.113883.6.12" :   "CPT",
    //"2.16.840.1.113883.3.88.12.80.32" : "CPT", //# CDAKEncounter Type from C32, a subset of CPT
    "2.16.840.1.113883.6.88" :   "RxNorm",
    "2.16.840.1.113883.6.103" :  "ICD-9-CM",
    "2.16.840.1.113883.6.104" :  "ICD-9-PCS",
    "2.16.840.1.113883.6.4" :   "ICD-10-PCS",
    "2.16.840.1.113883.6.90" :   "ICD-10-CM",
    "2.16.840.1.113883.6.14" :   "HCP",
    "2.16.840.1.113883.6.285" :   "HCPCS",
    "2.16.840.1.113883.5.2" : "HL7 Marital Status",
    "2.16.840.1.113883.12.292" : "CVX",
    "2.16.840.1.113883.5.83" : "HITSP C80 Observation Status",
    "2.16.840.1.113883.3.26.1.1" : "NCI Thesaurus",
    "2.16.840.1.113883.3.88.12.80.20" : "FDA",
    "2.16.840.1.113883.4.9" : "UNII",
    "2.16.840.1.113883.6.69" : "NDC",
    "2.16.840.1.113883.5.14" : "HL7 ActStatus",
    "2.16.840.1.113883.6.259" : "HL7 Healthcare Service Location",
    "2.16.840.1.113883.12.112" : "DischargeDisposition",
    "2.16.840.1.113883.5.4" : "HL7 Act Code",
    "2.16.840.1.113883.1.11.18877" : "HL7 Relationship Code",
    "2.16.840.1.113883.6.238" : "CDC Race",
    "2.16.840.1.113883.6.177" : "NLM MeSH",
    "2.16.840.1.113883.5.1076" : "Religious Affiliation",
    "2.16.840.1.113883.1.11.19717" : "HL7 ActNoImmunicationReason",
    "2.16.840.1.113883.3.88.12.80.33" : "NUBC",
    "2.16.840.1.113883.1.11.78" : "HL7 Observation Interpretation",
    "2.16.840.1.113883.3.221.5" : "Source of Payment Typology",
    "2.16.840.1.113883.6.13" : "CDT",
    "2.16.840.1.113883.18.2" : "AdministrativeSex",
    "2.16.840.1.113883.5.112" : "HL7 RouteOfAdministration", //added - EWW
    "UNK" : "Unknown"//added - EWW
    
    //more ...
    // https://www.hl7.org/fhir/terminologies-v3.html
  ]
  
  public static let CODE_SYSTEM_ALIASES: [String:String] = [
    "FDA SPL" : "NCI Thesaurus",
    "HSLOC" : "HL7 Healthcare Service Location",
    "SOP" : "Source of Payment Typology"
  ]
  
  //# Some old OID are still around in data, this hash maps retired OID values to
  //# the new value
  public static let OID_ALIASES: [String:String] = [
    "2.16.840.1.113883.6.59" : "2.16.840.1.113883.12.292" //# CVX
  ]
  
  
  //# Returns the name of a code system given an oid
  //# @param [String] oid of a code system
  //# @return [String] the name of the code system as described in the measure definition JSON
  public class func code_system_for(var oid: String) -> String {
    if let an_alias = OID_ALIASES[oid] {
      oid = an_alias
    }
    if let a_value = CDAK_EXTENDED_CODE_SYSTEMS[oid] {
      return a_value
    }
    
    print("DID NOT FIND oid \(oid)")
    return "Unknown"
  }
  
  //# Returns the oid for a code system given a codesystem name
  //# @param [String] the name of the code system
  //# @return [String] the oid of the code system
  public class func oid_for_code_system(var code_system: String) -> String {
  
    if let an_alias = CODE_SYSTEM_ALIASES[code_system] {
      code_system = an_alias
    }
    let cs = CDAK_EXTENDED_CODE_SYSTEMS.inverse()
    if let sys = cs[code_system] {
      return sys
    }
    
    return "UNK" // unknown
    //CODE_SYSTEMS.invert[code_system]
		//swap value for key  
  }
  
  //# Returns the whole map of OIDs to code systems
  //# @terurn [Hash] oids as keys, code system names as values
  public class func code_systems() -> [String:String] {
    return CDAK_EXTENDED_CODE_SYSTEMS
  }
  
  
  public class func addCodeSystem(code_system: String, oid: String? = "UNK") {
    if let oid = oid {
      if let  _ = CDAK_EXTENDED_CODE_SYSTEMS[oid] {
      //we already have this code system
      return
      }
      let cs = CDAK_EXTENDED_CODE_SYSTEMS.inverse()
      if let existing_oid = cs[code_system] {
        // do a reverse look-up for this code_system
        // we already have someting in the set - don't re-add the value for a different key
        // this can happen for things like bogus entries
        // EX: we have     "2.16.840.1.113883.12.292" : "CVX",
        // then an improperly configured CCD attempts to send in "CVX", "CVX"  (invalid OID)
        // shouldn't happen, but it does
        return
      } else {
        // we don't have this code system, so add it - "Unknown" is OK
        CDAK_EXTENDED_CODE_SYSTEMS[oid] = code_system
      }
    }
  }

  
}