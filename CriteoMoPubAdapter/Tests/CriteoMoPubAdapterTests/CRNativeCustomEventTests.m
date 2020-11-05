//
//  CRNativeCustomEventTests.m
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

#import <XCTest/XCTest.h>
#import "CRNativeCustomEvent.h"
#import "CRCustomEventHelper.h"
#import <OCMock.h>
#import <CriteoPublisherSdk/CriteoPublisherSdk.h>
#import <MoPub.h>
#import "MPNativeAdError.h"

#define PRODUCT_URL ([NSURL URLWithString:@"http://prod.uct"])
#define LOGO_URL ([NSURL URLWithString:@"http://lo.go"])

@interface CRNativeCustomEventTests : XCTestCase

@property(strong, nonatomic) Criteo *criteoMock;
@property(strong, nonatomic) MoPub *moPubMock;
@property(strong, nonatomic) CRNativeLoader *loaderMock;
@property(strong, nonatomic) id<CRNativeLoaderDelegate> loaderDelegate;
@property(strong, nonatomic) NSDictionary *defaultEventInfo;

@end

@implementation CRNativeCustomEventTests

- (void)setUp {
  self.defaultEventInfo = @{@"cpId" : @"myCpId", @"adUnitId" : @"myAdUnitId"};

  [self mockMoPubSharedInstance];
  [self mockCriteoSharedInstance];
  [self mockNativeLoaderInit];
}

- (void)testRequestSetMopubConsent {
  CRNativeCustomEvent *event = [self nativeCustomEventWithMocks];
  OCMStub([self.moPubMock currentConsentStatus]).andReturn(MPConsentStatusConsented);

  [event requestAdWithCustomEventInfo:self.defaultEventInfo adMarkup:nil];

  OCMVerify(times(1), [self.criteoMock setMopubConsent:@"explicit_yes"]);
}

- (void)testRequestRegisterAdUnit {
  CRNativeCustomEvent *event = [self nativeCustomEventWithMocks];

  [event requestAdWithCustomEventInfo:self.defaultEventInfo adMarkup:nil];

  CRNativeAdUnit *adUnit =
      [[CRNativeAdUnit alloc] initWithAdUnitId:self.defaultEventInfo[@"adUnitId"]];
  OCMVerify(times(1), [self.criteoMock registerCriteoPublisherId:self.defaultEventInfo[@"cpId"]
                                                     withAdUnits:@[ adUnit ]]);
}

#pragma mark - Delegate call

- (void)testNativeLoaderDidReceiveAd {
  CRNativeCustomEvent *event = [self nativeCustomEventWithMocks];
  event.delegate = OCMProtocolMock(@protocol(MPNativeCustomEventDelegate));
  [event requestAdWithCustomEventInfo:self.defaultEventInfo adMarkup:nil];

  CRNativeAd *ad = OCMClassMock(CRNativeAd.class);
  CRNativeLoader *loader = nil;
  [self.loaderDelegate nativeLoader:loader didReceiveAd:ad];

  OCMVerify(times(1), [event.delegate nativeCustomEvent:event didLoadAd:OCMOCK_ANY]);
}

- (void)testNativeLoaderDidFailToReceiveAdWithError {
  CRNativeCustomEvent *event = [self nativeCustomEventWithMocks];
  event.delegate = OCMProtocolMock(@protocol(MPNativeCustomEventDelegate));
  [event requestAdWithCustomEventInfo:self.defaultEventInfo adMarkup:nil];

  CRNativeLoader *loader = nil;
  [self.loaderDelegate nativeLoader:loader didFailToReceiveAdWithError:[self criteoError]];

  id errorArg = [self adapterFailToLoadErrorArgContainingStringInDescription:
                          @"Criteo Native Ad failed to load with error: test"];
  OCMVerify(times(1), [event.delegate nativeCustomEvent:event didFailToLoadAdWithError:errorArg]);
}

#pragma mark - Wrong request parameter

- (void)testRequestWithoutEventInfo {
  CRNativeCustomEvent *event = [self nativeCustomEventWithMocks];
  event.delegate = OCMProtocolMock(@protocol(MPNativeCustomEventDelegate));
  id helper = OCMClassMock(CRCustomEventHelper.class);
  NSError *err = [self criteoError];
  OCMStub([helper checkValidInfo:OCMOCK_ANY]);

  [event requestAdWithCustomEventInfo:@{} adMarkup:nil];

  OCMVerify(times(1), [event.delegate nativeCustomEvent:event didFailToLoadAdWithError:err]);
}

- (void)testRequestWithoutGoodInfoDoNotRegister {
  CRNativeCustomEvent *event = [self nativeCustomEventWithMocks];
  event.delegate = OCMProtocolMock(@protocol(MPNativeCustomEventDelegate));

  [event requestAdWithCustomEventInfo:@{} adMarkup:nil];

  OCMVerify(never(), [self.criteoMock registerCriteoPublisherId:OCMOCK_ANY withAdUnits:OCMOCK_ANY]);
}

#pragma mark - Private

- (CRNativeCustomEvent *)nativeCustomEventWithMocks {
  CRNativeCustomEvent *event = [[CRNativeCustomEvent alloc] init];
  return event;
}

- (void)mockCriteoSharedInstance {
  self.criteoMock = OCMClassMock(Criteo.class);
  OCMStub([(id)self.criteoMock sharedCriteo]).andReturn(self.criteoMock);
}

- (void)mockMoPubSharedInstance {
  self.moPubMock = OCMClassMock(MoPub.class);
  OCMStub([(id)self.moPubMock sharedInstance]).andReturn(self.moPubMock);
}

- (void)mockNativeLoaderInit {
  self.loaderMock = OCMClassMock(CRNativeLoader.class);
  OCMStub([(id)self.loaderMock alloc]).andReturn(self.loaderMock);
  OCMStub([self.loaderMock initWithAdUnit:OCMOCK_ANY]).andReturn(self.loaderMock);
  OCMStub([self.loaderMock setDelegate:OCMOCK_ANY]).andCall(self, @selector(assignLoaderDelegate:));
}

- (void)assignLoaderDelegate:(id<CRNativeLoaderDelegate>)delegate {
  self.loaderDelegate = delegate;
}

- (id)adapterFailToLoadErrorArgContainingStringInDescription:(NSString *)string {
  id errorArg = [OCMArg checkWithBlock:^BOOL(NSError *err) {
    return (err.code == MOPUBErrorAdapterFailedToLoadAd) &&
           [err.localizedDescription containsString:string];
  }];
  return errorArg;
}

- (NSError *)criteoError {
  NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"test"};
  NSError *criteoError = [[NSError alloc] initWithDomain:@"Test" code:1 userInfo:userInfo];
  return criteoError;
}

#pragma mark - Ad Adapter tests

- (void)testEmptyProperties {
  NSDictionary *expected = @{};
  CRNativeAd *ad = OCMClassMock(CRNativeAd.class);
  CRNativeCustomEvent *customEvent = [self nativeCustomEventWithMocks];

  NSDictionary *props = customEvent.properties;

  XCTAssertEqualObjects(props, expected);
}

- (void)testProperties {
  // The keys that matter:
  // https://developers.mopub.com/networks/integrate/build-adapters-ios/#quick-start-for-native-ads
  NSDictionary *expected = @{
    kAdTitleKey : NSStringFromSelector(@selector(title)),
    kAdTextKey : NSStringFromSelector(@selector(body)),
    kAdIconImageKey : LOGO_URL,
    kAdMainImageKey : PRODUCT_URL,
    kAdCTATextKey : NSStringFromSelector(@selector(callToAction)),
  };

  CRNativeCustomEvent *customEvent = [self nativeCustomEventWithMocks];

  NSDictionary *props = customEvent.properties;

  XCTAssertEqualObjects(props, expected);
}

- (void)testMainMediaView {
  CRNativeCustomEvent *customEvent = [self nativeCustomEventWithMocks];
  XCTAssert([[customEvent mainMediaView] isKindOfClass:[CRMediaView class]]);
}

- (void)testIconMediaView {
  CRNativeCustomEvent *customEvent = [self nativeCustomEventWithMocks];
  XCTAssert([[customEvent iconMediaView] isKindOfClass:[CRMediaView class]]);
}

- (CRNativeAd *)nativeAdMock {
  CRMediaContent *product = OCMClassMock(CRMediaContent.class);
  OCMStub([product url]).andReturn(PRODUCT_URL);
  CRMediaContent *logo = OCMClassMock(CRMediaContent.class);
  OCMStub([logo url]).andReturn(LOGO_URL);

  CRNativeAd *ad = OCMClassMock(CRNativeAd.class);
  OCMStub([ad title]).andReturn(@"title");
  OCMStub([ad body]).andReturn(@"body");
  OCMStub([ad price]).andReturn(@"price");
  OCMStub([ad callToAction]).andReturn(@"callToAction");
  OCMStub([ad productMedia]).andReturn(product);
  OCMStub([ad advertiserDescription]).andReturn(@"advertiserDescription");
  OCMStub([ad advertiserDescription]).andReturn(@"advertiserDomain");
  OCMStub([ad advertiserLogoMedia]).andReturn(logo);
  return ad;
}

@end
