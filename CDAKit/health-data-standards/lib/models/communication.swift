//
//  communication.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

/**
 Communication
 Could represent provider to patient, etc.
*/
open class CDAKCommunication: CDAKEntry {
  // MARK: CDA properties
  ///Direction of communication
  open var direction: String?
}

extension CDAKCommunication {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let direction = direction {
      dict["direction"] = direction as AnyObject?
    }
    
    return dict
  }
}
