//
//  HL7HelperTest.swift
//  CCDAccess
//
//  Created by Eric Whitley on 12/17/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import XCTest

class HL7HelperTest: XCTestCase {
    
  override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }
  
  func test_timestamp_to_integer() {
    let dateString = "20100821"
    
    let ts = HL7Helper.timestamp_to_integer(dateString)
    
    let dateStringFormatter = NSDateFormatter()
    dateStringFormatter.dateFormat = "yyyyMMdd"
    dateStringFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    dateStringFormatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
    dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    let d = dateStringFormatter.dateFromString(dateString)!
    
    XCTAssertEqual(d.timeIntervalSince1970, ts)
  }
  
  func test_timestamp_to_integer_when_nil() {
    XCTAssertEqual(nil, HL7Helper.timestamp_to_integer(nil))
  }

  func test_timestamp_to_integer_when_just_month_and_year() {
    let dateString = "201008"
    
    let ts = HL7Helper.timestamp_to_integer(dateString)

    let dateStringFormatter = NSDateFormatter()
    dateStringFormatter.dateFormat = "yyyyMM"
    dateStringFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    dateStringFormatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
    dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    let d = dateStringFormatter.dateFromString(dateString)!
    
    XCTAssertEqual(d.timeIntervalSince1970, ts)
  }
  
  func test_timestamp_to_integer_down_to_seconds() {
    let dateString = "20100821123022"
    
    let ts = HL7Helper.timestamp_to_integer(dateString)

    let dateStringFormatter = NSDateFormatter()
    dateStringFormatter.dateFormat = "yyyyMMddHHmmss"
    dateStringFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    dateStringFormatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
    dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    let d = dateStringFormatter.dateFromString(dateString)!
    
    XCTAssertEqual(d.timeIntervalSince1970, ts)
    
  }
  
}
