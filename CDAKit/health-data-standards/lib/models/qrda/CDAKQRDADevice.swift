//
//  CDAKQRDADevice.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

open class CDAKQRDADevice {
  open var name: String?
  open var model: String?
}

extension CDAKQRDADevice: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDADevice => name:\(name), model:\(model)"
  }
}


extension CDAKQRDADevice: MustacheBoxable {
  var boxedValues: [String:MustacheBox] {
    return [
      "name" :  Box(name),
      "model" :  Box(model)
    ]
  }
  
  public var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
}

extension CDAKQRDADevice: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    if let name = name {
      dict["name"] = name as AnyObject?
    }
    if let model = model {
      dict["model"] = model as AnyObject?
    }
    return dict
  }
}
