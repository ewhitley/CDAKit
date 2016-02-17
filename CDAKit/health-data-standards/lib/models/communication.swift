//
//  communication.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKCommunication: CDAKEntry {
  public var direction: String?
}

extension CDAKCommunication {
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let direction = direction {
      dict["direction"] = direction
    }
    
    return dict
  }
}
