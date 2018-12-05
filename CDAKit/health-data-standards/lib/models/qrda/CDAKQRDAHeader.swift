//
//  CDAKQRDAHeader.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/16/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

open class CDAKQRDAHeader {
  open var identifier: CDAKCDAIdentifier?
  open var authors: [CDAKQRDAAuthor] = []
  open var custodian: CDAKQRDACustodian?
  open var legal_authenticator: CDAKQRDALegalAuthenticator?
  open var performers: [CDAKProvider] = []
  //FIX_ME: For now, ignore this.  This is probably coming from the record that contains the header and the performers (providers) related to this record. I'm not sure how they do this in Mongo, but I can't find any direct cases of this being explicilty populated in the header. This is really only used for QRDA3 right now, so let's just defer doing this.
  open var time = Date()
  
  //NOTE: not originally in QRDA header.  Adding because we want to be able to vary this
  open var confidentiality: CDAKConfidentialityCodes = .Normal
  open var title: String?
}

extension CDAKQRDAHeader: CustomStringConvertible {
  public var description: String {
    return "CDAKQRDAHeader => identifier:\(identifier), authors:\(authors), custodian:\(custodian), legal_authenticator:\(legal_authenticator), performers:\(performers), time:\(time), confidentiality: \(confidentiality)"
  }
}

extension CDAKQRDAHeader: MustacheBoxable {
  
  var boxedValues: [String:MustacheBox] {
    var vals: [String:MustacheBox] = [String:MustacheBox]()

    if let identifier = identifier {
        vals["identifier"] = Box(identifier)
    }
    if authors.count > 0 {
      vals["authors"] = Box(authors)
    }
    if let custodian = custodian {
      vals["custodian"] = Box(custodian)
    }
    if let legal_authenticator = legal_authenticator {
      vals["legal_authenticator"] = Box(legal_authenticator)
    }
    if performers.count > 0 {
      vals["performers"] = Box(performers)
    }
    
    vals["time"] = Box(time.timeIntervalSince1970)
    vals["confidentiality"] = Box(confidentiality.rawValue)
    if let title = title {
      vals["title"] = Box(title)
    }
    
    
    return vals
  }
  
  
  public var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
}

extension CDAKQRDAHeader: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    if let identifier = identifier {
      dict["identifier"] = identifier.jsonDict as AnyObject?
    }
    if authors.count > 0 {
      dict["authors"] = authors.map({$0.jsonDict}) as AnyObject?
    }
    if let custodian = custodian {
      dict["custodian"] = custodian.jsonDict as AnyObject?
    }
    if let legal_authenticator = legal_authenticator {
      dict["legal_authenticator"] = legal_authenticator.jsonDict as AnyObject?
    }
    if performers.count > 0 {
      dict["performers"] = performers as AnyObject?
    }
    dict["time"] = time.description as AnyObject?
    if let title = title {
      dict["title"] = title as AnyObject?
    }
    return dict
  }
}
