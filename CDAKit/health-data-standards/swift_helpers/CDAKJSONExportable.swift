//
//  CDAKJSONExportable.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/17/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

public protocol CDAKJSONExportable {
  var json: String {get}
  var jsonDict: [String :AnyObject] {get}
}

extension CDAKJSONExportable {
  public var json: String {
    if let aString = CDAKCommonUtility.jsonStringFromDict(jsonDict) {
      return aString
    }
    return ""
  }
}