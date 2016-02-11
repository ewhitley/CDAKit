//
//  TestHelpers.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/25/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

//TestHelpers.collections.providers.load_providers()
//TestHelpers.fileHelpers.load_xml_string_from_file()
//http://stackoverflow.com/questions/1879247/why-cant-code-inside-unit-tests-find-bundle-resources


class TestHelpers {
  class collections {
    class providers {
      
      class func load_providers() {

        let provider_1 = HDSProvider()
        provider_1.title = "Dr."
        provider_1.given_name = "Robert"
        provider_1.family_name = "Kildare"
        provider_1.cda_identifiers.append(HDSCDAIdentifier(root: "2.16.840.1.113883.3.72.5.2", extension_id: "Kildare"))
        
        let provider_2 = HDSProvider()
        provider_2.title = "Dr."
        provider_2.given_name = "FirstName"
        provider_2.family_name = "LastName"
        provider_2.cda_identifiers.append(HDSCDAIdentifier(root: "2.16.840.1.113883.3.72.5.2", extension_id: "LastName"))
        provider_2.addresses.append(HDSAddress(street: ["100 Bureau Drive"], city: "Gaithersburg", state: "MD", zip: "20899", country: "US", use: nil))

        let provider_3 = HDSProvider()
        provider_3.title = "Dr."
        provider_3.given_name = "John"
        provider_3.family_name = "Watson"
        provider_3.cda_identifiers.append(HDSCDAIdentifier(root: "2.16.840.1.113883.3.72.5.2", extension_id: "Watson"))

        let provider_4 = HDSProvider()
        provider_4.title = "Dr."
        provider_4.given_name = "Pseudo"
        provider_4.family_name = "Physician-1"
        provider_4.specialty = "200000000X"
        provider_4.cda_identifiers.append(HDSCDAIdentifier(root: "2.16.840.1.113883.3.72.5.2", extension_id: "PseudoMD-1"))

        let provider_5 = HDSProvider()
        provider_5.title = "Dr."
        provider_5.given_name = "Pseudo"
        provider_5.family_name = "Physician-2"
        provider_5.specialty = "200000000X"
        provider_5.cda_identifiers.append(HDSCDAIdentifier(root: "2.16.840.1.113883.3.72.5.2", extension_id: "PseudoMD-2"))

        let provider_6 = HDSProvider()
        provider_6.title = "Dr."
        provider_6.given_name = "Pseudo"
        provider_6.family_name = "Physician-2"
        provider_6.cda_identifiers.append(HDSCDAIdentifier(root: "2.16.840.1.113883.3.72.5.2", extension_id: "PseudoMD-3"))
        provider_6.addresses.append(HDSAddress(street: ["100 Bureau Drive"], city: "Gaithersburg", state: "MD", zip: "20899", country: "US", use: nil))
        
        
      }
      
    }
  }
  
  
  class fileHelpers {
    
    class func load_xml_data_from_file(filename: String) -> NSData
    {
      let bundle = NSBundle(forClass: TestHelpers.self)

      let filepath = bundle.pathForResource(filename, ofType: "xml")
      if let filepath = filepath
      {
        if let data = NSData(contentsOfURL: NSURL(fileURLWithPath: filepath))
        {
          return data
        }
        else
        {
          fatalError("load_xml_from_file -> failed to map data '\(filename).xml'")
        }
      }
      else
      {
        fatalError("load_xml_from_file -> failed to find file '\(filename).xml'")
      }
    }
    
    class func load_xml_string_from_file(filename: String) -> String
    {
      let data = load_xml_data_from_file(filename)
      
      if let xml = NSString(data: data, encoding: NSUTF8StringEncoding) as? String
      {
        return xml
      }
      else
      {
        fatalError("load_xml_string_from_file -> failed to convert to string for '\(filename).xml'")
      }
    }
    
  }
  
}