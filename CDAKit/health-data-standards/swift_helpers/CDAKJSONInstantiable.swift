//
//  CDAKProtocols.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation


///do not use - will be removed
internal protocol CDAKJSONInstantiable {
  ///do not use - will be removed
  init(event: [String:Any?])
}

//this should be removed
// individual classes will handle this, NOT a Ruby-like reflection mechanism

extension CDAKJSONInstantiable {
  func initFromEventList(event: [String:Any?]) {
    for (key, value) in event {
      CDAKUtility.setProperty(self, property: key, value: value)
    }
  }
}

