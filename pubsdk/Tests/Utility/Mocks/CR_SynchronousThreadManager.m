//
//  CR_SynchronousThreadManager.m
//  pubsdkTests
//
//  Created by Romain Lofaso on 4/20/20.
//  Copyright © 2020 Criteo. All rights reserved.
//

#import "CR_SynchronousThreadManager.h"

@interface CR_SynchronousThreadManager ()

@property (assign, nonatomic) NSUInteger dispatchAsyncOnGlobalQueueCount;
@property (assign, nonatomic) NSUInteger dispatchAsyncOnMainQueueCount;

@end

@implementation CR_SynchronousThreadManager

- (void)dispatchAsyncOnMainQueue:(dispatch_block_t)block {
    NSAssert(block, @"Given block is empty");
    block();
}

- (void)dispatchAsyncOnGlobalQueue:(dispatch_block_t)block {
    NSAssert(block, @"Given block is empty");
    block();
}

@end