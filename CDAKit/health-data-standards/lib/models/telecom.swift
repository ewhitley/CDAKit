//
//  cda_identifier.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

class HDSTelecom: NSObject, HDSJSONInstantiable {
  
  var record: HDSRecord?

  var use: String?
  var value: String?
  var preferred: Bool?
  
  //embedded_in :contactable, polymorphic: true
  
  override init(){
    super.init()
  }
  
  init(use: String?, value: String, preferred: Bool? = false) {
    super.init()
    self.use = use
    self.value = value
    self.preferred = preferred
  }
  
  required init(event: [String:Any?]) {
    super.init()
    initFromEventList(event)
  }
  
  private func initFromEventList(event: [String:Any?]) {
    for (key, value) in event {
      HDSUtility.setProperty(self, property: key, value: value)
    }
  }

  override var description: String {
    return "HDSTelecom => use: \(use), value: \(value), preferred: \(preferred)"
  }

  
}

extension HDSTelecom {
  override var mustacheBox: MustacheBox {
    return Box([
      "use": use,
      "value": value,
      "preferred": String(preferred)
      ])
  }
}