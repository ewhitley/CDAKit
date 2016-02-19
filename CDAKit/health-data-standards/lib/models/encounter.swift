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
public class CDAKEncounter: CDAKEntry {

  // MARK: CDA properties
  /**
  CDA priorityCode
  [Reference](http://www.cdapro.com/know/25039)
  */
  public var admit_type: CDAKCodedEntries = CDAKCodedEntries() // :admit_type, type: Hash
  ///CDA dischargeDispositionCode
  public var discharge_disposition: CDAKCodedEntries = CDAKCodedEntries() // :discharge_disposition, type: Hash
  ///Time of admission
  public var admit_time: Double? // , as: :admit_time, type: Integer
  ///Time of discharge
  public var discharge_time: Double? // :discharge_time, type: Integer
  ///Principal diagnosis
  public var principal_diagnosis: CDAKCodedEntries = CDAKCodedEntries() //:principal_diagnosis, type: Hash
  ///Diagnosis
  public var diagnosis: CDAKCodedEntries = CDAKCodedEntries()
  
  ///Transfer to
  public var transfer_to: CDAKTransfer?//, class_name: "CDAKTransfer"
  ///Transfer from
  public var transfer_from: CDAKTransfer?//, class_name: "CDAKTransfer"
  
  ///Facility
  public var facility: CDAKFacility?
  
  ///Performer
  public var performer: CDAKProvider?

  // MARK: Health-Data-Standards Functions
  ///Offset all dates by specified double
  override func shift_dates(date_diff: Double) {
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
  override public var description: String {
    return super.description + " , admit_type: \(admit_type), discharge_disposition: \(discharge_disposition), admit_time: \(admit_time), discharge_time: \(discharge_time), principal_diagnosis: \(principal_diagnosis), transfer_to: \(transfer_to), transfer_from: \(transfer_from), facility: \(facility), performer: \(performer)"
  }
  
}

// MARK: - Mustache marshalling
extension CDAKEncounter {
  override var boxedValues: [String:MustacheBox] {
    var vals = super.boxedValues
    
    vals["admit_type"] = Box(self.admit_type)
    vals["discharge_disposition"] = Box(self.discharge_disposition)
    vals["admit_time"] = Box(self.admit_time)
    vals["principal_diagnosis"] = Box(self.principal_diagnosis)
    vals["diagnosis"] = Box(self.diagnosis)
    vals["transfer_to"] = Box(self.transfer_to)
    vals["transfer_from"] = Box(self.transfer_from)
    vals["facility"] = Box(self.facility)
    vals["performer"] = Box(self.performer)
    
    return vals
  }
}

// MARK: - JSON Generation
extension CDAKEncounter {
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if admit_type.count > 0 {
      dict["admit_type"] = admit_type.codes.map({$0.jsonDict})
    }
    if discharge_disposition.count > 0 {
      dict["discharge_disposition"] = discharge_disposition.codes.map({$0.jsonDict})
    }
    if let admit_time = admit_time {
      dict["admit_time"] = admit_time
    }
    if let discharge_time = discharge_time {
      dict["discharge_time"] = discharge_time
    }
    
    if principal_diagnosis.count > 0 {
      dict["principal_diagnosis"] = principal_diagnosis.codes.map({$0.jsonDict})
    }
    if diagnosis.count > 0 {
      dict["diagnosis"] = diagnosis.codes.map({$0.jsonDict})
    }
    
    if let transfer_to = transfer_to {
      dict["transfer_to"] = transfer_to.jsonDict
    }
    if let transfer_from = transfer_from {
      dict["transfer_from"] = transfer_from.jsonDict
    }
    if let facility = facility {
      dict["facility"] = facility.jsonDict
    }
    if let performer = performer {
      dict["performer"] = performer.jsonDict
    }
    
    return dict
  }
}

