 //
//  entry.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache


public class HDSEntry: NSObject , HDSThingWithCodes, HDSPropertyAddressable, HDSJSONInstantiable, HDSThingWithTimes {
  
  //Equatable, Hashable,
  
  //include Mongoid::Attributes::Dynamic
  weak var record: HDSRecord?
  //the original code makes use of the ability to point back to the containing record
  // adding a weak reference here since the record actually contains the entry (self)
  
  //ThingWithCodes
  public var codes: HDSCodedEntries = HDSCodedEntries()
  
  public var cda_identifier: HDSCDAIdentifier? //, class_name: "HDSCDAIdentifier", as: :cda_identifiable
  //MARK: FIXME - I changed the class to PhysicalQuantityResultValue here
  // the test cases all made it appear we're using that and not ResultValue
  public var values = [HDSResultValue]() //, class_name: "ResultValue"... and yet... it wants PhysicalQuantityResultValue - but in other places... ResultValue (PhysicalQuantityResultValue is a subclass of ResultValue)
  public var references = [HDSReference]() //
  public var provider_preference = [HDSEntry]() //, class_name: "HDSEntry"
  public var patient_preference = [HDSEntry]() //, class_name: "HDSEntry"
  
  public var item_description: String?
  public var specifics: String?
  public var time: Double?
  public var start_time: Double?
  public var end_time: Double?
  
  public var status_code : HDSCodedEntries = HDSCodedEntries() //, type: Hash
  public var mood_code: String = "EVN" //, type: String, default: "EVN"
  public var negation_ind: Bool? = false //, as: :negation_ind, type: Boolean
  public var negation_reason : HDSCodedEntries = HDSCodedEntries()//, as: :negation_reason, type: Hash
  public var oid: String? //, type: String
  public var reason: HDSReason?//, type: Hash
  
  
  public var comment: String? // not in original model, but found in some other HDSEntry items like pregnancies
  
  public var version: Int = 1
  public var id: String?
  public var created_at = NSDate()
  public var updated_at = NSDate()

  
  //Condition
  //method "builds" (new) object and reflects on properties (response to -> class, id)
  // any of the HDSEntry types should have this
  func add_reference(entry: HDSEntry, type: String) {
    let ref = HDSReference(type: type, referenced_type: HDSCommonUtility.classNameAsString(entry), referenced_id: entry.id, entry: entry)
    references.append(ref)
    //references.build(type: type, referenced_type: entry.class, referenced_id: entry.id)
    
  }
  
  
  func times_to_s(nil_string: String = "UNK") -> String {
    
    var ret = ""
    
    if start_time != nil || end_time != nil {
      let start_string: String = (start_time != nil ? HDSEntry.time_to_s(start_time!) : nil_string)
      let end_string: String = (end_time != nil ? HDSEntry.time_to_s(end_time!) : nil_string)
      ret = "\(start_string) - \(end_string)"
    } else if let time = time {
      //Time.at(time).utc.to_formatted_s(:long_ordinal)
      return NSDate(timeIntervalSince1970: Double(time)).stringFormattedAsHDSDate
    }
    
    return ret
  }
  
  class func time_to_s(input_time: Double) -> String {
    //original code
    //Time.at(input_time).utc.to_formatted_s(:long_ordinal)
    
    let date = NSDate(timeIntervalSince1970: NSTimeInterval(input_time))
    let date_string = date.stringFormattedAsHDSDate
    return date_string
    
    //explanation
    //http://ruby-doc.org/core-2.2.3/Time.html
    //Time is stored internally as the number of seconds with fraction since the Epoch, January 1, 1970 00:00
    // http://apidock.com/rails/ActiveSupport/CoreExtensions/DateTime/Conversions/to_formatted_s
    // datetime.to_formatted_s(:long_ordinal)  # => "December 4th, 2007 00:00"
    
  }
  

  //  # HDSEntry previously had a status field that dropped the code set and converted
  //  # the status to a String. HDSEntry now preserves the original code and code set.
  //  # This method is here to maintain backwards compatibility.
  func status_legacy() -> String? {
    
    if status_code.count > 0 {
      if let hl7 = status_code["HL7 ActStatus"] {
        return hl7.first
      } else if let snomed = status_code["SNOMED-CT"] {
        if let snomed = snomed.first {
          switch snomed {
          case "55561003":
            return "active"
          case "73425007":
            return "inactive"
          case "413322009":
            return "resolved"
          default:
            return nil
          }
        }
      }
    }
    
    return nil
    
  }
  
  //replacing ruby virtual attribute ("method")
  //http://stackoverflow.com/questions/5398919/what-does-the-equal-symbol-do-when-put-after-the-method-name-in-a-method-d
  // I realize this is ugly - I'm trying to retain the initial code as much as possible, even where not "Swifty"
  
  public var status: String? {
  
    get { return status_legacy() }
    
    set(status_text) {
    
      var sc: HDSCodedEntries = HDSCodedEntries()
      
      switch status_text {
      case let status_text where status_text == "active":
        //self.status_code = {'SNOMED-CT' => ['55561003'], 'HL7 ActStatus' => ['active']}
        sc["SNOMED-CT"] = HDSCodedEntry(codeSystem: "SNOMED-CT", codes: ["55561003"])
        sc["HL7 ActStatus"] = HDSCodedEntry(codeSystem: "HL7 ActStatus", codes: ["active"])
        self.status_code = sc
      case let status_text where status_text == "inactive":
        //self.status_code = {'SNOMED-CT' => ['73425007']}
        sc["SNOMED-CT"] = HDSCodedEntry(codeSystem: "SNOMED-CT", codes: ["73425007"])
        self.status_code = sc
      case let status_text where status_text == "resolved":
        //self.status_code = {'SNOMED-CT' => ['413322009']}
        sc["SNOMED-CT"] = HDSCodedEntry(codeSystem: "SNOMED-CT", codes: ["413322009"])
        self.status_code = sc
      default:
        //self.status_code = {'HL7 ActStatus' => [status_text]}
        //boom
        sc["HL7 ActStatus"] = HDSCodedEntry(codeSystem: "HL7 ActStatus", codes: [status_text!])
        self.status_code = sc
      }
    }
  }
  
  //# Sets the value for the entry
  //# @param [String] scalar the value
  //# @param [String] units the units of the scalar value
  public func set_value(scalar: Any?, units: String?) {

    var a_scalar: String?
    if let val = scalar {
      //if we have an optional, unwrap it and attempt to make it a String
      a_scalar = String(val)
    }
    
    let pq_value = HDSPhysicalQuantityResultValue(scalar: a_scalar, units: units)
    self.values.append(pq_value)
  }

  
  public override required init() {
    super.init()
  }
  
  public required init(event: [String:Any?]) {
    super.init()
    initFromEventList(event)
  }
  
  init(from_hash event: [String:Any?]) {
    super.init()
    initFromEventList(event)
  }
  
  private func initFromEventList(event: [String:Any?]) {
    let ignore_props: [String] = ["code", "code_set", "value", "unit"]

    //in some cases we'll have key-value PAIRS like...
    // code_set / code
    // value / unit
    // these won't work for the single key-value entries
    if let code = event["code"], code_set = event["code_set"] as? String {
      add_code(code, code_system: code_set)
    }

    if let value = event["value"] {
      var unit: String?
      if let a_unit = event["unit"] as? String {
        unit = a_unit
      }
      set_value(value, units: unit)
    }
    
    for (key, value) in event {
      //ignore the ones we're handling differnetly above
      if !ignore_props.contains(key) {
        HDSUtility.setProperty(self, property: key, value: value)
      }
    }
  }
  
  public init(record: HDSRecord) {
    self.record = record
  }
  
  public init(cda_identifier: HDSCDAIdentifier) {
    self.cda_identifier = cda_identifier
  }
  
  //MARK: FIXME - changed values from ResultValue to PhysicalQuantityResultValue
  public init(cda_identifier: HDSCDAIdentifier, codes: HDSCodedEntries, values: [HDSPhysicalQuantityResultValue]) {
    self.cda_identifier = cda_identifier
    self.codes = codes
    self.values = values
  }

  
  //MARK: FIXME - incomplete "is_in_code_set"
  //# Checks if a code is in the list of possible codes
  //# @param [Array] code_set an Array of Hashes that describe the values for code sets
  //#                The hash has a key of "set" for the code system name and "values"
  //#                for the actual code list
  //# @return [true, false] whether the code is in the list of desired codes
  func is_in_code_set(code_set: [HDSCodedEntries]) -> Bool {
    for entries in code_set {
      for (key, entry) in entries {
        if codes.findIntersectingCodes(forCodeSystem: key, matchingCodes: entry.codes)?.count > 0 {
          return true
        }
      }
    }
//    for code_system in codes.keys {
//      let all_codes_in_system = code_set.filter({set in set["set"]?.first == code_system})
//      //      all_codes_in_system = code_set.find_all {|set| set['set'] == code_system}
//      
//      for codes_in_system in all_codes_in_system {
//        var values_set: Set<String> = Set()
//        var codes_set: Set<String> = Set()
//        if let values = codes_in_system["values"] {
//          values_set = Set(values)
//        }
//        if let values = codes[code_system] {
//          codes_set = Set(values)
//        }
//        //print("code_system = '\(code_system)', values_set = '\(values_set)' , codes_set = '\(codes_set)', intersection = '\(values_set.intersect(codes_set))' ")
//        
//        if values_set.intersect(codes_set).count > 0 {
//          return true
//        }
//      }
//    }
    
    return false
  }
  
  
  //# Tries to find a single point in time for this entry. Will first return time if it is present,
  //# then fall back to start_time and finally end_time
  func as_point_in_time() -> Double? {
    if let time = time {
      return time
    }
    if let start_time = start_time {
      return start_time
    }
    if let end_time = end_time {
      return end_time
    }
    return nil
  }
  
  //# Checks to see if this HDSEntry can be used as a date range
  //# @return [true, false] If the HDSEntry has a start and end time returns true, false otherwise.
  var is_date_range : Bool {
    if start_time != nil && end_time != nil {
      return true
    }
    return false
  }
  
  //# Checks to see if this HDSEntry is usable for measure calculation. This means that it contains
  //# at least one code and has one of its time properties set (start, end or time)
  //# @return [true, false]
  func usable() -> Bool {
    if codes.count > 0 && (start_time != nil || end_time != nil || time != nil) {
      return true
    }
    return false
  }
  
  
  
  
  func shift_dates(date_diff: Double) {
    if let start_time = start_time {
      self.start_time = start_time + date_diff
    }
    if let end_time = end_time {
      self.end_time = end_time + date_diff
    }
    if let time = time {
      self.time = time + date_diff
    }
  }
  
  //MARK: FIXME - not using the hash - just using native properties
  override public var hashValue: Int {
    
    var hv: Int
    
    hv = "\(codes)".hashValue
      
    if values.count > 0 {
      hv = hv ^ "\(values)".hashValue
    }
    if let start_time = start_time, end_time = end_time {
      hv = hv ^ start_time.hashValue
      hv = hv ^ end_time.hashValue
    } else {
      hv = hv ^ "\(time)".hashValue
    }
    
    if let status = status {
      hv = hv ^ status.hashValue
    }
    if let specifics = specifics {
      hv = hv ^ specifics.hashValue
    }
    
    //should we not include the class name?
    
    return hv
  }
  

  //# Returns the hash value, calculating it if not already done
  // MARK: FIXME - do as lazy?
  // EWW: not doing this as lazy just now
  var hash_object : [String:Any] {
    return to_hash()
  }
  
  //  # Creates a Hash for this HDSEntry
  //  # @return [Hash] a Hash representing the HDSEntry
  func to_hash() -> [String:Any] {
    
    var entry_hash: [String:Any] = [:]

    //we want something like
    // yes - this removes the OID
    // we want a straight up dictionary of [code_system: [codes]]
    entry_hash["codes"] = codes.codeDictionary
    
    if values.count > 0 {
      entry_hash["value"] = values
    }
    
    if is_date_range {
      entry_hash["start_time"] = start_time
      entry_hash["end_time"] = end_time
    } else {
      entry_hash["time"] = as_point_in_time()
    }

    if let status = status {
      entry_hash["status"] = status
    }
    if let item_description = item_description {
      entry_hash["item_description"] = item_description
    }
    if let specifics = specifics {
      entry_hash["specifics"] = specifics
    }
    
    return entry_hash
  }
  
  
  //MARK: FIXME - not sure this whole "identifier" business is right here
  public var identifier: AnyObject? {
    if let cda_identifier = cda_identifier {
      return cda_identifier
    } else {
      return id
    }
  }

  //MARK: FIXME: this is a bad placeholder to deal with typing - I just need an "identifier" I can use as a key
  public var identifier_as_string: String {
    if let cda_identifier = cda_identifier {
      return cda_identifier.as_string
    }
    if let id = id {
      return id
    }
    return ""
  }


  override public var description : String {
    return "\(self.dynamicType) => codes: \(codes), cda_identifier: \(identifier_as_string), values: \(values), references: \(references), provider_preference: \(provider_preference), patient_preference: \(patient_preference), item_description: \(item_description), specifics: \(specifics), time: \(time), start_time: \(start_time), end_time: \(end_time), status_code: \(status_code), mood_code: \(mood_code), negation_ind: \(negation_ind), negation_reason: \(negation_reason), oid: \(oid), reason: \(reason), version: \(version), id: \(id), created_at: \(created_at), updated_at: \(updated_at)"
  }
  
}

/*
extension HDSEntry {
  // NSObject already does MustacheBoxable
  override var mustacheBox: MustacheBox {
    return Box(["time": self.time])
    //"codes": self.codes,
  }
}
*/

//new in Swift 2.x with NSObject
// http://mgrebenets.github.io/swift/2015/06/21/equatable-nsobject-with-swift-2/
extension HDSEntry {
  override public func isEqual(object: AnyObject?) -> Bool {
    if let rhs = object as? HDSEntry {
      return hashValue == rhs.hashValue && HDSCommonUtility.classNameAsString(self) == HDSCommonUtility.classNameAsString(rhs)
    }
    return false
  }
}

func == (lhs: HDSEntry, rhs: HDSEntry) -> Bool {
  return lhs.hashValue == rhs.hashValue && HDSCommonUtility.classNameAsString(lhs) == HDSCommonUtility.classNameAsString(rhs)
}

extension HDSEntry {
  
//  var export_section_name: String {
//    switch String(self.dynamicType) {
//    case "HDSAllergy": return "allergies"
//    case "HDSEncounter": return "encounters"
//    case "HDSCareGoal": return "plan_of_care"
//    case "Condition": return "conditions"
//    case "HDSImmunization": return "immunizations"
//    case "HDSMedicalEquipment": return "medical_equipment"
//    case "HDSMedicalEquipment": return "medications"
//    case "HDSProcedure": return "procedures"
//    case "ResultValue": return "results"
//    case "HDSLabResult": return "results"
//    case "HDSSocialHistory": return "social_history"
//    case "HDSVitalSign": return "vitals"
//    default: fatalError("Unknown type '\(self.dynamicType)' in export_section_name")
//    }
//  }
//  var export_section_status: Bool? {
//    switch String(self.dynamicType) {
//    case "Condition": return true
//    default: return nil
//    }
//  }
//  var export_section_value: Bool? {
//    switch String(self.dynamicType) {
//    case "ResultValue": return true
//    case "HDSVitalSign": return true
//    default: return nil
//    }
//  }
  
  var preferred_code_sets: [String] {
    switch String(self.dynamicType) {
    case "HDSAllergy": return ["RxNorm"]
    case "HDSCareGoal": return ["SNOMED-CT"]
    case "HDSCondition": return ["SNOMED-CT"]
    case "HDSEncounter": return ["CPT"]
    case "HDSImmunization": return ["CVX"]
    case "HDSMedicalEquipment": return ["SNOMED-CT"]
    case "HDSMedication": return ["RxNorm"]
    case "HDSProcedure": return ["CPT", "ICD-9-CM", "ICD-10-CM", "HCPCS", "SNOMED-CT"]
    case "HDSResultValue": return ["LOINC", "SNOMED-CT"]
    case "HDSLabResult": return ["LOINC", "SNOMED-CT"]
    case "HDSSocialHistory": return ["SNOMED-CT"]
    case "HDSVitalSign": return ["LOINC", "SNOMED-CT"] //NOTE - in the original Ruby template they key was "SNOMED"
      // which is wrong, but... not sure if they did something else with it
    default: return []
    }
  }

  var code_display : String {
    return ViewHelper.code_display(self, options: ["preferred_code_sets":self.preferred_code_sets])
  }
  
  var boxedValues: [String:MustacheBox] {
    //let x = ViewHelper.code_display(self, options: ["preferred_code_set":self.export_preferred_code_sets])
    //let y = ViewHelper.code_display(self, options: ["preferred_code_set":self.export_preferred_code_sets])
    
    //      //code_system_oid = HealthDataStandards::Util::HDSCodeSystemHelper.oid_for_code_system(preferred_code['code_set'])
    //var entry_preferred_code : [String:String] = [:]
    var entry_preferred_code : HDSCodedEntry?
    var code_system_oid = ""
//    if let a_preferred_code = preferred_code(preferred_code_sets), let code_set = a_preferred_code["code_set"] {
    if let a_preferred_code = preferred_code(preferred_code_sets) {
      let code_set = a_preferred_code.codeSystem
      code_system_oid = HDSCodeSystemHelper.oid_for_code_system(code_set)
      entry_preferred_code = HDSCodedEntry(codeSystem: code_set, codes: a_preferred_code.codes, codeSystemOid: code_system_oid)
    }
    
    return [
      "cda_identifier" :  Box(self.cda_identifier),
      "values" :  Box(self.values),
      "codes" : Box(self.codes),
      "references" :  Box(self.references),
      "provider_preference" :  Box(self.provider_preference),
      "patient_preference" :  Box(self.patient_preference),
      "description" :  Box(self.item_description),
      "specifics" :  Box(self.specifics),
      "time" :  Box(self.time),
      "start_time" :  Box(self.start_time),
      "end_time" :  Box(self.end_time),
      "status_code" :  Box(self.status_code),
      "mood_code" :  Box(self.mood_code),
      "negation_ind" :  Box(self.negation_ind),
      "negation_reason" :  Box(self.negation_reason),
      "oid" :  Box(self.oid),
      "reason" :  Box(self.reason),
      "version" :  Box(self.version),
      "id" :  Box(self.id),
      "created_at" :  Box(self.created_at),
      "updated_at" :  Box(self.updated_at),
      
      //used in C32 narrative_block
      //"section": Box(self.export_section_name),

      
      "status": Box(self.status),
      
      "statusCode_code": self.status != nil && self.status! == "resolved" ? Box("completed") : Box("active"),

      "myType" : Box(String(self.dynamicType)),
      "preferred_code_sets": Box(self.preferred_code_sets),
      "code_display": Box(code_display),

      "as_point_in_time" : Box(self.as_point_in_time()),
//      "preferred_code" : entry_preferred_code.count > 0 ? Box(["code":entry_preferred_code["code"], "code_set":entry_preferred_code["code_set"]] ) : Box(nil), //need to transform this into a usable struct
      "preferred_code" : entry_preferred_code != nil ? Box(["code":entry_preferred_code!.codes, "code_set":entry_preferred_code!.codeSystem] ) : Box(nil), //need to transform this into a usable struct
      "code_system_oid" : Box(code_system_oid),
      "translation_codes": Box(self.translation_codes(self.preferred_code_sets).arrayOfFlattenedCodedEntry.map({ce -> [String:String] in
        return ["code_set": ce.codeSystem, "code": ce.code!]
      })),
      "codes_to_s" : Box(codes_to_s()),
      "times_to_s" : Box(times_to_s()),
      
      "status_code_for" : Box(ViewHelper.status_code_for(self))
      
      //preferred_code = entry.preferred_code(preferred_code_sets)
      //if preferred_code
      //code_system_oid = HealthDataStandards::Util::HDSCodeSystemHelper.oid_for_code_system(preferred_code['code_set'])
      
    ]
  }
  
  override public var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
}



extension HDSEntry {



  
  
  
}
