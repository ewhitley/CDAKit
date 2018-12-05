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
open class CDAKExport {
  
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
  open class func export(patientRecord record: CDAKRecord, inFormat format: CDAKExportFormat) -> String {
    
    var rendering = ""
    
    let repo = TemplateRepository(bundle: CDAKCommonUtility.bundle)
    do {
      let template = try repo.template(named: "\(format)_show.\(format)")

      let data = ["patient": record]
      
      
      // we need to register our Mustache helpers
      //---------
      // USE: telecoms:{{#each(patient.telecoms)}} hi {{value}} {{use}} {{/}}
      template.register(Box(StandardLibrary.each), forKey: "each")
      // USE: {{ UUID_generate(nil) }}
      template.register(Box(MustacheFilters.UUID_generate), forKey: "UUID_generate" )
      // USE: {{ date_as_number(z) }}, nil: {{ date_as_number(nil) }}
      template.register(Box(MustacheFilters.DateAsNumber), forKey: "date_as_number" )
      template.register( Box(MustacheFilters.DateAsHDSString), forKey: "date_as_string")
      
      // USE: {{ value_or_null_flavor(entry.as_point_in_time) }}
      template.register(Box(MustacheFilters.value_or_null_flavor), forKey:"value_or_null_flavor")
      template.register(Box(MustacheFilters.oid_for_code_system), forKey: "oid_for_code_system")
      template.register(Box(MustacheFilters.is_numeric), forKey:"is_numeric")
      template.register(Box(MustacheFilters.is_bool), forKey: "is_bool")
      
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
