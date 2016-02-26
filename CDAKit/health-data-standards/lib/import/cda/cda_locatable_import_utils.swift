//
//  locatable_import_utils.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/11/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi


//# Helpers for importing C32 addresses and telecoms
class CDAKImport_CDA_LocatableImportUtils {

  class func import_address(address_element: XMLElement) -> CDAKAddress? {
    let address = CDAKAddress()
    address.use = address_element["use"]
    address.street = address_element.xpath("./cda:streetAddressLine").map({$0.stringValue})
    address.city = address_element.xpath("./cda:city").first?.stringValue
    address.state = address_element.xpath("./cda:state").first?.stringValue
    address.zip = address_element.xpath("./cda:postalCode").first?.stringValue
    address.country = address_element.xpath("./cda:country").first?.stringValue
    
    if address.is_empty {
      return nil
    }
    return address
  }

  class func import_telecom(telecom_element: XMLElement) -> CDAKTelecom? {
    let tele = CDAKTelecom()
    tele.value = telecom_element["value"]
    tele.use = telecom_element["use"]
    
    if tele.is_empty {
      return nil
    }
    return tele
  }
  
}

