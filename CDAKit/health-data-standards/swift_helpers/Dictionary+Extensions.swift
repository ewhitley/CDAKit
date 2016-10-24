//
//  Dictionary+Extensions.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/10/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//http://stackoverflow.com/questions/26728477/swift-how-to-combine-two-dictionary-arrays
//http://ericasadun.com/2015/07/08/swift-merging-dictionaries/
extension Dictionary {
  mutating func merge<K, V>(_ dict: [K: V]){
    for (k, v) in dict {
      self.updateValue(v as! Value, forKey: k as! Key)
    }
  }
  
  func inverse() -> [String:String] {
    var inverted : [String:String] = [:]
    for (key, value) in self {
      if let value = value as? String, let key = key as? String {
        inverted[value] = key
      }
    }
    return inverted
  }
  
}
