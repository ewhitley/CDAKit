//
//  reason.swift
//  
//
//  Created by Eric Whitley on 1/5/16.
//
//

import Foundation
import Mustache

//NOTE: deviating from original Ruby again
// this was NOT an CDAKEntry.  Needed to do this for the generalized importer
// it was treating everything like an entry because it had similar-ish fields
//CDAKJSONInstantiable, CustomStringConvertible

public class CDAKReason: CDAKEntry {
//  var item_description: String?
//  var codes: CDAKCodedEntries = CDAKCodedEntries()
  
//  required init() {
//  }
//  
//  required init(event: [String:Any?]) {
//    initFromEventList(event)
//  }
  
  override public var description: String {
    return "CDAKReason => description: \(item_description), codes: \(codes)"
  }
  
}


//extension CDAKReason: MustacheBoxable {
//  var boxedValues: [String:MustacheBox] {
//    return [
//      "codes" :  Box(codes),
//      "description" : Box(item_description)
//    ]
//  }
//  
//  var mustacheBox: MustacheBox {
//    return Box(boxedValues)
//  }
//}
