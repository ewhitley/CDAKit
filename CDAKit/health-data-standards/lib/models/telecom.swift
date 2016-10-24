//
//  cda_identifier.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

/**
 Telephone
*/
open class CDAKTelecom: NSObject, CDAKJSONInstantiable {
  
  // MARK: CDA properties
  weak var record: CDAKRecord?

  ///phone use type
  open var use: String?
  ///phone number
  open var value: String?
  ///is this the preferred phone?
  open var preferred: Bool?
  
  /**
   Determines whether the phone is empty
   */
  open var is_empty: Bool {
    
    let someText: String = "\(value ?? "")".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    
    if someText.characters.count > 0 {
      return false
    }
    return true
    
  }

  
  // MARK: - Initializers
  public override init(){
    super.init()
  }
  
  public init(use: String?, value: String, preferred: Bool? = false) {
    super.init()
    self.use = use
    self.value = value
    self.preferred = preferred
  }
  
  // MARK: - Deprecated - Do not use
  ///Do not use - will be removed. Was used in HDS Ruby.
  public required init(event: [String:Any?]) {
    super.init()
    initFromEventList(event)
  }
  
  ///Do not use - will be removed. Was used in HDS Ruby.
  fileprivate func initFromEventList(_ event: [String:Any?]) {
    for (key, value) in event {
      CDAKUtility.setProperty(self, property: key, value: value)
    }
  }

  // MARK: Standard properties
  ///Debugging description
  open override var description: String {
    return "CDAKTelecom => use: \(use), value: \(value), preferred: \(preferred)"
  }

  
}

extension CDAKTelecom {
  // MARK: - Mustache marshalling
  override open var mustacheBox: MustacheBox {
    return Box([
      "use": use,
      "value": value,
      "preferred": String(describing: preferred)
      ])
  }
}

extension CDAKTelecom: CDAKJSONExportable {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    if let use = use {
      dict["use"] = use as AnyObject?
    }
    if let value = value {
      dict["value"] = value as AnyObject?
    }
    if let preferred = preferred {
      dict["preferred"] = preferred as AnyObject?
    }
    return dict
  }
}

