//
//  ChangeInfo.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

class HDSMetadataChangeInfo {
  
  var timestamp: NSDate?
  var pedigree: HDSMetadataPedigree?
    
  init(timestamp: NSDate? ) {
    self.timestamp = timestamp
  }
  
}
