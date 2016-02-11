//
//  HDSGlobalData.swift
//  CCDAccess
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

var HDSRecords = [HDSRecord]()
var HDSProviders = [HDSProvider]()

var HDS_EXTENDED_CODE_SYSTEMS: [String:String] = HDSCodeSystemHelper.CODE_SYSTEMS
// to help us extend the code systems as we find new ones - or you can add them
// original is in code_system_helper
// "2.16.840.1.113883.6.1" :    "LOINC",

protocol HDSJSONInstantiable {
  init(event: [String:Any?])
}


extension HDSJSONInstantiable {
  func initFromEventList(event: [String:Any?]) {
    for (key, value) in event {
      HDSUtility.setProperty(self, property: key, value: value)
    }
  }
}


