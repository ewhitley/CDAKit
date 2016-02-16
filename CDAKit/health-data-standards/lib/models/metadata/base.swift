//
//  Base.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation




public class CDAKMetadataBase {
  
  static let NS = "http://www.hl7.org/schemas/hdata/2009/11/metadata"
  
  public var mime_types: [String] = [String]()
  public var confidentiality: String?
  public var original_creation_time: NSDate?

  public var pedigrees: [CDAKMetadataPedigree] = [CDAKMetadataPedigree]()
  public var modified_dates: [CDAKMetadataChangeInfo] = [CDAKMetadataChangeInfo]()
  public var copied_dates: [CDAKMetadataChangeInfo] = [CDAKMetadataChangeInfo]()
  public var linked_documents: [CDAKMetadataLinkInfo] = [CDAKMetadataLinkInfo]()
  
  public init(mime_types: [String], confidentiality: String?, original_creation_time: NSDate? ) {
    self.mime_types = mime_types
    if let confidentiality = confidentiality {
      self.confidentiality = confidentiality
    }
    self.original_creation_time = original_creation_time
  }

  public init() {
    
  }
  
}
