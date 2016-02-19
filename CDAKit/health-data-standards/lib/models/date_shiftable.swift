//
//  date_shiftable.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/1/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

/**
Protocol for date shifting functions
*/
protocol CDAKDateShiftable {
  ///Offset all dates by specified double
  func shift_dates(date_diff: Double)
}

