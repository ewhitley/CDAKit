//
//  CDAKQRDADevice.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKQRDADevice {
  public var name: String?
  public var model: String?
}

extension CDAKQRDADevice: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDADevice => name:\(name), model:\(model)"
  }
}


extension CDAKQRDADevice: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    if let name = name {
      dict["name"] = name
    }
    if let model = model {
      dict["model"] = model
    }
    return dict
  }
}