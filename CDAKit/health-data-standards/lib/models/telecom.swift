//
//  cda_identifier.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

public class CDAKTelecom: NSObject, CDAKJSONInstantiable {
  
  var record: CDAKRecord?

  public var use: String?
  public var value: String?
  public var preferred: Bool?
  
  public override init(){
    super.init()
  }
  
  public init(use: String?, value: String, preferred: Bool? = false) {
    super.init()
    self.use = use
    self.value = value
    self.preferred = preferred
  }
  
  public required init(event: [String:Any?]) {
    super.init()
    initFromEventList(event)
  }
  
  private func initFromEventList(event: [String:Any?]) {
    for (key, value) in event {
      CDAKUtility.setProperty(self, property: key, value: value)
    }
  }

  public override var description: String {
    return "CDAKTelecom => use: \(use), value: \(value), preferred: \(preferred)"
  }

  
}

extension CDAKTelecom {
  override public var mustacheBox: MustacheBox {
    return Box([
      "use": use,
      "value": value,
      "preferred": String(preferred)
      ])
  }
}

extension CDAKTelecom: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    if let use = use {
      dict["use"] = use
    }
    if let value = value {
      dict["value"] = value
    }
    if let preferred = preferred {
      dict["preferred"] = preferred
    }
    return dict
  }
}

