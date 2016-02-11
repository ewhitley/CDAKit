//
//  Base.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

class HDSMetadataBase {
  
  static let NS = "http://www.hl7.org/schemas/hdata/2009/11/metadata"
  
  var mime_types: [String] = [String]()
  var confidentiality: String?
  var original_creation_time: NSDate?

  var pedigrees: [HDSMetadataPedigree] = [HDSMetadataPedigree]()
  var modified_dates: [HDSMetadataChangeInfo] = [HDSMetadataChangeInfo]()
  var copied_dates: [HDSMetadataChangeInfo] = [HDSMetadataChangeInfo]()
  var linked_documents: [HDSMetadataLinkInfo] = [HDSMetadataLinkInfo]()
  
  init(mime_types: [String], confidentiality: String?, original_creation_time: NSDate? ) {
    self.mime_types = mime_types
    self.confidentiality = confidentiality
    self.original_creation_time = original_creation_time
  }

  init() {
    
  }
  
}
