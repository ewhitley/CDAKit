//
//  NSDate+Formatters.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation


//http://stackoverflow.com/questions/24089999/how-do-you-create-a-swift-date-object
//NSDate(dateString:"2014-06-06")
//https://gist.github.com/algal/09b08515460b7bd229fa

extension NSDate {
  
  var stringFormattedAsRFC3339: String {
    return rfc3339formatter.stringFromDate(self)
  }
  
  class func dateFromRFC3339FormattedString(rfc3339FormattedString:String) -> NSDate?
  {
    /*
    NOTE: will replace this with a failible initializer when Apple fixes the bug
    that requires the initializer to initialize all stored properties before returning nil,
    even when this is impossible.
    */
    if let d = rfc3339formatter.dateFromString(rfc3339FormattedString)
    {
      return NSDate(timeInterval:0,sinceDate:d)
    }
    else {
      return nil
    }
  }
  
  
  var stringFormattedAsHDSDate: String {
    return hdsDateformatter.stringFromDate(self).stringByReplacingOccurrencesOfString(",", withString: daySuffix(self)+",")
  }

  var stringFormattedAsHDSDateNumber: String {
    return hdsDateNumberformatter.stringFromDate(self)
  }
  
  class func dateFromHDSFormattedString(hdsFormattedString:String) -> NSDate?
  {
    //we're abusing the possible formats here
    // if we have "December 31, 2009" we're OK for date formatter
    // if we have "December 31st, 2009" then we have to rip out st, nd, rd, th day suffixes
    if let d = hdsDateformatter.dateFromString(HDSCommonUtility.Regex.replaceMatches("(\\d)(st|nd|rd|th)(,)", inString: hdsFormattedString, withString: "$1$3")!)
    {
      return NSDate(timeInterval:0,sinceDate:d)
    }
    else {
      return nil
    }
  }
  
  //http://stackoverflow.com/questions/7416865/date-formatter-for-converting-14-sept-2011-in-14th-sept
  //http://stackoverflow.com/questions/1283045/ordinal-month-day-suffix-option-for-nsdateformatter-setdateformat
  func daySuffix(date: NSDate) -> String {
    //let calendar = NSCalendar.currentCalendar()
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
    calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    let dayOfMonth = calendar.component(.Day, fromDate: date)
    switch dayOfMonth {
    case 1, 21, 31: return "st"
    case 2, 22: return "nd"
    case 3, 23: return "rd"
    default: return "th"
    }
  }
  
  
  
}

private var rfc3339formatter:NSDateFormatter = {
  let formatter = NSDateFormatter()
  formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
  formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
  formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
  formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
  return formatter
}()

// http://apidock.com/rails/ActiveSupport/CoreExtensions/DateTime/Conversions/to_formatted_s
// datetime.to_formatted_s(:long_ordinal)  # => "December 4th, 2007 00:00"
// http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
private var hdsDateformatter:NSDateFormatter = {
  let formatter = NSDateFormatter()
  formatter.dateFormat = "MMMM d, yyyy HH:mm"
  formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
  formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
  formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")

//  let dateStringFormatter = NSDateFormatter()
//  dateStringFormatter.dateFormat = "yyyy-MM-dd"
//  dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
//  let d = dateStringFormatter.dateFromString(dateString)!
//  self.init(timeInterval:0, sinceDate:d)

  
  return formatter
}()


//20070118061017
//http://apidock.com/rails/Time/to_formatted_s
private var hdsDateNumberformatter:NSDateFormatter = {
  let formatter = NSDateFormatter()
  formatter.dateFormat = "yyyyMMddHHmmss"
  formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
  formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
  formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
  return formatter
}()

