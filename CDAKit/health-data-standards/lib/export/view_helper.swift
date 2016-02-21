//
//  view_helper.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/17/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

class ViewHelper {
  
  //code_display
  //preferred_code_sets
  
  //options = 
  // {"tag_name"=>"value", "extra_content"=>"xsi:type=\"CD\"", "preferred_code_sets"=>["SNOMED-CT"]}
  // {"preferred_code_sets"=>["LOINC", "SNOMED-CT"]}
  // looks like the value of the dictionary can be a string or an array of values
  // FIX_ME: - issue with :codes here
  class func code_display(entry: CDAKEntry, var options:[String:Any] = [:]) -> String {
    
    if options["tag_name"] == nil { options["tag_name"] = "code" }

    if options["attribute"] == nil { options["attribute"] = "codes" } //note: original ruby uses :codes symbol
    var options_attribute: String = ""
    if let attr = options["attribute"] as? String {
      options_attribute = attr
    }
    // :codes -> go look at ThingWithCodes -> preferred_code
    //options['attribute'] ||= :codes

    var options_exclude_null_flavor = false
    if let opt = options["exclude_null_flavor"] as? Bool {
      options_exclude_null_flavor = opt
    }
    
    var code_string = "" //"nil" in original Ruby, but empty string works better for us
    
    //# allowing wild card matching of any code system for generic templates
    //# valueset filtering should filter out a decent code
    /*
    pcs will look like... ["LOINC", "SNOMED-CT"]
    */
    var pcs: [String] = []
    var preferred_code_sets : [String] = []
    if let options = options["preferred_code_sets"] as? [String] {
      preferred_code_sets = options
    }
    if preferred_code_sets.count > 0 {
      if preferred_code_sets.contains("*") {
        //# all of the code_systems that we know about
        pcs = Array(Set(CDAKCodeSystemHelper.CODE_SYSTEMS.values).union(CDAKCodeSystemHelper.CODE_SYSTEM_ALIASES.keys))
        // if options['preferred_code_sets'] && options['preferred_code_sets'].index("*")
        // options['preferred_code_sets'] can apparently take a wildcard "*" argument here
        //  so we're saying "if we have code sets" - and if one of them is "wildcard" - give us everything
        // otherwise, only give us the preferred code sets we sent in
        //pcs = if options['preferred_code_sets'] && options['preferred_code_sets'].index("*")
      } else {
        pcs = preferred_code_sets
      }
    }

    var value_set_map: [CDAKCodedEntries] = []
    if let vsm = options["value_set_map"] as? [CDAKCodedEntries] {
      value_set_map = vsm
    }
    
    let preferred_code = entry.preferred_code(pcs, codes_attribute: options_attribute, value_set_map: value_set_map)
    
    if let preferred_code = preferred_code {
      let pc = preferred_code.codeSystem
      let code_system_oid = CDAKCodeSystemHelper.oid_for_code_system(pc)
      let tag_name = options["tag_name"] as? String
      let code = preferred_code.codes.first
      let extra_content = options["extra_content"] as? String
      let display = preferred_code.displayName != nil ? "displayName=\"\(preferred_code.displayName!)\"" : ""
      code_string = "<\(tag_name ?? "") code=\"\(code ?? "")\" codeSystemName=\"\(pc)\" codeSystem=\"\(code_system_oid ?? "")\" \(display) \(extra_content ?? "")>"
    } else {      
      let tag_name = options["tag_name"] as? String
      let extra_content = options["extra_content"] as? String
      code_string = "<\(tag_name ?? "") "
      if !options_exclude_null_flavor {
         code_string += "nullFlavor=\"UNK\" "
      }
      code_string += "\(extra_content ?? "")>"
    }
    
    
    //if options["attribute"] == :codes && entry.respond_to?(:translation_codes)
    // we can't see if the method translation_codes is available, but...
    // the only class/protocol that uses this is ThingWithCodes, so we can test to see if
    // the entry is of type ThingWithCodes... but all entries at that, so....
    if options_attribute == "codes" {
      code_string += "<originalText>\(CDAKCommonUtility.html_escape(entry.item_description))</originalText>"
      for (codeSystem, codes) in entry.translation_codes(preferred_code_sets, value_set_map: value_set_map) {
        let display = codes.displayName != nil ? " displayName=\"\(codes.displayName!)\"" : ""
        for code in codes {
          code_string += "<translation code=\"\(code)\" codeSystemName=\"\(codeSystem)\" codeSystem=\"\(CDAKCodeSystemHelper.oid_for_code_system(codeSystem))\"\(display)/>\n"
        }
      }
    }
    
    code_string += "</\(options["tag_name"]!)>"
    return code_string
  }
  
  class func status_code_for(entry: CDAKEntry) -> String? {
    if let status = entry.status {
      switch status.lowercaseString {
      case "active": return "55561003"
      case "inactive": return "73425007"
      case "resolved": return "413322009"
      default: return nil
      //default: fatalError("status_code_for() - invalid status (\(status)) for CDAKEntry")
      }
    }
    return nil
    //fatalError("status_code_for() - no status for CDAKEntry")
  }
  
//  class func fulfillment_quantity(codes: CDAKCodedEntries, fulfillmentHistory: CDAKFulfillmentHistory, dose:[String:String]) -> String {
  class func fulfillment_quantity(codes: CDAKCodedEntries, fulfillmentHistory: CDAKFulfillmentHistory, dose: CDAKValueAndUnit) -> String {
    if codes["RxNorm"]?.count > 0 {
      if let qty = fulfillmentHistory.quantity_dispensed.value, dose_value = dose.value {
        let doses = Int(qty / dose_value)
        return "value=\"\(doses)\""
//        if let qty = Double(qty), dose_value = Double(dose_value) {
//          let doses = Int(qty / dose_value)
//          return "value=\"\(doses)\""
//        }
      }
    }
//    let qty = fulfillmentHistory.quantity_dispensed["value"] != nil ? fulfillmentHistory.quantity_dispensed["value"]! : ""
//    let unit = fulfillmentHistory.quantity_dispensed["unit"] != nil ? fulfillmentHistory.quantity_dispensed["unit"]! : ""
    let qty = fulfillmentHistory.quantity_dispensed.value != nil ? String(fulfillmentHistory.quantity_dispensed.value!) : ""
    let unit = fulfillmentHistory.quantity_dispensed.unit != nil ? String(fulfillmentHistory.quantity_dispensed.unit!) : ""
    return "value=\"\(qty)\" unit=\"\(unit)\""
  }
  
  //take an Int representing time since 1970 -> format into date
  // using Ruby Time:: :number format ('%Y%m%d%H%M%S')
  // FIX_ME: - this isn't doing something right..
  /*
    value_or_null_flavor(946702800) -> not right
    //Swift: 2000 12 31 23 00 00
    //Ruby: "2000-01-01 05:00:00 +0000"
  
    value_or_null_flavor(-284061600) -> seems OK
    //Swift: 1960 12 31 00 00 00
    //Ruby: 1960-12-31 00:00:00 -0600
  */
  class func value_or_null_flavor(time: Double?) -> String {
    if let time = time {
      //:number => '%Y%m%d%H%M%S'
      //return "value='#{Time.at(time).utc.to_formatted_s(:number)}'"
      
      let d = NSDate(timeIntervalSince1970: NSTimeInterval(time))
//      let dateFormat = NSDateFormatter()
//      dateFormat.dateFormat = "YYYYMMddHHmmss"
//      let dateString = dateFormat.stringFromDate(d)

      return "value=\"\(d.stringFormattedAsHDSDateNumber)\""
    } else {
      return "nullFlavor='UNK'"
    }
  }
  
  class func dose_quantity(codes: CDAKCodedEntries, dose: [String:String]) -> String {
    if codes["RxNorm"]?.count > 0 {
      return "value = '1'"
    } else {
      let value = dose["value"] != nil ? dose["value"]! : ""
      let unit = dose["unit"] != nil ? dose["unit"]! : ""
      return "value=\"\(value)\" unit=\"\(unit)\""
    }
  }

  
  class func time_if_not_nil(args: [Int?]?) -> NSDate? {
    //args.compact.map {|t| Time.at(t).utc}.first
    if let args = args {
      return args.filter({$0 != nil}).map({t in NSDate(timeIntervalSince1970: NSTimeInterval(t!))}).first
    }
    else {
      return nil
    }
  }

  class func time_if_not_nil(args: Int?...) -> NSDate? {
    //args.compact.map {|t| Time.at(t).utc}.first
      return args.filter({$0 != nil}).map({t in NSDate(timeIntervalSince1970: NSTimeInterval(t!))}).first
  }


  
  class func is_num(str: String?) -> Bool {
    if let str = str, _ = Double(str) {
      return true
    }
    return false
  }
  
  class func is_bool(str: String?) -> Bool {
    return ["true","false"].contains(str != nil ? str!.lowercaseString : "")
  }

  //FIX_ME: - this isn't going to work for our custom objects right now
  // and I can't make them CustomStringConvertible without impacting the "description" property
//  class func identifier_for(value: [CustomStringConvertible]) -> String {
//    return String(value).hnk_MD5String()
//  }
  
  //EX: field -> "severity"
  //    codes -> {"SNOMED-CT"=>["6736007"]}
  //FIX_ME: - finish the implementation. As best I can tell, this is only used by the HTML export. Deal with it then.
  // output can be a few different things, but most often seems to be a string like...
  // SNOMED-CT: 6736007
//  func convert_field_to_hash(field: String, codes: Any) {
//    if let codes = codes as? [CDAKCodedEntries] {
//      //return codes.collect{ |code| convert_field_to_hash(field, convert_field_to_hash(field, code))}.join("<br>")
//      let x = codes.map({
//        (code) in
//        
//      })
//    }
//    
////    let x = "hello".capitalizedString
//    
//    if let codes = codes as? CDAKCodedEntries {
//      
//    } else {
//      
//    }
//    
//  }
  
  
  
}