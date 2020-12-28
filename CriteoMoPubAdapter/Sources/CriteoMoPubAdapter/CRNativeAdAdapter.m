//
//  CRNativeAdAdapter.m
//  CriteoMoPubAdapter
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

#import "CRNativeAdAdapter.h"
#import <CriteoPublisherSdk/CriteoPublisherSdk.h>

@interface CRNativeAdAdapter ()

@property(strong, nonatomic) CRMediaView *productMediaView;
@property(strong, nonatomic) CRMediaView *advertiserLogoMediaView;

@end

@implementation CRNativeAdAdapter

- (instancetype)initWithNativeAd:(CRNativeAd *)nativeAd {
  if (self = [super init]) {
    _nativeAd = nativeAd;
  }
  return self;
}

- (NSDictionary *)properties {
  return [self computedProperties];
}

- (NSURL *)defaultActionURL {
  // https://developers.mopub.com/networks/integrate/build-adapters-ios/#quick-start-for-native-ads
  // > Another necessary property to implement is the defaultActionURL -
  // > the URL the user is taken to when they interact with the ad.
  // > If the native ad automatically opens it then this can be nil.
  //
  // The Criteo SDK opens it itself. So we return nil.
  return nil;
}

- (BOOL)enableThirdPartyClickTracking {
  return YES;
}

- (UIView *)mainMediaView {
  if (self.productMediaView == nil) {
    self.productMediaView = [[CRMediaView alloc] init];
    self.productMediaView.mediaContent = self.nativeAd.productMedia;
  }
  return self.productMediaView;
}

- (UIView *)iconMediaView {
  if (self.advertiserLogoMediaView == nil) {
    self.advertiserLogoMediaView = [[CRMediaView alloc] init];
    self.advertiserLogoMediaView.mediaContent = self.nativeAd.advertiserLogoMedia;
  }
  return self.advertiserLogoMediaView;
}

#pragma mark - Private

- (NSDictionary *)computedProperties {
  NSMutableDictionary *props = [[NSMutableDictionary alloc] init];
  props[kAdTitleKey] = self.nativeAd.title;
  props[kAdTextKey] = self.nativeAd.body;
  props[kAdMainImageKey] = self.nativeAd.productMedia.url;
  props[kAdIconImageKey] = self.nativeAd.advertiserLogoMedia.url;
  props[kAdCTATextKey] = self.nativeAd.callToAction;
  return props;
}

@end
