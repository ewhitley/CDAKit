//
//  SwiftUtility.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

class CDAKCommonUtility {

  static let podName = "CDAKit"
  static var bundle: NSBundle {
    let frameworkBundle = NSBundle(forClass: CDAKTemplateHelper.self)
    //if we're in a pod, look for our own bundle in the parent project
    if let bundlePath = frameworkBundle.pathForResource(podName, ofType: "bundle") {
      if let myBundle = NSBundle.init(path: bundlePath) {
        return myBundle
      }
    }
    //otherwise, try to just return ourselves like this
    return frameworkBundle
  }
  
  class func classNameAsString(obj: Any, removeOptional: Bool = true) -> String {
    //    //prints more readable results for dictionaries, arrays, Int, etc
    var class_name = String(obj.dynamicType).componentsSeparatedByString(".").last!
    if removeOptional == true && class_name.containsString("Optional") {
      class_name = CDAKCommonUtility.Regex.replaceMatches("(?:^|\")([^\"]*)(?:$|\")", inString: class_name, withString: "")!
    }

    return class_name
  }
  
  
  class Regex
  {
    //from Ray Wenderlich's example - really nice stuff
    class func listGroups(pattern: String, inString string: String) -> [String] {
      var groupMatches = [String]()

      do {
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let range = NSMakeRange(0, string.characters.count)
        let matches = regex.matchesInString(string, options: [], range: range)
        
        for match in matches {
          let rangeCount = match.numberOfRanges
          
          for group in 0..<rangeCount {
            groupMatches.append((string as NSString).substringWithRange(match.rangeAtIndex(group)))
          }
        }
      }
      catch {
        
      }
        
      return groupMatches
    }
    
    class func replaceMatches(pattern: String, inString string: String, withString replacementString: String) -> String? {
      do {
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let range = NSMakeRange(0, string.characters.count)
        
        return regex.stringByReplacingMatchesInString(string, options: [], range: range, withTemplate: replacementString)
      }
      catch {
        fatalError("replaceMatches Exception with pattern '\(pattern)'")
      }
    }
    
    //from Ray Wenderlich
    class func listMatches(pattern: String, inString string: String) -> [String] {
      do {
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let range = NSMakeRange(0, string.characters.count)
        let matches = regex.matchesInString(string, options: [], range: range)
        
        return matches.map {
          let range = $0.range
          return (string as NSString).substringWithRange(range)
        }
      }
      catch {
        fatalError("listMatches Exception with pattern '\(pattern)' ")
      }
    }
    
    //from Ray Wenderlich
    class func containsMatch(pattern: String, inString string: String) -> Bool {
      do {
        let regex = try NSRegularExpression(pattern: pattern, options: [] )
        let range = NSMakeRange(0, string.characters.count)
        return regex.firstMatchInString(string, options: [], range: range) != nil
      }
      catch {
        fatalError("containsMatch Exception with pattern '\(pattern)' ")
      }
    }
    
  }

  
  
  class func load_json_from_file(filename:String) -> NSDictionary
  {
    let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json")
    if let path = path
    {
      do {
        let jsonData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
        let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
      
        return jsonResult
      }
      catch {
        fatalError("load_json_from_file -> failed to map '\(filename).json'")
      }
    }
    else
    {
      fatalError("load_json_from_file -> failed to find '\(filename).json'")
    }
  }
  
  class func load_xml_data_from_file(filename: String) -> NSData
  {
    let filepath = NSBundle.mainBundle().pathForResource(filename, ofType: "xml")
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
    let data = CDAKCommonUtility.load_xml_data_from_file(filename)
    
    if let xml = NSString(data: data, encoding: NSUTF8StringEncoding) as? String
    {
      return xml
    }
    else
    {
      fatalError("load_xml_string_from_file -> failed to convert to string for '\(filename).xml'")
    }
  }
  
  //https://medium.com/swift-programming/4-json-in-swift-144bf5f88ce4
  class func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
    //var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
    let options = prettyPrinted ?
      NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
    
    if NSJSONSerialization.isValidJSONObject(value) {
      do {
        let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
        if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
          return string as String
        }
      }
      catch {
      }
    }
    return ""
  }
  
  //https://medium.com/swift-programming/4-json-in-swift-144bf5f88ce4
  class func JSONParseDictionary(jsonString: String) -> [String: AnyObject] {
    if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
      do {
        let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))  as? [String: AnyObject]
        return dictionary!
      }
      catch {
        
      }
    }
    return [String: AnyObject]()
  }

  //http://api.rubyonrails.org/classes/ERB/Util.html
  //https://github.com/Halotis/EscapeHTML/blob/master/EscapeHTML/EscapeHTML.swift
  class func html_escape(html: String?) -> String{
    if let html = html {
      var result = html.stringByReplacingOccurrencesOfString("&", withString: "&amp;", options: [], range: nil)
      result = result.stringByReplacingOccurrencesOfString("\"", withString: "&quot;", options: [], range: nil)
      result = result.stringByReplacingOccurrencesOfString("'", withString: "&#39;", options: [], range: nil)
      result = result.stringByReplacingOccurrencesOfString("<", withString: "&lt;", options: [], range: nil)
      result = result.stringByReplacingOccurrencesOfString(">", withString: "&gt;", options: [], range: nil)
      return result
    }
    return ""
  }
  
  
  
}