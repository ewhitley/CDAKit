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
  static var bundle: Bundle {
    
    let frameworkBundle = Bundle(for: CDAKCommonUtility.self)
    //if we're in a pod, look for our own bundle in the parent project
    if let bundlePath = frameworkBundle.path(forResource: podName, ofType: "bundle") {
      if let myBundle = Bundle.init(path: bundlePath) {
        //print("CDAKCommonUtility -> myBundle.bundlePath = '\(myBundle.bundlePath)'")
        return myBundle
      }
    }
    //otherwise, try to just return ourselves like this
    //print("CDAKCommonUtility -> frameworkBundle = '\(frameworkBundle.bundlePath)'")
    return frameworkBundle
  }
  
  class func classNameAsString(_ obj: Any, removeOptional: Bool = true) -> String {
    //    //prints more readable results for dictionaries, arrays, Int, etc
    var class_name = String(describing: type(of: (obj) as AnyObject)).components(separatedBy: ".").last!
    if removeOptional == true && class_name.contains("Optional") {
      class_name = CDAKCommonUtility.Regex.replaceMatches("(?:^|\")([^\"]*)(?:$|\")", inString: class_name, withString: "")!
    }

    return class_name
  }
  
  
  class Regex
  {
    //from Ray Wenderlich's example - really nice stuff
    class func listGroups(_ pattern: String, inString string: String) -> [String] {
      var groupMatches = [String]()

      do {
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let range = NSMakeRange(0, string.characters.count)
        let matches = regex.matches(in: string, options: [], range: range)
        
        for match in matches {
          let rangeCount = match.numberOfRanges
          
          for group in 0..<rangeCount {
            groupMatches.append((string as NSString).substring(with: match.rangeAt(group)))
          }
        }
      }
      catch {
        
      }
        
      return groupMatches
    }
    
    class func replaceMatches(_ pattern: String, inString string: String, withString replacementString: String) -> String? {
      do {
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let range = NSMakeRange(0, string.characters.count)
        
        return regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: replacementString)
      }
      catch {
        fatalError("replaceMatches Exception with pattern '\(pattern)'")
      }
    }
    
    //from Ray Wenderlich
    class func listMatches(_ pattern: String, inString string: String) -> [String] {
      do {
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let range = NSMakeRange(0, string.characters.count)
        let matches = regex.matches(in: string, options: [], range: range)
        
        return matches.map {
          let range = $0.range
          return (string as NSString).substring(with: range)
        }
      }
      catch {
        fatalError("listMatches Exception with pattern '\(pattern)' ")
      }
    }
    
    //from Ray Wenderlich
    class func containsMatch(_ pattern: String, inString string: String) -> Bool {
      do {
        let regex = try NSRegularExpression(pattern: pattern, options: [] )
        let range = NSMakeRange(0, string.characters.count)
        return regex.firstMatch(in: string, options: [], range: range) != nil
      }
      catch {
        fatalError("containsMatch Exception with pattern '\(pattern)' ")
      }
    }
    
  }

  
  
  class func load_json_from_file(_ filename:String) -> NSDictionary
  {
    let path = Bundle.main.path(forResource: filename, ofType: "json")
    if let path = path
    {
      do {
        let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
        let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
      
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
  
  class func load_xml_data_from_file(_ filename: String) -> Data
  {
    let filepath = Bundle.main.path(forResource: filename, ofType: "xml")
    if let filepath = filepath
    {
      if let data = try? Data(contentsOf: URL(fileURLWithPath: filepath))
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
  
  class func load_xml_string_from_file(_ filename: String) -> String
  {
    let data = CDAKCommonUtility.load_xml_data_from_file(filename)
    
    if let xml = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String
    {
      return xml
    }
    else
    {
      fatalError("load_xml_string_from_file -> failed to convert to string for '\(filename).xml'")
    }
  }
  
  //https://medium.com/swift-programming/4-json-in-swift-144bf5f88ce4
  class func JSONStringify(_ value: AnyObject, prettyPrinted: Bool = false) -> String {
    //var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
    let options = prettyPrinted ?
      JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
    
    if JSONSerialization.isValidJSONObject(value) {
      do {
        let data = try JSONSerialization.data(withJSONObject: value, options: options)
        if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
          return string as String
        }
      }
      catch {
      }
    }
    return ""
  }
  
  //https://medium.com/swift-programming/4-json-in-swift-144bf5f88ce4
  class func JSONParseDictionary(_ jsonString: String) -> [String: AnyObject] {
    if let data = jsonString.data(using: String.Encoding.utf8) {
      do {
        let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))  as? [String: AnyObject]
        return dictionary!
      }
      catch {
        
      }
    }
    return [String: AnyObject]()
  }

  //http://api.rubyonrails.org/classes/ERB/Util.html
  //https://github.com/Halotis/EscapeHTML/blob/master/EscapeHTML/EscapeHTML.swift
  class func html_escape(_ html: String?) -> String{
    if let html = html {
      var result = html.replacingOccurrences(of: "&", with: "&amp;", options: [], range: nil)
      result = result.replacingOccurrences(of: "\"", with: "&quot;", options: [], range: nil)
      result = result.replacingOccurrences(of: "'", with: "&#39;", options: [], range: nil)
      result = result.replacingOccurrences(of: "<", with: "&lt;", options: [], range: nil)
      result = result.replacingOccurrences(of: ">", with: "&gt;", options: [], range: nil)
      return result
    }
    return ""
  }
  
  class func jsonStringFromDict(_ jsonDict: [String:AnyObject]) -> String? {
    if JSONSerialization.isValidJSONObject(jsonDict) { // True
      do {
        let rawData = try JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
        let jsonString = NSString(data: rawData, encoding: String.Encoding.utf8.rawValue) as? String
        return jsonString // NSString(data: rawData, encoding: String.Encoding.utf8.rawValue) as? String
      } catch let error as NSError {
        print(error)
      }
    } else {
      print("jsonStringFromDict - invalid JSON object")
    }
    return nil
  }

  
}
