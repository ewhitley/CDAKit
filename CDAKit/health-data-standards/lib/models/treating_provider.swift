//
//  treating_provider.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

/**
Information about provider who rendered care
*/
public class CDAKTreatingProvider: CDAKEntry {
  
  // MARK: CDA properties

  ///identifier
  public var treatingProviderID: Int?
}

extension CDAKTreatingProvider {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let treatingProviderID = treatingProviderID {
      dict["treatingProviderID"] = treatingProviderID
    }
    
    return dict
  }
}