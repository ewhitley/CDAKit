//
//  CDAKQRDAHeader.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKQRDAHeader {
  public var identifier: CDAKCDAIdentifier?
  public var authors: [CDAKQRDAAuthor] = []
  public var custodian: CDAKQRDACustodian?
  public var legal_authenticator: CDAKQRDALegalAuthenticator?
  public var performers: [CDAKProvider] = []
  //FIXME: For now, ignore this.  This is probably coming from the record that contains the header and the performers (providers) related to this record. I'm not sure how they do this in Mongo, but I can't find any direct cases of this being explicilty populated in the header. This is really only used for QRDA3 right now, so let's just defer doing this.
  public var time = NSDate()
  
  //NOTE: not originally in QRDA header.  Adding because we want to be able to vary this
  public var confidentiality: CDAKConfidentialityCodes = .Normal
  public var title: String?
}

extension CDAKQRDAHeader: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDAHeader => identifier:\(identifier), authors:\(authors), custodian:\(custodian), legal_authenticator:\(legal_authenticator), performers:\(performers), time:\(time), confidentiality: \(confidentiality)"
  }
}

extension CDAKQRDAHeader: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    if let identifier = identifier {
      dict["identifier"] = identifier.jsonDict
    }
    if authors.count > 0 {
      dict["authors"] = authors.map({$0.jsonDict})
    }
    if let custodian = custodian {
      dict["custodian"] = custodian.jsonDict
    }
    if let legal_authenticator = legal_authenticator {
      dict["legal_authenticator"] = legal_authenticator.jsonDict
    }
    if performers.count > 0 {
      dict["performers"] = performers
    }
    dict["time"] = time.description
    if let title = title {
      dict["title"] = title
    }
    return dict
  }
}
