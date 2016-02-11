//
//  coded_entries.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/14/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache


public struct HDSCodedTerm {
  var code: String
  var displayName: String?
}

public struct HDSCodedEntry: CustomStringConvertible, SequenceType, CollectionType, Equatable, Hashable {
  var codeSystem: String
  var codeSystemOid: String?
  var displayName: String?
  
//  private var _codes = Set<String>()
  private var _codes: [HDSCodedTerm] = []
  var codes: [String] {
    get { return _codes.map({$0.code}) }
    set { _codes = newValue.map({HDSCodedTerm(code: $0, displayName: nil)}) }
  }

  var codedTerms: [HDSCodedTerm] {
    get { return _codes }
    set { _codes = newValue }
  }
  
  var code: String? {
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

  
  init(codeSystem: String, codes: String?, codeSystemOid: String? = nil, displayName: String? = nil) {
    self.codeSystem = codeSystem
    if let code = codes {
      self.codes.append(code)
    }
    if let codeSystemOid = codeSystemOid {
      self.codeSystemOid = codeSystemOid
    }
    self.displayName = displayName
    HDSCodeSystemHelper.addCodeSystem(codeSystem, oid: codeSystemOid)
  }
  init(codeSystem: String, codes: [String?]?, codeSystemOid: String? = nil, displayName: String? = nil) {
    self.codeSystem = codeSystem
    if let codes = codes {
      self.codes = codes.filter({$0 != nil}).map({$0!})
    }
    if let codeSystemOid = codeSystemOid {
      self.codeSystemOid = codeSystemOid
    }
    self.displayName = displayName
    HDSCodeSystemHelper.addCodeSystem(codeSystem, oid: codeSystemOid)
  }
  init(codeSystem: String, codes: [String?], codeSystemOid: String? = nil, displayName: String? = nil) {
    self.codeSystem = codeSystem
    self.codes = codes.filter({$0 != nil}).map({$0!})
    if let codeSystemOid = codeSystemOid {
      self.codeSystemOid = codeSystemOid
    }
    self.displayName = displayName
    HDSCodeSystemHelper.addCodeSystem(codeSystem, oid: codeSystemOid)
  }
  init(codeSystem: String, codes: [String], codeSystemOid: String? = nil, displayName: String? = nil) {
    self.codeSystem = codeSystem
    self.codes = codes
    if let codeSystemOid = codeSystemOid {
      self.codeSystemOid = codeSystemOid
    }
    self.displayName = displayName
    HDSCodeSystemHelper.addCodeSystem(codeSystem, oid: codeSystemOid)
  }
  public var description: String {
    return ("codeSystem: \(codeSystem), codeSystemOid: \(codeSystemOid), codes: \(codes), displayName: \(displayName)")
  }
  
  public var hashValue: Int {
    return "\(codeSystem)\(codeSystemOid)\(codes)".hashValue
  }

  func containsCode(codeSystem: String, withCode code: String) -> Bool {
    return (self.codeSystem == codeSystem && self.codes.filter({$0 == code}).count > 0) ? true : false
  }



  
}

public func == (lhs: HDSCodedEntry, rhs: HDSCodedEntry) -> Bool {
  return lhs.hashValue == rhs.hashValue
}

extension HDSCodedEntry: MustacheBoxable {
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


public struct HDSCodedEntries: CustomStringConvertible, SequenceType, CollectionType, Equatable, Hashable {
  
  public func generate() -> DictionaryGenerator<String, HDSCodedEntry> {
    return entries.generate()
  }
  
  public typealias Index = Dictionary<String, HDSCodedEntry>.Index
  public typealias _Element = (String, HDSCodedEntry)
  public var startIndex: Index {get { return entries.startIndex }}
  public var endIndex: Index {get { return entries.endIndex }}
  public subscript(_i: Index) -> _Element {get { return entries[_i] }}
  public var first: _Element? { get {return entries.first} }
  public var count: Int { get {return entries.count} }
  var keys: [String] { return codeSystems }

  
  private var _codeSystems: Set<String> = Set<String>()
  private var entries: [String:HDSCodedEntry] = [:]

  var codeSystems: [String] {
    get { return Array(_codeSystems) }
    set { _codeSystems = Set(newValue) }
  }
  
  var codes: [HDSCodedEntry] {
    get { return entries.map({$0.1}) }
  }

  //this is an extraordinarily bad method
  // you're basically saying "look - just find me any title"
  // and those titles are absolutely going to be different across vocabularies and individual coded values
  // so this is "just pick one"
  // we're just going to say "pick the most frequently used name"...
  var mostFrequentDisplayName: String? {

    var displayName_Counts:[String:Int] = [:]
    for (_, v) in entries {
      if let nm = v.displayName {
        displayName_Counts[nm] = (displayName_Counts[nm] ?? 0) + 1
      }
    }
    // we want to sort descending by frequency of items
    return displayName_Counts.sort({ $0.1 > $1.1 }).first?.0
  }
  
  
  init(){}
  init(codeSystem:String, code: String?, codeSystemOid: String? = nil){
    addCodes(codeSystem, codes: code, codeSystemOid: codeSystemOid)
  }
  init(entries:[String:[String]]?){
    if let entries = entries {
      addCodes(entries)
    }
  }
  init(entries:[String:String?]?){
    addCodes(entries)
  }
  init(entries: [HDSCodedEntry]?) {
    if let entries = entries {
      for entry in entries {
        addCodes(entry.codeSystem, codes: entry.codes, codeSystemOid: entry.codeSystemOid, displayName: entry.displayName)
      }
    }
  }
  init(entries: HDSCodedEntry?) {
    if let entry = entries {
      addCodes(entry.codeSystem, codes: entry.codes, codeSystemOid: entry.codeSystemOid, displayName: entry.displayName)
    }
  }
  
  subscript(codeSystem: String) -> HDSCodedEntry? {
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
  mutating func removeCodes(foundInEntries set1: HDSCodedEntries) {
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

  
  mutating func addCodes(entries: [HDSCodedEntry]) {
    for entry in entries {
      addCodes(entry.codeSystem, codes: entry.codes, codeSystemOid: entry.codeSystemOid, displayName: entry.displayName)
    }
  }
  mutating func addCodes(entry: HDSCodedEntry) {
    addCodes(entry.codeSystem, codes: entry.codes, codeSystemOid: entry.codeSystemOid, displayName: entry.displayName)
  }
  mutating func addCodes(codedSet:[String:String?]?) {
    if let codedSet = codedSet {
      for (key, value) in codedSet {
        addCodes(key, codes: value)
      }
    }
  }
  mutating func addCodes(codedSet:[String:[String?]]?) {
    if let codedSet = codedSet {
      for (key, value) in codedSet {
        addCodes(key, codes: value)
      }
    }
  }
  mutating func addCodes(codedSet:[String:[String]]?) {
    if let codedSet = codedSet {
      for (key, value) in codedSet {
        addCodes(key, codes: value)
      }
    }
  }
  mutating func addCodes(codedSet:[String:[String]]) {
    for (key, value) in codedSet {
      addCodes(key, codes: value)
    }
  }
  
  mutating func addCodes(codeSystem: String, codes: String?, codeSystemOid: String? = nil, displayName: String? = nil) {
    if let code = codes {
      self.addCodes(codeSystem, codes: [code], codeSystemOid: codeSystemOid)
    }
  }
  mutating func addCodes(codeSystem: String, codes: [String?]?, codeSystemOid: String? = nil, displayName: String? = nil) {
    if let codes = codes {
      addCodes(codeSystem, codes: codes, codeSystemOid: codeSystemOid)
    }
  }
  mutating func addCodes(codeSystem: String, codes: [String?], codeSystemOid: String? = nil, displayName: String? = nil) {
    addCodes(codeSystem, codes: codes.filter({$0 != nil}).map({$0!}), codeSystemOid: codeSystemOid, displayName: displayName)
  }
  
  mutating func addCodes(codeSystem: String, codes: [String], codeSystemOid: String? = nil, displayName: String? = nil) {
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
      self.entries[codeSystem] = HDSCodedEntry(codeSystem: codeSystem, codes: codes, codeSystemOid: codeSystemOid, displayName: displayName)
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
  
  var arrayOfFlattenedCodedEntry: [HDSCodedEntry] {
    var result: [HDSCodedEntry] = []
    for (key, ce) in entries {
      for code in ce.codes {
        result.append(HDSCodedEntry(codeSystem: key, codes: code))
      }
    }
    return result
  }
  
  var arrayOfFlattenedStringPairs: [[String:String]] {
    var result: [[String:String]] = []
    for (key, ce) in entries {
      for code in ce.codes {
        result.append([key: code])
      }
    }
    return result
  }

  var numberOfDistinctCodes: Int {
    return entries.flatMap({$0.1.codes}).count
  }
  
}


public func == (lhs: HDSCodedEntries, rhs: HDSCodedEntries) -> Bool {
  return lhs.hashValue == rhs.hashValue
}

//MARK: FIXME - this is probably wrong - resolve after other fixes
// see if we can just return the actual boxed values from self
extension HDSCodedEntries: MustacheBoxable {
//  var boxedValues: [String:MustacheBox] {
//    return [
//      "entries": Box(entries)
//    ]
//  }
  public var mustacheBox: MustacheBox {
    return Box(codeDictionary) // I don't really want the rest of the stuff (yet...)
  }
}
