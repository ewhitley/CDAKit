//
//  ChangeInfo.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

class CDAKMetadataChangeInfo {
  
  var timestamp: NSDate?
  var pedigree: CDAKMetadataPedigree?
    
  init(timestamp: NSDate? ) {
    self.timestamp = timestamp
  }
  
}
