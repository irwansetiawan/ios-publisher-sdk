//
//  CRNativeAdView.h
//  CriteoPublisherSdk
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

@import UIKit;

@class CRNativeAd;

NS_ASSUME_NONNULL_BEGIN

/**
 * View that wrap a UIView for displaying an Advanced Native Ad.
 *
 * You need to call super if you override methods.
 */
@interface CRNativeAdView : UIControl

/**
 * The advanced native ad associated to the view.
 *
 * The assignation of the native ad is mandatory to track the impression and the clicks on the
 * advanced native ad.
 */
@property(strong, nonatomic, nullable) CRNativeAd *nativeAd;

@end

NS_ASSUME_NONNULL_END
