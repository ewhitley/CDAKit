//
//  thing_with_times.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/13/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

// found we needed this - places in CDAK with dynamic attributes reference times ad-hoc
// EX: Import.CDA.SectionImporter.extract_value() throws dates at ResultValue
// https://github.com/projectcypress/health-data-standards/blob/961086df506a64482a3622ba18143a60361d73f9/lib/health-data-standards/import/cda/section_importer.rb#L131
public protocol CDAKThingWithTimes: class {
  var time: Double? { get set }
  var start_time: Double? { get set }
  var end_time: Double? { get set }
}
