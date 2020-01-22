//
//  CR_StandaloneBannerFunctionalTests.m
//  pubsdk
//
//  Created by Aleksandr Pakhmutov on 23/12/2019.
//  Copyright © 2019 Criteo. All rights reserved.
//

#import <XCTest/XCTestCase.h>
#import "CR_IntegrationsTestBase.h"
#import "CR_TestAdUnits.h"
#import "CRBannerView.h"
#import "CRBannerView+Internal.h"
#import "XCTestCase+Criteo.h"
#import "CR_CreativeViewChecker.h"


@interface CR_StandaloneBannerFunctionalTests : CR_IntegrationsTestBase

@end

@implementation CR_StandaloneBannerFunctionalTests

- (void)test_givenBannerWithBadAdUnitId_whenLoadAd_thenDelegateReceiveFail {
    CRBannerAdUnit *banner = [CR_TestAdUnits randomBanner320x50];
    [self initCriteoWithAdUnits:@[banner]];

    CR_CreativeViewChecker *viewChecker = [[CR_CreativeViewChecker alloc] initWithAdUnit:banner criteo:self.criteo];

    [viewChecker.bannerView loadAd];

    [self criteo_waitForExpectations:@[viewChecker.bannerViewFailToReceiveAdExpectation]];
}

- (void)test_givenBannerWithGoodAdUnitId_whenLoadAd_thenDelegateInvoked {
    CRBannerAdUnit *banner = [CR_TestAdUnits demoBanner320x50];
    [self initCriteoWithAdUnits:@[banner]];
    CR_CreativeViewChecker *viewChecker = [[CR_CreativeViewChecker alloc] initWithAdUnit:banner criteo:self.criteo];

    [viewChecker.bannerView loadAd];

    [self criteo_waitForExpectations:@[viewChecker.bannerViewDidReceiveAdExpectation]];
}

- (void)test_givenBannerWithGoodAdUnitId_whenLoadAd_thenAdIsLoadedProperly {
    CRBannerAdUnit *banner = [CR_TestAdUnits preprodBanner320x50];
    [self initCriteoWithAdUnits:@[banner]];
    CR_CreativeViewChecker *viewChecker = [[CR_CreativeViewChecker alloc] initWithAdUnit:banner criteo:self.criteo];

    [viewChecker.bannerView loadAd];

    [self criteo_waitForExpectations:@[viewChecker.adCreativeRenderedExpectation]];
}

@end
