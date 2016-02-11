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
// this was NOT an HDSEntry.  Needed to do this for the generalized importer
// it was treating everything like an entry because it had similar-ish fields
//HDSJSONInstantiable, CustomStringConvertible

class HDSReason: HDSEntry {
//  var item_description: String?
//  var codes: HDSCodedEntries = HDSCodedEntries()
  
//  required init() {
//  }
//  
//  required init(event: [String:Any?]) {
//    initFromEventList(event)
//  }
  
  override var description: String {
    return "HDSReason => description: \(item_description), codes: \(codes)"
  }
  
}


//extension HDSReason: MustacheBoxable {
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
