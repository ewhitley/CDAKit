//
//  record.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

struct code_and_name {
  var code: String
  var name: String
}

class HDSRecord: NSObject, NSCopying, HDSPropertyAddressable {
  
  //include Mongoid::Attributes::Dynamic
  //extend Memoist

  var title: String?
  var first: String?
  var last: String?
  var gender: String?
  var birthdate: Double?
  var deathdate: Double?
  var religious_affiliation: HDSCodedEntries = HDSCodedEntries()
  var effective_time: Double?
  
  var _id: String = NSUUID().UUIDString

  //MARK: FIXME - apparently the JSON has "pregnancies" as its own item
  // that's not on the dx or problem list (which makes sense - sort of)
  // but this isn't relfected in the base model
  // figure out where this is coming from and how to handle
  // for now, making it an "entry"
  var pregnancies: [HDSEntry] = []
  
  //MARK: FIXME - race / ethnicity really should be a multi-value fields
  // MU2 allows for multiple
  var race: HDSCodedEntries = HDSCodedEntries()
  var ethnicity: HDSCodedEntries = HDSCodedEntries()
  
  var languages: [HDSCodedEntries] = [] //Array, default: []

  //MARK: FIXME - not sure this is used
  //var test_id: BSON::ObjectId
  var marital_status: HDSCodedEntries = HDSCodedEntries()
  var medical_record_number: String?
  var medical_record_assigner: String?
  var expired: Bool?
  
  //NOT IN MODEL
  var clinicalTrialParticipant: Bool? //NOT in model, but in Mongo JSON (probably for QRDA)
  //var custodian: String? //NOT in model, but in Mongo JSON (probably for QRDA)
  
  //index "last" => 1
  //index medical_record_number: 1
  //index test_id: 1
  //index bundle_id: 1
  private var _allergies = [HDSAllergy]()
  var allergies: [HDSAllergy] {
    get {return _allergies}
    set {
      for c in newValue {
        c.record = self
      }
      _allergies = newValue
    }
  }

  private var _care_goals = [HDSEntry]() // , class_name: "HDSEntry" # This can be any number of different entry types
  var care_goals: [HDSEntry] {
    get {return _care_goals}
    set {
      for c in newValue {
        c.record = self
      }
      _care_goals = newValue
    }
  }

  private var _conditions = [HDSCondition]()
  var conditions: [HDSCondition] {
    get {return _conditions}
    set {
      for c in newValue {
        c.record = self
      }
      _conditions = newValue
    }
  }
  
  private var _encounters = [HDSEncounter]()
  var encounters: [HDSEncounter] {
    get {return _encounters}
    set {
      for c in newValue {
        c.record = self
      }
      _encounters = newValue
    }
  }
  
  private var _communications = [HDSCommunication]()
  var communications: [HDSCommunication] {
    get {return _communications}
    set {
      for c in newValue {
        c.record = self
      }
      _communications = newValue
    }
  }

  private var _family_history = [HDSFamilyHistory]()
  var family_history: [HDSFamilyHistory] {
    get {return _family_history}
    set {
      for c in newValue {
        c.record = self
      }
      _family_history = newValue
    }
  }
  
  private var _immunizations = [HDSImmunization]()
  var immunizations: [HDSImmunization] {
    get {return _immunizations}
    set {
      for c in newValue {
        c.record = self
      }
      _immunizations = newValue
    }
  }
  
  private var _medical_equipment = [HDSMedicalEquipment]()
  var medical_equipment: [HDSMedicalEquipment] {
    get {return _medical_equipment}
    set {
      for c in newValue {
        c.record = self
      }
      _medical_equipment = newValue
    }
  }

  
  private var _medications = [HDSMedication]()
  var medications: [HDSMedication] {
    get {return _medications}
    set {
      for c in newValue {
        c.record = self
      }
      _medications = newValue
    }
  }
  
  private var _procedures = [HDSProcedure]()
  var procedures: [HDSProcedure] {
    get {return _procedures}
    set {
      for c in newValue {
        c.record = self
      }
      _procedures = newValue
    }
  }
  
  private var _results = [HDSLabResult]()//, class_name: "HDSLabResult"
  var results: [HDSLabResult] {
    get {return _results}
    set {
      for c in newValue {
        c.record = self
      }
      _results = newValue
    }
  }
  
  private var _socialhistories = [HDSSocialHistory]() //, class_name: "HDSEntry"
  var social_history: [HDSSocialHistory] {
    get { return socialhistories }
    set { socialhistories = newValue }
  }
  var socialhistories: [HDSSocialHistory] {
    get {return _socialhistories}
    set {
      for c in newValue {
        c.record = self
      }
      _socialhistories = newValue
    }
  }

  private var _vital_signs = [HDSVitalSign]()
  var vital_signs: [HDSVitalSign] {
    get {return _vital_signs}
    set {
      for c in newValue {
        c.record = self
      }
      _vital_signs = newValue
    }
  }
  
  private var _support = [HDSSupport]()
  var support: [HDSSupport] {
    get {return _support}
    set {
      for c in newValue {
        c.record = self
      }
      _support = newValue
    }
  }

  private var _advance_directives = [HDSEntry]() //, class_name: "HDSEntry"
  var advance_directives: [HDSEntry] {
    get {return _advance_directives}
    set {
      for c in newValue {
        c.record = self
      }
      _advance_directives = newValue
    }
  }
  
  private var _insurance_providers = [HDSInsuranceProvider]()
  var insurance_providers: [HDSInsuranceProvider] {
    get {return _insurance_providers}
    set {
      for c in newValue {
        c.record = self
      }
      _insurance_providers = newValue
    }
  }
  
  private var _functional_statuses = [HDSFunctionalStatus]()
  var functional_statuses: [HDSFunctionalStatus] {
    get {return _functional_statuses}
    set {
      for c in newValue {
        c.record = self
      }
      _functional_statuses = newValue
    }
  }
  
  //MARK: FIXME - I think "provider_performances" shoud be handled differently here
  private var _provider_performances = [HDSProviderPerformance]()
  var provider_performances: [HDSProviderPerformance] {
    get {return _provider_performances}
    set {
      for c in newValue {
        c.record = self
      }
      _provider_performances = newValue
    }
  }
  
  private var _addresses = [HDSAddress]() //, as: :locatable
  var addresses: [HDSAddress] {
    get {return _addresses}
    set {
      for c in newValue {
        c.record = self
      }
      _addresses = newValue
    }
  }
  
  private var _telecoms = [HDSTelecom]() //, as: :contactable
  var telecoms: [HDSTelecom] {
    get {return _telecoms}
    set {
      for c in newValue {
        c.record = self
      }
      _telecoms = newValue
    }
  }

  
  var Sections = ["allergies", "care_goals", "conditions", "encounters", "immunizations", "medical_equipment",
    "medications", "procedures", "results", "communications", "family_history", "social_history", "vital_signs", "support", "advance_directives",
    "insurance_providers", "functional_statuses"]
  
  
  //MARK: FIXME - BAD implementation
  // this is a mess
  class func by_provider(provider: HDSProvider, effective_date: Double?) -> [HDSRecord] {
    var records = [HDSRecord]()
    if let effective_date = effective_date {
      var a_provider: HDSProvider?
      a_provider = provider_queries(provider.npi!, effective_date: effective_date)
      for record in HDSRecords {
        for perf in record.provider_performances {
          if perf.provider?.npi == a_provider?.npi {
            records.append(record)
          }
        }
      }
    } else {
      //: where('provider_performances.provider_id'=>prov.id)
      for record in HDSRecords {
        for perf in record.provider_performances {
          if perf.provider?.npi == provider.npi {
            records.append(record)
          }
        }
      }
    }
    
    return records
  }
  
  //MARK: FIXME - Should this return just one record?
  //scope :by_patient_id, ->(id) { where(:medical_record_number => id) }
  class func by_patient_id(id: String) -> [HDSRecord] {
    var records = [HDSRecord]()
    for record in HDSRecords {
      if record.medical_record_number == id {
        records.append(record)
      }
    }
    return records
  }
  
  
  class func update_or_create(data: HDSRecord) -> HDSRecord {
    //existing = HDSRecord.where(medical_record_number: data.medical_record_number).first
    var existing: HDSRecord?
    for record in HDSRecords {
      if record.medical_record_number == data.medical_record_number {
        existing = record
      }
    }
    if var existing = existing {
      //MARK: FIXME - this is just horribly dangerous
      //kludgy (and probably wrong) work-around for Ruby's being able to just magically copy
      //existing.update_attributes!(data.attributes.except('_id'))
      existing = data.copy() as! HDSRecord
      return existing
    } else {
      return data
    }
  }
  
  func providers() -> [HDSProvider] {
    return provider_performances.filter({pp in pp.provider != nil}).map({pp in pp.provider!})
  }

  var over_18: Bool {
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
  
  
  //MARK: FIXME - move this into the HDS helper stuff
  func getSection(section: String) -> [HDSEntry] {
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
    default : return [HDSEntry]()
    }
  }
  
  func setSection(section: String, entries: [HDSEntry]) {
      switch section {
      case "allergies" :  allergies = (entries as! [HDSAllergy])
      case "care_goals" :  care_goals = entries
      case "conditions" :  conditions = (entries as! [HDSCondition])
      case "encounters" :  encounters = (entries as! [HDSEncounter])
      case "immunizations" :  immunizations = (entries as! [HDSImmunization])
      case "medical_equipment" :  medical_equipment = (entries as! [HDSMedicalEquipment])
      case "medications" :  medications = (entries as! [HDSMedication])
      case "procedures" :  procedures = (entries as! [HDSProcedure])
      case "results" :  results = (entries as! [HDSLabResult])
      case "communications" :  communications = (entries as! [HDSCommunication])
      case "family_history" :  family_history = (entries as! [HDSFamilyHistory])
      case "social_history" :  social_history = (entries as! [HDSSocialHistory])
      case "vital_signs" :  vital_signs = (entries as! [HDSVitalSign])
      case "support" :  support = (entries as! [HDSSupport])
      case "advance_directives" :  advance_directives = entries
      case "insurance_providers" :  insurance_providers = (entries as! [HDSInsuranceProvider])
      case "functional_statuses" :  functional_statuses = (entries as! [HDSFunctionalStatus])
      default: print("section '\(section)' not found")
      }
  }
  
  func entries_for_oid(oid: String) -> [HDSEntry] {
    //OK, so this appears to be sort of reflecting on the Ruby attributes by "section"
    // EX: section string "allergies" -> looks at object property "allergies"
    // I don't want to start doing wonky things to work around reflection challenges, so I'm just going to 
    // brute force this with a switch statement
    var matching_entries_by_section = [HDSEntry]()

      
    for section in Sections {
//      // let's look at all of our Swift object's properties - by name
//      if let property_name = self.propertyNames().filter({$0 == section}).first {
//        //OK, so is this now a property which is typed as an array of HDSEntry?
//        // if so, let's go ahead and pull those out
//        if let entries = self.valueForKey(property_name) as? [HDSEntry] {
//        // now let's see if the individual entries match the OID we're looking for
//          matching_entries_by_section.appendContentsOf(entries.filter({entry in entry.oid == oid}))
//        }
//      }
    
      let entries = getSection(section)
      matching_entries_by_section.appendContentsOf(entries.filter({entry in entry.oid == oid}))

    }
    
    //removed the original "flatten" since we're just merging the contents of the array and not arrays in arrays
    return matching_entries_by_section
  }
  
  
  var entries: [HDSEntry] {
    var all_entries = [HDSEntry]()
    for section in Sections {
//      if let property_name = self.propertyNames().filter({$0 == section}).first {
//        if let entries = self.valueForKey(property_name) as? [HDSEntry] {
//          all_entries.appendContentsOf(entries)
//        }
//      }
      let entries = getSection(section)
      all_entries.appendContentsOf(entries)
    }
    return all_entries
  }
  
  //memoize :entries_for_oid
  //MARK: FIXME - later address lazy + caching
  
  
  //# Remove duplicate entries from a section based on cda_identifier or id.
  //# This method may lose information because it does not compare entries
  //# based on clinical content
  //def dedup_section_ignoring_content!(section)
  // http://stackoverflow.com/questions/612189/why-are-exclamation-marks-used-in-ruby-methods
  // In general, methods that end in ! indicate that the method will modify the object it's called on. Ruby calls these "dangerous methods" because they change state that someone else might have a reference to.

  //marked as mutating / dangerous in Ruby
  func dedup_section_ignoring_content(section: String) {
    //ok, as I gather here... this should review a given "section" (string reference to a variable like "encounter"
    // or "allergies"
    // from there, it uses the "identifier" (HDSCDAIdentifier or the id) to determine uniqueness (nothing else)
    // it then tosses out the duplicates and re-sets the given "section" to the new value
    // so - basically - de-dupe the arrays based on the identifier

    //Warning: this is some very ugly, very verbose code...
    // I'm not sure of a better/concise/elegant way of dealing with the typing and "uniq" from Ruby
    var unique_entries = [HDSEntry]()
    var unique_cda_identifiers = [HDSCDAIdentifier]()
    var unique_id_identifiers = [String]()
    
      let entries = getSection(section)
      for entry in entries {
        for ref in entry.references {
          ref.resolve_referenced_id()
        }
        if let id = entry.identifier as? HDSCDAIdentifier {
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
      
//    if let property_name = self.propertyNames().filter({$0 == section}).first {
//      if let entries = self.valueForKey(property_name) as? [HDSEntry] {
//        for entry in entries {
//          for ref in entry.references {
//            ref.resolve_referenced_id()
//          }
//          //identifier can be a HDSCDAIdentifier or a String?
//          if let id = entry.identifier as? HDSCDAIdentifier {
//            if !unique_cda_identifiers.contains(id) {
//              unique_cda_identifiers.append(id)
//              unique_entries.append(entry)
//            }
//          } else if let id = entry.identifier as? String {
//            if !unique_id_identifiers.contains(id) {
//              unique_id_identifiers.append(id)
//              unique_entries.append(entry)
//            }
//          }
//        }
//      }
//      self.setValue(unique_entries, forKey: property_name)
//    }
  }
  
  //marked as mutating / dangerous in Ruby
  // yup - this code is even worse than the above - similar, but worse
  func dedup_section_merging_codes_and_values(section: String) {
    var unique_entries = [String:HDSEntry]()
              
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

              //    if let property_name = self.propertyNames().filter({$0 == section}).first {
//      if let entries = self.valueForKey(property_name) as? [HDSEntry] {
//        for entry in entries {
//          for ref in entry.references {
//            ref.resolve_referenced_id()
//          }
//          //ok, so it looks like we're iterating through the entries
//          // add if new / not yet added
//          // if already added, merge the values
//          // "new" is based on the entry identifier
//          if unique_entries[entry.identifier_as_string] != nil {
//            unique_entries[entry.identifier_as_string]!.codes = mergeCodes(unique_entries[entry.identifier_as_string]!.codes, ar2: entry.codes)
//            unique_entries[entry.identifier_as_string]?.values.appendContentsOf(entry.values)
//          } else {
//            unique_entries[entry.identifier_as_string] = entry
//          }
//          
//        }
//      }
//      self.setValue(Array(unique_entries.values), forKey: property_name)
//    }
  }
  
  func mergeCodes(var ar1: HDSCodedEntries, ar2: HDSCodedEntries) -> HDSCodedEntries {
//    for (key, value) in ar2 {
//      if ar1[key] != nil {
//        ar1[key]!.appendContentsOf(value)
//        ar1[key] = Array(Set(ar1[key]!))
//      } else {
//        ar1[key] = value
//      }
//    }
    for (_, HDSCodedEntry) in ar2 {
      ar1.addCodes(HDSCodedEntry)
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
        if let entries = self.valueForKey(property_name) as? [HDSEntry] {
          for entry in entries {
            entry.shift_dates(date_diff)
          }
        }
      }
    }
  }
  
  
  //MARK: queries
  
  //MARK: FIXME - no implementation
  //Making the (probably bad) assumption these return a single value - provider_id assumed to be unique
  // see warning about NPI vs. provider_id on provider_query
  class func provider_queries(provider_id: String, effective_date: Double) -> HDSProvider? {

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
  //MARK: FIXME - BAD implementation
  // because we're not using Mongo here we don't really have a "provider_id" the way it's looking for here...
  // I'm going to do a "bad thing" and use NPI for the moment since it's all I've got
  class func provider_query(provider_id: String, start_before: Double?, end_before: Double?) -> HDSProvider? {
    //  def self.provider_query(provider_id, start_before, end_after)
    for record in HDSRecords {
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

  /*


  */
  
  
  //MARK: Shady
  // this is so hacky it hurts
  required override init() { // <== Need "required" because we need to call dynamicType() below
    super.init()
    HDSRecords.append(self)
  }
  
  deinit {
    for (index, record) in HDSRecords.enumerate() {
      if record == self {
        HDSRecords.removeAtIndex(index)
        break
      }
    }
  }
  
  
  required init(event: [String:Any?]) {
    
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
        default: print("HDSEntry.init() undefined value setter for key \(time_key)")
        }
      }
    }
    
    
    let ignore_props: [String] = ["birthdate", "deathdate"]

    for (key, value) in event {
      //ignore the ones we're handling differnetly above
      if !ignore_props.contains(key) {
        HDSUtility.setProperty(self, property: key, value: value)
      }
    }

    
    HDSRecords.append(self)
    
  }
  
  //MARK: Copying
  //http://stackoverflow.com/questions/25808972/how-to-implement-copy-constructor-in-swift-subclass
  func copyWithZone(zone: NSZone) -> AnyObject { // <== NSCopying
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
  
  
  override var description : String {
    return "HDSRecord => title: \(title), first: \(first), last: \(last), gender: \(gender), birthdate: \(birthdate), deathdate: \(deathdate), religious_affiliation: \(religious_affiliation), effective_time: \(effective_time), race: \(race), ethnicity: \(ethnicity), languages = \(languages), marital_status: \(marital_status), medical_record_number: \(medical_record_number), medical_record_assigner: \(medical_record_assigner), expired: \(expired), clinicalTrialParticipant: \(clinicalTrialParticipant), allergies: \(allergies), care_goals: \(care_goals), conditions: \(conditions), encounters: \(encounters), communications: \(communications), family_history: \(family_history), immunizations: \(immunizations), medical_equipment: \(medical_equipment), medications: \(medications), procedures: \(procedures), results: \(results), social_history: \(social_history), vital_signs: \(vital_signs), advance_directives: \(advance_directives), insurance_providers: \(insurance_providers), functional_statuses: \(functional_statuses), provider_performances: \(provider_performances), addresses: \(addresses), telecoms: \(telecoms)"
  }
  
}


extension HDSRecord {
  override var mustacheBox: MustacheBox {
    /*
    var boxValues : [String:MustacheBox] = [:]
    var boxValues = [
      "title": self.title,
      "first": self.first,
      "last": self.last,
      "gender": self.gender,
      //      "birthdate": Box(self.birthdate),
      //      "deathdate": Box(self.deathdate),
      //      "religious_affiliation": Box(self.religious_affiliation),
      //      "effective_time": Box(self.effective_time),
      //      "race": Box(self.race),
      //      "ethnicity": Box(self.ethnicity),
      //      "languages": Box(self.languages),
      //      "marital_status": Box(self.marital_status),
      //      "medical_record_number": Box(self.medical_record_number),
      //      "medical_record_assigner": Box(self.medical_record_assigner),
      //      "expired": Box(self.expired),
      //
      //      "allergies": Box(self.allergies),
      //      "care_goals": Box(self.care_goals),
      //      "conditions": Box(self.conditions),
      //      "encounters": Box(self.encounters),
      //      "communications": Box(self.communications),
      //      "family_history": Box(self.family_history),
      //      "immunizations": Box(self.immunizations),
      //      "medical_equipment": Box(self.medical_equipment),
      //      "medications": Box(self.medications),
      //
      //      "procedures": Box(self.procedures),
      //      "results": Box(self.results),
      //
      //      "social_history": Box(self.social_history),
      //      "socialhistories": Box(self.socialhistories),
      //      "vital_signs": Box(self.vital_signs),
      //      "support": Box(self.support),
      //      "advance_directives": Box(self.advance_directives),
      //      "insurance_providers": Box(self.insurance_providers),
      //
      //      "functional_statuses": Box(self.functional_statuses),
      //      "provider_performances": Box(self.provider_performances),
      //      
      //      "addresses": Box(self.addresses),
      //      "telecoms": Box(self.telecoms)
      
    ]
    return Box(boxValues)
  */
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

      
      //"status": Box(self.export_section_status),
      
      //      "narrative_template" : Box([
      //        "status" : Box(self.export_section_status),
      //        "value": Box(self.export_section_value)
      //        ]),
      //  var export_section_status: Bool? {
      //    switch String(self.dynamicType) {
      //    case "HDSCondition": return true
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
  
  func boxEntries(entries: [HDSEntry], section: String, status: Bool = false, value: Bool = false) -> MustacheBox? {
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



extension HDSRecord {
  
  func export(inFormat format: HDSExport.HDSExportFormat) -> String {
    return HDSExport.export(patientRecord: self, inFormat: format)
  }
  
  convenience init(copyFrom record: HDSRecord) {
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
  
  convenience init?(fromXML doc: String) {
    if let record = HDSImport_BulkRecordImporter.importRecord(doc) {
      self.init(copyFrom: record)
    } else {
      return nil
    }
  }
  
  
}
