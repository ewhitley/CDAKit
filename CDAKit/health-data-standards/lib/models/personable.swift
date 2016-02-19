//
//  personable.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

/**
Defines basic "person-like" attributes shared by Person and Provider objects
*/
protocol CDAKPersonable {
  ///title
  var title: String? { get set }
  ///Given / First name
  var given_name: String? { get set }
  ///Family / Last name
  var family_name: String? { get set }

  ///addresses
  var addresses: [CDAKAddress] {get set}
  ///telecoms
  var telecoms: [CDAKTelecom] {get set}
  
}
