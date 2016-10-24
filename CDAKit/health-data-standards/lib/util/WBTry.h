//
//  WBTry.h
//  Try
//
//  Created by Jacob Berkman on 2014-08-20.
//

#import <Foundation/Foundation.h>

@interface WBTry : NSObject

/**
 @brief         Performs a block of code wrapped in Objective-C exception handling blocks.
 @discussion    This method accepts a block of code which is performed inside a \@try block.
                If the code throws an Objective-C exception, it is caught in a \@catch. If
                a catchAndRethrowBlock is provided it is executed, and if it returns YES, the
                exception will be rethrown with \@throw. Lastly, if a finallyBlock is provided
                we will perform it in within a \@finally block.
 @param         tryBlock                The block to perform within a \@try block.
 @param         catchAndRethrowBlock    An optional block that can be executed if an exception was thrown. 
                                        If it returns YES, we rethrow the exception.
 @param         finallyBlock            An optional block that is called in the \@finally block.

 */
+ (void)tryBlock:(nonnull void (^)(void))tryBlock  catchAndRethrowBlock:(nullable BOOL (^)(_Nonnull id))catchAndRethrowBlock finallyBlock:(nullable void (^)(void))finallyBlock;

@end
