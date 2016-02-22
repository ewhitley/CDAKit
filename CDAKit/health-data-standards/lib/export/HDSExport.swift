//
//  CDAKExport.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/4/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

/**
 Primary CDA export class
*/
public class CDAKExport {
  
  /**
   Provides list of known CDA export types
   
   - ccda
   - c32
  */
  public enum CDAKExportFormat: String {
    case ccda  = "ccda"
    case c32 = "c32"
  }
  
  /**
   Exports provided record to CDA XML in requested format
   
   - parameter record: CDAKRecord you wish to export to XML
   - parameter format: Specified format (from CDAKExportFormat). (.c32, .ccda)
  */
  public class func export(patientRecord record: CDAKRecord, inFormat format: CDAKExportFormat) -> String {
    
    var rendering = ""
    
    let repo = TemplateRepository(bundle: CDAKCommonUtility.bundle)
    do {
      let template = try repo.template(named: "\(format)_show.\(format)")

      let data = ["patient": record]
      
      
      // we need to register our Mustache helpers
      //---------
      // USE: telecoms:{{#each(patient.telecoms)}} hi {{value}} {{use}} {{/}}
      template.registerInBaseContext("each", Box(StandardLibrary.each))
      // USE: {{ UUID_generate(nil) }}
      template.registerInBaseContext("UUID_generate", Box(MustacheFilters.UUID_generate))
      // USE: {{ date_as_number(z) }}, nil: {{ date_as_number(nil) }}
      template.registerInBaseContext("date_as_number", Box(MustacheFilters.DateAsNumber))
      template.registerInBaseContext("date_as_string", Box(MustacheFilters.DateAsHDSString))
      
      // USE: {{ value_or_null_flavor(entry.as_point_in_time) }}
      template.registerInBaseContext("value_or_null_flavor", Box(MustacheFilters.value_or_null_flavor))
      template.registerInBaseContext("oid_for_code_system", Box(MustacheFilters.oid_for_code_system))
      template.registerInBaseContext("is_numeric", Box(MustacheFilters.is_numeric))
      template.registerInBaseContext("is_bool", Box(MustacheFilters.is_bool))
      
      do {
        rendering = try template.render(Box(data))
      }
      catch let error as MustacheError {
        print("Failed to process template. Line \(error.lineNumber) - \(error.kind). Error: \(error.description)")
      }
      catch let error as NSError {
        print(error.localizedDescription)
      }
    }
    catch let error as NSError {
      print(error.localizedDescription)
    }
    
    return rendering
    
  }
  
}
