//
//  trap.swift
//  Try
//
//  Created by Jacob Berkman on 2015-10-19.
//

import Foundation

public let tryErrorDomain = "Try"
public let tryExceptionErrorCode = 1
public let tryExceptionErrorKey = "exception"

/**
 Wraps a closure in a `WBTry.tryBlock` to catch Objective-C exceptions using the Swift error handling model.
 
 - parameter    block:  The block of code to run within a `WBTry.tryBlock`.
 - throws:      Throws an `NSError` if the wrapped code throws an exception.
*/
public func trap(_ block: @escaping () -> Void) throws {
    var exception: Any?

    WBTry.try(block, catchAndRethrow: {
        exception = $0
        return false
    }, finallyBlock: nil)

    if let e = exception {
        throw NSError(domain: tryErrorDomain, code: tryExceptionErrorCode, userInfo: [tryExceptionErrorKey: e])
    }
}
