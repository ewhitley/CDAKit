//
//  CDAKExport.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/4/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache


public class CDAKExport {
  
  public enum CDAKExportFormat: String {
    case ccda  = "ccda"
    case c32 = "c32"
  }
  

  public class func export(patientRecord record: CDAKRecord, inFormat format: CDAKExportFormat) -> String {
    
    var rendering = ""
    
    let template_helper = CDAKTemplateHelper(template_format: format.rawValue, template_subdir: format.rawValue, template_directory: nil)
    let template = template_helper.template("show")
    
    let data = ["patient": record]
    
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
    
    return rendering
    
  }
  
}
