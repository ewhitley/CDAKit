 //
//  entry.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


/**
Root type of generic CDA Entry.  All other "entry-like" types inherit from CDAKEntry
*/
 
open class CDAKEntry: NSObject , CDAKThingWithCodes, CDAKPropertyAddressable, CDAKThingWithTimes, CDAKJSONInstantiable, CDAKThingWithIdentifier {
  
  //Equatable, Hashable,
  
  //include Mongoid::Attributes::Dynamic
  weak var record: CDAKRecord?
  //the original code makes use of the ability to point back to the containing record
  // adding a weak reference here since the record actually contains the entry (self)
  
  // MARK: CDA properties
  //ThingWithCodes
  /** 
  Core coded entries that represent any "meaning" behind the entry
  These will be in the format of...
    ClinicalVocabulary:ConceptID
  Like
    LOINC:12345
  */
  open var codes: CDAKCodedEntries = CDAKCodedEntries()
  
  ///Type of CDA Entry if available
  open var cda_identifier: CDAKCDAIdentifier? //, class_name: "CDAKCDAIdentifier", as: :cda_identifiable
  //FIX_ME: - I changed the class to PhysicalQuantityResultValue here
  // the test cases all made it appear we're using that and not ResultValue
  /**
  Any associated result values. 
  
  Specific entries may contain "result," often in the form of a physical quantity result value, etc.
  
  EX: Result of "Weight" is 160 lbs.
  */
  open var values = [CDAKResultValue]() //, class_name: "ResultValue"... and yet... it wants PhysicalQuantityResultValue - but in other places... ResultValue (PhysicalQuantityResultValue is a subclass of ResultValue)
  ///CDA Reference
  open var references = [CDAKReference]() //
  ///CDA Provider preference
  open var provider_preference = [CDAKEntry]() //, class_name: "CDAKEntry"
  ///CDA patient preference
  open var patient_preference = [CDAKEntry]() //, class_name: "CDAKEntry"
  
  ///CDA Description
  open var item_description: String?
  ///CDA specifics
  open var specifics: String?
  ///A generalized "time" associated with the entry
  open var time: Double?
  ///A start time associated with this entry
  open var start_time: Double?
  ///an end time associated with this entry
  open var end_time: Double?
  
  ///CDA status code
  open var status_code : CDAKCodedEntries = CDAKCodedEntries() //, type: Hash
  /**
  CDA moodCode.  Defaulted to "EVN"
  [Reference](http://www.cdapro.com/know/25027)
  */
  open var mood_code: String = "EVN" //, type: String, default: "EVN"
  ///CDA negation indicator.  Is this a "negation" of the act?
  open var negation_ind: Bool? = false //, as: :negation_ind, type: Boolean
  ///CDA negation reason
  open var negation_reason : CDAKCodedEntries = CDAKCodedEntries()//, as: :negation_reason, type: Hash
  ///CDA OID
  open var oid: String? //, type: String
  ///CDA Reason
  open var reason: CDAKReason?//, type: Hash
  
  ///Comments support
  open var comment: String? // not in original model, but found in some other CDAKEntry items like pregnancies
  
  ///Version of entry
  open var version: Int = 1
  ///id
  open var id: String?
  ///Date of entry creation
  open var created_at = Date()
  ///Date of last entry update
  open var updated_at = Date()

  ///Allows you to provide a custom list of code set keys / tags to override the default behavior for this entry.  All entries have defined preferred code sets like "SNOMED-CT" or "LOINC", but if you use a generic CDAKEntry, none are defined.  You can use this to either completely override the default code sets supplied by the system or provide a specific set of preferred code sets for generic entries (as is required for things like an `Indication` within an `encounter` or `medication`.
  open var explicit_preferred_code_sets : [String] = []
  
  //Condition
  //method "builds" (new) object and reflects on properties (response to -> class, id)
  // any of the CDAKEntry types should have this
  func add_reference(_ entry: CDAKEntry, type: String) {
    let ref = CDAKReference(type: type, referenced_type: CDAKCommonUtility.classNameAsString(entry), referenced_id: entry.id, entry: entry)
    references.append(ref)
    //references.build(type: type, referenced_type: entry.class, referenced_id: entry.id)
    
  }
  
  
  // MARK: Health-Data-Standards Functions
  ///Convert times to CDA strings
  func times_to_s(_ nil_string: String = "UNK") -> String {
    
    var ret = ""
    
    if start_time != nil || end_time != nil {
      let start_string: String = (start_time != nil ? CDAKEntry.time_to_s(start_time!) : nil_string)
      let end_string: String = (end_time != nil ? CDAKEntry.time_to_s(end_time!) : nil_string)
      ret = "\(start_string) - \(end_string)"
    } else if let time = time {
      //Time.at(time).utc.to_formatted_s(:long_ordinal)
      return Date(timeIntervalSince1970: Double(time)).stringFormattedAsHDSDate
    }
    
    return ret
  }
  
  ///Convert times to CDA strings
  class func time_to_s(_ input_time: Double) -> String {
    //original code
    //Time.at(input_time).utc.to_formatted_s(:long_ordinal)
    
    let date = Date(timeIntervalSince1970: TimeInterval(input_time))
    let date_string = date.stringFormattedAsHDSDate
    return date_string
    
    //explanation
    //http://ruby-doc.org/core-2.2.3/Time.html
    //Time is stored internally as the number of seconds with fraction since the Epoch, January 1, 1970 00:00
    // http://apidock.com/rails/ActiveSupport/CoreExtensions/DateTime/Conversions/to_formatted_s
    // datetime.to_formatted_s(:long_ordinal)  # => "December 4th, 2007 00:00"
  }
  

  /**
  CDAKEntry previously had a status field that dropped the code set and converted the status to a String. CDAKEntry now preserves the original code and code set.
 
  This method is here to maintain backwards compatibility.
  */
  func status_legacy() -> String? {
    
    if status_code.count > 0 {
      if let hl7 = status_code["HL7 ActStatus"]?.first {
        return hl7.code
      } else if let snomed = status_code["SNOMED-CT"]?.first {
        //if let snomed = snomed.first {
          switch snomed.code {
          case "55561003":
            return "active"
          case "73425007":
            return "inactive"
          case "413322009":
            return "resolved"
          default:
            return nil
          }
        //}
      }
    }
    
    return nil
    
  }
  
  //replacing ruby virtual attribute ("method")
  //http://stackoverflow.com/questions/5398919/what-does-the-equal-symbol-do-when-put-after-the-method-name-in-a-method-d
  // I realize this is ugly - I'm trying to retain the initial code as much as possible, even where not "Swifty"
  
  ///CDA status string
  open var status: String? {
  
    get { return status_legacy() }
    
    set(status_text) {
    
      var sc: CDAKCodedEntries = CDAKCodedEntries()
      
      switch status_text {
      case let status_text where status_text == "active":
        //self.status_code = {'SNOMED-CT' => ['55561003'], 'HL7 ActStatus' => ['active']}
//        sc["SNOMED-CT"] = CDAKCodedEntry(codeSystem: "SNOMED-CT", code: ["55561003"])
//        sc["HL7 ActStatus"] = CDAKCodedEntry(codeSystem: "HL7 ActStatus", code: ["active"])
        sc.addCodes("SNOMED-CT", code: "55561003")
        sc.addCodes("HL7 ActStatus", code: "active")
        self.status_code = sc
      case let status_text where status_text == "inactive":
        //self.status_code = {'SNOMED-CT' => ['73425007']}
//        sc["SNOMED-CT"] = CDAKCodedEntry(codeSystem: "SNOMED-CT", codes: ["73425007"])
//        self.status_code = sc
        sc.addCodes("SNOMED-CT", code: "73425007")
      case let status_text where status_text == "resolved":
        //self.status_code = {'SNOMED-CT' => ['413322009']}
        //sc["SNOMED-CT"] = CDAKCodedEntry(codeSystem: "SNOMED-CT", codes: ["413322009"])
        sc.addCodes("SNOMED-CT", code: "413322009")
        self.status_code = sc
      default:
        //self.status_code = {'HL7 ActStatus' => [status_text]}
        //boom
        //sc["HL7 ActStatus"] = CDAKCodedEntry(codeSystem: "HL7 ActStatus", codes: [status_text!])
        sc.addCodes("HL7 ActStatus", code: status_text!)
        self.status_code = sc
      }
    }
  }
  
  /**
 
  Sets the value for the entry
  
  - parameter scalar: the value.  Anything we can convert to a String
  - parameter units: the units of the scalar value
  */
  open func set_value(_ scalar: Any?, units: String?) {

    var a_scalar: String?
    if let val = scalar {
      //if we have an optional, unwrap it and attempt to make it a String
      a_scalar = String(describing: val)
    }
    
    let pq_value = CDAKPhysicalQuantityResultValue(scalar: a_scalar, units: units)
    self.values.append(pq_value)
  }

  /**
   Checks if a code is in the list of possible codes
   
   - parameter code_set: array of CodedEntries. Describe the values for code sets
   - returns: true / false whether the code is in the list of desired codes
   */
  func is_in_code_set(_ code_set: [CDAKCodedEntries]) -> Bool {
    for entries in code_set {
//      for (key, entry) in entries {
//        if codes.findIntersectingCodes(forCodeSystem: key, matchingCodes: entry.codes)?.count > 0 {
//          return true
//        }
//      }
      if codes.findIntersectingCodedEntries(forCodedEntries: entries)?.count > 0 {
        return true
      }
    }
    
    return false
  }
  
  
  /**
   Tries to find a single point in time for this entry. Will first return time if it is present, then fall back to start_time and finally end_time
   */
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
  
  /**
   Checks to see if this CDAKEntry can be used as a date range
   
   - returns: true / false If the CDAKEntry has a start and end time returns true, false otherwise.
   */
  var is_date_range : Bool {
    if start_time != nil && end_time != nil {
      return true
    }
    return false
  }
  
  /**
   Checks to see if this CDAKEntry is usable for measure calculation. This means that it contains at least one code and has one of its time properties set (start, end or time)
   */
  func usable() -> Bool {
    if codes.count > 0 && (start_time != nil || end_time != nil || time != nil) {
      return true
    }
    return false
  }
  
  ///Offset all dates by specified double
  func shift_dates(_ date_diff: Double) {
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
  
  
  /**
   DO NOT USE - legacy Ruby
   Returns the hash object, calculating it if not already done
   */
  internal var hash_object : [String:Any] {
    // FIX_ME: - do as lazy?
    // EWW: not doing this as lazy just now
    return to_hash()
  }
  
  /**
   DO NOT USE - legacy Ruby
   Creates a Hash for this CDAKEntry
   - returns: A Hash representing the CDAKEntry
   */
  internal func to_hash() -> [String:Any] {
    
    var entry_hash: [String:Any] = [:]
    
    //we want something like
    // yes - this removes the OID
    // we want a straight up dictionary of [code_system: [codes]]
    //entry_hash["codes"] = codes.codeDictionary
    entry_hash["codes"] = codes.jsonDict
    
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
  
  ///Returns CDA identifier or fixed id if not present
  open var identifier: AnyObject? {
    //FIX_ME: - not sure this whole "identifier" business is right here
    if let cda_identifier = cda_identifier {
      return cda_identifier
    } else {
      return id as AnyObject?
    }
  }
  
  ///Converts CDA identifier to string for use
  open var identifier_as_string: String {
    //FIX_ME:: this is a bad placeholder to deal with typing - I just need an "identifier" I can use as a key
    if let cda_identifier = cda_identifier {
      return cda_identifier.as_string
    }
    if let id = id {
      return id
    }
    return ""
  }
  
  // MARK: Standard properties
  ///Internal object hash value
  override open var hashValue: Int {
    //FIX_ME: - not using the hash - just using native properties
    
    var hv: Int
    
    hv = "\(codes)".hashValue
    
    if values.count > 0 {
      hv = hv ^ "\(values)".hashValue
    }
    if let start_time = start_time, let end_time = end_time {
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

  
  // MARK: - Initializers
  public override required init() {
    super.init()
  }
  
  public init(record: CDAKRecord) {
    //self.record = record
  }
  
  public init(cda_identifier: CDAKCDAIdentifier) {
    self.cda_identifier = cda_identifier
  }
  
  public init(cda_identifier: CDAKCDAIdentifier, codes: CDAKCodedEntries, values: [CDAKPhysicalQuantityResultValue]) {
    //FIX_ME: - changed values from ResultValue to PhysicalQuantityResultValue
    self.cda_identifier = cda_identifier
    self.codes = codes
    self.values = values
  }

  
  // MARK: - Deprecated - Do not use
  ///Do not use - will be removed. Was used in HDS Ruby.
  public required init(event: [String:Any?]) {
    super.init()
    initFromEventList(event)
  }
  
  ///Do not use - will be removed. Was used in HDS Ruby.
  internal init(from_hash event: [String:Any?]) {
    super.init()
    initFromEventList(event)
  }
  
  ///Do not use - will be removed. Was used in HDS Ruby.
  fileprivate func initFromEventList(_ event: [String:Any?]) {
    let ignore_props: [String] = ["code", "code_set", "value", "unit"]
    
    //in some cases we'll have key-value PAIRS like...
    // code_set / code
    // value / unit
    // these won't work for the single key-value entries
    if let code = event["code"], let code_set = event["code_set"] as? String {
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
        CDAKUtility.setProperty(self, property: key, value: value)
      }
    }
  }
  
  // MARK: Standard properties
  ///Debugging description
  override open var description : String {
    return "\(type(of: self)) => codes: \(codes), cda_identifier: \(identifier_as_string), values: \(values), references: \(references), provider_preference: \(provider_preference), patient_preference: \(patient_preference), item_description: \(item_description), specifics: \(specifics), time: \(time), start_time: \(start_time), end_time: \(end_time), status_code: \(status_code), mood_code: \(mood_code), negation_ind: \(negation_ind), negation_reason: \(negation_reason), oid: \(oid), reason: \(reason), version: \(version), id: \(id), created_at: \(created_at), updated_at: \(updated_at)"
  }
  
}


//new in Swift 2.x with NSObject
// http://mgrebenets.github.io/swift/2015/06/21/equatable-nsobject-with-swift-2/
extension CDAKEntry {
  override open func isEqual(_ object: Any?) -> Bool {
    if let rhs = object as? CDAKEntry {
      return hashValue == rhs.hashValue && CDAKCommonUtility.classNameAsString(self) == CDAKCommonUtility.classNameAsString(rhs)
    }
    return false
  }
}

func == (lhs: CDAKEntry, rhs: CDAKEntry) -> Bool {
  return lhs.hashValue == rhs.hashValue && CDAKCommonUtility.classNameAsString(lhs) == CDAKCommonUtility.classNameAsString(rhs)
}
 
extension CDAKEntry {
  
  //MARK: Additional properties to help with code sets
  var preferred_code_sets: [String] {
    
    if explicit_preferred_code_sets.count > 0 {
      return explicit_preferred_code_sets
    }
    
    switch String(describing: type(of: self)) {
    case "CDAKAllergy": return ["RxNorm"]
    case "CDAKCareGoal": return ["SNOMED-CT"]
    case "CDAKCondition": return ["SNOMED-CT"]
    case "CDAKEncounter": return ["CPT"]
    case "CDAKImmunization": return ["CVX"]
    case "CDAKMedicalEquipment": return ["SNOMED-CT"]
    case "CDAKMedication": return ["RxNorm"]
    case "CDAKProcedure": return ["CPT", "ICD-9-CM", "ICD-10-CM", "HCPCS", "SNOMED-CT"]
    case "CDAKResultValue": return ["LOINC", "SNOMED-CT"]
    case "CDAKLabResult": return ["LOINC", "SNOMED-CT"]
    case "CDAKSocialHistory": return ["SNOMED-CT"]
    case "CDAKVitalSign": return ["LOINC", "SNOMED-CT"] //NOTE - in the original Ruby template they key was "SNOMED"

      
    default: return []
    }
  }

  var code_display : String {
    return ViewHelper.code_display(self, options: ["preferred_code_sets":self.preferred_code_sets])
  }
  
  // MARK: - Mustache marshalling
  var boxedValues: [String:MustacheBox] {
    
    
    //find a preferred term using a specified vocabulary
    // pick the first one - the rest can be translations
    var entry_preferred_code : CDAKCodedEntry?
    var code_system_oid = ""
    if let a_preferred_code = preferred_code(preferred_code_sets) {
      //legacy Ruby approach
      let code_set = a_preferred_code.codeSystem
      code_system_oid = CDAKCodeSystemHelper.oid_for_code_system(code_set)
      entry_preferred_code = a_preferred_code
    }
    var entry_translation_codes: CDAKCodedEntries? = self.codes
    if entry_preferred_code != nil {
      entry_translation_codes = self.translation_codes(self.preferred_code_sets)
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
      
      "status": Box(self.status),
      
      "statusCode_code": self.status != nil && self.status! == "resolved" ? Box("completed") : Box("active"),

      "myType" : Box(String(describing: type(of: self))),
      "preferred_code_sets": Box(self.preferred_code_sets),
      "code_display": Box(code_display),

      "as_point_in_time" : Box(self.as_point_in_time() ?? ""),
      "code_system_oid" : Box(code_system_oid),
      "preferred_code": entry_preferred_code != nil ? Box(entry_preferred_code!) : Box(""),
      "translation_codes": entry_translation_codes != nil ? Box(entry_translation_codes!) : Box([]),
      
      "codes_to_s" : Box(codes_to_s()),
      "times_to_s" : Box(times_to_s()),
      
      "status_code_for" : Box(ViewHelper.status_code_for(self))
    ]
  }
  
  override open var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
}

extension CDAKEntry {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    if codes.count > 0 {
      dict["codes"] = codes.codes.map({$0.jsonDict}) as AnyObject?
    }
    
    if let cda_identifier = cda_identifier {
      dict["cda_identifier"] = cda_identifier.jsonDict as AnyObject?
    }
    if values.count > 0 {
      dict["values"] = values.map({$0.jsonDict}) as AnyObject?
    }
    if references.count > 0 {
      dict["references"] = references.map({$0.jsonDict}) as AnyObject?
    }
    if provider_preference.count > 0 {
      dict["provider_preference"] = provider_preference.map({$0.jsonDict}) as AnyObject?
    }
    if patient_preference.count > 0 {
      dict["patient_preference"] = patient_preference.map({$0.jsonDict}) as AnyObject?
    }
    if let item_description = item_description {
      dict["description"] = item_description as AnyObject?
    }
    if let specifics = specifics {
      dict["specifics"] = specifics as AnyObject?
    }
    if let time = time {
      dict["time"] = time as AnyObject?
    }
    if let start_time = start_time {
      dict["start_time"] = start_time as AnyObject?
    }
    if let end_time = end_time {
      dict["end_time"] = end_time as AnyObject?
    }
    
    if status_code.count > 0 {
      dict["status_code"] = status_code.codes.map({$0.jsonDict}) as AnyObject?
    }
    dict["mood_code"] = mood_code as AnyObject?
    
    if let negation_ind = negation_ind {
      dict["negation_ind"] = negation_ind as AnyObject?
    }
    
    if negation_reason.count > 0 {
      dict["negation_reason"] = negation_reason.codes.map({$0.jsonDict}) as AnyObject?
    }
    
    if let oid = oid {
      dict["oid"] = oid as AnyObject?
    }
    if let reason = reason {
      dict["reason"] = reason.jsonDict as AnyObject?
    }
    if let comment = comment {
      dict["comment"] = comment as AnyObject?
    }
    dict["version"] = version as AnyObject?
    if let id = id {
      dict["id"] = id as AnyObject?
    }
    dict["created_at"] = created_at.description as AnyObject?
    dict["updated_at"] = updated_at.description as AnyObject?
    
    return dict
  }
 }


