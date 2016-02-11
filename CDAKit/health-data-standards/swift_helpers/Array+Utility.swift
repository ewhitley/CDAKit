//
//  Array+Utility.swift
//  CCDAccess
//
//  Created by Eric Whitley on 12/7/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//http://stackoverflow.com/questions/24003191/pick-a-random-element-from-an-array
extension Array {
  func randomItem() -> Element? {
    if self.count > 0 {
      let index = Int(arc4random_uniform(UInt32(self.count)))
      return self[index]
    }
    return nil
  }
}
