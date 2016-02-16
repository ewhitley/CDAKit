//
//  author.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKMetadataAuthor {
  
//  static let Types = ["authenticator", "authorcustodiandataEnterer", "informant",
//    "legalAuthenticator", "participant", "performer", "recordTarget"]
  
  public enum Types: String {
    case authenticator
    case authorcustodiandataEnterer
    case informant
    case legalAuthenticator
    case participant
    case performer
    case recordTarget
  }
  
  enum InputError: ErrorType {
    case InputMissing
    case TypeIncorrect
  }
  
  public var name: String?
  public var role: String?
  
  public var type: Types?
  
  
  //no throws in a setter yet
  // https://forums.developer.apple.com/thread/17826
//  var _type: String?
//  public var type: String? {
//    get {
//      return _type
//    }
//    set(newType) {
//      do {
//        try setType(newType)
//      }
//      catch _ {
//        fatalError("Invalid Type")
//      }
//    }
//  }
//  
//  public func setType(type: String?) throws {
//    guard let type = type where CDAKMetadataAuthor.Types.contains(type) else {
//      throw InputError.TypeIncorrect
//    }
//    _type = type
//  }
  
}