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
  
  public var friendlyNarrativeDescription: String {
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
    // return "\(codeSystem)\(codeSystemOid)\(codes)".hashValue
    // NOTE: should go back and fix this.  OID is _REALLY_ the only thing we should be using for comparison, NOT the codeSystem key/tag
    return "\(codeSystem)\(code)".hashValue
  }
  
  
}

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



public struct CDAKCodedEntries: CustomStringConvertible, SequenceType, CollectionType, Equatable, Hashable {
  
  public func generate() -> DictionaryGenerator<String, [CDAKCodedEntry]> {
    return entries.generate()
  }
  
  public typealias Index = Dictionary<String, [CDAKCodedEntry]>.Index
  public typealias _Element = (String, [CDAKCodedEntry])
  public var startIndex: Index {get { return entries.startIndex }}
  public var endIndex: Index {get { return entries.endIndex }}
  public subscript(_i: Index) -> _Element {get { return entries[_i] }}
  public var first: _Element? { get {return entries.first} }
  public var count: Int { get {return entries.count} }
  public var keys: [String] { return codeSystems }
  
  
  private var _codeSystems: Set<String> = Set<String>()
  private var entries: [String:[CDAKCodedEntry]] = [:]
  
  public var codeSystems: [String] {
    get { return Array(_codeSystems) }
    //set { _codeSystems = Set(newValue) }
  }
  
  public var codes: [CDAKCodedEntry] {
    get { return entries.flatMap({$0.1}) }
  }
  
  ///Initializers
  public init(){}
  public init(codeSystem:String, code: String, codeSystemOid: String? = nil){
    addCodes(codeSystem, code: code, codeSystemOid: codeSystemOid)
  }
  public init(entries: [CDAKCodedEntry]) {
    for entry in entries {
      addCodes(entry.codeSystem, code: entry.code, codeSystemOid: entry.codeSystemOid, displayName: entry.displayName)
    }
  }
  public init(entry: CDAKCodedEntry?) {
    if let entry = entry {
      addCodes(entry.codeSystem, code: entry.code, codeSystemOid: entry.codeSystemOid, displayName: entry.displayName)
    }
  }
  
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
  
  mutating public func addCodes(entries: CDAKCodedEntries...) {
    for entry in entries {
      addCodes(entry)
    }
  }
  
  mutating public func addCodes(entries: [CDAKCodedEntry]) {
    for entry in entries {
      addCodes(entry.codeSystem, code: entry.code, codeSystemOid: entry.codeSystemOid, displayName: entry.displayName)
    }
  }

  mutating public  func addCodes(entry: CDAKCodedEntry?) {
    if let entry = entry {
      addCodes(entry.codeSystem, code: entry.code, codeSystemOid: entry.codeSystemOid, displayName: entry.displayName)
    }
  }

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
  
  public func containsCode(withCodeSystem codeSystem: String, andCode code: String) -> Bool {
    if let ces = entries[codeSystem]?.contains(CDAKCodedEntry(codeSystem: codeSystem, code: code)){
      return ces
    }
    return false
  }
  
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


public func == (lhs: CDAKCodedEntries, rhs: CDAKCodedEntries) -> Bool {
  return lhs.hashValue == rhs.hashValue
}


extension CDAKCodedEntries: MustacheBoxable {
  // MARK: - Mustache marshalling
  public var mustacheBox: MustacheBox {
    return Box(codes.map({Box($0)}))
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
