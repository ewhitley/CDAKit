//
//  bulk_record_importer.swift
//  CCDAccess
//
//  Created by Eric Whitley on 1/11/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class HDSImport_BulkRecordImporter {
  
  class func importRecord(XMLString: String, providier_map:[String:HDSProvider] = [:]) -> HDSRecord? {
    
    do {
      let doc = try XMLDocument(string: XMLString, encoding: NSUTF8StringEncoding)
      
      //      var providers: [String] = [] //change this
      //      var root_element_name = doc.root.name
      
      if let root = doc.root {
        if let root_element_name = root.tag where root_element_name == "ClinicalDocument" {
          //print(root_element_name)
          
          doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
          doc.definePrefix("sdtc", defaultNamespace: "urn:hl7-org:sdtc")
          doc.definePrefix("mif", defaultNamespace: "urn:hl7-org:v3/mif")
          
          if doc.xpath("/cda:ClinicalDocument/cda:templateId[@root='2.16.840.1.113883.3.88.11.32.1']").count > 0 {
            print("Deteremined XML document format as: C32")
            let importer = HDSImport_C32_PatientImporter()
            let record = importer.parse_c32(doc)
            return record
          } else if doc.xpath("/cda:ClinicalDocument/cda:templateId[@root='2.16.840.1.113883.10.20.22.1.2']").count > 0 {
            print("Deteremined XML document format as: CCDA")
            let importer = HDSImport_CCDA_PatientImporter()
            let record = importer.parse_ccda(doc)
            return record
          } else if doc.xpath("/cda:ClinicalDocument/cda:templateId[@root='2.16.840.1.113883.10.20.24.1.2']").count > 0 {
            print("QRDA1 not (yet) supported")
          } else {
            print("Unable to determinate document template/type of CDA document")
          }
        } else {
          print("XML does not appear to be a valid ClinicalDocument")
        }
      }
    } catch let error as XMLError {
      switch error {
      case .NoError: print("wth this should not appear")
      case .ParserFailure, .InvalidData: print(error)
      case .LibXMLError(let code, let message):
        print("libxml error code: \(code), message: \(message)")
      }
    } catch let error as NSError {
      print("Error: \(error.localizedDescription)")
    }

    return nil
  }
  
}

