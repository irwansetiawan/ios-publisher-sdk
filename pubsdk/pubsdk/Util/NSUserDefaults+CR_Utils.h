//
//  NSUserDefaults+CRPrivateKeysAndUtils.h
//  pubsdk
//
//  Copyright © 2019 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (CR_Utils)

- (BOOL)containsKey: (NSString *)key;

@end

NS_ASSUME_NONNULL_END
