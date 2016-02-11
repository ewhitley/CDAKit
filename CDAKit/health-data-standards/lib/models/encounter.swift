//
//  encounter.swift
//  CCDAccess
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

class HDSEncounter: HDSEntry {
  
  var admitType: HDSCodedEntries = HDSCodedEntries() // :admit_type, type: Hash
  var dischargeDisposition: HDSCodedEntries = HDSCodedEntries() // :discharge_disposition, type: Hash
  var admitTime: Double? // , as: :admit_time, type: Integer
  var dischargeTime: Double? // :discharge_time, type: Integer
  var principalDiagnosis: HDSCodedEntries = HDSCodedEntries() //:principal_diagnosis, type: Hash
  var diagnosis: HDSCodedEntries = HDSCodedEntries()
  
  var transferTo: HDSTransfer?//, class_name: "HDSTransfer"
  var transferFrom: HDSTransfer?//, class_name: "HDSTransfer"
  
  var facility: HDSFacility?
  
  //belongs_to :performer, class_name: "Provider"
  var performer: HDSProvider?

  var admit_type: HDSCodedEntries {
    get { return admitType }
    set(value) { admitType = value }
  }

  var discharge_disposition: HDSCodedEntries {
    get { return dischargeDisposition }
    set(value) { dischargeDisposition = value }
  }

  var admit_time: Double? {
    get { return admitTime }
    set(value) { admitTime = value }
  }

  var discharge_time: Double? {
    get { return dischargeTime }
    set(value) { dischargeTime = value }
  }

  var principal_diagnosis: HDSCodedEntries {
    get { return principalDiagnosis }
    set(value) { principalDiagnosis = value }
  }

//  alias :transfer_to :transferTo
  var transfer_to: HDSTransfer? {
    get { return transferTo }
    set(value) { transferTo = value }
  }

  //  alias :transfer_from :transferFrom
  var transfer_from: HDSTransfer? {
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
  
  override var description: String {
    return super.description + " , admit_type: \(admit_type), discharge_disposition: \(discharge_disposition), admit_time: \(admit_time), discharge_time: \(discharge_time), principal_diagnosis: \(principal_diagnosis), transfer_to: \(transfer_to), transfer_from: \(transfer_from), facility: \(facility), performer: \(performer)"
  }
  
}

extension HDSEncounter {
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
