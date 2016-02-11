//
//  order_information.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//NOTE: Changing class to HDSEntry
public class HDSOrderInformation: HDSEntry {
  
  //include Mongoid::Attributes::Dynamic
  
  public var order_number: String? //, as: :order_number, type: String
  public var fills: Int? //, type: Integer
//  var quantityOrdered = [String:String]() //, as: :quantity_ordered, type: Hash
  public var quantity_ordered = HDSValueAndUnit()
  public var order_expiration_date_time: Double? //, as: :order_expiration_date_time, type: Integer
  public var order_date_time: Double? //, as: :order_date_time, type: Integer
  
  //MARK: FIXME - handle getting order_information by HDSProvider
  //belongs_to :provider
  public var provider: HDSProvider?
  
//  var order_number: String? {
//    get {return orderNumber }
//    set {orderNumber = newValue }
//  }
//
//  var quantity_ordered: [String:String] {
//    get {return quantityOrdered }
//    set {quantityOrdered = newValue }
//  }
//
//  var order_expiration_date_time: Double? {
//    get {return orderExpirationDateTime }
//    set {orderExpirationDateTime = newValue }
//  }
//
//  var order_date_time: Double? {
//    get {return orderDateTime }
//    set {orderDateTime = newValue }
//  }

  
  override func shift_dates(date_diff: Double) {
    super.shift_dates(date_diff)
    
    if let order_date_time = order_date_time {
      self.order_date_time = order_date_time + date_diff
    }
    if let order_expiration_date_time = order_expiration_date_time {
      self.order_expiration_date_time = order_expiration_date_time + date_diff
    }
  }
  
//  init(event: [String:Any?]) {
//    
//    let times = [
//      "orderDateTime",
//      "orderExpirationDateTime"
//    ]
//    
//    for time_key in times {
//      if event.keys.contains(time_key) {
//        var a_new_time: Int?
//        if let time = event[time_key] as? Int {
//          a_new_time = time
//        }
//        if let time = event[time_key] as? String {
//          if let time = Int(time) {
//            a_new_time = time
//          }
//        }
//        switch time_key {
//        case "orderDateTime": self.orderDateTime = a_new_time
//        case "orderExpirationDateTime": self.orderExpirationDateTime = a_new_time
//        default: print("HDSEntry.init() undefined value setter for key \(time_key)")
//        }
//      }
//    }
//    
//  }
//  
//  init() {
//  }
  
}