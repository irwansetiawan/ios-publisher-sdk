//
//  CRCriteoAdapterConfigurationTests.m
//  CriteoMoPubAdapterTests
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
#import "CRCriteoAdapterConfiguration.h"

@interface CRCriteoAdapterConfigurationTests : XCTestCase

@end

@implementation CRCriteoAdapterConfigurationTests

- (void)testBiddingToken{
    CRCriteoAdapterConfiguration *config = [[CRCriteoAdapterConfiguration alloc] init];
    XCTAssertNil([config biddingToken]);
}

- (void)testmoPubNetworkName{
    CRCriteoAdapterConfiguration *config = [[CRCriteoAdapterConfiguration alloc] init];
    XCTAssertEqual([config moPubNetworkName], @"criteo");
}

@end
