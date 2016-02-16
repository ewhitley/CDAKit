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
  public var type: String?
}

extension CDAKQRDADevice: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDADevice => name:\(name), type:\(type)"
  }
}
