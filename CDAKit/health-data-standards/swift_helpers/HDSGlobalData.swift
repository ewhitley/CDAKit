//
//  CDAKGlobalData.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

var CDAKRecords = [CDAKRecord]()
var CDAKProviders = [CDAKProvider]()

var CDAK_EXTENDED_CODE_SYSTEMS: [String:String] = CDAKCodeSystemHelper.CODE_SYSTEMS
// to help us extend the code systems as we find new ones - or you can add them
// original is in code_system_helper
// "2.16.840.1.113883.6.1" :    "LOINC",

protocol CDAKJSONInstantiable {
  init(event: [String:Any?])
}


extension CDAKJSONInstantiable {
  func initFromEventList(event: [String:Any?]) {
    for (key, value) in event {
      CDAKUtility.setProperty(self, property: key, value: value)
    }
  }
}


