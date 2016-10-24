//
//  WBTry.m
//  Try
//
//  Created by Jacob Berkman on 2014-08-20.
//

#import "WBTry.h"

@implementation WBTry

+ (void)tryBlock:(nonnull void (^)(void))tryBlock  catchAndRethrowBlock:(nullable BOOL (^)(_Nonnull id))catchAndRethrowBlock finallyBlock:(nullable void (^)(void))finallyBlock {
    @try {
        tryBlock();
    }
    @catch (id exception) {
        if (catchAndRethrowBlock && catchAndRethrowBlock(exception)) {
            @throw;
        }
    }
    @finally {
        if (finallyBlock) {
            finallyBlock();
        }
    }
}

@end
