//
//  encounter.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache


/**
Represents a CDA Encounter
 
[Reference](http://www.cdapro.com/know/26178)
*/
open class CDAKEncounter: CDAKEntry {

  // MARK: CDA properties
  /**
  CDA priorityCode
  [Reference](http://www.cdapro.com/know/25039)
  */
  open var admit_type: CDAKCodedEntries = CDAKCodedEntries() // :admit_type, type: Hash
  ///CDA dischargeDispositionCode
  open var discharge_disposition: CDAKCodedEntries = CDAKCodedEntries() // :discharge_disposition, type: Hash
  ///Time of admission
  open var admit_time: Double? // , as: :admit_time, type: Integer
  ///Time of discharge
  open var discharge_time: Double? // :discharge_time, type: Integer
  ///Principal diagnosis
  open var principal_diagnosis: CDAKCodedEntries = CDAKCodedEntries() //:principal_diagnosis, type: Hash
  ///Diagnosis
  open var diagnosis: CDAKCodedEntries = CDAKCodedEntries()
  
  ///Transfer to
  open var transfer_to: CDAKTransfer?//, class_name: "CDAKTransfer"
  ///Transfer from
  open var transfer_from: CDAKTransfer?//, class_name: "CDAKTransfer"
  
  ///Facility
  open var facility: CDAKFacility?
  
  ///Performer
  open var performer: CDAKProvider?

  /**
   Indication
   This is the problem that was the reason for the medication
   
   - Version 1.0: Not present
   - Version 1.0.1: Added as a full Entry.  It contains a full problem, including dates, codes, etc.
   */
  open var indication: CDAKEntry?  // type: Hash

  
  // MARK: Health-Data-Standards Functions
  ///Offset all dates by specified double
  override func shift_dates(_ date_diff: Double) {
    super.shift_dates(date_diff)

    if let facility = facility {
      facility.shift_dates(date_diff)
    }

    if let admit_time = admit_time {
      self.admit_time = admit_time + date_diff
    }
    if let discharge_time = discharge_time {
      self.discharge_time = discharge_time + date_diff
    }
  }
  
  // MARK: Standard properties
  ///Debugging description
  override open var description: String {
    return super.description + " , admit_type: \(admit_type), discharge_disposition: \(discharge_disposition), admit_time: \(admit_time), discharge_time: \(discharge_time), principal_diagnosis: \(principal_diagnosis), transfer_to: \(transfer_to), transfer_from: \(transfer_from), facility: \(facility), performer: \(performer)"
  }
  
}

extension CDAKEncounter {
  // MARK: - Mustache marshalling
  override var boxedValues: [String:MustacheBox] {
    var vals = super.boxedValues
    
    vals["admit_type"] = Box(admit_type)
    vals["discharge_disposition"] = Box(discharge_disposition)
    if let admit_time = admit_time {
      vals["admit_time"] = Box(admit_time)
    }
    if let discharge_time = discharge_time {
      vals["discharge_time"] = Box(discharge_time)
    }
    vals["principal_diagnosis"] = Box(principal_diagnosis)
    vals["diagnosis"] = Box(diagnosis)
    if let transfer_to = transfer_to {
      vals["transfer_to"] = Box(transfer_to)
    }
    if let transfer_from = transfer_from {
      vals["transfer_from"] = Box(transfer_from)
    }
    if let facility = facility {
      vals["facility"] = Box(facility)
    }
    if let performer = performer {
      vals["performer"] = Box(performer)
    }
    if let indication = indication {
      vals["indication"] = Box(indication)
    }
    
    return vals
  }
}

extension CDAKEncounter {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if admit_type.count > 0 {
      dict["admit_type"] = admit_type.codes.map({$0.jsonDict}) as AnyObject?
    }
    if discharge_disposition.count > 0 {
      dict["discharge_disposition"] = discharge_disposition.codes.map({$0.jsonDict}) as AnyObject?
    }
    if let admit_time = admit_time {
      dict["admit_time"] = admit_time as AnyObject?
    }
    if let discharge_time = discharge_time {
      dict["discharge_time"] = discharge_time as AnyObject?
    }
    
    if principal_diagnosis.count > 0 {
      dict["principal_diagnosis"] = principal_diagnosis.codes.map({$0.jsonDict}) as AnyObject?
    }
    if diagnosis.count > 0 {
      dict["diagnosis"] = diagnosis.codes.map({$0.jsonDict}) as AnyObject?
    }
    
    if let transfer_to = transfer_to {
      dict["transfer_to"] = transfer_to.jsonDict as AnyObject?
    }
    if let transfer_from = transfer_from {
      dict["transfer_from"] = transfer_from.jsonDict as AnyObject?
    }
    if let facility = facility {
      dict["facility"] = facility.jsonDict as AnyObject?
    }
    if let performer = performer {
      dict["performer"] = performer.jsonDict as AnyObject?
    }
    
    if let indication = indication {
      dict["indication"] = indication.jsonDict as AnyObject?
    }

    
    return dict
  }
}

