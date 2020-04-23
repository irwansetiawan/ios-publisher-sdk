//
//  CR_ThreadManagerWaiter.h
//  pubsdk
//
//  Created by Romain Lofaso on 1/29/20.
//  Copyright © 2020 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CR_ThreadManager;

NS_ASSUME_NONNULL_BEGIN

@interface CR_ThreadManagerWaiter : NSObject

- (instancetype)initWithThreadManager:(CR_ThreadManager *)threadManager;

/**
* Wait the idle state with a default timeout relevant for
 * the unit tests and the integrations tests.
*/
- (void)waitIdle;

/**
 * Wait the idle state with a timeout relevant for the
 * performance tests.
 *
 * The performance tests can be longuer than other kind of tests.
 * So it requires a timeout greater than the default one.
 */
- (void)waitIdleForPerformanceTests;
- (void)waitIdleWithTimeout:(NSTimeInterval)timeout;

@end

NS_ASSUME_NONNULL_END