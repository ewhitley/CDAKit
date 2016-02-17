//
//  CDAKQRDAId.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

//import Foundation

//Removing this class - redundant
//This class is identical to the existing CDA Identifier class, so I'm getting rid of this one
/*
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

extension CDAKQRDAId: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    if let root = root {
      dict["root"] = root
    }
    if let extension_id = extension_id {
      dict["extension"] = extension_id
    }
    return dict
  }
}
*/



