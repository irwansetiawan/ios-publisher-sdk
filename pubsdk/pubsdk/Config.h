//
//  Config.h
//  pubsdk
//
//  Created by Adwait Kulkarni on 1/11/19.
//  Copyright © 2019 Criteo. All rights reserved.
//

#ifndef Config_h
#define Config_h

#import <Foundation/Foundation.h>

@class ApiHandler;
@interface Config : NSObject

@property (strong, nonatomic, readonly) NSNumber *networkId;
@property (strong, nonatomic, readonly) NSNumber *profileId;
@property (strong, nonatomic, readonly) NSString *cdbUrl;
@property (strong, nonatomic, readonly) NSString *path;
@property (strong, nonatomic, readonly) NSString *sdkVersion;
@property (strong, nonatomic, readonly) NSString *appId;
@property (nonatomic) BOOL killSwitch;

- (instancetype) initWithNetworkId:(NSNumber *) networkId
NS_DESIGNATED_INITIALIZER;

- (instancetype) init NS_UNAVAILABLE;

/*
 * Helper function to convert NSData returned from a network call
 * to an NSDictionary with config values
 */
+ (NSDictionary *) getConfigValuesFromData: (NSData *) data;

/*
 * Fetches and refreshes the config object's values
 * Uses the ApiHandler to make a get call to config end point
 */
- (void) refreshConfig:(ApiHandler *)apiHandler;

@end

#endif /* Config_h */