//
//  CR_ThreadManager.h
//  CriteoPublisherSdk
//
//  Copyright © 2018-2020 Criteo. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CR_CompletionContext;

/**
 * Abstraction over GCD for executing tasks.
 *
 * Usefull to implement a CountDownLatch in the tests.
 */
@interface CR_ThreadManager : NSObject

@property(atomic, assign, readonly) BOOL isIdle;
@property(atomic, assign, readonly) NSInteger blockInProgressCounter;

- (void)dispatchAsyncOnMainQueue:(dispatch_block_t)block;
- (void)dispatchAsyncOnGlobalQueue:(dispatch_block_t)block;

/** Runs with a context interacting with the CR_ThreadManager instance. */
- (void)runWithCompletionContext:(void (^)(CR_CompletionContext *))block;

@end

/**
 * Run completion code that cannot be handled directly by
 * the CR_ThreadManager API.
 *
 * It increment the blockInProgressCounter of CR_ThreadManager
 * as soon as it is initialized.
 */
@interface CR_CompletionContext : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithThreadManager:(CR_ThreadManager *)threadManager NS_DESIGNATED_INITIALIZER;

/** Execute the block. Can be called only once per instance. */
- (void)executeBlock:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END