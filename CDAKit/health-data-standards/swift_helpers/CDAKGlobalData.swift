//
//  CDAKGlobalData.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation




public class CDAKGlobals {

  public static let sharedInstance = CDAKGlobals()
  
  private init() {
  }

  /**
   Allows importing of "non-standard" CDA documents.  If we find an XML file with the general CDA header we're going to attempt to import it
   
   Any document with a template ID of "2.16.840.1.113883.10.20.22.1.1", but does not conform to another known OID for a CCDA / C32 type (or whatever else we support) will be caught and send through the CCDA importer.
   
   The default value is "false."  You will need to explicitly enable this if you want to attempt to import unknown document types.
  */
  public var attemptNonStandardCDAImport = false
  
  /**
   Returns all providers discovered during import of all records.
   
   It is possible that, during import, a provider is "dropped" and not imported.  This can occur if the provider already "exists" in this collection based on matching rules.  The system will only import ONE copy of a given provider where a "match" is found.  Match rules include things like "same NPI" or (failing NPI match) "same name(s)."
   */
  public var allProviders: [CDAKProvider] {
    get {
      return CDAKProviders
    }
  }
  var CDAKProviders = [CDAKProvider]()

  /**
   Returns all records imported during all sessions
  */
  public var allRecords: [CDAKRecord] {
    get {
      return CDAKRecords
    }
  }
  var CDAKRecords = [CDAKRecord]()
  
  /**
   Allows extension of known code systems as we find new ones - or you can add them explicitly.
   
   Requires entry in the format - "OID": "VocabualaryName"
  
   EX: "2.16.840.1.113883.6.1" :    "LOINC",

   During import this will be automatically extended to incorporate new types that are not in the original Ruby version of HDS.
   
   */
  public var CDAK_EXTENDED_CODE_SYSTEMS: [String:String] = CDAKCodeSystemHelper.CODE_SYSTEMS
  
}


