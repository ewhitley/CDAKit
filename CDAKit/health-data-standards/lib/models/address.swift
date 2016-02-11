//
//  address.swift
//  CCDAccess
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

class HDSAddress: NSObject, HDSJSONInstantiable {
  
  var record: HDSRecord?
  
  var street: [String] = [String]()
  var city: String?
  var state: String?
  var zip: String?
  var country: String?
  var use: String?
  
  
  override init(){
    super.init()
  }
  
  init(street:[String] = [], city: String?, state: String?, zip: String?, country: String?, use: String?) {
    super.init()
    self.street = street
    self.city = city
    self.state = state
    self.zip = zip
    self.country = country
    self.use = use
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
    return "HDSAddress => street: \(street), city: \(city), state: \(state), zip: \(zip), country: \(country), use: \(use)"
  }
  
}