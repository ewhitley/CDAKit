//
//  ChangeInfo.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKMetadataChangeInfo {
  
  public var timestamp: NSDate?
  public var pedigree: CDAKMetadataPedigree?
    
  public init(timestamp: NSDate? ) {
    self.timestamp = timestamp
  }
  
}
