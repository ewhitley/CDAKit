//
//  personable.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

protocol CDAKPersonable {
  
  var title: String? { get set }
  var given_name: String? { get set }
  var family_name: String? { get set }

  var addresses: [CDAKAddress] {get set}
  var telecoms: [CDAKTelecom] {get set}
  
//  receiver.embeds_many :addresses, as: :locatable
//  receiver.embeds_many :telecoms, as: :contactable
  
}

//extension Peronsable {
//  
////  var _title: String?
////  var title: String? {
////    get {
////      return _title
////    }
////    set(value) {
////      _title = value
////    }
////  }
//  
//}
