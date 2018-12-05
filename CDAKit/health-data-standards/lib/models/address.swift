//
//  address.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

/**
Represents a physical address
*/
open class CDAKAddress: NSObject, CDAKJSONInstantiable {
  
  //Pointer back to parent record
  weak var record: CDAKRecord?
  
  // MARK: CDA properties
  ///Street
  open var street: [String] = [String]()
  ///City
  open var city: String?
  ///State
  open var state: String?
  ///Zip code
  open var zip: String?
  ///Country code
  open var country: String?
  /**
   HL7 Address Use codes
   HL7 OID: 2.16.840.1.113883.5.1119
   [Reference] (https://www.hl7.org/fhir/v3/AddressUse/index.html)
  */
  open var use: String?
  
  /**
   Determines whether the address is empty
  */
  open var is_empty: Bool {
    
    let someText: String = "\(street.flatMap({$0}).joined(separator: ""))\(city ?? "")\(state ?? "")\(zip ?? "")\(country ?? "")".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    
    if someText.characters.count > 0 {
      return false
    }
    
    return true
  }
  
  // MARK: - Initializers
  public override init(){
    super.init()
  }
  
  public init(street:[String] = [], city: String?, state: String?, zip: String?, country: String?, use: String?) {
    super.init()
    self.street = street
    self.city = city
    self.state = state
    self.zip = zip
    self.country = country
    self.use = use
  }
  
  // MARK: - Deprecated - Do not use
  ///Do not use - will be removed. Was used in HDS Ruby.
  required public init(event: [String:Any?]) {
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
  override open var description: String {
    return "CDAKAddress => street: \(street), city: \(city), state: \(state), zip: \(zip), country: \(country), use: \(use)"
  }
  
}

extension CDAKAddress: CDAKJSONExportable {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    if street.count > 0 {
      dict["street"] = street as AnyObject?
    }
    if let city = city {
      dict["city"] = city as AnyObject?
    }
    if let state = state {
      dict["state"] = state as AnyObject?
    }
    if let zip = zip {
      dict["zip"] = zip as AnyObject?
    }
    if let country = country {
      dict["country"] = country as AnyObject?
    }
    if let use = use {
      dict["use"] = use as AnyObject?
    }
    return dict
  }
}
