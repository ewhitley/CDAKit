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
public class CDAKTelecom: NSObject, CDAKJSONInstantiable {
  
  // MARK: CDA properties
  weak var record: CDAKRecord?

  ///phone use type
  public var use: String?
  ///phone number
  public var value: String?
  ///is this the preferred phone?
  public var preferred: Bool?
  
  /**
   Determines whether the phone is empty
   */
  public var is_empty: Bool {
    
    let someText: String = "\(value ?? "")".stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    
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
  private func initFromEventList(event: [String:Any?]) {
    for (key, value) in event {
      CDAKUtility.setProperty(self, property: key, value: value)
    }
  }

  // MARK: Standard properties
  ///Debugging description
  public override var description: String {
    return "CDAKTelecom => use: \(use), value: \(value), preferred: \(preferred)"
  }

  
}

extension CDAKTelecom {
  // MARK: - Mustache marshalling
  override public var mustacheBox: MustacheBox {
    return Box([
      "use": use,
      "value": value,
      "preferred": String(preferred)
      ])
  }
}

extension CDAKTelecom: CDAKJSONExportable {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
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

