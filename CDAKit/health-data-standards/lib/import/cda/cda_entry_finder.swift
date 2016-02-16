//
//  entry_finder.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/12/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

class CDAKImport_CDA_EntryFinder {
  var entry_xpath: String!
  
  init(entry_xpath: String){
    self.entry_xpath = entry_xpath
  }
  
  func entries(doc: XMLDocument) -> XPathNodeSet {
    let entry_elements = doc.xpath(entry_xpath)
    return entry_elements
    //Should probably review this.
    // I think we can get away with just returning the node set
    //   since the closure will execute outside of this context
    //   and we're returning a collection in either case
    // Apparently with Ruby you can adjust this to say "if not a block outside, then..."
    //   and return an alternative set of data - which could be anything of any type
    // EX: http://stackoverflow.com/questions/21655106/ruby-yield-row-if-block-given
    /*
    if block_given?
      entry_elements.each do |entry_element|
      yield entry_element
    end
    else
      entry_elements
    end
    */
    
  }
  
}

