//
//  locatable_import_utils.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/11/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi


//# Helpers for importing C32 addresses and telecoms
class HDSImport_CDA_LocatableImportUtils {

  class func import_address(address_element: XMLElement) -> HDSAddress {
    let address = HDSAddress()
    address.use = address_element["use"]
    address.street = address_element.xpath("./cda:streetAddressLine").map({$0.stringValue})
    address.city = address_element.xpath("./cda:city").first?.stringValue
    address.state = address_element.xpath("./cda:state").first?.stringValue
    address.zip = address_element.xpath("./cda:postalCode").first?.stringValue
    address.country = address_element.xpath("./cda:country").first?.stringValue
    return address
  }

  class func import_telecom(telecom_element: XMLElement) -> HDSTelecom {
    let tele = HDSTelecom()
    tele.value = telecom_element["value"]
    tele.use = telecom_element["use"]
    return tele
  }
  
}

