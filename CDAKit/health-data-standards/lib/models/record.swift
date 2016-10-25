//
//  record.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
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

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


public struct code_and_name {
  var code: String
  var name: String
}

/**
Primary container for all patient data that is to be represented with CDA
 
 When creating this record, you may wish to supply a custom header (CDAKQRDAHeader) or during CDA XML generation a default boilerplate header will be applied
 
 
 ```swift
 
 let doc = ((supply your CDA XML string))
 
 do {
   //let's try to import from CDA
   let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
 
   //let's create a new vital
   // use the coded values to govern "meaning" (height, weight, BMI, BP items, etc.)
   let aVital = CDAKVitalSign()
   aVital.codes.addCodes("LOINC", codes: ["3141-9"]) //weight
   aVital.values.append(CDAKPhysicalQuantityResultValue(scalar: 155.0, units: "lb"))
   aVital.start_time = NSDate().timeIntervalSince1970
   aVital.end_time = NSDate().timeIntervalSince1970
 
   //append our height to our record
   record.vital_signs.append(aVital)
 
   //render from our model to CDA - format set to .ccda (could also do .c32)
   print(record(inFormat: .ccda))
 }
 catch {
   //do something
 }
 
 ```
 
*/
open class CDAKRecord: NSObject, NSCopying, CDAKPropertyAddressable {

  // MARK: CDA properties
  ///patient prefix (was title)
  open var prefix: String?
  ///patient first / given name
  open var first: String?
  ///patient last / family name
  open var last: String?
  ///patient suffix
  open var suffix: String?
  ///patient gender. Please consider using an HL7 Administrative Gender
  open var gender: String?
  ///birthdate (using time since 1970)
  open var birthdate: Double?
  ///date of death (using time since 1970)
  open var deathdate: Double?
  ///religious affiliation(s)
  open var religious_affiliation: CDAKCodedEntries = CDAKCodedEntries()
  ///effective time for record (not date created - date last valid)
  open var effective_time: Double?
  
  ///global unique identifier for record. Defaulted.
  open var _id: String = UUID().uuidString
  
  /**
  When creating this record, you may wish to supply a custom header (CDAKQRDAHeader) or during CDA XML generation a default boilerplate header will be applied

    Should you wish to apply a header across all records, you can specify one in `CDAKGlobals.sharedInstance.CDAKDefaultMetadata`
   
   Optionally, you can disable the global header import by toggling `disableGlobalHeader`
   */
  open var header: CDAKQRDAHeader? {
    get {
      if let local_header = _header {
        return local_header
      }
      if disableGlobalHeader == true {
        return nil
      }
      return CDAKGlobals.sharedInstance.CDAKDefaultMetadata
    }
    set {
      _header = newValue
    }
  }
  fileprivate var _header: CDAKQRDAHeader?

  ///Allows you to toggle whether the global header is completely disabled for this record
  open var disableGlobalHeader = false
  
  // FIX_ME:  - apparently the JSON has "pregnancies" as its own item
  // that's not on the dx or problem list (which makes sense - sort of)
  // but this isn't relfected in the base model
  // figure out where this is coming from and how to handle
  // for now, making it an "entry"
  ///any known patient pregnancies
  open var pregnancies: [CDAKEntry] = []
  
  // CHANGED: - race / ethnicity really should be a multi-value fields. Original did NOT do this
  // MU2 allows for multiple
  ///patient race (coded)
  open var race: CDAKCodedEntries = CDAKCodedEntries()
  ///patient ethnicities (coded)
  open var ethnicity: CDAKCodedEntries = CDAKCodedEntries()
  ///patient languages (coded)
  open var languages: [CDAKCodedEntries] = [] //Array, default: []
  ///patient martial status (coded)
  open var marital_status: CDAKCodedEntries = CDAKCodedEntries()
  ///patient medical record number
  open var medical_record_number: String?
  ///patient medical record assigner
  open var medical_record_assigner: String?
  ///is patient expired? (deceased)
  open var expired: Bool?
  
  //NOT IN MODEL
  ///is this patient a clinical trial participant? Please refer to CMS guidance on implications
  open var clinicalTrialParticipant: Bool? //NOT in model, but in Mongo JSON (probably for QRDA)
  ///name of record custodian?
  open var custodian: String? //NOT in model, but in Mongo JSON (probably for QRDA)
  ///any patient identifiers.  This may include collections of MRNs if you use multiple EMRs, etc.  Could conceivably include identifiers like SSN
  open var identifiers: [CDAKCDAIdentifier] = [] // NOT in the orignal model, but we want to have these on hand
  
  fileprivate var _addresses = [CDAKAddress]() //, as: :locatable
  ///patient addresses
  open var addresses: [CDAKAddress] {
    get {return _addresses}
    set {
//      for c in newValue {
//        c.record = self
//      }
      _addresses = newValue
    }
  }
  
  fileprivate var _telecoms = [CDAKTelecom]() //, as: :contactable
  ///patient telecoms
  open var telecoms: [CDAKTelecom] {
    get {return _telecoms}
    set {
//      for c in newValue {
//        c.record = self
//      }
      _telecoms = newValue
    }
  }

  
  ///Determines whether patient is currently over the age of 18
  open var over_18: Bool {
    //Time.at(birthdate) < Time.now.years_ago(18)
    guard let birthdate = birthdate else {
      return false
    }
    
    //http://stackoverflow.com/questions/24723431/swift-days-between-two-nsdates
    let start_date = Date(timeIntervalSince1970: TimeInterval(birthdate))
    let end_date = Date() //now
    
    let cal = Calendar.current
    let year_unit : NSCalendar.Unit = NSCalendar.Unit.year
    let components = (cal as NSCalendar).components(year_unit, from: start_date, to: end_date, options: [])
    
    if components.year >= 18 {
      return true
    }
    
    return false
  }
  
  // I don't know a better way to do this, so ...
  // For a given entry we create, we need a way to point back to this parent Record
  // When we create an entry and append it to the entry array(s), we create a reference back to this Record

  // MARK: - Collections of child Entries for CDA Sections
  fileprivate var _allergies = [CDAKAllergy]()
  ///Allergies collection
  open var allergies: [CDAKAllergy] {
    get {return _allergies}
    set {
      for c in newValue {
        c.record = self
      }
      _allergies = newValue
    }
  }

  fileprivate var _care_goals = [CDAKEntry]()
  ///This can be any number of different entry types
  open var care_goals: [CDAKEntry] {
    get {return _care_goals}
    set {
      for c in newValue {
        c.record = self
      }
      _care_goals = newValue
    }
  }

  fileprivate var _conditions = [CDAKCondition]()
  ///conditions collection
  open var conditions: [CDAKCondition] {
    get {return _conditions}
    set {
      for c in newValue {
        c.record = self
      }
      _conditions = newValue
    }
  }
  
  fileprivate var _encounters = [CDAKEncounter]()
  ///encounters collection
  open var encounters: [CDAKEncounter] {
    get {return _encounters}
    set {
      for c in newValue {
        c.record = self
      }
      _encounters = newValue
    }
  }
  
  fileprivate var _communications = [CDAKCommunication]()
  ///communications collection
  open var communications: [CDAKCommunication] {
    get {return _communications}
    set {
      for c in newValue {
        c.record = self
      }
      _communications = newValue
    }
  }

  fileprivate var _family_history = [CDAKFamilyHistory]()
  ///family history collection
  open var family_history: [CDAKFamilyHistory] {
    get {return _family_history}
    set {
      for c in newValue {
        c.record = self
      }
      _family_history = newValue
    }
  }
  
  fileprivate var _immunizations = [CDAKImmunization]()
  ///immunizations collection
  open var immunizations: [CDAKImmunization] {
    get {return _immunizations}
    set {
      for c in newValue {
        c.record = self
      }
      _immunizations = newValue
    }
  }
  
  fileprivate var _medical_equipment = [CDAKMedicalEquipment]()
  ///medical equipment collection
  open var medical_equipment: [CDAKMedicalEquipment] {
    get {return _medical_equipment}
    set {
      for c in newValue {
        c.record = self
      }
      _medical_equipment = newValue
    }
  }

  
  fileprivate var _medications = [CDAKMedication]()
  ///medications collection
  open var medications: [CDAKMedication] {
    get {return _medications}
    set {
      for c in newValue {
        c.record = self
      }
      _medications = newValue
    }
  }
  
  fileprivate var _procedures = [CDAKProcedure]()
  ///procedures collection
  open var procedures: [CDAKProcedure] {
    get {return _procedures}
    set {
      for c in newValue {
        c.record = self
      }
      _procedures = newValue
    }
  }
  
  fileprivate var _results = [CDAKLabResult]()//, class_name: "CDAKLabResult"
  ///lab results collection
  open var results: [CDAKLabResult] {
    get {return _results}
    set {
      for c in newValue {
        c.record = self
      }
      _results = newValue
    }
  }
  
  fileprivate var _socialhistories = [CDAKSocialHistory]() //, class_name: "CDAKEntry"
  ///social histories collection
  open var social_history: [CDAKSocialHistory] {
    get { return socialhistories }
    set { socialhistories = newValue }
  }
  var socialhistories: [CDAKSocialHistory] {
    get {return _socialhistories}
    set {
      for c in newValue {
        c.record = self
      }
      _socialhistories = newValue
    }
  }

  fileprivate var _vital_signs = [CDAKVitalSign]()
  ///vital signs collection
  open var vital_signs: [CDAKVitalSign] {
    get {return _vital_signs}
    set {
      for c in newValue {
        c.record = self
      }
      _vital_signs = newValue
    }
  }
  
  fileprivate var _support = [CDAKSupport]()
  ///support collection
  open var support: [CDAKSupport] {
    get {return _support}
    set {
      for c in newValue {
        c.record = self
      }
      _support = newValue
    }
  }

  fileprivate var _advance_directives = [CDAKEntry]() //, class_name: "CDAKEntry"
  ///advance directives collection
  open var advance_directives: [CDAKEntry] {
    get {return _advance_directives}
    set {
      for c in newValue {
        c.record = self
      }
      _advance_directives = newValue
    }
  }
  
  fileprivate var _insurance_providers = [CDAKInsuranceProvider]()
  ///insurance providers collection
  open var insurance_providers: [CDAKInsuranceProvider] {
    get {return _insurance_providers}
    set {
      for c in newValue {
        c.record = self
      }
      _insurance_providers = newValue
    }
  }
  
  fileprivate var _functional_statuses = [CDAKFunctionalStatus]()
  ///functional status collection
  open var functional_statuses: [CDAKFunctionalStatus] {
    get {return _functional_statuses}
    set {
      for c in newValue {
        c.record = self
      }
      _functional_statuses = newValue
    }
  }
  
  //FIX_ME: - I think "provider_performances" shoud be handled differently here
  fileprivate var _provider_performances = [CDAKProviderPerformance]()
  /**
  provider performances collection
   This is really only relevant for QRDA III
   */
  open var provider_performances: [CDAKProviderPerformance] {
    get {return _provider_performances}
    set {
      for c in newValue {
        c.record = self
      }
      _provider_performances = newValue
    }
  }
  

  //MARK: Legacy Ruby
  
  ///list of section identifiers. Legacy Ruby
  fileprivate var Sections = ["allergies", "care_goals", "conditions", "encounters", "immunizations", "medical_equipment",
    "medications", "procedures", "results", "communications", "family_history", "social_history", "vital_signs", "support", "advance_directives",
    "insurance_providers", "functional_statuses"]
  
  ///Legacy Ruby. Search for record(s) by provider.
  internal class func by_provider(_ provider: CDAKProvider, effective_date: Double?) -> [CDAKRecord] {
    // FIX_ME: this is a mess
    var records = [CDAKRecord]()
    if let effective_date = effective_date {
      var a_provider: CDAKProvider?
      a_provider = provider_queries(provider.npi!, effective_date: effective_date)
      for record in CDAKGlobals.sharedInstance.CDAKRecords {
        for perf in record.provider_performances {
          if perf.provider?.npi == a_provider?.npi {
            records.append(record)
          }
        }
      }
    } else {
      //: where('provider_performances.provider_id'=>prov.id)
      for record in CDAKGlobals.sharedInstance.CDAKRecords {
        for perf in record.provider_performances {
          if perf.provider?.npi == provider.npi {
            records.append(record)
          }
        }
      }
    }
    
    return records
  }
  
  //scope :by_patient_id, ->(id) { where(:medical_record_number => id) }
  ///Legacy Ruby. Searches for a patient record by patient MRN
  internal class func by_patient_id(_ id: String) -> [CDAKRecord] {
    //FIX_ME: Should this return just one record?
    var records = [CDAKRecord]()
    for record in CDAKGlobals.sharedInstance.CDAKRecords {
      if record.medical_record_number == id {
        records.append(record)
      }
    }
    return records
  }
  
  ///Legacy Ruby. Determines if a record exists already in the record collection
  internal class func update_or_create(_ data: CDAKRecord) -> CDAKRecord {
    //existing = CDAKRecord.where(medical_record_number: data.medical_record_number).first
    var existing: CDAKRecord?
    for record in CDAKGlobals.sharedInstance.CDAKRecords {
      if record.medical_record_number == data.medical_record_number {
        existing = record
      }
    }
    if var existing = existing {
      //FIX_ME: this is just horribly dangerous
      //kludgy (and probably wrong) work-around for Ruby's being able to just magically copy
      //existing.update_attributes!(data.attributes.except('_id'))
      existing = data.copy() as! CDAKRecord
      return existing
    } else {
      return data
    }
  }

  ///Legacy Ruby. Returns all providers contained in provider performances
  internal func providers() -> [CDAKProvider] {
    return provider_performances.filter({pp in pp.provider != nil}).map({pp in pp.provider!})
  }


    ///returns a specific set of patient entry records based on the supplied section name (if found)
  fileprivate func getSection(_ section: String) -> [CDAKEntry] {
    //FIX_ME: move this into the CDAK helper stuff
    switch section {
    case "allergies" : return allergies
    case "care_goals" : return care_goals
    case "conditions" : return conditions
    case "encounters" : return encounters
    case "immunizations" : return immunizations
    case "medical_equipment" : return medical_equipment
    case "medications" : return medications
    case "procedures" : return procedures
    case "results" : return results
    case "communications" : return communications
    case "family_history" : return family_history
    case "social_history" : return social_history
    case "vital_signs" : return vital_signs
    case "support" : return support
    case "advance_directives" : return advance_directives
    case "insurance_providers" : return insurance_providers
    case "functional_statuses" : return functional_statuses
    default : return [CDAKEntry]()
    }
  }
  
  ///based on the supplied section name (if found), replaces entries with supplied collection
  fileprivate func setSection(_ section: String, entries: [CDAKEntry]) {
      switch section {
      case "allergies" :  allergies = (entries as! [CDAKAllergy])
      case "care_goals" :  care_goals = entries
      case "conditions" :  conditions = (entries as! [CDAKCondition])
      case "encounters" :  encounters = (entries as! [CDAKEncounter])
      case "immunizations" :  immunizations = (entries as! [CDAKImmunization])
      case "medical_equipment" :  medical_equipment = (entries as! [CDAKMedicalEquipment])
      case "medications" :  medications = (entries as! [CDAKMedication])
      case "procedures" :  procedures = (entries as! [CDAKProcedure])
      case "results" :  results = (entries as! [CDAKLabResult])
      case "communications" :  communications = (entries as! [CDAKCommunication])
      case "family_history" :  family_history = (entries as! [CDAKFamilyHistory])
      case "social_history" :  social_history = (entries as! [CDAKSocialHistory])
      case "vital_signs" :  vital_signs = (entries as! [CDAKVitalSign])
      case "support" :  support = (entries as! [CDAKSupport])
      case "advance_directives" :  advance_directives = entries
      case "insurance_providers" :  insurance_providers = (entries as! [CDAKInsuranceProvider])
      case "functional_statuses" :  functional_statuses = (entries as! [CDAKFunctionalStatus])
      default: print("section '\(section)' not found")
      }
  }
  
  ///For a given OID, searches all entries and returns entries with matching OID
  internal func entries_for_oid(_ oid: String) -> [CDAKEntry] {
    //OK, so this appears to be sort of reflecting on the Ruby attributes by "section"
    // EX: section string "allergies" -> looks at object property "allergies"
    // I don't want to start doing wonky things to work around reflection challenges, so I'm just going to 
    // brute force this with a switch statement
    var matching_entries_by_section = [CDAKEntry]()

      
    for section in Sections {
      let entries = getSection(section)
      matching_entries_by_section.append(contentsOf: entries.filter({entry in entry.oid == oid}))

    }
    
    //removed the original "flatten" since we're just merging the contents of the array and not arrays in arrays
    return matching_entries_by_section
  }

  ///Combines all entries into a single collection and returns them
  internal var entries: [CDAKEntry] {
    var all_entries = [CDAKEntry]()
    for section in Sections {
      let entries = getSection(section)
      all_entries.append(contentsOf: entries)
    }
    return all_entries
  }

  /**
  Remove duplicate entries from a section based on cda_identifier or id.

  This method may lose information because it does not compare entries based on clinical content.
  
  Warning: Marked as mutating / "dangerous" in Ruby
  */
  internal func dedup_section_ignoring_content(_ section: String) {
    // http://stackoverflow.com/questions/612189/why-are-exclamation-marks-used-in-ruby-methods
    // In general, methods that end in ! indicate that the method will modify the object it's called on. Ruby calls these "dangerous methods" because they change state that someone else might have a reference to.

    //ok, as I gather here... this should review a given "section" (string reference to a variable like "encounter"
    // or "allergies"
    // from there, it uses the "identifier" (CDAKCDAIdentifier or the id) to determine uniqueness (nothing else)
    // it then tosses out the duplicates and re-sets the given "section" to the new value
    // so - basically - de-dupe the arrays based on the identifier

    //Warning: this is some very ugly, very verbose code...
    // I'm not sure of a better/concise/elegant way of dealing with the typing and "uniq" from Ruby
    var unique_entries = [CDAKEntry]()
    var unique_cda_identifiers = [CDAKCDAIdentifier]()
    var unique_id_identifiers = [String]()
    
      let entries = getSection(section)
      for entry in entries {
        for ref in entry.references {
          ref.resolve_referenced_id()
        }
        if let id = entry.identifier as? CDAKCDAIdentifier {
          if !unique_cda_identifiers.contains(id) {
            unique_cda_identifiers.append(id)
            unique_entries.append(entry)
          }
        } else if let id = entry.identifier as? String {
          if !unique_id_identifiers.contains(id) {
            unique_id_identifiers.append(id)
            unique_entries.append(entry)
          }
        }
      }
      setSection(section, entries: unique_entries)
  }
  
  //
  // yup - this code is even worse than the above - similar, but worse
  /**
    Marked as mutating / dangerous in Ruby
  
  Attempts to determine if there are duplicate entries in the Record and removes any extras.
  */
  internal func dedup_section_merging_codes_and_values(_ section: String) {
    var unique_entries = [String:CDAKEntry]()
              
    let entries = getSection(section)
    for entry in entries {
      for ref in entry.references {
        ref.resolve_referenced_id()
      }
      //ok, so it looks like we're iterating through the entries
      // add if new / not yet added
      // if already added, merge the values
      // "new" is based on the entry identifier
      if unique_entries[entry.identifier_as_string] != nil {
        unique_entries[entry.identifier_as_string]!.codes = mergeCodes(unique_entries[entry.identifier_as_string]!.codes, ar2: entry.codes)
        unique_entries[entry.identifier_as_string]?.values.append(contentsOf: entry.values)
      } else {
        unique_entries[entry.identifier_as_string] = entry
      }
    }
              
    setSection(section, entries: Array(unique_entries.values))
  }
  
  ///DO NOT USE.  Alternate method exists in Coded Entries. Merges codes between two sets of coded entries
  private func mergeCodes(_ ar1: CDAKCodedEntries, ar2: CDAKCodedEntries) -> CDAKCodedEntries {
    var ar1 = ar1
    for (_, CDAKCodedEntry) in ar2 {
      ar1.addCodes(CDAKCodedEntry)
    }
    return ar1
  }
  
  internal func dedup_section(_ section: String) {
    if ["encounters", "procedures", "results"].contains(section) {
      dedup_section_merging_codes_and_values(section)
    } else {
      dedup_section_ignoring_content(section)
    }
  }
  
  internal func dedup_record() {
    for section in Sections {
      dedup_section(section)
    }
  }
  
  // MARK: Health-Data-Standards Functions
  ///Offset all dates by specified double
  func shift_dates(_ date_diff: Double) {
    
    if let birthdate = birthdate {
      self.birthdate = birthdate + date_diff
    }
    if let deathdate = deathdate {
      self.deathdate = deathdate + date_diff
    }
    for pp in provider_performances {
      pp.shift_dates(date_diff)
    }
    for sec in Sections {
      if let property_name = self.propertyNames().filter({$0 == sec}).first {
        if let entries = self.value(forKey: property_name) as? [CDAKEntry] {
          for entry in entries {
            entry.shift_dates(date_diff)
          }
        }
      }
    }
  }
  

  fileprivate class func provider_queries(_ provider_id: String, effective_date: Double) -> CDAKProvider? {
    //FIX_ME: - review implementation for accuracy
    //Making the (probably bad) assumption these return a single value - provider_id assumed to be unique
    // see warning about NPI vs. provider_id on provider_query
    if let provider = provider_query(provider_id, start_before: effective_date, end_before: effective_date) {
      return provider
    }
    if let provider = provider_query(provider_id, start_before: nil, end_before: effective_date) {
      return provider
    }
    if let provider = provider_query(provider_id, start_before: effective_date, end_before: nil) {
      return provider
    }

    return nil
  }

  fileprivate class func provider_query(_ provider_id: String, start_before: Double?, end_before: Double?) -> CDAKProvider? {
    for record in CDAKGlobals.sharedInstance.CDAKRecords {
      for perf in record.provider_performances {
        if let provider = perf.provider {
          if provider.npi == provider_id //bad
            && (perf.start_date == nil || perf.start_date <= start_before)
            && (perf.end_date == nil || perf.start_date >= end_before)
          {
            return provider
          }
        }
      }
    }
    return nil
  }

  // MARK: - Initializers

  required override public init() { // <== Need "required" because we need to call dynamicType() below
    super.init()
    //disabling auto-appending this record to the wrapping collection
    //CDAKGlobals.sharedInstance.CDAKRecords.append(self)
  }
  
  deinit {
    for (index, record) in CDAKGlobals.sharedInstance.CDAKRecords.enumerated() {
      if record == self {
        CDAKGlobals.sharedInstance.CDAKRecords.remove(at: index)
        break
      }
    }
  }
  
  
  // MARK: - Deprecated - Do not use
  ///Do not use - will be removed. Was used in HDS Ruby.
  required public init(event: [String:Any?]) {
    
    super.init()
    
    let times = [
      "birthdate",
      "deathdate"
    ]
    
    for time_key in times {
      if event.keys.contains(time_key) {
        var a_new_time: Double?
        if let time = event[time_key] as? Double {
          a_new_time = time
        }
        if let time = event[time_key] as? String {
          if let time = Double(time) {
            a_new_time = time
          }
        }
        switch time_key {
          case "birthdate": self.birthdate = a_new_time
          case "deathdate": self.deathdate = a_new_time
        default: print("CDAKEntry.init() undefined value setter for key \(time_key)")
        }
      }
    }
    
    
    let ignore_props: [String] = ["birthdate", "deathdate"]

    for (key, value) in event {
      if !ignore_props.contains(key) {
        CDAKUtility.setProperty(self, property: key, value: value)
      }
    }
    
    //CDAKGlobals.sharedInstance.CDAKRecords.append(self)
    
  }
  
  //MARK: Copying
  //http://stackoverflow.com/questions/25808972/how-to-implement-copy-constructor-in-swift-subclass
  open func copy(with zone: NSZone?) -> Any { // <== NSCopying
    // *** Construct "one of my current class". This is why init() is a required initializer
    let theCopy = type(of: self).init()
    
    theCopy.prefix = self.prefix
    theCopy.first = self.first
    theCopy.last = self.last
    theCopy.suffix = self.suffix
    theCopy.gender = self.gender
    theCopy.birthdate = self.birthdate
    theCopy.deathdate = self.deathdate
    theCopy.religious_affiliation = self.religious_affiliation
    theCopy.effective_time = self.effective_time
    theCopy.race = self.race
    theCopy.ethnicity = self.ethnicity
    theCopy.languages = self.languages
    theCopy.marital_status = self.marital_status
    theCopy.medical_record_number = self.medical_record_number
    theCopy.medical_record_assigner = self.medical_record_assigner
    theCopy.expired = self.expired
    theCopy.allergies = self.allergies
    theCopy.care_goals = self.care_goals
    theCopy.conditions = self.conditions
    theCopy.encounters = self.encounters
    theCopy.communications = self.communications
    theCopy.family_history = self.family_history
    theCopy.immunizations = self.immunizations
    theCopy.medical_equipment = self.medical_equipment
    theCopy.medications = self.medications
    theCopy.procedures = self.procedures
    theCopy.results = self.results
    theCopy.socialhistories = self.socialhistories
    theCopy.vital_signs = self.vital_signs
    theCopy.support = self.support
    theCopy.advance_directives = self.advance_directives
    theCopy.insurance_providers = self.insurance_providers
    theCopy.functional_statuses = self.functional_statuses
    theCopy.provider_performances = self.provider_performances
    theCopy.addresses = self.addresses
    theCopy.telecoms = self.telecoms
    theCopy.clinicalTrialParticipant = self.clinicalTrialParticipant
    theCopy.custodian = self.custodian
    
    return theCopy
  }
  
  
  // MARK: Standard properties
  ///Debugging description

  override open var description : String {
    return "CDAKRecord => prefix: \(prefix), first: \(first), last: \(last), suffix: \(suffix), gender: \(gender), birthdate: \(birthdate), deathdate: \(deathdate), religious_affiliation: \(religious_affiliation), effective_time: \(effective_time), race: \(race), ethnicity: \(ethnicity), languages = \(languages), marital_status: \(marital_status), medical_record_number: \(medical_record_number), medical_record_assigner: \(medical_record_assigner), expired: \(expired), clinicalTrialParticipant: \(clinicalTrialParticipant), allergies: \(allergies), care_goals: \(care_goals), conditions: \(conditions), encounters: \(encounters), communications: \(communications), family_history: \(family_history), immunizations: \(immunizations), medical_equipment: \(medical_equipment), medications: \(medications), procedures: \(procedures), results: \(results), social_history: \(social_history), vital_signs: \(vital_signs), advance_directives: \(advance_directives), insurance_providers: \(insurance_providers), functional_statuses: \(functional_statuses), provider_performances: \(provider_performances), addresses: \(addresses), telecoms: \(telecoms)"
  }

}

