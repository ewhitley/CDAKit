//
//  author.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

class CDAKMetadataAuthor {
  
  static let Types = ["authenticator", "authorcustodiandataEnterer", "informant",
    "legalAuthenticator", "participant", "performer", "recordTarget"]
  
//  enum Types {
//    case authenticator, authorcustodiandataEnterer, informant,
//    legalAuthenticator, participant, performer, recordTarget
//  }
  
  enum InputError: ErrorType {
    case InputMissing
    case TypeIncorrect
  }
  
  var name: String?
  var role: String?
  
  //no throws in a setter yet
  // https://forums.developer.apple.com/thread/17826
  var _type: String?
  var type: String? {
    get {
      return _type
    }
    set(newType) {
      do {
        try setType(newType)
      }
      catch _ {
        fatalError("Invalid Type")
      }
    }
  }
  
  func setType(type: String?) throws {
    guard let type = type where CDAKMetadataAuthor.Types.contains(type) else {
      throw InputError.TypeIncorrect
    }
    _type = type
  }
  
//  init(type: String, name: String?, role: String?) throws {
//    self.name = name
//    self.role = role
//    self.type = type
//
//    guard Author.Types.contains(type) else {
//      throw InputError.TypeIncorrect
//    }
//
//  }
  
}