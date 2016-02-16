//
//  narrative_reference_handler.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/11/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class CDAKImport_CDA_NarrativeReferenceHandler {
  var id_map: [String:String] = [:] // this might be an XMLElement - not clear yet

  func build_id_map(doc: XMLDocument) {
    let path = "//*[@ID]"
    let ids = doc.xpath(path)
    for id in ids {
      if let tag = id["ID"] {
        let value = id.stringValue //Nokogiri.content # aliases node.text node.inner_text node.to_str
        id_map[tag] = value
      }
    }
  }
  
  /**
  - parameter tag: the XML tag you're looking for
  - returns: text description of the tag
  */
  func lookup_tag(var tag: String) -> String? {
    var value = id_map[tag]
    //# Not sure why, but sometimes the reference is #<Reference> and the ID value is <Reference>, and
    //# sometimes it is #<Reference>.  We look for both.
    if value == nil && tag.characters.first == "#" {
      tag = String(tag.characters.dropFirst())
      value = id_map[tag]
    }
    return value
  }
  
}




