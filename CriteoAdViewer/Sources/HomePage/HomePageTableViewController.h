//
//  HomePageTableViewController.h
//  CriteoAdViewer
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

#import <UIKit/UIKit.h>
#import <CriteoPublisherSdk/CriteoPublisherSdk.h>
#import "Criteo+Internal.h"

#define GOOGLEBANNERADUNITID_320x50 @"/140800857/Endeavour_320x50"
#define GOOGLEBANNERADUNITID_300X250 @"/140800857/Endeavour_300x250"
#define GOOGLENATIVEADUNITID_FLUID @"/140800857/Endeavour_Native"
#define GOOGLEINTERSTITIALADUNITID @"/140800857/Endeavour_Interstitial_320x480"

#define MOPUBBANNERADUNITID_320X50 @"bb0577af6858451d8191c2058fe59d03"
#define MOPUBBANNERADUNITID_300X250 @"69942486c90c4cd4b3c627ba613509a3"
#define MOPUBINTERSTITIALADUNITID @"966fbbf95ba24ab990e5f037cc674bbc"

#define CRITEOBANNERADUNITID_320x50 @"30s6zt3ayypfyemwjvmp"
#define CRITEOINTERSTITIALID @"6yws53jyfjgoq1ghnuqb"
#define CRITEONATIVEADUNITID @"190tsfngohsvfkh3hmkm"
#define CRITEOVIDEOADUNITID @"mf2v6pikq5vqdjdtfo3j"

@interface HomePageTableViewController : UITableViewController

@property(nonatomic, strong) CRBannerAdUnit *googleBannerAdUnit_320x50;
@property(nonatomic, strong) CRBannerAdUnit *googleBannerAdUnit_300x250;
@property(nonatomic, strong) CRInterstitialAdUnit *googleInterstitialAdUnit;
@property(nonatomic, strong) CRNativeAdUnit *googleNativeAdUnit_Fluid;

@property(nonatomic, strong) CRBannerAdUnit *moPubBannerAdUnit_320x50;
@property(nonatomic, strong) CRBannerAdUnit *moPubBannerAdUnit_300x250;
@property(nonatomic, strong) CRInterstitialAdUnit *moPubInterstitialAdUnit;

@property(nonatomic, strong) CRBannerAdUnit *criteoBannerAdUnit_320x50;
@property(nonatomic, strong) CRInterstitialAdUnit *criteoInterstitialAdUnit;
@property(nonatomic, strong) CRInterstitialAdUnit *criteoInterstitialVideoAdUnit;
@property(nonatomic, strong) CRNativeAdUnit *criteoNativeAdUnit;

@end
