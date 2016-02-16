//
//  String+CryptoExtensions.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/17/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

//import Foundation
//import CommonCrypto

//http://stackoverflow.com/questions/25424831/cant-convert-nsdata-to-nsstring-in-swift

//extension String {
  
//  func md5(string string: String) -> [UInt8] {
//    var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
//    if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
//      CC_MD5(data.bytes, CC_LONG(data.length), &digest)
//    }
//    
//    return digest
//  }
//  
//  func md5(string: String) -> NSData {
//    let digest = NSMutableData(length: Int(CC_MD5_DIGEST_LENGTH))!
//    if let data :NSData = string.dataUsingEncoding(NSUTF8StringEncoding) {
//      CC_MD5(data.bytes, CC_LONG(data.length),
//        UnsafeMutablePointer<UInt8>(digest.mutableBytes))
//    }
//    return digest
//  }
//  
//  func md5Digest(string: NSString) -> NSString {
//    let data = string.dataUsingEncoding(NSUTF8StringEncoding)!
//    var hash = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
//    CC_MD5(data.bytes, CC_LONG(data.length), &hash)
//    let resstr = NSMutableString()
//    for byte in hash {
//      resstr.appendFormat("%02hhx", byte)
//    }
//    return resstr
//  }
  
//  func hnk_MD5String() -> String {
//    if let data = self.dataUsingEncoding(NSUTF8StringEncoding)
//    {
//      if let result = NSMutableData(length: Int(CC_MD5_DIGEST_LENGTH)) {
//        let resultBytes = UnsafeMutablePointer<CUnsignedChar>(result.mutableBytes)
//        CC_MD5(data.bytes, CC_LONG(data.length), resultBytes)
//        let resultEnumerator = UnsafeBufferPointer<CUnsignedChar>(start: resultBytes, count: result.length)
//        let MD5 = NSMutableString()
//        for c in resultEnumerator {
//          MD5.appendFormat("%02x", c)
//        }
//        return MD5 as String
//      }
//    }
//    return ""
//  }
  
//}


