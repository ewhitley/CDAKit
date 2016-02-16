//
//  CDAKQRDAHeader.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKQRDAHeader {
  public var identifier: CDAKQRDAId?
  public var authors: [CDAKQRDAAuthor] = []
  public var custodian: CDAKQRDACustodian?
  public var legal_authenticator: CDAKQRDALegalAuthenticator?
  public var performers: [CDAKProvider] = []
  public var time = NSDate()
  
  //NOTE: not originally in QRDA header
  public var confidentiality: CDAKConfidentialityCodes = .Normal
}

extension CDAKQRDAHeader: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDAHeader => identifier:\(identifier), authors:\(authors), custodian:\(custodian), legal_authenticator:\(legal_authenticator), performers:\(performers), time:\(time), confidentiality: \(confidentiality)"
  }
}

