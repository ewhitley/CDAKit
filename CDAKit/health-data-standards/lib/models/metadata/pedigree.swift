//
//  Pedigree.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

class CDAKMetadataPedigree {
  
  var organization: String?
  var signature: String?
  var document_method: String?
  var derived: Bool?

  var author: CDAKMetadataAuthor?
  var source_pedigrees: [CDAKMetadataPedigree] = [CDAKMetadataPedigree]()
  var source_documents: [CDAKMetadataLinkInfo] = [CDAKMetadataLinkInfo]()
  
  init(organization: String?, signature: String?, document_method: String?, derived: Bool?  ) {
    self.organization = organization
    self.signature = signature
    self.document_method = document_method
    self.derived = derived
  }
  
  init() {
  }
  
}
