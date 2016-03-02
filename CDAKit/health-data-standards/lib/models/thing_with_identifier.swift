//
//  thing_with_times.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/13/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation

public protocol CDAKThingWithIdentifier: class {
  var cda_identifier: CDAKCDAIdentifier? { get set }
}
