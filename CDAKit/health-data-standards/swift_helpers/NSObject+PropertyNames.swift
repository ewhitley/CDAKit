//
//  NSObject+PropertyNames.swift
//  CCDAccess
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//http://derpturkey.com/get-property-names-of-object-in-swift/

extension NSObject {
  
  //
  // Retrieves an array of property names found on the current object
  // using Objective-C runtime functions for introspection:
  // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
  //
  func propertyNames() -> Array<String> {
    var results: Array<String> = [];
    
    // retrieve the properties via the class_copyPropertyList function
    var count: UInt32 = 0;
    let myClass: AnyClass = self.classForCoder;
    let properties = class_copyPropertyList(myClass, &count);
    
    // iterate each objc_property_t struct
    for var i: UInt32 = 0; i < count; i++ {
      let property = properties[Int(i)];
      
      // retrieve the property name by calling property_getName function
      let cname = property_getName(property);
      
      // covert the c string into a Swift string
      let name = String.fromCString(cname);
      results.append(name!);
    }
    
    // release objc_property_t structs
    free(properties);
    
    results.appendContentsOf(SwiftPropertyNames())
    results = Array(Set(results))
    
    return results;
  }
  
  //http://stackoverflow.com/questions/24844681/list-of-classs-properties-in-swift
  func SwiftPropertyNames() -> [String] {
    return Mirror(reflecting: self).children.filter { $0.label != nil }.map { $0.label! }
  }

  
}