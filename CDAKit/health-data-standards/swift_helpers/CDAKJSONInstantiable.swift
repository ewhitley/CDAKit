//
//  CDAKProtocols.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation


///Do not use - will be removed. Was used in HDS Ruby.
internal protocol CDAKJSONInstantiable {
  // MARK: - Deprecated - Do not use
  ///Do not use - will be removed. Was used in HDS Ruby.
  init(event: [String:Any?])
}

//this should be removed
// individual classes will handle this, NOT a Ruby-like reflection mechanism

extension CDAKJSONInstantiable {
  func initFromEventList(_ event: [String:Any?]) {
    for (key, value) in event {
      CDAKUtility.setProperty(self, property: key, value: value)
    }
  }
}

