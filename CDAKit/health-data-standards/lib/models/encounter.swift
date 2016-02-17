//
//  encounter.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache




public class CDAKEncounter: CDAKEntry {
  
  public var admitType: CDAKCodedEntries = CDAKCodedEntries() // :admit_type, type: Hash
  public var dischargeDisposition: CDAKCodedEntries = CDAKCodedEntries() // :discharge_disposition, type: Hash
  public var admitTime: Double? // , as: :admit_time, type: Integer
  public var dischargeTime: Double? // :discharge_time, type: Integer
  public var principalDiagnosis: CDAKCodedEntries = CDAKCodedEntries() //:principal_diagnosis, type: Hash
  public var diagnosis: CDAKCodedEntries = CDAKCodedEntries()
  
  public var transferTo: CDAKTransfer?//, class_name: "CDAKTransfer"
  public var transferFrom: CDAKTransfer?//, class_name: "CDAKTransfer"
  
  public var facility: CDAKFacility?
  
  //belongs_to :performer, class_name: "Provider"
  public var performer: CDAKProvider?

  public var admit_type: CDAKCodedEntries {
    get { return admitType }
    set(value) { admitType = value }
  }

  public var discharge_disposition: CDAKCodedEntries {
    get { return dischargeDisposition }
    set(value) { dischargeDisposition = value }
  }

  public var admit_time: Double? {
    get { return admitTime }
    set(value) { admitTime = value }
  }

  public var discharge_time: Double? {
    get { return dischargeTime }
    set(value) { dischargeTime = value }
  }

  public var principal_diagnosis: CDAKCodedEntries {
    get { return principalDiagnosis }
    set(value) { principalDiagnosis = value }
  }

//  alias :transfer_to :transferTo
  public var transfer_to: CDAKTransfer? {
    get { return transferTo }
    set(value) { transferTo = value }
  }

  //  alias :transfer_from :transferFrom
  public var transfer_from: CDAKTransfer? {
    get { return transferFrom }
    set(value) { transferFrom = value }
  }
  
  override func shift_dates(date_diff: Double) {
    super.shift_dates(date_diff)

    if let facility = facility {
      facility.shift_dates(date_diff)
    }

    if let admitTime = admitTime {
      self.admitTime = admitTime + date_diff
    }
    if let dischargeTime = dischargeTime {
      self.dischargeTime = dischargeTime + date_diff
    }
  }
  
  override public var description: String {
    return super.description + " , admit_type: \(admit_type), discharge_disposition: \(discharge_disposition), admit_time: \(admit_time), discharge_time: \(discharge_time), principal_diagnosis: \(principal_diagnosis), transfer_to: \(transfer_to), transfer_from: \(transfer_from), facility: \(facility), performer: \(performer)"
  }
  
}

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

extension CDAKEncounter {
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

