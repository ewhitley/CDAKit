//
//  record.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

public struct code_and_name {
  var code: String
  var name: String
}

public class CDAKRecord: NSObject, NSCopying, CDAKPropertyAddressable {

  public var title: String?
  public var first: String?
  public var last: String?
  public var gender: String?
  public var birthdate: Double?
  public var deathdate: Double?
  public var religious_affiliation: CDAKCodedEntries = CDAKCodedEntries()
  public var effective_time: Double?
  
  public var _id: String = NSUUID().UUIDString

  // FIXME:  - apparently the JSON has "pregnancies" as its own item
  // that's not on the dx or problem list (which makes sense - sort of)
  // but this isn't relfected in the base model
  // figure out where this is coming from and how to handle
  // for now, making it an "entry"
  public var pregnancies: [CDAKEntry] = []
  
  // FIXME: - race / ethnicity really should be a multi-value fields
  // MU2 allows for multiple
  public var race: CDAKCodedEntries = CDAKCodedEntries()
  public var ethnicity: CDAKCodedEntries = CDAKCodedEntries()
  
  public var languages: [CDAKCodedEntries] = [] //Array, default: []

  public var marital_status: CDAKCodedEntries = CDAKCodedEntries()
  public var medical_record_number: String?
  public var medical_record_assigner: String?
  public var expired: Bool?
  
  //NOT IN MODEL
  var clinicalTrialParticipant: Bool? //NOT in model, but in Mongo JSON (probably for QRDA)
  var custodian: String? //NOT in model, but in Mongo JSON (probably for QRDA)
  
  // I don't know a better way to do this, so ...
  // For a given entry we create, we need a way to point back to this parent Record
  // When we create an entry and append it to the entry array(s), we create a reference back to this Record
  private var _allergies = [CDAKAllergy]()
  public var allergies: [CDAKAllergy] {
    get {return _allergies}
    set {
      for c in newValue {
        c.record = self
      }
      _allergies = newValue
    }
  }

  private var _care_goals = [CDAKEntry]()
  ///This can be any number of different entry types
  public var care_goals: [CDAKEntry] {
    get {return _care_goals}
    set {
      for c in newValue {
        c.record = self
      }
      _care_goals = newValue
    }
  }

  private var _conditions = [CDAKCondition]()
  public var conditions: [CDAKCondition] {
    get {return _conditions}
    set {
      for c in newValue {
        c.record = self
      }
      _conditions = newValue
    }
  }
  
  private var _encounters = [CDAKEncounter]()
  public var encounters: [CDAKEncounter] {
    get {return _encounters}
    set {
      for c in newValue {
        c.record = self
      }
      _encounters = newValue
    }
  }
  
  private var _communications = [CDAKCommunication]()
  public var communications: [CDAKCommunication] {
    get {return _communications}
    set {
      for c in newValue {
        c.record = self
      }
      _communications = newValue
    }
  }

  private var _family_history = [CDAKFamilyHistory]()
  public var family_history: [CDAKFamilyHistory] {
    get {return _family_history}
    set {
      for c in newValue {
        c.record = self
      }
      _family_history = newValue
    }
  }
  
  private var _immunizations = [CDAKImmunization]()
  public var immunizations: [CDAKImmunization] {
    get {return _immunizations}
    set {
      for c in newValue {
        c.record = self
      }
      _immunizations = newValue
    }
  }
  
  private var _medical_equipment = [CDAKMedicalEquipment]()
  public var medical_equipment: [CDAKMedicalEquipment] {
    get {return _medical_equipment}
    set {
      for c in newValue {
        c.record = self
      }
      _medical_equipment = newValue
    }
  }

  
  private var _medications = [CDAKMedication]()
  public var medications: [CDAKMedication] {
    get {return _medications}
    set {
      for c in newValue {
        c.record = self
      }
      _medications = newValue
    }
  }
  
  private var _procedures = [CDAKProcedure]()
  public var procedures: [CDAKProcedure] {
    get {return _procedures}
    set {
      for c in newValue {
        c.record = self
      }
      _procedures = newValue
    }
  }
  
  private var _results = [CDAKLabResult]()//, class_name: "CDAKLabResult"
  public var results: [CDAKLabResult] {
    get {return _results}
    set {
      for c in newValue {
        c.record = self
      }
      _results = newValue
    }
  }
  
  private var _socialhistories = [CDAKSocialHistory]() //, class_name: "CDAKEntry"
  public var social_history: [CDAKSocialHistory] {
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

  private var _vital_signs = [CDAKVitalSign]()
  public var vital_signs: [CDAKVitalSign] {
    get {return _vital_signs}
    set {
      for c in newValue {
        c.record = self
      }
      _vital_signs = newValue
    }
  }
  
  private var _support = [CDAKSupport]()
  public var support: [CDAKSupport] {
    get {return _support}
    set {
      for c in newValue {
        c.record = self
      }
      _support = newValue
    }
  }

  private var _advance_directives = [CDAKEntry]() //, class_name: "CDAKEntry"
  public var advance_directives: [CDAKEntry] {
    get {return _advance_directives}
    set {
      for c in newValue {
        c.record = self
      }
      _advance_directives = newValue
    }
  }
  
  private var _insurance_providers = [CDAKInsuranceProvider]()
  public var insurance_providers: [CDAKInsuranceProvider] {
    get {return _insurance_providers}
    set {
      for c in newValue {
        c.record = self
      }
      _insurance_providers = newValue
    }
  }
  
  private var _functional_statuses = [CDAKFunctionalStatus]()
  public var functional_statuses: [CDAKFunctionalStatus] {
    get {return _functional_statuses}
    set {
      for c in newValue {
        c.record = self
      }
      _functional_statuses = newValue
    }
  }
  
  //MARK: FIXME - I think "provider_performances" shoud be handled differently here
  private var _provider_performances = [CDAKProviderPerformance]()
  public var provider_performances: [CDAKProviderPerformance] {
    get {return _provider_performances}
    set {
      for c in newValue {
        c.record = self
      }
      _provider_performances = newValue
    }
  }
  
  private var _addresses = [CDAKAddress]() //, as: :locatable
  public var addresses: [CDAKAddress] {
    get {return _addresses}
    set {
      for c in newValue {
        c.record = self
      }
      _addresses = newValue
    }
  }
  
  private var _telecoms = [CDAKTelecom]() //, as: :contactable
  public var telecoms: [CDAKTelecom] {
    get {return _telecoms}
    set {
      for c in newValue {
        c.record = self
      }
      _telecoms = newValue
    }
  }

  
  public var Sections = ["allergies", "care_goals", "conditions", "encounters", "immunizations", "medical_equipment",
    "medications", "procedures", "results", "communications", "family_history", "social_history", "vital_signs", "support", "advance_directives",
    "insurance_providers", "functional_statuses"]
  
  
  class func by_provider(provider: CDAKProvider, effective_date: Double?) -> [CDAKRecord] {
    // FIXME: this is a mess
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
  class func by_patient_id(id: String) -> [CDAKRecord] {
    //FIXME: Should this return just one record?
    var records = [CDAKRecord]()
    for record in CDAKGlobals.sharedInstance.CDAKRecords {
      if record.medical_record_number == id {
        records.append(record)
      }
    }
    return records
  }
  
  
  class func update_or_create(data: CDAKRecord) -> CDAKRecord {
    //existing = CDAKRecord.where(medical_record_number: data.medical_record_number).first
    var existing: CDAKRecord?
    for record in CDAKGlobals.sharedInstance.CDAKRecords {
      if record.medical_record_number == data.medical_record_number {
        existing = record
      }
    }
    if var existing = existing {
      //FIXME: this is just horribly dangerous
      //kludgy (and probably wrong) work-around for Ruby's being able to just magically copy
      //existing.update_attributes!(data.attributes.except('_id'))
      existing = data.copy() as! CDAKRecord
      return existing
    } else {
      return data
    }
  }
  
  public func providers() -> [CDAKProvider] {
    return provider_performances.filter({pp in pp.provider != nil}).map({pp in pp.provider!})
  }

  public var over_18: Bool {
    //Time.at(birthdate) < Time.now.years_ago(18)
    guard let birthdate = birthdate else {
      return false
    }
    
    //http://stackoverflow.com/questions/24723431/swift-days-between-two-nsdates
    let start_date = NSDate(timeIntervalSince1970: NSTimeInterval(birthdate))
    let end_date = NSDate() //now
    
    let cal = NSCalendar.currentCalendar()
    let year_unit : NSCalendarUnit = NSCalendarUnit.Year
    let components = cal.components(year_unit, fromDate: start_date, toDate: end_date, options: [])

    if components.year >= 18 {
      return true
    }
    
    return false
  }
  
  func getSection(section: String) -> [CDAKEntry] {
    //FIXME: move this into the CDAK helper stuff
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
  
  func setSection(section: String, entries: [CDAKEntry]) {
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
  
  public func entries_for_oid(oid: String) -> [CDAKEntry] {
    //OK, so this appears to be sort of reflecting on the Ruby attributes by "section"
    // EX: section string "allergies" -> looks at object property "allergies"
    // I don't want to start doing wonky things to work around reflection challenges, so I'm just going to 
    // brute force this with a switch statement
    var matching_entries_by_section = [CDAKEntry]()

      
    for section in Sections {
      let entries = getSection(section)
      matching_entries_by_section.appendContentsOf(entries.filter({entry in entry.oid == oid}))

    }
    
    //removed the original "flatten" since we're just merging the contents of the array and not arrays in arrays
    return matching_entries_by_section
  }
  
  
  public var entries: [CDAKEntry] {
    var all_entries = [CDAKEntry]()
    for section in Sections {
      let entries = getSection(section)
      all_entries.appendContentsOf(entries)
    }
    return all_entries
  }
  
  //memoize :entries_for_oid
  //MARK: FIXME - later address lazy + caching
  
  
  /**
  Remove duplicate entries from a section based on cda_identifier or id.

  This method may lose information because it does not compare entries based on clinical content.
  
  Warning: Marked as mutating / "dangerous" in Ruby
  */
  func dedup_section_ignoring_content(section: String) {
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
  
  //marked as mutating / dangerous in Ruby
  // yup - this code is even worse than the above - similar, but worse
  func dedup_section_merging_codes_and_values(section: String) {
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
        unique_entries[entry.identifier_as_string]?.values.appendContentsOf(entry.values)
      } else {
        unique_entries[entry.identifier_as_string] = entry
      }
    }
              
    setSection(section, entries: Array(unique_entries.values))
  }
  
  func mergeCodes(var ar1: CDAKCodedEntries, ar2: CDAKCodedEntries) -> CDAKCodedEntries {
    for (_, CDAKCodedEntry) in ar2 {
      ar1.addCodes(CDAKCodedEntry)
    }
    return ar1
  }
  
  func dedup_section(section: String) {
    if ["encounters", "procedures", "results"].contains(section) {
      dedup_section_merging_codes_and_values(section)
    } else {
      dedup_section_ignoring_content(section)
    }
  }
  
  func dedup_record() {
    for section in Sections {
      dedup_section(section)
    }
  }
  
  
  func shift_dates(date_diff: Double) {
    
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
        if let entries = self.valueForKey(property_name) as? [CDAKEntry] {
          for entry in entries {
            entry.shift_dates(date_diff)
          }
        }
      }
    }
  }
  
  
  class func provider_queries(provider_id: String, effective_date: Double) -> CDAKProvider? {
    //FIXME: - review implementation for accuracy
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

  class func provider_query(provider_id: String, start_before: Double?, end_before: Double?) -> CDAKProvider? {
    //FIXME: - review implementation for accuracy
    // because we're not using Mongo here we don't really have a "provider_id" the way it's looking for here...
    // I'm going to do a "bad thing" and use NPI for the moment since it's all I've got
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
  
  required override public init() { // <== Need "required" because we need to call dynamicType() below
    //FIXME: Shady
    // this is so hacky it hurts
    super.init()
    CDAKGlobals.sharedInstance.CDAKRecords.append(self)
  }
  
  deinit {
    for (index, record) in CDAKGlobals.sharedInstance.CDAKRecords.enumerate() {
      if record == self {
        CDAKGlobals.sharedInstance.CDAKRecords.removeAtIndex(index)
        break
      }
    }
  }
  
  
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
    
    CDAKGlobals.sharedInstance.CDAKRecords.append(self)
    
  }
  
  //MARK: Copying
  //http://stackoverflow.com/questions/25808972/how-to-implement-copy-constructor-in-swift-subclass
  public func copyWithZone(zone: NSZone) -> AnyObject { // <== NSCopying
    // *** Construct "one of my current class". This is why init() is a required initializer
    let theCopy = self.dynamicType.init()
    
    theCopy.title = self.title
    theCopy.first = self.first
    theCopy.last = self.last
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
    
    return theCopy
  }
  
  
  override public var description : String {
    return "CDAKRecord => title: \(title), first: \(first), last: \(last), gender: \(gender), birthdate: \(birthdate), deathdate: \(deathdate), religious_affiliation: \(religious_affiliation), effective_time: \(effective_time), race: \(race), ethnicity: \(ethnicity), languages = \(languages), marital_status: \(marital_status), medical_record_number: \(medical_record_number), medical_record_assigner: \(medical_record_assigner), expired: \(expired), clinicalTrialParticipant: \(clinicalTrialParticipant), allergies: \(allergies), care_goals: \(care_goals), conditions: \(conditions), encounters: \(encounters), communications: \(communications), family_history: \(family_history), immunizations: \(immunizations), medical_equipment: \(medical_equipment), medications: \(medications), procedures: \(procedures), results: \(results), social_history: \(social_history), vital_signs: \(vital_signs), advance_directives: \(advance_directives), insurance_providers: \(insurance_providers), functional_statuses: \(functional_statuses), provider_performances: \(provider_performances), addresses: \(addresses), telecoms: \(telecoms)"
  }
  
}


extension CDAKRecord {
  override public var mustacheBox: MustacheBox {
    var vals: [String:MustacheBox] = [String:MustacheBox]()
    vals = [
      "id": Box(self._id),
      "title": Box(self.title),
      "first": Box(self.first),
      "last": Box(self.last),
      "gender": Box(self.gender),
      "birthdate": Box(self.birthdate),
      "deathdate": Box(self.deathdate),
      "religious_affiliation": Box(self.religious_affiliation),
      "effective_time": Box(self.effective_time),
      "race": Box(self.race),
      "ethnicity": Box(self.ethnicity),
      "languages": self.languages.count > 0 ? Box(self.languages) : Box(["IETF":["en-US"]]),
      "marital_status": Box(self.marital_status),
      "medical_record_number": Box(self.medical_record_number),
      "medical_record_assigner": Box(self.medical_record_assigner),
      "expired": Box(self.expired),
      "addresses": Box(self.addresses),
      "telecoms": Box(self.telecoms)
    ]

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

    
    return Box(vals)
  }
  
  func boxEntries(entries: [CDAKEntry], section: String, status: Bool = false, value: Bool = false) -> MustacheBox? {
    if entries.count > 0 {
      return Box([
        "section" : Box(section),
        "status" : Box(status),
        "value" : Box(value),
        "entries": Box(entries)
        ])
    }
    return nil
  }
  
}



extension CDAKRecord {
  
  public func export(inFormat format: CDAKExport.CDAKExportFormat) -> String {
    return CDAKExport.export(patientRecord: self, inFormat: format)
  }
  
  public convenience init(copyFrom record: CDAKRecord) {
    self.init()
    self.title = record.title
    self.first = record.first
    self.last = record.last
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
  }

  //I don't think I'm doing this right
  public convenience init(fromXML doc: String) throws   {
    let x = try CDAKImport_BulkRecordImporter.importRecord(doc)
    self.init(copyFrom: x)
  }
  
}
