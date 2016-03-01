//
//  coded_entries.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/14/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache


//FIX_ME: this needs serious clean-up. A lot of rendundant and "chatty" stuff going on.

/**

CDAKCodedEntry represents a single coded term for a single vocabulary.

* codeSystem: the key/tag for the vocabulary.  EX: "LOINC" or "SNOMED-CT"
* codeSystemOID: the OID for the vocabulary.  If not supplied, the CodedEntry will attempt to look it up based on the key/tag.
* code: the vocabulary code that represents the individual vocabulary concept.
* displayName: the human-readable concept description

For the following sample:

```
<code code="8302-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Patient Body Height">
```

* codeSystemName: `LOINC`
* codeSystem: `2.16.840.1.113883.6.1`
* code: `8302-2`
* displayName: `Patient Body Height`

*/
public struct CDAKCodedEntry: CustomStringConvertible, Equatable, Hashable {
  
  //MARK: Standard properties
  ///Key for the code system. EX: "LOINC"
  public var codeSystem: String
  ///The specific vocabulary code for the term
  public var code: String
  
  private var _displayName: String?
  ///the human-readable description for the term
  public var displayName: String? {
    get {
      return _displayName
    }
    set {
      if let newValue = newValue {
        _displayName = newValue
      }
    }
  }
  
  //used by the XML emitter.  The emitter was struggling with "swift expression too complex," so I'm doing this here to help.  It attempts to provide a human-readable version of a code for the narrative blocks.
  internal var friendlyNarrativeDescription: String {
    return "\(code)\(displayName != nil ? (" (" + displayName! + ")") : "")"
  }
  
  private var _codeSystemOid: String?
  /// OID for the specified vocabulary. Optional. Will be automatically looked up by codeSystem key if value is nil
  public var codeSystemOid: String? {
    get {
      if let _codeSystemOid = _codeSystemOid {
        return _codeSystemOid
      }
      return CDAKCodeSystemHelper.oid_for_code_system(self.codeSystem)
    }
    set {
      _codeSystemOid = newValue
    }
  }
  
  // MARK: - Initializers
  /**
  Primary initializer.
  - parameter codeSystem: (String) Key for the code system. EX: "LOINC"
  - parameter code: (String) The specific vocabulary code for the term
  - parameter codeSystemOid: (String) OID for the specified vocabulary. Optional. Will be automatically looked up by codeSystem key if not supplied
  - parameter displayName: (String) The human-readable description for the term
  */
  public init(codeSystem: String, code: String, codeSystemOid: String? = nil, displayName: String? = nil) {
    self.codeSystem = codeSystem
    self.code = code
    self.codeSystemOid = codeSystemOid
    self.displayName = displayName
    CDAKCodeSystemHelper.addCodeSystem(codeSystem, oid: codeSystemOid)
  }

  // MARK: Standard properties
  ///Debugging description
  public var description: String {
    return ("codeSystem: \(codeSystem), codeSystemOid: \(codeSystemOid), code: \(code), displayName: \(displayName)")
  }
  
  ///hash value
  public var hashValue: Int {
    // Removing the code system OID portion of the comparison
    // There are situations where CDAK equates these as "the same," but we might
    //   have an OID in one, but not another
    // The original Ruby CDAK would see these as "the same" so we're following that
    //return "\(codeSystemOid ?? codeSystem)\(code)".hashValue
    return "\(codeSystem)\(code)".hashValue
    //we need a better way to do this.  If we use OIDs, for things like CVX with OID aliases, we get mismatches with the same code key/tag. But... we can also have different code keys/tags for the same OID. We should probably expand the OID aliases (and term aliases) then return all matches - then use those in the hash.
  }
  
  
}

//Equality comparison for a single Coded Entry
public func == (lhs: CDAKCodedEntry, rhs: CDAKCodedEntry) -> Bool {
  return lhs.hashValue == rhs.hashValue
}

extension CDAKCodedEntry: MustacheBoxable {
  // MARK: - Mustache marshalling
  var boxedValues: [String:MustacheBox] {
    return [
      "codeSystem" :  Box(self.codeSystem),
      "codeSystemOid" :  Box(self.codeSystemOid),
      "code" :  Box(self.code),
      "displayName": Box(displayName)
    ]
  }
  public var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
}


extension CDAKCodedEntry: CDAKJSONExportable {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]

    dict["codeSystem"] = codeSystem
    if let codeSystemOid = codeSystemOid {
      dict["codeSystemOid"] = codeSystemOid
    }
    if let displayName = displayName {
      dict["displayName"] = displayName
    }
    dict["code"] = code

    return dict
  }
}

/**
 Represents a collection of vocabulary concepts for an entry.
 
 * Spans multiple vocabularies
 * For a single vocabulary, can have multiple vocabulary codes

 Example:
 --

 * LOINC
   * LOINC | 2.16.840.1.113883.6.1 | 8302-2 | Patient Body Height
 * SNOMED-CT
   * SNOMED | 2.16.840.1.113883.6.96 | 50373000 | Body Height
 
 
*/
public struct CDAKCodedEntries: CustomStringConvertible, SequenceType, CollectionType, Equatable, Hashable {
  
  //MARK: Dictionary Generator properties and methods
  public func generate() -> DictionaryGenerator<String, [CDAKCodedEntry]> {
    return entries.generate()
  }
  
  public typealias Index = Dictionary<String, [CDAKCodedEntry]>.Index
  public typealias _Element = (String, [CDAKCodedEntry])
  public var startIndex: Index {get { return entries.startIndex }}
  public var endIndex: Index {get { return entries.endIndex }}
  ///provides access to coded entries by vocabulary key/tag
  public subscript(_i: Index) -> _Element {get { return entries[_i] }}
  ///first entry
  public var first: _Element? { get {return entries.first} }
  ///number of entries
  public var count: Int { get {return entries.count} }
  ///vocabulary system keys/tags
  public var keys: [String] { return codeSystems }
  
  private var _codeSystems: Set<String> = Set<String>()
  private var entries: [String:[CDAKCodedEntry]] = [:]
  
  ///All vocabulary code system keys/tags used in current entries
  public var codeSystems: [String] {
    get { return Array(_codeSystems) }
    //set { _codeSystems = Set(newValue) }
  }
  
  ///Returns all entries across all vocabularies
  public var codes: [CDAKCodedEntry] {
    get { return entries.flatMap({$0.1}) }
  }
  
  ///If you need to manage the notion of preferred codes or translation codes at the code level (as opposed to the entry level), then you can do so by supplying a list of code system keys/tags as Strings. EX: "LOINC", "SNOMED-CT".  These will then be "preferred" code systems.
  public var preferred_code_sets: [String] = []

  ///If you have supplied preferred code sets, you can then export the first matching preferred term for that set of code sets
  public var preferred_code: CDAKCodedEntry? {
    get {
      return entries.flatMap({$0.1}).filter({preferred_code_sets.contains($0.codeSystem)}).sort({$0.0.code < $0.1.code}).first
    }
  }
  
  ///If you have supplied preferred code sets, you can emit the list of translation codes for the entry
  public var translation_codes: [CDAKCodedEntry] {
    get {
      return entries.flatMap({$0.1}).filter({$0 != preferred_code})
    }
  }
  
//  var entry_preferred_code : CDAKCodedEntry?
//  var code_system_oid = ""
//  if let a_preferred_code = preferred_code(preferred_code_sets) {
//    //legacy Ruby approach
//    let code_set = a_preferred_code.codeSystem
//    code_system_oid = CDAKCodeSystemHelper.oid_for_code_system(code_set)
//    entry_preferred_code = a_preferred_code
//  }
//  var entry_translation_codes: CDAKCodedEntries? = self.codes
//  if entry_preferred_code != nil {
//  entry_translation_codes = self.translation_codes(self.preferred_code_sets)
//  }
  
  
  //MARK: Initializers
  ///Basic initializer
  public init(){}
  /**
   Basic initializer
   
   - parameter codeSystem: the vocabulary key/tag.  EX: "SNOMED-CT"
   - parameter code: the vocabulary concept code
   - parameter codeSystemOid: the OID associated with the vocabulary. If it is not supplied, the OID will be looked up based on the supplied vocabulary codeSystem
   - parameter displayName: the human-readable concept description
  */
  public init(codeSystem:String, code: String, codeSystemOid: String? = nil, displayName: String? = nil){
    addCodes(codeSystem, code: code, codeSystemOid: codeSystemOid, displayName: displayName)
  }
  /**
   Basic initializer
   
   - parameter entries: Accepts an array of coded entries
  */
  public init(entries: [CDAKCodedEntry]) {
    for entry in entries {
      addCodes(entry.codeSystem, code: entry.code, codeSystemOid: entry.codeSystemOid, displayName: entry.displayName)
    }
  }
  /**
   Basic initializer
   
   - parameter entry: Accepts an optional coded entry
   */
  public init(entry: CDAKCodedEntry?) {
    if let entry = entry {
      addCodes(entry.codeSystem, code: entry.code, codeSystemOid: entry.codeSystemOid, displayName: entry.displayName)
    }
  }
  
  ///Subscript to return all coded entries based on vocabulary key/tag
  public subscript(codeSystem: String) -> [CDAKCodedEntry]? {
    get {
      return self.entries[codeSystem]
    }
    set(newValue) {
      if newValue == nil {
        self.entries.removeValueForKey(codeSystem)
        self._codeSystems = Set(self.codeSystems.filter {$0 != codeSystem})
        return
      }
      
      let oldValue = self.entries.updateValue(newValue!, forKey: codeSystem)
      if oldValue == nil {
        self._codeSystems.insert(codeSystem)
      }
    }
  }
  
  // we may want to remove a bunch of entries from a set
  mutating func removeCodes(foundInEntries set1: CDAKCodedEntries) {
    if let matchingCodes = findIntersectingCodedEntries(forCodedEntries: set1) {
      for c in matchingCodes {
        if let index = entries[c.codeSystem]!.indexOf(c) {
          entries[c.codeSystem]!.removeAtIndex(index)
        }
      }
    }
  }
  
   /**
   Add a code to the vocabulary collection
   - parameter entries: an array of coded entries
   */
  mutating public func addCodes(entries: [CDAKCodedEntry]) {
    for entry in entries {
      addCodes(entry.codeSystem, code: entry.code, codeSystemOid: entry.codeSystemOid, displayName: entry.displayName)
    }
  }

  /**
   Add a code to the vocabulary collection
   - parameter entries: an optional coded entry
   */
  mutating public  func addCodes(entry: CDAKCodedEntry?) {
    if let entry = entry {
      addCodes(entry.codeSystem, code: entry.code, codeSystemOid: entry.codeSystemOid, displayName: entry.displayName)
    }
  }

  /**
   Primary method to add a code to the vocabulary collection
   
   If a code with the same vocabulary key/tag and code already exists and the new description is non-nil, this will overwrite the existing description with the new one.

   - parameter codeSystem: the vocabulary key/tag.  EX: "SNOMED-CT"
   - parameter code: the vocabulary concept code
   - parameter codeSystemOid: the OID associated with the vocabulary. If it is not supplied, the OID will be looked up based on the supplied vocabulary codeSystem
   - parameter displayName: the human-readable concept description
   */
  mutating public  func addCodes(codeSystem: String, code: String, codeSystemOid: String? = nil, displayName: String? = nil) {
    //primary function for adding codes
    var aNewCode = CDAKCodedEntry(codeSystem: codeSystem, code: code, codeSystemOid: codeSystemOid, displayName: displayName)
    
    self._codeSystems.insert(codeSystem)
    
    if self.entries[codeSystem] != nil {
      if let index = entries[codeSystem]!.indexOf(aNewCode) {
        // this code is already in the collection, so we're going to see if the description is populated
        // if the old term has a displayName and this one is nil, then we're going to keep the old term
        // otherwise, we're going to overwrite whatever exists with this term instead
        print("this code already exists")
        
        if let displayName = entries[codeSystem]![index].displayName {
          aNewCode.displayName = displayName
        }
        entries[codeSystem]![index] = aNewCode
        
      } else {
        self.entries[codeSystem]?.append(aNewCode)
      }
    } else {
      //add new code system key and then add term
      self.entries[codeSystem] = [aNewCode]
    }
    
  }
  /**
   Evaluates existing entries to determine if the supplied concept key/tag and code already exist in the entry collection
   
   - parameter withCodeSystem (codeSystem): the vocabulary key/tag.  EX: "SNOMED-CT"
   - parameter andCode (code): the vocabulary concept code

  */
  public func containsCode(withCodeSystem codeSystem: String, andCode code: String) -> Bool {
    if let ces = entries[codeSystem]?.contains(CDAKCodedEntry(codeSystem: codeSystem, code: code)){
      return ces
    }
    return false
  }
  
  /**
   Evaluates existing entries to determine if the supplied concept already exists in the entry collection
   
   - parameter codedEntry: the concept you wish to compare against the existing entry collection
   
   */
  public func containsCode(codedEntry: CDAKCodedEntry) -> Bool {
    if let ces = entries[codedEntry.codeSystem]?.contains(codedEntry){
      return ces
    }
    return false
  }
  
  /**
   Searches all codeded entries for a match of the specified vocabulary and codes
   - parameter forCodeSystem: (String) key for code system. EX: "LOINC"
   - parameter matchingCodes: [String] array of strings for code values
   - returns: an array of CDAKCodedEntry containing the specified codeSystem:code(s)
   */
  public func findIntersectingCodedEntries(forCodeSystem codeSystem: String, matchingCodes codes:[String]) -> [CDAKCodedEntry]? {
    if let someEntries = entries[codeSystem] {
      return someEntries.filter({ entry in codes.contains(entry.code)})
    }
    return nil
  }
  
  /**
   Searches all codeded entries for a match of the specified vocabulary and codes
   - parameter forCodedEntries: Array of [CDAKCodedEntry]
   - returns: an array of CDAKCodedEntry containing the specified codeSystem:code(s)
   */
  public func findIntersectingCodedEntries(forCodedEntries matching:[CDAKCodedEntry]?) -> [CDAKCodedEntry]? {
    if let matching = matching {
      return matching.filter({m in codes.contains(m)})
    }
    return nil
  }
  
  /**
   Searches all codeded entries for a match of the specified vocabulary and codes
   - parameter forCodedEntries: CDAKCodedEntries
   - returns: an array of CDAKCodedEntry containing the specified codeSystem:code(s)
   */
  public func findIntersectingCodedEntries(forCodedEntries ces:CDAKCodedEntries?) -> [CDAKCodedEntry]? {
    if let ces = ces {
      return findIntersectingCodedEntries(forCodedEntries: ces.codes)
    }
    return nil
  }
  
  /**
   Counts all distinct entries across all vocabularies.  Where `count` would return the number of vocabulary keys/tags, `numberOfDistinctCodes` returns the number of distinct codes.
  */
  public var numberOfDistinctCodes: Int {
    return entries.flatMap({$0.1}).count
  }
  
  
  // MARK: Standard properties
  ///Debugging description
  public var description: String {
    return (self.entries.description)
  }
  
  ///hash value
  public var hashValue: Int {
    var a_hash: Int = 0
    for code in codes {
      a_hash = a_hash ^ code.hashValue
    }
    return a_hash
  }
  

  
}

//Equality comparison for CodedEntries
public func == (lhs: CDAKCodedEntries, rhs: CDAKCodedEntries) -> Bool {
  return lhs.hashValue == rhs.hashValue
}


extension CDAKCodedEntries: MustacheBoxable {
  // MARK: - Mustache marshalling
  public var mustacheBox: MustacheBox {
    return Box(codes.map({Box($0)}))
  }
}

extension CDAKCodedEntries {
  ///Marshalles preferred_code and translation_codes so we can more easily reuse them in Mustache templates
  public var boxedPreferredAndTranslatedCodes: MustacheBox {
    get {
      var codes: [String:MustacheBox] = [:]
      codes["preferred_code"] = Box(preferred_code)
      codes["translation_codes"] = Box(translation_codes)
      return Box(codes)
    }
  }
}

extension CDAKCodedEntries: CDAKJSONExportable {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]

    dict["entries"] = codes.map({$0.jsonDict})

    return dict
  }
}
