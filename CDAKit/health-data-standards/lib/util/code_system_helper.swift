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
    "FDA SPL" : "NCI Thesaurus", //Structured Product Labeling?
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
    if let a_value = CDAKGlobals.sharedInstance.CDAK_EXTENDED_CODE_SYSTEMS[oid] {
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
    let cs = CDAKGlobals.sharedInstance.CDAK_EXTENDED_CODE_SYSTEMS.inverse()
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
    return CDAKGlobals.sharedInstance.CDAK_EXTENDED_CODE_SYSTEMS
  }
  
  
  public class func addCodeSystem(code_system: String, oid: String? = "UNK") {
    if let oid = oid {
      if let  _ = CDAKGlobals.sharedInstance.CDAK_EXTENDED_CODE_SYSTEMS[oid] {
      //we already have this code system
      return
      }
      let cs = CDAKGlobals.sharedInstance.CDAK_EXTENDED_CODE_SYSTEMS.inverse()
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
        CDAKGlobals.sharedInstance.CDAK_EXTENDED_CODE_SYSTEMS[oid] = code_system
      }
    }
  }

}


/**
 Contains commonly referenced keys you may use in value sets
 
 These keys are used to look up specific HL7 OIDs, so it's important they be used consistently
*/
public struct CDAKVocabularyKeys {
  /// Logical Observation Identifiers Names and Codes. Created and managed by the Regenstrief Institute, Inc.
  public static let LOINC = "LOINC"
  /// SNOMED-CT, Systematized Nomenclature of Clinical Terms. Created by the College of American Pathologists (CAP) and now managed by the International Health Terminology Standards Development Organisation  (IHTSDO)
  public static let SNOMEDCT = "SNOMED-CT"
  /// Current Procedural Terminology
  public static let CPT = "CPT"
  /// RxNorm. Medications (brand and generic), ingredients, packaging, and more. Managed by the National Library of Medicine (NLM)
  public static let RxNorm = "RxNorm"
  /// ICD-9-CM. International Classification of Diseases, Ninth Revision, Clinical Modification
  public static let ICD9CM = "ICD-9-CM"
  /// ICD-9-PCS. International Classification of Diseases, Ninth Revision, Procedure Coding System
  public static let ICD9PCS = "ICD-9-PCS"
  /// ICD-10-PCS. International Classification of Diseases, Tenth Revision, Procedure Coding System
  public static let ICD10PCS = "ICD-10-PCS"
  /// ICD-10-CM. International Classification of Diseases, Tenth Revision, Clinical Modification
  public static let ICD10CM = "ICD-10-CM"
  /// HCP. HCFA Common Procedure Coding System
  public static let HCP = "HCP"
  /// HCPCS. Healthcare Common Procedure Coding System
  public static let HCPCS = "HCPCS"
  /// HL7 Marital Status
  public static let HL7MaritalStatus = "HL7 Marital Status"
  /// CVX. Vaccine administered
  public static let CVX = "CVX"
  /// HITSP C80 Observation Status
  public static let HITSPC80ObservationStatus = "HITSP C80 Observation Status"
  /// NCI Thesaurus
  public static let NCIThesaurus = "NCI Thesaurus"
  /// FDA. Concepts specific to the US Food and Drug Administration.
  public static let FDA = "FDA"
  /// UNII. Unique Ingredient Identifier. Unique identifiers for active drug ingredient. Managed by the US Food and Drug Administration (FDA).
  public static let UNII = "UNII"
  /// NDC. National Drug Codes.
  public static let NDC = "NDC"
  /// HL7 ActStatus
  public static let HL7ActStatus = "HL7 ActStatus"
  /// HL7 Healthcare Service Location
  public static let HL7HealthcareServiceLocation = "HL7 Healthcare Service Location"
  /// HL7 Discharge Disposition
  public static let DischargeDisposition = "DischargeDisposition"
  /// HL7 Act Code
  public static let HL7ActCode = "HL7 Act Code"
  /// HL7 Relationship Code
  public static let HL7RelationshipCode = "HL7 Relationship Code"
  /// CDC Race
  public static let CDCRace = "CDC Race"
  /// NLM MeSH
  public static let NLMMeSH = "NLM MeSH"
  /// Religious Affiliation
  public static let ReligiousAffiliation = "Religious Affiliation"
  /// HL7 No Immunization Reason Value Set. This identifies the reason why the immunization did not occur.
  public static let HL7ActNoImmunicationReason = "HL7 ActNoImmunicationReason"
  /// NUBC. National Uniform Billing Committee (NUBC)
  public static let NUBC = "NUBC"
  /// HL7 Observation Interpretation
  public static let HL7ObservationInterpretation = "HL7 Observation Interpretation"
  /// Source of Payment Typology
  public static let SourceofPaymentTypology = "Source of Payment Typology"
  /// CDT. American Dental Association's Current Dental Terminology 2 (CDT-2)
  public static let CDT = "CDT"
  /// HL7 Administrative Sex
  public static let AdministrativeSex = "AdministrativeSex"
  /// HL7 RouteOfAdministration
  public static let HL7RouteOfAdministration = "HL7 RouteOfAdministration"
  // FDA SPL. Alias for NCIThesaurus
  //public static let NCIThesaurus = "FDA SPL"
  //NOTE: not including FDA SPL - the original Ruby says this is an alias of NCI Thesaurus
  // HSLOC. Alias for HL7HealthcareServiceLocation
  //public static let HL7HealthcareServiceLocation = "HSLOC"
  //NOTE: duplicate from code_system_helper aliases - may need to determine if one version is preferred
  /// SOP. Source Of Payment Typology
  public static let SourceOfPaymentTypology = "SOP"
}

/**
Provides lists of fixed string constants you may wish to use for a specific type of CDA attribute
*/
public struct CDAKConceptHelpers {
  
  /**
   HL7 Address Use codes
   [Reference](https://www.hl7.org/fhir/v3/AddressUse/index.html)
  */
  public struct HL7AddressUse {
    /// bad address - Description: A flag indicating that the address is bad, in fact, useless.
    public static let BAD = "BAD"
    /// confidential address - Description: Indicates that the address is considered sensitive and should only be shared or published in accordance with organizational controls governing patient demographic information with increased sensitivity. Uses of Addresses. Lloyd to supply more complete description.
    public static let CONF = "CONF"
    /// home address - Description: A communication address at a home, attempted contacts for business purposes might intrude privacy and chances are one will contact family or other household members instead of the person one wishes to call. Typically used with urgent cases, or if no other contacts are available.
    public static let H = "H"
    /// primary home - Description: The primary home, to reach a person after business hours.
    public static let HP = "HP"
    /// vacation home - Description: A vacation home, to reach a person while on vacation.
    public static let HV = "HV"
    /// temporary address - Description: A temporary address, may be good for visit or mailing. Note that an address history can provide more detailed information.
    public static let TMP = "TMP"
    /// work place - Description: An office address. First choice for business related contacts during business hours.
    public static let WP = "WP"
    /// direct - Description: Indicates a work place address or telecommunication address that reaches the individual or organization directly without intermediaries. For phones, often referred to as a 'private line'.
    public static let DIR = "DIR"
    /// public - Description: Indicates a work place address or telecommunication address that is a 'standard' address which may reach a reception service, mail-room, or other intermediary prior to the target entity.
    public static let PUB = "PUB"
    /// _PostalAddressUse - Description: Address uses that only apply to postal addresses, not telecommunication addresses.
    public static let _PostalAddressUse = "_PostalAddressUse"
    /// physical visit address - Description: Used primarily to visit an address.
    public static let PHYS = "PHYS"
    /// postal address - Description: Used to send mail.
    public static let PST = "PST"
    /// _TelecommunicationAddressUse - Description: Address uses that only apply to telecommunication addresses, not postal addresses.
    public static let _TelecommunicationAddressUse = "_TelecommunicationAddressUse"
    /// answering service - Description: An automated answering machine used for less urgent cases and if the main purpose of contact is to leave a message or access an automated announcement.
    public static let AS = "AS"
    /// emergency contact - Description: A contact specifically designated to be used for emergencies. This is the first choice in emergencies, independent of any other use codes.
    public static let EC = "EC"
    /// mobile contact) - Description: A telecommunication device that moves and stays with its owner. May have characteristics of all other use codes, suitable for urgent matters, not the first choice for routine business.
    public static let MC = "MC"
    /// pager - Description: A paging device suitable to solicit a callback or to leave a very short message.
    public static let PG = "PG"
  }
  /**
   HL7 Priority Codes
   Often used with CDA priority code
   [Reference](http://www.cdapro.com/know/25039)
   */
  public struct HL7PriorityCode {
    /// ASAP -
    public static let A = "A"
    /// Callback results -
    public static let CR = "CR"
    /// Callback for scheduling -
    public static let CS = "CS"
    /// Callback placer for scheduling -
    public static let CSP = "CSP"
    /// Contact recipient for scheduling -
    public static let CSR = "CSR"
    /// Elective -
    public static let EL = "EL"
    /// Emergency -
    public static let EM = "EM"
    /// Preoperative -
    public static let P = "P"
    /// As needed -
    public static let PRN = "PRN"
    /// Routine -
    public static let R = "R"
    /// Rush reporting -
    public static let RR = "RR"
    /// Stat -
    public static let S = "S"
    /// Timing critical -
    public static let T = "T"
    /// Use as directed - 
    public static let UD = "UD"
    /// Urgent - 
    public static let UR = "UR"
  }
  /**
   From CDAPro: "qualifies the timing and intent of the clinical act."
   [Reference](http://www.cdapro.com/know/25027)
   */
  public struct HL7MoodCode {
    /// The clinical statement/event already happened -
    public static let EVN = "EVN"
    /// The clinical statement is intended to happen in the future -
    public static let INT = "INT"
    /// The clinical statement is a request or order -
    public static let RQO = "RQO"
    /// The clinical statement is planned for a specific time/place (appointment) -
    public static let APT = "APT"
    /// The clinical statement is a request to book an appointment -
    public static let ARQ = "ARQ"
    /// The clinical statement is being proposed -
    public static let PRP = "PRP"
    /// The clinical statement is promised -
    public static let PRMS = "PRMS"
    /// The clinical statement is a definition/observation -
    public static let DEF = "DEF"
    /// The clinical statement is a goal/objective -
    public static let GOL = "GOL"
    /// The clinical statement is a pre-condition/criteria -
    public static let EVNCRT = "EVN.CRT"
  }
}





