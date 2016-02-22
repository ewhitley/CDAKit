//
//  template_helper.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/21/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//
//
//import Foundation
//import Mustache
//
// Class no longer used.  Was originally in HDS, but we're just using GRMustache's template repository now instead.  Leaving in for reference for now.
////# Class that finds ERb templates. Here is how it can be configured:
////# [template_format] What format (C32, CCDA, etc) are we looking for. This will cause
////#                   the TemplateHelper to look for template_name.template_format.erb
////# [template_subdir] The sub directory where templates live. If none is provided, it
////#                   will look for templates in the root of the template_directory
////# [template_directory] The root directory to look in for templates. By default, it
////#                      is in the template folder of this gem. It can be handy to
////#                      provide a different directory if you want to use this class
////#                      outside of the CDAK gem
//
//class CDAKTemplateHelper {
//
//  static let TEMPLATE_DIRECTORY = "health-data-standards/templates/" //make sure whatever you set is in the build phases (resources)
//  static let TEMPLATE_EXTENSION = "mustache"
//  
//  let use_paths = false
//  
////  let frameworkBundle = NSBundle(identifier: "ericwhitley.org.CDAKit")//should fix bundle ID to follow org.x.app
//  
//
//  
//  class TemplateCacheEntry {
//    var mtime: NSDate        //  1450359800
//    var filename: String  // /templates/c32/_allergies.c32.erb
//    var erb: Mustache.Template       // erb string
//    
//    init(mtime: NSDate, filename: String, erb: Mustache.Template) {
//      self.mtime = mtime
//      self.filename = filename
//      self.erb = erb
//    }
//  }
//  
//  var template_format: String
//  var template_subdir: String?
//  var template_directory: String = CDAKTemplateHelper.TEMPLATE_DIRECTORY
//  var template_cache: [String:TemplateCacheEntry] = [String:TemplateCacheEntry]()
//  // ex: for keys -> _allergies, _narrative_block, _code_with_reference
//  
//  init(template_format: String, template_subdir: String? = nil, template_directory: String? = nil){
//    self.template_format = template_format
//    self.template_subdir = template_subdir
//    if let template_directory = template_directory {
//      self.template_directory = template_directory
//    }
//    
//  }
//  
//  var template_root: String? {
//    if use_paths == true {
//      if let template_subdir = template_subdir {
//        return template_directory + template_subdir
//      } else {
//        return template_directory
//      }
//    } else {
//      return nil
//    }
//  }
//  
//  //# Returns the raw ERb for the template_name provided. This method will look in
//  //# template_directory/template_subdir/template_name.template_format.erb
//  func template(template_name: String) -> Mustache.Template {
//    return cache_template(template_name)
//  }
//  
//  //# Basically the same template, but prepends an underscore to the template name
//  //# to mimic the Rails convention for template fragments
//  func partial(partial_name: String) -> Mustache.Template {
//    return cache_template("_\(partial_name)")
//  }
//  
//  //NOTE: We're not going to follow the example here
//  func cache_template(template_name: String) -> Mustache.Template {
//    
//    let entry = template_cache[template_name]// ?? TemplateCacheEntry(mtime: -1, filename: nil, erb: nil)
//
//    let fileName = "\(template_format)_\(template_name).\(template_format)"
//    
//    
//    guard let filePath = CDAKCommonUtility.bundle.pathForResource(fileName, ofType: CDAKTemplateHelper.TEMPLATE_EXTENSION) else {
//      fatalError("Failed to find template '\(fileName).\(CDAKTemplateHelper.TEMPLATE_EXTENSION)' in path '\(template_root)' ")
//    }
//    
//    do {
//      let templateURL = NSURL(fileURLWithPath: filePath)
//      
//      let templateAttributes = try NSFileManager.defaultManager().attributesOfItemAtPath(filePath)
//      guard let fileModDate: NSDate = templateAttributes["NSFileModificationDate"] as? NSDate else {
//        fatalError("Unable to obtain NSFileModificationDate from template '\(fileName).\(CDAKTemplateHelper.TEMPLATE_EXTENSION)' in path '\(template_root)' ")
//      }
//      
//      if entry == nil || entry?.mtime.compare(fileModDate) == .OrderedAscending  {
//        //if our entry is either empty or older than the current file, load from file
//        let template = try Template(URL: templateURL)
//        let newEntry = TemplateCacheEntry(mtime: fileModDate, filename: fileName, erb: template)
//        template_cache[template_name] = newEntry
//        return newEntry.erb
//      }
//    }
//    catch let error as MustacheError {
//      fatalError("Failed to process template '\(fileName).\(CDAKTemplateHelper.TEMPLATE_EXTENSION)' in path '\(template_root)' . Line \(error.lineNumber) - \(error.kind). Error: \(error.description)")
//
//    }
//    catch let error as NSError {
//      fatalError("Failed to load template '\(fileName).\(CDAKTemplateHelper.TEMPLATE_EXTENSION)' in path '\(template_root)'. Exception: \(error.localizedDescription) ")
//    }
//    catch {
//      fatalError("Failed to load template '\(fileName).\(CDAKTemplateHelper.TEMPLATE_EXTENSION)' in path '\(template_root)' ")
//    }
//    
//    return entry!.erb
//  }
//  
//}