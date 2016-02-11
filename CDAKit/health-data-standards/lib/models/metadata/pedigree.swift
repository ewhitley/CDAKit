//
//  Pedigree.swift
//  CCDAccess
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

class HDSMetadataPedigree {
  
  var organization: String?
  var signature: String?
  var document_method: String?
  var derived: Bool?

  var author: HDSMetadataAuthor?
  var source_pedigrees: [HDSMetadataPedigree] = [HDSMetadataPedigree]()
  var source_documents: [HDSMetadataLinkInfo] = [HDSMetadataLinkInfo]()
  
  init(organization: String?, signature: String?, document_method: String?, derived: Bool?  ) {
    self.organization = organization
    self.signature = signature
    self.document_method = document_method
    self.derived = derived
  }
  
  init() {
  }
  
}
