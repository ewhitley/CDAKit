//
//  bulk_record_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/11/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

public enum CDAKImportError : Error {
  case notImplemented
  case unableToDetermineFormat
  case noClinicalDocumentElement
  case invalidXML
}


internal class CDAKImport_BulkRecordImporter {
  
  internal class func importRecord(_ XMLString: String, providier_map:[String:CDAKProvider] = [:]) throws -> CDAKRecord {
    
    do {
      let doc = try XMLDocument(string: XMLString, encoding: String.Encoding.utf8)
      
      if let root = doc.root {
        if let root_element_name = root.tag , root_element_name == "ClinicalDocument" {
          
          doc.definePrefix("cda", defaultNamespace: "urn:hl7-org:v3")
          doc.definePrefix("sdtc", defaultNamespace: "urn:hl7-org:sdtc")
          doc.definePrefix("mif", defaultNamespace: "urn:hl7-org:v3/mif")
          
          if doc.xpath("/cda:ClinicalDocument/cda:templateId[@root='2.16.840.1.113883.3.88.11.32.1']").count > 0 {
            print("Deteremined XML document format as: C32")
            let importer = CDAKImport_C32_PatientImporter()
            let record = importer.parse_c32(doc)
            record.header = CDAKImport_cat1_HeaderImporter.import_header(doc)
            return record
          } else if doc.xpath("/cda:ClinicalDocument/cda:templateId[@root='2.16.840.1.113883.10.20.22.1.2']").count > 0 {
            print("Deteremined XML document format as: CCDA")
            let importer = CDAKImport_CCDA_PatientImporter()
            let record = importer.parse_ccda(doc)
            record.header = CDAKImport_cat1_HeaderImporter.import_header(doc)
            return record
          } else if doc.xpath("/cda:ClinicalDocument/cda:templateId[@root='2.16.840.1.113883.10.20.24.1.2']").count > 0 {
            print("QRDA1 not (yet) supported")
            throw CDAKImportError.notImplemented
          } else if doc.xpath("/cda:ClinicalDocument/cda:templateId[@root='2.16.840.1.113883.10.20.22.1.1']").count > 0 && CDAKGlobals.sharedInstance.attemptNonStandardCDAImport == true {
            //last ditch "we have a general US header, but that's about it"
            print("Deteremined XML document format as: Non-Standard CDA. This may or may not import completely.")
            let importer = CDAKImport_CCDA_PatientImporter()
            let record = importer.parse_ccda(doc)
            record.header = CDAKImport_cat1_HeaderImporter.import_header(doc)
            return record
          } else {
            print("Unable to determinate document template/type of CDA document")
            throw CDAKImportError.unableToDetermineFormat
          }
        } else {
          print("XML does not appear to be a valid ClinicalDocument")
          throw CDAKImportError.noClinicalDocumentElement
        }
      } else {
        throw CDAKImportError.invalidXML
      }
    } catch let error as XMLError {
      switch error {
      case .parserFailure, .invalidData: print(error)
      case .libXMLError(let code, let message):
        print("libxml error code: \(code), message: \(message)")
      default: print(error)
      }
      
      throw CDAKImportError.invalidXML
      
    }
  }
  
}

