//
//  hl7_helper.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/17/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

/**
Assistive functions to help conform to HL7 formats
*/
open class CDAKHL7Helper {
  
  /**
  Converts an HL7 timestamp into an Integer
   - parameter timestamp: [String] the HL7 timestamp. Expects YYYYMMDD format
   - returns: [Integer] Date in seconds since the epoch
  */
  open class func timestamp_to_integer(_ timestamp: String?) -> Double? {
    
    if let _timestamp = timestamp {
      if _timestamp.characters.count >= 4 {

        let index = _timestamp.index(_timestamp.startIndex, offsetBy: 4)
        let year = _timestamp.substring(to: index) //  _timestamp[0...3]

        var month = "01"
        if _timestamp.characters.count >= 6 {
            let start = _timestamp.index(_timestamp.startIndex, offsetBy: 4)
            let end =   _timestamp.index(_timestamp.startIndex, offsetBy: 6)
            let range = start..<end
            month =  _timestamp.substring(with: range)
        }

        //let month = _timestamp.characters.count >= 6 ? _timestamp[4...5] : "01"

        var day = "01"
        if _timestamp.characters.count >= 8 {
            let start = _timestamp.index(_timestamp.startIndex, offsetBy: 6)
            let end =   _timestamp.index(_timestamp.startIndex, offsetBy: 8)
            let range = start..<end
            day =  _timestamp.substring(with: range)
        }

        //let day =  ? _timestamp[6...7] : "01"


        var hour = "00"
        if _timestamp.characters.count >= 10 {
            let start = _timestamp.index(_timestamp.startIndex, offsetBy: 8)
            let end =   _timestamp.index(_timestamp.startIndex, offsetBy: 10)
            let range = start..<end
            hour =  _timestamp.substring(with: range)
        }

        //let hour = _timestamp.characters.count >= 10 ? _timestamp[8...9] : "00"

        var min = "00"
        if _timestamp.characters.count >= 12 {
            let start = _timestamp.index(_timestamp.startIndex, offsetBy: 10)
            let end =   _timestamp.index(_timestamp.startIndex, offsetBy: 12)
            let range = start..<end
            min =  _timestamp.substring(with: range)
        }

        //let min = _timestamp.characters.count >= 12 ? _timestamp[10...11] : "00"

        var sec = "00"
        if _timestamp.characters.count >= 14 {
            let start = _timestamp.index(_timestamp.startIndex, offsetBy: 12)
            let end =   _timestamp.index(_timestamp.startIndex, offsetBy: 14)
            let range = start..<end
            sec =  _timestamp.substring(with: range)
        }

        //let sec = _timestamp.characters.count >= 14 ? _timestamp[12...13] : "00"

        
        let dateString = ("\(year)\(month)\(day)\(hour)\(min)\(sec)")
        
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyyMMddHHmmss"
        
        dateStringFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateStringFormatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        
        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
        let d = dateStringFormatter.date(from: dateString)
        
        if let d = d {
          return d.timeIntervalSince1970
        }
      }
    }
    
    return nil
  }
  
}
