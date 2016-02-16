//
//  date_shiftable.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/1/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

protocol CDAKDateShiftable {
//  var start_time: Int? { get set }
//  var end_time: Int? { get set }
  func shift_dates(date_diff: Double)
}

//extension DateShiftable {
//  mutating func shift_dates(date_diff: Int) {
//    if let start_time = start_time {
//      self.start_time = start_time + date_diff
//    }
//    if let end_time = end_time {
//      self.end_time = end_time + date_diff
//    }
//  }
//}

protocol CDAKPropertyQueryable {
  
}