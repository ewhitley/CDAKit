 //
//  entry.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

/**
There is a recurring need to capture entry-like things witin an entry.  Instead of making these full entries, we're introducing a quick "sub" entry.
*/
 
 //this is probably a mistake... but we can change this later if we need to

 open class CDAKEntryDetail: CDAKThingWithCodes, CDAKThingWithTimes, CDAKThingWithIdentifier, CustomStringConvertible {

  // MARK: CDA properties
  ///A generalized "time" associated with the entry
  open var time: Double?
  ///A start time associated with this entry
  open var start_time: Double?
  ///an end time associated with this entry
  open var end_time: Double?

  ///Type of CDA Entry if available
  open var cda_identifier: CDAKCDAIdentifier? //, class_name: "CDAKCDAIdentifier", as: :cda_identifiable
  
  /**
  Core coded entries that represent any "meaning" behind the entry
  These will be in the format of...
  ClinicalVocabulary:ConceptID
  Like
  LOINC:12345
  */
  open var codes: CDAKCodedEntries = CDAKCodedEntries()
  

  // MARK: Standard properties
  ///Internal object hash value
  open var hashValue: Int {
    //FIX_ME: - not using the hash - just using native properties
    
    var hv: Int
    
    hv = "\(codes)".hashValue
    
    if let start_time = start_time, let end_time = end_time {
      hv = hv ^ start_time.hashValue
      hv = hv ^ end_time.hashValue
    } else {
      hv = hv ^ "\(time)".hashValue
    }
    
    return hv
  }
  
  // MARK: Standard properties
  ///Debugging description
  open var description : String {
    return "\(type(of: self)) => codes: \(codes), cda_identifier: \(cda_identifier), time: \(time), start_time: \(start_time), end_time: \(end_time)"
  }

 }

func == (lhs: CDAKEntryDetail, rhs: CDAKEntryDetail) -> Bool {
  return lhs.hashValue == rhs.hashValue && CDAKCommonUtility.classNameAsString(lhs) == CDAKCommonUtility.classNameAsString(rhs)
}
 
extension CDAKEntryDetail: MustacheBoxable {
 
 // MARK: - Mustache marshalling
 var boxedValues: [String:MustacheBox] {
  return [
    "cda_identifier" :  Box(self.cda_identifier),
    "codes" : Box(self.codes.boxedPreferredAndTranslatedCodes),
    "time" :  Box(self.time),
    "start_time" :  Box(self.start_time),
    "end_time" :  Box(self.end_time),
    "as_point_in_time": Box(time ?? start_time ?? end_time ?? "")
  ]
 }
 
 public var mustacheBox: MustacheBox {
  return Box(boxedValues)
 }
}


extension CDAKEntryDetail: CDAKJSONExportable {
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
    if let time = time {
      dict["time"] = time as AnyObject?
    }
    if let start_time = start_time {
      dict["start_time"] = start_time as AnyObject?
    }
    if let end_time = end_time {
      dict["end_time"] = end_time as AnyObject?
    }
    return dict
  }
 }


