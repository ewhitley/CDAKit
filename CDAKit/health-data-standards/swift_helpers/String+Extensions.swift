//
//  String+Extensions.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation


extension String {

  //http://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language
  subscript (i: Int) -> Character {
    return self[self.startIndex.advancedBy(i)]
  }
  
  subscript (i: Int) -> String {
    return String(self[i] as Character)
  }
  
  subscript (r: Range<Int>) -> String {
    return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
  }

//  //http://dev.iachieved.it/iachievedit/swift-titleized-string-extension/
//  var titleized:String {
//    var words = self.lowercaseString.characters.split(" ").map { String($0) }
//    words[0] = words[0].capitalizedString
//    for i in 1..<words.count {
//      if !SMALL_WORDS.contains(words[i]) {
//        words[i] = words[i].capitalizedString
//      }
//    }
//    return words.joinWithSeparator(" ")
//  }
  
}


