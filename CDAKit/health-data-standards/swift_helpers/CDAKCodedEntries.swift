//
//  coded_entries.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/14/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache


//FIXME: this needs serious clean-up. A lot of rendundant and "chatty" stuff going on.

public struct CDAKCodedTerm: Equatable, Hashable {
  var code: String
  var displayName: String?

  public var hashValue: Int {
    return "\(code)\(displayName)".hashValue
  }

}

public func == (lhs: CDAKCodedTerm, rhs: CDAKCodedTerm) -> Bool {
  return lhs.hashValue == rhs.hashValue
}

extension CDAKCodedTerm: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    dict["code"] = code
    if let displayName = displayName {
      dict["displayName"] = displayName
    }
    
    return dict
  }
}




public struct CDAKCodedEntry: CustomStringConvertible, SequenceType, CollectionType, Equatable, Hashable {
  public var codeSystem: String
  public var codeSystemOid: String?
  public var displayName: String?
  
  private var _codes: [CDAKCodedTerm] = []
  public var codes: [String] {
    get { return _codes.map({$0.code}) }
    set {
      let terms = newValue.map({CDAKCodedTerm(code: $0, displayName: nil)})
      _codes = mergeTermDisplayNames(terms)
    }
  }

  private func uniqueTerms(forTerms terms: [CDAKCodedTerm]) -> [CDAKCodedTerm] {
    var uniqueTerms: [CDAKCodedTerm] = []
    for term in terms {
      if !uniqueTerms.contains(term) {
        uniqueTerms.append(term)
      }
    }
    return uniqueTerms
  }
  
  private func mergeTermDisplayNames(inTerms: [CDAKCodedTerm]) -> [CDAKCodedTerm] {
    //this is slow, but I want to be explicit about what we're doing for the moment
    var mergedTerms: [CDAKCodedTerm] = inTerms
    
    //we already have terms, so some may have descriptions where our existing may not
    // in this case (while not necessarily "right,") we want to retain descriptions wherever we can
    // this is slow and cumbersome
    if _codes.count > 0 {
      for c in _codes {
        for (i, t) in mergedTerms.enumerate() {
          if c.displayName != nil && t.displayName == nil {
            mergedTerms[i].displayName = c.displayName
          }
        }
      }
    }
    
    return uniqueTerms(forTerms: mergedTerms)
  }
  
  public var codedTerms: [CDAKCodedTerm] {
    get { return _codes }
    set { _codes = newValue }
  }
  
  public var code: String? {
    get {
      return codes.first
    }
    set {
      if let newValue = newValue {
        codes = [newValue]
      } else {
        codes = []
      }
    }
  }
  
  public func generate() -> IndexingGenerator<Array<String>> {
    return codes.generate()
  }
  
  public typealias Index = Array<String>.Index
  public typealias _Code = String
  public var startIndex: Index {get { return codes.startIndex }}
  public var endIndex: Index {get { return codes.endIndex }}
  public subscript(_i: Index) -> _Code {get { return codes[_i] }}
  public var first: _Code? { get {return codes.first} }
  public var count: Int { get {return codes.count} }

  
  public init(codeSystem: String, codes: String?, codeSystemOid: String? = nil, displayName: String? = nil) {
    self.codeSystem = codeSystem
    if let code = codes {
      self.codes.append(code)
    }
    if let codeSystemOid = codeSystemOid {
      self.codeSystemOid = codeSystemOid
    }
    self.displayName = displayName
    CDAKCodeSystemHelper.addCodeSystem(codeSystem, oid: codeSystemOid)
  }
  public init(codeSystem: String, codes: [String?]?, codeSystemOid: String? = nil, displayName: String? = nil) {
    self.codeSystem = codeSystem
    if let codes = codes {
      self.codes = codes.filter({$0 != nil}).map({$0!})
    }
    if let codeSystemOid = codeSystemOid {
      self.codeSystemOid = codeSystemOid
    }
    self.displayName = displayName
    CDAKCodeSystemHelper.addCodeSystem(codeSystem, oid: codeSystemOid)
  }
  public init(codeSystem: String, codes: [String?], codeSystemOid: String? = nil, displayName: String? = nil) {
    self.codeSystem = codeSystem
    self.codes = codes.filter({$0 != nil}).map({$0!})
    if let codeSystemOid = codeSystemOid {
      self.codeSystemOid = codeSystemOid
    }
    self.displayName = displayName
    CDAKCodeSystemHelper.addCodeSystem(codeSystem, oid: codeSystemOid)
  }
  public init(codeSystem: String, codes: [String], codeSystemOid: String? = nil, displayName: String? = nil) {
    self.codeSystem = codeSystem
    self.codes = codes
    if let codeSystemOid = codeSystemOid {
      self.codeSystemOid = codeSystemOid
    }
    self.displayName = displayName
    CDAKCodeSystemHelper.addCodeSystem(codeSystem, oid: codeSystemOid)
  }
  public var description: String {
    return ("codeSystem: \(codeSystem), codeSystemOid: \(codeSystemOid), codes: \(codes), displayName: \(displayName)")
  }
  
  public var hashValue: Int {
    // Removing the code system OID portion of the comparison
    // There are situations where CDAK equates these as "the same," but we might
    //   have an OID in one, but not another
    // The original Ruby CDAK would see these as "the same" so we're following that
    //return "\(codeSystem)\(codeSystemOid)\(codes)".hashValue
    return "\(codeSystem)\(codes)".hashValue
  }

  public func containsCode(codeSystem: String, withCode code: String) -> Bool {
    return (self.codeSystem == codeSystem && self.codes.filter({$0 == code}).count > 0) ? true : false
  }



  
}

public func == (lhs: CDAKCodedEntry, rhs: CDAKCodedEntry) -> Bool {
  return lhs.hashValue == rhs.hashValue
}


extension CDAKCodedEntry: MustacheBoxable {
  var boxedValues: [String:MustacheBox] {
    return [
      "codeSystem" :  Box(self.codeSystem),
      "codeSystemOid" :  Box(self.codeSystemOid),
      "codes" :  Box(self.codes)
    ]
  }
  public var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
}


extension CDAKCodedEntry: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    dict["codeSystem"] = codeSystem
    if let codeSystemOid = codeSystemOid {
      dict["codeSystemOid"] = codeSystemOid
    }
    if let displayName = displayName {
      dict["displayName"] = displayName
    }
    dict["codes"] = codedTerms.map({$0.jsonDict})
    
    return dict
  }
}



extension CDAKCodedEntries: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    //dict["entries"] = entries.map({ce in "\"\(ce.0)\":[\(ce.1.map({$0}))]"})
    dict["entries"] = codes.map({$0.jsonDict})
    
    return dict
  }
}

public struct CDAKCodedEntries: CustomStringConvertible, SequenceType, CollectionType, Equatable, Hashable {
  
  public func generate() -> DictionaryGenerator<String, CDAKCodedEntry> {
    return entries.generate()
  }
  
  public typealias Index = Dictionary<String, CDAKCodedEntry>.Index
  public typealias _Element = (String, CDAKCodedEntry)
  public var startIndex: Index {get { return entries.startIndex }}
  public var endIndex: Index {get { return entries.endIndex }}
  public subscript(_i: Index) -> _Element {get { return entries[_i] }}
  public var first: _Element? { get {return entries.first} }
  public var count: Int { get {return entries.count} }
  public var keys: [String] { return codeSystems }

  
  private var _codeSystems: Set<String> = Set<String>()
  private var entries: [String:CDAKCodedEntry] = [:]

  public var codeSystems: [String] {
    get { return Array(_codeSystems) }
    set { _codeSystems = Set(newValue) }
  }
  
  public var codes: [CDAKCodedEntry] {
    get { return entries.map({$0.1}) }
  }

  // this is an extraordinarily bad method
  // you're basically saying "look - just find me any title"
  // and those titles are absolutely going to be different across vocabularies and individual coded values
  // so this is "just pick one"
  // we're just going to say "pick the most frequently used name"...
  public var mostFrequentDisplayName: String? {

    var displayName_Counts:[String:Int] = [:]
    for (_, v) in entries {
      if let nm = v.displayName {
        displayName_Counts[nm] = (displayName_Counts[nm] ?? 0) + 1
      }
    }
    // we want to sort descending by frequency of items
    return displayName_Counts.sort({ $0.1 > $1.1 }).first?.0
  }
  
  
  public init(){}
  public init(codeSystem:String, code: String?, codeSystemOid: String? = nil){
    addCodes(codeSystem, codes: code, codeSystemOid: codeSystemOid)
  }
  public init(entries:[String:[String]]?){
    if let entries = entries {
      addCodes(entries)
    }
  }
  public init(entries:[String:String?]?){
    addCodes(entries)
  }
  public init(entries: [CDAKCodedEntry]?) {
    if let entries = entries {
      for entry in entries {
        addCodes(entry.codeSystem, codes: entry.codes, codeSystemOid: entry.codeSystemOid, displayName: entry.displayName)
      }
    }
  }
  public init(entries: CDAKCodedEntry?) {
    if let entry = entries {
      addCodes(entry.codeSystem, codes: entry.codes, codeSystemOid: entry.codeSystemOid, displayName: entry.displayName)
    }
  }
  
  public subscript(codeSystem: String) -> CDAKCodedEntry? {
    get {
      return self.entries[codeSystem]
    }
    set(newValue) {
      if newValue == nil {
        self.entries.removeValueForKey(codeSystem)
        self.codeSystems = self.codeSystems.filter {$0 != codeSystem}
        return
      }
      
      let oldValue = self.entries.updateValue(newValue!, forKey: codeSystem)
      if oldValue == nil {
        self.codeSystems.append(codeSystem)
      }
    }
  }
  
  //we may want to remove a bunch of entries from a set
  mutating func removeCodes(foundInEntries set1: CDAKCodedEntries) {
    for (kr, vr) in set1 {
      //EX: SNOMED-CT: [entries]
      if self[kr] != nil {
        self[kr]!.codes = (self[kr]?.filter({!vr.contains($0)}))!
        //if there are no codes left, just remove the entries entirely
        if self[kr]!.codes.count == 0 {
          self[kr] = nil
        }
      }
    }
  }
  
  public func findIntersectingCodes(forCodeSystem codeSystem: String, matchingCodes codes:[String]) -> [String]? {
    return entries[codeSystem]?.codes.filter({codes.contains($0)})
  }

  
  public mutating func addCodes(entries: [CDAKCodedEntry]) {
    for entry in entries {
      addCodes(entry.codeSystem, codes: entry.codes, codeSystemOid: entry.codeSystemOid, displayName: entry.displayName)
    }
  }
  public mutating func addCodes(entry: CDAKCodedEntry) {
    addCodes(entry.codeSystem, codes: entry.codes, codeSystemOid: entry.codeSystemOid, displayName: entry.displayName)
  }
  public mutating func addCodes(codedSet:[String:String?]?) {
    if let codedSet = codedSet {
      for (key, value) in codedSet {
        addCodes(key, codes: value)
      }
    }
  }
  public mutating func addCodes(codedSet:[String:[String?]]?) {
    if let codedSet = codedSet {
      for (key, value) in codedSet {
        addCodes(key, codes: value)
      }
    }
  }
  public mutating func addCodes(codedSet:[String:[String]]?) {
    if let codedSet = codedSet {
      for (key, value) in codedSet {
        addCodes(key, codes: value)
      }
    }
  }
  public mutating func addCodes(codedSet:[String:[String]]) {
    for (key, value) in codedSet {
      addCodes(key, codes: value)
    }
  }
  
  public mutating func addCodes(codeSystem: String, codes: String?, codeSystemOid: String? = nil, displayName: String? = nil) {
    if let code = codes {
      self.addCodes(codeSystem, codes: [code], codeSystemOid: codeSystemOid)
    }
  }
  public mutating func addCodes(codeSystem: String, codes: [String?]?, codeSystemOid: String? = nil, displayName: String? = nil) {
    if let codes = codes {
      addCodes(codeSystem, codes: codes, codeSystemOid: codeSystemOid)
    }
  }
  public mutating func addCodes(codeSystem: String, codes: [String?], codeSystemOid: String? = nil, displayName: String? = nil) {
    addCodes(codeSystem, codes: codes.filter({$0 != nil}).map({$0!}), codeSystemOid: codeSystemOid, displayName: displayName)
  }
  
  public mutating func addCodes(codeSystem: String, codes: [String], codeSystemOid: String? = nil, displayName: String? = nil) {
    self.codeSystems.append(codeSystem)
    if self.entries[codeSystem] != nil {
      self.entries[codeSystem]!.codes.appendContentsOf(codes)
      if let codeSystemOid = codeSystemOid {
        self.entries[codeSystem]!.codeSystemOid = codeSystemOid
      }
      if let displayName = displayName {
        self.entries[codeSystem]!.displayName = displayName
      }
    } else {
      self.entries[codeSystem] = CDAKCodedEntry(codeSystem: codeSystem, codes: codes, codeSystemOid: codeSystemOid, displayName: displayName)
    }
  }
  
  public var description: String {
    return (self.entries.description)
  }
  
  public var hashValue: Int {
    var a_hash: Int = 0
    for code in codes {
      a_hash = a_hash ^ code.hashValue
    }
    return a_hash
  }
  
  public func containsCode(codeSystem: String, withCode code: String) -> Bool {
    if let entry = entries[codeSystem] {
      return entry.containsCode(codeSystem, withCode: code)
    }
    return false
  }
  
  public var codeDictionary: [String:[String]] {
    var result: [String:[String]] = [:]
    for (key, entry) in entries {
      result[key] = entry.codes
    }
    return result
  }
  
  public var arrayOfFlattenedCodedEntry: [CDAKCodedEntry] {
    var result: [CDAKCodedEntry] = []
    for (key, ce) in entries {
      for code in ce.codes {
        result.append(CDAKCodedEntry(codeSystem: key, codes: code))
      }
    }
    return result
  }
  
  public var arrayOfFlattenedStringPairs: [[String:String]] {
    var result: [[String:String]] = []
    for (key, ce) in entries {
      for code in ce.codes {
        result.append([key: code])
      }
    }
    return result
  }

  public var numberOfDistinctCodes: Int {
    return entries.flatMap({$0.1.codes}).count
  }
  
}


public func == (lhs: CDAKCodedEntries, rhs: CDAKCodedEntries) -> Bool {
  return lhs.hashValue == rhs.hashValue
}

//MARK: FIXME - this is probably wrong - resolve after other fixes
// see if we can just return the actual boxed values from self
extension CDAKCodedEntries: MustacheBoxable {
//  var boxedValues: [String:MustacheBox] {
//    return [
//      "entries": Box(entries)
//    ]
//  }
  public var mustacheBox: MustacheBox {
    return Box(codeDictionary) // I don't really want the rest of the stuff (yet...)
  }
}