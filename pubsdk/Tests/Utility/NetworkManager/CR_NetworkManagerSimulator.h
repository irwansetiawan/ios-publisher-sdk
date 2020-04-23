//
//  CR_NetworkSessionPlayer.h
//  pubsdk
//
//  Created by Romain Lofaso on 12/17/19.
//  Copyright © 2019 Criteo. All rights reserved.
//

#import "CR_NetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

extern const NSTimeInterval CR_NetworkManagerSimulatorInterstitialDefaultTtl;

@interface CR_NetworkManagerSimulator : CR_NetworkManager

@property (class, assign, nonatomic, readonly) NSTimeInterval interstitialTtl;

- (instancetype)initWithDeviceInfo:(CR_DeviceInfo *)deviceInfo NS_UNAVAILABLE;
- (instancetype)initWithDeviceInfo:(CR_DeviceInfo *)deviceInfo session:(NSURLSession *)session NS_UNAVAILABLE;
- (instancetype)initWithConfig:(CR_Config *)config NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END