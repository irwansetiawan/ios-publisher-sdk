//
//  CR_BidManagerHelper.h
//  pubsdk
//
//  Copyright © 2019 Criteo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CR_BidManagerHelper : NSObject

+ (void)removeCriteoBidsFromMoPubRequest:(id)adRequest;

@end

NS_ASSUME_NONNULL_END
