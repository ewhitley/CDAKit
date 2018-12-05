//
//  NSDate+Formatters.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation



extension Date {
  
  var stringFormattedAsRFC3339: String {
    return rfc3339formatter.string(from: self)
  }
  
  //http://stackoverflow.com/questions/24089999/how-do-you-create-a-swift-date-object
  //NSDate(dateString:"2014-06-06")
  //https://gist.github.com/algal/09b08515460b7bd229fa
  static func dateFromRFC3339FormattedString(_ rfc3339FormattedString:String) -> Date?
  {
    /*
    NOTE: will replace this with a failible initializer when Apple fixes the bug
    that requires the initializer to initialize all stored properties before returning nil,
    even when this is impossible.
    */
    if let d = rfc3339formatter.date(from: rfc3339FormattedString)
    {
      return Date(timeInterval:0,since:d)
    }
    else {
      return nil
    }
  }
  
  
  var stringFormattedAsHDSDate: String {
    return hdsDateformatter.string(from: self).replacingOccurrences(of: ",", with: daySuffix(self)+",")
  }

  var stringFormattedAsHDSDateNumber: String {
    return hdsDateNumberformatter.string(from: self)
  }
  
  static func dateFromHDSFormattedString(_ hdsFormattedString:String) -> Date?
  {
    //we're abusing the possible formats here
    // if we have "December 31, 2009" we're OK for date formatter
    // if we have "December 31st, 2009" then we have to rip out st, nd, rd, th day suffixes
    if let d = hdsDateformatter.date(from: CDAKCommonUtility.Regex.replaceMatches("(\\d)(st|nd|rd|th)(,)", inString: hdsFormattedString, withString: "$1$3")!)
    {
      return Date(timeInterval:0,since:d)
    } else if let d = hdsDateNumberformatter.date(from: hdsFormattedString) {
      return Date(timeInterval: 0, since: d)
    } else if let d = hdsDateNumberFormatterShort.date(from: hdsFormattedString) {
      return Date(timeInterval: 0, since: d)
    } else if let d = hdsDateNumberFormatterYearOnly.date(from: hdsFormattedString) {
      return Date(timeInterval: 0, since: d)
    }
    else {
      return nil
    }
  }
  
  //http://stackoverflow.com/questions/7416865/date-formatter-for-converting-14-sept-2011-in-14th-sept
  //http://stackoverflow.com/questions/1283045/ordinal-month-day-suffix-option-for-nsdateformatter-setdateformat
  func daySuffix(_ date: Date) -> String {
    //let calendar = NSCalendar.currentCalendar()
    var calendar = Calendar(identifier: Calendar.Identifier.iso8601)
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    let dayOfMonth = (calendar as NSCalendar).component(.day, from: date)
    switch dayOfMonth {
    case 1, 21, 31: return "st"
    case 2, 22: return "nd"
    case 3, 23: return "rd"
    default: return "th"
    }
  }
  
  
  
}

private var rfc3339formatter:DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
  formatter.timeZone = TimeZone(secondsFromGMT: 0)
  formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
  formatter.locale = Locale(identifier: "en_US_POSIX")
  return formatter
}()

// http://apidock.com/rails/ActiveSupport/CoreExtensions/DateTime/Conversions/to_formatted_s
// datetime.to_formatted_s(:long_ordinal)  # => "December 4th, 2007 00:00"
// http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
private var hdsDateformatter:DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "MMMM d, yyyy HH:mm"
  formatter.timeZone = TimeZone(secondsFromGMT: 0)
  formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
  formatter.locale = Locale(identifier: "en_US_POSIX")
  return formatter
}()


//20070118061017
//http://apidock.com/rails/Time/to_formatted_s
private var hdsDateNumberformatter:DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyyMMddHHmmss"
  formatter.timeZone = TimeZone(secondsFromGMT: 0)
  formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
  formatter.locale = Locale(identifier: "en_US_POSIX")
  return formatter
}()
//we've seen some files not following spec and failing to include HHmmss
//200701180
private var hdsDateNumberFormatterShort:DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyyMMdd"
  formatter.timeZone = TimeZone(secondsFromGMT: 0)
  formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
  formatter.locale = Locale(identifier: "en_US_POSIX")
  return formatter
}()
//as well as just years.... social history with just "1947"
//200701180
private var hdsDateNumberFormatterYearOnly:DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyy"
  formatter.timeZone = TimeZone(secondsFromGMT: 0)
  formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
  formatter.locale = Locale(identifier: "en_US_POSIX")
  return formatter
}()
