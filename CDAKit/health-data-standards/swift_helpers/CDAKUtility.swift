//
//  CDAKUtility.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/10/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation


/**
Warning - This class is due for removal.  DO NOT USE.
 
 This is used for internal testing to mimic certain sections of the original Ruby.
 
 Yes.  The code is foul.  Don't look at it or you might burn your eyes.
*/

 ///Do not use - will be removed. Was used in HDS Ruby.
internal protocol CDAKPropertyAddressable {
  // MARK: - Deprecated - Do not use
  init(event: [String:Any?])
}

class CDAKUtility {
  
  static let DEBUG = true
  static let entry_fields: [String] = [
    "item_description",
    "description",
    "specifics",
    "status",
    "time",
    "end_time",
    "start_time",
    "negationInd",
    "oid",
    "id",
    "codes"
  ]
  
  class func intValue(_ value: Any?) -> Int? {
    if let value = value as? Int { return value }
    else if let value = value as? Int? { return value }
    else if let value = value as? String { return Int(value) }
    else if let value = value as? String?, let u_value = value { return Int(u_value) }
    return nil
  }

  class func doubleValue(_ value: Any?) -> Double? {
    if let value = value as? Double { return value }
    else if let value = value as? Double? { return value }
    else if let value = value as? String { return Double(value) }
    else if let value = value as? String?, let u_value = value { return Double(u_value) }
    return nil
  }
  
  class func stringValue(_ value: Any?) -> String? {
    var a_value: String?
    if let value = value as? String { a_value = value }
    else if let value = value as? String? { a_value = value }
    else if let value = value { a_value = String(describing: value) }
    if let a_value = a_value {
      if a_value != "<null>" { return a_value }
    }
    return nil
  }

  class func boolValue(_ value: Any?) -> Bool? {
    if let value = value as? Bool { return value }
    else if let value = value as? Bool? { return value }
    return nil
  }
  
  //apparently some of the data can have a "flat" setup ala...
  // race { codeSystem: CDC, code: 12345 } 
  //    BUT the code system might not be supplied
  // race {code: 12345 }
  // so we need to account for a flattened setup and the possibility of an absent code system
  class func singleCodeFieldFlat(_ value: Any?, withDefaultCodeSystem defaultCodeSystem: String? = nil) -> CDAKCodedEntries {
    var result: CDAKCodedEntries = CDAKCodedEntries()
    //print(value)
    print("singleCodeFieldFlat:value = \(value)")
    if let value = value as? [String:Any?] {
      if let val = value["code"] {
        if let val = val { //still optional
          let code = String(describing: val) //since we can have integers, etc. in here
          if code != "<null>" { //filter out the weird "<null>" we see in CDAK entries
          var codeSystem: String?
            if let val = value["codeSystem"] as? String {
              codeSystem = val
            } else if let val = value["code_set"] as? String {
              codeSystem = val
            } else {
              codeSystem = defaultCodeSystem
            }
            if let codeSystem = codeSystem {
              result.addCodes(codeSystem, code: code)
              //result[codeSystem] = [code]
            }
          }
        }
      }
      //no sense in continuing without a code
    }
    return result
  }

  
  //"codes" : ["CPT" : ["1234"]]
  //I feel so very very dirty.  And yes - I realize how bad this code is.
  class func dictionaryStringArray(_ value: Any?, withDefaultCodeSystem defaultCodeSystem: String? = nil) -> CDAKCodedEntries {
    var result: CDAKCodedEntries = CDAKCodedEntries()
    print("dictionaryStringArray:value = \(value)")
    if let value = value as? CDAKCodedEntries { return value }
//    else if let value = value as? [String:Any] {
//      print("dictionaryStringArray:value = \(value) WITH TYPE [String:Any]")
//    }
//    else if let value = value as? [String:[Any]] {
//      print("dictionaryStringArray:value = \(value) WITH TYPE [String:[Any]]")
//    }
//    else if let value = value as? [String:[String]] {
//      print("dictionaryStringArray:value = \(value) WITH TYPE [String:[String]]")
//    }
//    else if let value = value as? [String:String] {
//      print("dictionaryStringArray:value = \(value) WITH TYPE [String:String]")
//    }
    else if let value = value as? [String:[String]] {
      for (key, value) in value {
        for code in value {
          if code != "<null>" {
            result.addCodes(key, code: code)
          }
        }
      }
    }
    else if let value = value as? [String:Any?] {
      for (key, value) in value {
        if let value = value {
          //print(value)
          if let values = value as? [Any?] {
            for code in values {
              if let code = code as? String , code != "<null>" {
                result.addCodes(key, code: code)
              }
            }
            //result[key] = values.filter({$0 != nil}).map({String($0)}).filter({$0 != "<null>"})
          } else if let values = value as? [Any] {
            //result.addCodes(key, codes: values.map({String($0)}).filter({$0 != "<null>"}))
            for code in values {
              if let code = code as? String , code != "<null>" {
                result.addCodes(key, code: code)
              }
            }
            //result[key] = values.map({String($0)}).filter({$0 != "<null>"})
          }
        }
      }
    }
    //ok - we might have one of those "codeSystem: (value), code: (value)" entries
    if result.count == 0 {
      result = singleCodeFieldFlat(value, withDefaultCodeSystem: defaultCodeSystem)
    }
    return result
  }
  
  class func arrayOfCodedEntries(_ value: Any?) -> [CDAKCodedEntries] {
    var result: [CDAKCodedEntries] = []
    //print(value)

    if let value = value as? [Any] {
      for value in value {
        if let value = value as? [String:Any?], let codes = value["codes"] {
          let a_value = dictionaryStringArray(codes)
          if a_value.count > 0 {
            result.append(a_value)
          }
        }
      }
    }
    
    return result
  }

  
  class func dictionaryAny(_ value: Any?) -> [String:Any?] {
    let result: [String:Any?] = [:]
    //print(value)
    if let value = value as? [String:Any?] {
      //print(value)
      return value
    }
    return result
  }

  
  class func debug_message(_ object: String, function: String, property: String) {
    if CDAKUtility.DEBUG {
      if !CDAKUtility.entry_fields.contains(property) { print("\(function) for \(object) failed to return '\(property)' ") }
    }
  }
  
  class func getProperty(_ obj: Any?, property: String) -> Any? {

    
    if let obj = obj as? CDAKEntry {
      switch property {
      case "item_description", "description": return obj.item_description
      case "specifics": return obj.specifics
      case "status":  return obj.status
      case "time": return obj.time
      case "end_time": return obj.end_time
      case "start_time": return obj.start_time
      case "negationInd", "negation_ind": return obj.negation_ind
      case "negationReason", "negation_reason": return obj.negation_reason
      case "oid": return obj.oid
      case "id": return obj.id
      case "codes": return obj.codes
      default: print("getProperty for CDAKEntry failed to return '\(property)' ")
      }
    }
    
    if let obj = obj as? CDAKEncounter {
      switch property {
      case "admit_time", "admitTime": return obj.admit_time
      case "discharge_time", "dischargeTime": return obj.discharge_time
      default: debug_message("CDAKEncounter", function: "getProperty", property: property)
      }
    } else if let obj = obj as? CDAKCondition {
      switch property {
      case "time_of_death": return obj.time_of_death
      default: debug_message("CDAKCondition", function: "getProperty", property: property)
      }
      //shouldn't need this since we're now making CDAKFacility an CDAKEntry
//    } else if let obj = obj as? CDAKFacility {
//      switch property {
//      case "start_time": return obj.start_time
//      case "end_time": return obj.end_time
//      default: debug_message("CDAKFacility", function: "getProperty", property: property)
//      }
    } else if let obj = obj as? CDAKFulfillmentHistory {
      switch property {
      case "dispense_date": return obj.dispense_date
      default: debug_message("CDAKFulfillmentHistory", function: "getProperty", property: property)
      }
    } else if let obj = obj as? CDAKFunctionalStatus {
      switch property {
      case "type": return obj.type
      default: debug_message("CDAKFunctionalStatus", function: "getProperty", property: property)
      }
      //shouldn't need this since we're now making CDAKGuarantor an CDAKEntry
//    } else if let obj = obj as? CDAKGuarantor {
//      switch property {
//      case "end_time": return obj.end_time
//      case "start_time": return obj.start_time
//      case "time": return obj.time
//      default: debug_message("CDAKGuarantor", function: "getProperty", property: property)
//      }
    } else if let obj = obj as? CDAKMedicalEquipment {
      switch property {
      case "removal_time": return obj.removal_time
      default: debug_message("CDAKMedicalEquipment", function: "getProperty", property: property)
      }
    } else if let obj = obj as? CDAKMedication {
      switch property {
      case "active_datetime": return obj.active_datetime
      case "signed_datetime": return obj.signed_datetime
      default: debug_message("CDAKMedication", function: "getProperty", property: property)
      }
    } else if let obj = obj as? CDAKOrderInformation {
      switch property {
      case "order_date_time", "orderDateTime": return obj.order_date_time
      case "order_expiration_date_time", "orderExpirationDateTime": return obj.order_expiration_date_time
      default: debug_message("CDAKOrderInformation", function: "getProperty", property: property)
      }
    } else if let obj = obj as? CDAKProcedure {
      switch property {
      case "incision_time": return obj.incision_time
      default: debug_message("CDAKProcedure", function: "getProperty", property: property)
      }
    } else if let obj = obj as? CDAKProviderPerformance {
      switch property {
      case "end_date": return obj.end_date
      case "start_date": return obj.start_date
      default: debug_message("CDAKProviderPerformance", function: "getProperty", property: property)
      }
    } else if let obj = obj as? CDAKFulfillmentHistory {
      switch property {
      case "dispense_date": return obj.dispense_date
      default: debug_message("CDAKFulfillmentHistory", function: "getProperty", property: property)
      }
    } else if let obj = obj as? CDAKRecord {
      switch property {
      case "birthdate": return obj.birthdate
      case "deathdate": return obj.deathdate
      default: debug_message("CDAKRecord", function: "getProperty", property: property)
      }
    }
    
    return nil
  }
  
  class func setProperty(_ obj: Any?, property: String, value: Any?) {
    
    if let obj = obj as? CDAKEntry {
      switch property {
      case "item_description", "description": obj.item_description = stringValue(value)
      case "specifics": obj.specifics = stringValue(value)
      case "status":  obj.status = stringValue(value)
      case "time": obj.time = doubleValue(value)
      case "end_time", "high", "hi": obj.end_time = doubleValue(value)
      case "start_time", "low": obj.start_time = doubleValue(value)
      case "negationInd", "negation_ind": obj.negation_ind = boolValue(value)
      case "negationReason", "negation_reason": obj.negation_reason = singleCodeFieldFlat(value) //I think we changed this...
        
      case "oid":  obj.oid = stringValue(value)
      case "id", "_id":  obj.id = stringValue(value)
      case "codes", "code": obj.codes = dictionaryStringArray(value)
      case "status_code", "problemStatus": obj.status_code = dictionaryStringArray(value)
      case "patient_preference" : obj.patient_preference = createArrayOfEntries(CDAKEntry.self, withValues: value)
      case "references" : obj.references = createArrayOfEntries(CDAKReference.self, withValues: value)
      case "provider_preference" : obj.provider_preference = createArrayOfEntries(CDAKEntry.self, withValues: value)
      case "comment":  obj.comment = stringValue(value)
        
      case "reason": obj.reason = CDAKReason(event: dictionaryAny(value))
        
      case "values":
        if let values = value as? [Any] {
          for value in values {
            if let event = value as? [String:Any?] {
              var units: String?
              if let a_unit = event["units"] {
                units = stringValue(a_unit)
              }
              var scalar: String?
              if let a_scalar = event["scalar"], let another_scalar = stringValue(a_scalar) {
                //I know, I know - we're cleaning up weirdness in CDAK with "null"
                scalar = another_scalar
              }
              obj.set_value(scalar, units: units)
            }
          }
        }
        
      default: print("setProperty for CDAKEntry failed to find '\(property)' ")
      }
    }
    
    if let obj = obj as? CDAKEncounter {
      switch property {
      case "admit_time", "admitTime": obj.admit_time = doubleValue(value)
      case "discharge_time", "dischargeTime": obj.discharge_time = doubleValue(value)
      //FIX_ME: - apparently the Mongo JSON just uses a single string like "Home" ?
        // look at "dischargeDisp"
      case "discharge_disposition", "dischargeDisposition", "dischargeDisp": obj.discharge_disposition = dictionaryStringArray(value)
      case "admit_type", "admitType": obj.admit_type = dictionaryStringArray(value)
      case "facility": obj.facility = CDAKFacility(event: dictionaryAny(value))
      case "performer": obj.performer = CDAKProvider(event: dictionaryAny(value))
      default: debug_message("CDAKEncounter", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKAllergy {
      switch property {
     // case "reaction": obj.reaction = singleCodeFieldFlat(value)
     // case "severity": obj.severity = singleCodeFieldFlat(value)
      default: debug_message("CDAKAllergy", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKCondition {
      switch property {
      case "time_of_death": obj.time_of_death = doubleValue(value)
      case "severity": obj.severity = dictionaryStringArray(value)

        //NOT ordinatlity - apparently that's a string in the source?
      case "ordinality_code": obj.ordinality = dictionaryStringArray(value)
      case "laterality": obj.laterality = dictionaryStringArray(value)
      case "anatomical_target": obj.anatomical_target = dictionaryStringArray(value)
      case "anatomical_location": obj.anatomical_location = dictionaryStringArray(value)

      case "priority": obj.priority = intValue(value)
      case "cause_of_death": obj.cause_of_death = boolValue(value)
      case "type": obj.type = stringValue(value)
      case "name": obj.name = stringValue(value)

      case "age_at_onset", "ageAtOnset": obj.age_at_onset = intValue(value)

      case "severity": obj.severity = dictionaryStringArray(value)

      case "treating_provider" : obj.treating_provider = createArrayOfEntries(CDAKProvider.self, withValues: value)

      default: debug_message("CDAKCondition", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKFacility {
      switch property {
      case "name": obj.name = stringValue(value)
      //case "codes", "code": obj.code = dictionaryStringArray(value)
      case "addresses" : obj.addresses = createArrayOfEntries(CDAKAddress.self, withValues: value)
      case "telecoms" : obj.telecoms = createArrayOfEntries(CDAKTelecom.self, withValues: value)
      default: debug_message("CDAKFacility", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKFulfillmentHistory {
      switch property {
      case "dispense_date": obj.dispense_date = doubleValue(value)
      default: debug_message("CDAKFulfillmentHistory", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKFunctionalStatus {
      switch property {
      case "type": obj.type = stringValue(value)
      default: debug_message("CDAKFunctionalStatus", function: "setProperty", property: property)
      }
      //shouldn't need this since we're now making CDAKGuarantor an CDAKEntry
//    } else if let obj = obj as? CDAKGuarantor {
//      switch property {
//      case "end_time": obj.end_time = intValue(value)
//      case "start_time": obj.start_time = intValue(value)
//      case "time": obj.time = intValue(value)
//      default: debug_message("CDAKGuarantor", function: "setProperty", property: property)
//      }
    } else if let obj = obj as? CDAKMedicalEquipment {
      switch property {
      case "removal_time": obj.removal_time = doubleValue(value)
      default: debug_message("CDAKMedicalEquipment", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKMedication {
      switch property {
      case "active_datetime": obj.active_datetime = doubleValue(value)
      case "signed_datetime": obj.signed_datetime = doubleValue(value)
      case "freeTextSig", "free_text_sig": obj.free_text_sig = stringValue(value)
      
        
        
      default: debug_message("CDAKMedication", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKOrderInformation {
      switch property {
      case "order_date_time", "orderDateTime": obj.order_date_time = doubleValue(value)
      case "order_expiration_date_time", "orderExpirationDateTime": obj.order_expiration_date_time = doubleValue(value)
      default: debug_message("CDAKOrderInformation", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKProcedure {
      switch property {
      case "incision_time": obj.incision_time = doubleValue(value)
      default: debug_message("CDAKProcedure", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKProviderPerformance {
      switch property {
      case "end_date": obj.end_date = doubleValue(value)
      case "start_date": obj.start_date = doubleValue(value)
      default: debug_message("CDAKProviderPerformance", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKFulfillmentHistory {
      switch property {
      case "dispense_date": obj.dispense_date = doubleValue(value)
      default: debug_message("CDAKFulfillmentHistory", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKRecord {
      switch property {
        
      case "id", "_id" :
        if let a_value = stringValue(value) {
          //remove Object("") wrapping we find in CDAK samples - fall back on just loading the value
          let quote_match = "([\"'])(?:(?=(\\\\?))\\2.)*?\\1"
          obj._id = CDAKCommonUtility.Regex.listMatches(quote_match, inString: a_value).first ?? a_value
        }
        
      case "birthdate": obj.birthdate = doubleValue(value)
      case "deathdate": obj.deathdate = doubleValue(value) //NOTE - NOT adjusting expired if this is set to non-nil

      case "effective_time": obj.effective_time = doubleValue(value)

      case "first": obj.first = stringValue(value)
      case "last": obj.last = stringValue(value)
      case "prefix": obj.prefix = stringValue(value)
      case "suffix": obj.suffix = stringValue(value)
      //OK, so there's extra data in the mongo json, but NOT in the model
      // "name" -> not in model
      case "name": break
        
      case "gender": obj.gender = stringValue(value)
      case "expired": if let expired = boolValue(value) { obj.expired = expired }
      
      case "medical_record_number": obj.medical_record_number = stringValue(value)
      case "medical_record_assigner": obj.medical_record_assigner = stringValue(value)

      //Not in model, but in mongo JSON (probably for QRDA)
      // not adding as we don't really know this (sort of ResearchKit integration)
      case "clinicalTrialParticipant": obj.clinicalTrialParticipant = boolValue(value)
  
      //this is in the root of the mongo json, but that's not how the model represents it
      //case "confidentiality": obj.confidentiality = stringValue(value) //HL7 value represented as code & value in json

      case "religiousAffiliation", "religious_affiliation": obj.religious_affiliation = singleCodeFieldFlat(value, withDefaultCodeSystem: "HL7")
        
      case "race": obj.race = singleCodeFieldFlat(value, withDefaultCodeSystem: "CDC")
      case "ethnicity": obj.ethnicity = singleCodeFieldFlat(value, withDefaultCodeSystem: "CDC")

      case "marital_status", "maritalStatus": obj.marital_status = singleCodeFieldFlat(value, withDefaultCodeSystem: "HL7")

      // array of codes
      case "languages" : obj.languages = arrayOfCodedEntries(value)

        
      //case "custodian": obj.custodian = stringValue(value) //need to do QRDA extensions
        
      case "encounters": obj.encounters = createArrayOfEntries(CDAKEncounter.self, withValues: value)
      case "addresses" : obj.addresses = createArrayOfEntries(CDAKAddress.self, withValues: value)
      case "telecoms" : obj.telecoms = createArrayOfEntries(CDAKTelecom.self, withValues: value)

      case "advance_directives" : obj.advance_directives = createArrayOfEntries(CDAKEntry.self, withValues: value)
      case "allergies" : obj.allergies = createArrayOfEntries(CDAKAllergy.self, withValues: value)

      case "care_goals" : obj.care_goals = createArrayOfEntries(CDAKCareGoal.self, withValues: value)
      case "communications" : obj.communications = createArrayOfEntries(CDAKCommunication.self, withValues: value)
      case "conditions" : obj.conditions = createArrayOfEntries(CDAKCondition.self, withValues: value)
      case "family_history" : obj.family_history = createArrayOfEntries(CDAKFamilyHistory.self, withValues: value)
      case "functional_statuses" : obj.functional_statuses = createArrayOfEntries(CDAKFunctionalStatus.self, withValues: value)
      case "immunizations" : obj.immunizations = createArrayOfEntries(CDAKImmunization.self, withValues: value)
      case "insurance_providers" : obj.insurance_providers = createArrayOfEntries(CDAKInsuranceProvider.self, withValues: value)
        

      case "medical_equipment" : obj.medical_equipment = createArrayOfEntries(CDAKMedicalEquipment.self, withValues: value)
      case "medications" : obj.medications = createArrayOfEntries(CDAKMedication.self, withValues: value)


      case "procedures" : obj.procedures = createArrayOfEntries(CDAKProcedure.self, withValues: value)
      case "provider_performances" : obj.provider_performances = createArrayOfEntries(CDAKProviderPerformance.self, withValues: value)
      case "results" : obj.results = createArrayOfEntries(CDAKLabResult.self, withValues: value)
      case "social_history", "socialhistories", "social_histories" : obj.social_history = createArrayOfEntries(CDAKSocialHistory.self, withValues: value)
      case "vital_signs" : obj.vital_signs = createArrayOfEntries(CDAKVitalSign.self, withValues: value)

      //NOTE: not in base model - may be from QRDA?
      case "pregnancies" : obj.pregnancies = createArrayOfEntries(CDAKEntry.self, withValues: value)

        //values

        
      default: debug_message("CDAKRecord", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKAddress {
      switch property {
      case "city": obj.city = stringValue(value)
      case "state": obj.state = stringValue(value)
      case "zip": obj.zip = stringValue(value)
      case "country": obj.country = stringValue(value)
      case "use": obj.use = stringValue(value)
      case "street":
        var street: [String] = []
        if let values = value as? [Any] {
          for value in values {
            if let value = stringValue(value) {
              street.append(value)
            }
          }
        }
        obj.street = street
        
      default: debug_message("CDAKAddress", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKTelecom {
      switch property {
      case "use": obj.use = stringValue(value)
      case "value": obj.value = stringValue(value)
      case "preferred": obj.preferred = boolValue(value)
      default: debug_message("CDAKTelecom", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKProvider {
      switch property {
      case "prefix": obj.prefix = stringValue(value)
      case "given_name": obj.given_name = stringValue(value)
      case "family_name": obj.family_name = stringValue(value)
      case "suffix": obj.suffix = stringValue(value)
      case "specialty": obj.specialty = stringValue(value)
      case "phone": obj.phone = stringValue(value)

      case "addresses" : obj.addresses = createArrayOfEntries(CDAKAddress.self, withValues: value)
      case "telecoms" : obj.telecoms = createArrayOfEntries(CDAKTelecom.self, withValues: value)
      case "organization" : obj.organization = CDAKOrganization(event: dictionaryAny(value))
      case "cda_identifiers" : obj.cda_identifiers = createArrayOfEntries(CDAKCDAIdentifier.self, withValues: value)
      default: debug_message("CDAKProvider", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKOrganization {
      switch property {
      case "name": obj.name = stringValue(value)
      case "addresses" : obj.addresses = createArrayOfEntries(CDAKAddress.self, withValues: value)
      case "telecoms" : obj.telecoms = createArrayOfEntries(CDAKTelecom.self, withValues: value)
      default: debug_message("CDAKOrganization", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKCDAIdentifier {
      switch property {
      case "root": obj.root = stringValue(value)
      case "extension_id": obj.extension_id = stringValue(value)
      default: debug_message("CDAKCDAIdentifier", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKReason {
      switch property {
      case "description": obj.item_description = stringValue(value)
      case "codes": obj.codes = dictionaryStringArray(value)
      default: debug_message("CDAKReason", function: "setProperty", property: property)
      }
    } else if let obj = obj as? CDAKInsuranceProvider {
      switch property {
      case "name": obj.name = stringValue(value)
      case "payer": obj.payer = CDAKOrganization(event: dictionaryAny(value))
      case "guarantors" : obj.guarantors = createArrayOfEntries(CDAKGuarantor.self, withValues: value)
      case "subscriber": obj.subscriber = CDAKPerson(event: dictionaryAny(value))
      
      case "type": obj.type = stringValue(value)
      case "member_id": obj.member_id = stringValue(value)
      case "name": obj.name = stringValue(value)

      //var relationship = [String:String]() //, type: Hash
      //var financial_responsibility_type = [String:String]() //, type: Hash
        
      default: debug_message("CDAKInsuranceProvider", function: "setProperty", property: property)
      }
    }

    
  }
  
  //http://stackoverflow.com/questions/30897892/how-to-create-generic-convenience-initializer-in-swift
  //http://austinzheng.com/2015/09/29/swift-generics-pt-2/
  //T.Type
  class func createArrayOfEntries<T: CDAKJSONInstantiable>(_ type : T.Type, withValues value: Any?) -> [T] {
    var result : [T] = []
    if let values = value as? [Any] {
      for value in values {
        if let event = value as? [String:Any?] {
          result.append(T(event: event))
        }
      }
    }
    return result
  }
  
  
  class func convertStringToDictionary(_ text: String) -> [String:Any] {
    if let data = text.data(using: String.Encoding.utf8) {
      do {
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
        
        var otherJson: [String:Any] = [:]
        if let json = json {
          for(key, value) in json {
            otherJson[key] = (value as Any)
          }
        }
        return otherJson
        
      } catch let error as NSError {
        print(error.localizedDescription)
      }
    }
    return [:]
  }
  
}




