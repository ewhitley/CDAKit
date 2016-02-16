//
//  CDAKQRDAId.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKQRDAId {
  public var extension_id: String?
  public var root: String?
  
  init(){
  }
  
  init(root: String? = nil, extension_id: String? = nil) {
    if let root = root {
      self.root = root
    }
    if let extension_id = extension_id {
      self.extension_id = extension_id
    }
  }
  
}

extension CDAKQRDAId: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDAId => extension_id:\(extension_id), root:\(root)"
  }
}

