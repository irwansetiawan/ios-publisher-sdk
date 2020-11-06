//
//  CRNativeCustomEvent.m
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

#import <CriteoPublisherSdk/CriteoPublisherSdk.h>

#if __has_include("MoPub.h")
#import "MPNativeAdError.h"
#import "NSString+MPConsentStatus.h"
#endif

#import "CRCustomEventHelper.h"
#import "CRNativeCustomEvent.h"

@interface CRNativeCustomEvent () <CRNativeLoaderDelegate>

@property(strong, nonatomic, readonly) Criteo *criteo;
@property(strong, nonatomic, readonly) MoPub *mopub;

@property(strong, nonatomic) CRNativeLoader *loader;

@property(strong, nonatomic) CRNativeAd *nativeAd;
@property(strong, nonatomic) CRMediaView *productMediaView;
@property(strong, nonatomic) CRMediaView *advertiserLogoMediaView;

@end

@implementation CRNativeCustomEvent

@synthesize delegate;

- (instancetype)init {
  self = [super init];
  if (self) {
    _criteo = [Criteo sharedCriteo];
    _mopub = [MoPub sharedInstance];
  }
  return self;
}

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
  if (![CRCustomEventHelper checkValidInfo:info]) {
    if ([self.delegate respondsToSelector:@selector(nativeCustomEvent:didFailToLoadAdWithError:)]) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate
                    nativeCustomEvent:self
             didFailToLoadAdWithError:MPNativeAdNSErrorForInvalidAdServerResponse(@"Criteo Native ad request failed due to invalid server parameters.")];
      });
    }
    return;
  }

  [self updateMopubConsent];

  [self loadAdwithEventInfo:info];
}

#pragma mark - Private

- (CRNativeAdUnit *)adUnitWithEventInfo:(NSDictionary *)info {
  NSString *adUnitId = info[kCRCustomEventHelperAdUnitId];
  CRNativeAdUnit *adUnit = [[CRNativeAdUnit alloc] initWithAdUnitId:adUnitId];
  return adUnit;
}

- (void)loadAdwithEventInfo:(NSDictionary *)info {
  CRNativeAdUnit *adUnit = [self adUnitWithEventInfo:info];
  NSString *publisherId = info[kCRCustomEventHelperCpId];
  [self.criteo registerCriteoPublisherId:publisherId withAdUnits:@[ adUnit ]];

  self.loader = [[CRNativeLoader alloc] initWithAdUnit:adUnit];
  self.loader.delegate = self;
  [self.loader loadAd];
}

- (void)updateMopubConsent {
  NSString *consentStatusStr = [NSString stringFromConsentStatus:self.mopub.currentConsentStatus];
  [self.criteo setMopubConsent:consentStatusStr];
}

#pragma mark CRNativeLoaderDelegate

- (void)nativeLoader:(CRNativeLoader *)loader didReceiveAd:(CRNativeAd *)ad {
  self.nativeAd = ad;
  MPNativeAd *nativeAd = [[MPNativeAd alloc] initWithAdAdapter:self];
  [self.delegate nativeCustomEvent:self didLoadAd:nativeAd];
}

- (void)nativeLoader:(CRNativeLoader *)loader didFailToReceiveAdWithError:(NSError *)error {
  NSString *errorDescription =
      [NSString stringWithFormat:@"Criteo Native Ad failed to load with error: %@",
                                 error.localizedDescription];
  NSError *mopubError = [NSError errorWithCode:MOPUBErrorAdapterFailedToLoadAd
                          localizedDescription:errorDescription];
  [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:mopubError];
}

- (void)nativeLoaderDidDetectImpression:(CRNativeLoader *)loader {
}

- (void)nativeLoaderDidDetectClick:(CRNativeLoader *)loader {
}

- (void)nativeLoaderWillLeaveApplicationForNativeAd:(CRNativeLoader *)loader {
}

# pragma mark MPNativeAdAdapter Implementation

- (NSDictionary *)properties {
  return [self computedProperties];
}


- (NSDictionary *)computedProperties {
  NSMutableDictionary *props = [[NSMutableDictionary alloc] init];
  props[kAdTitleKey] = self.nativeAd.title;
  props[kAdTextKey] = self.nativeAd.body;
  props[kAdMainImageKey] = self.nativeAd.productMedia.url;
  props[kAdIconImageKey] = self.nativeAd.advertiserLogoMedia.url;
  props[kAdCTATextKey] = self.nativeAd.callToAction;
  return props;
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

@end
