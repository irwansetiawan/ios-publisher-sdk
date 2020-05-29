//
//  CR_DeviceInfoTests.m
//  CriteoPublisherSdkTests
//
//  Copyright © 2018-2020 Criteo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>

#import "CR_DeviceInfo.h"
#import "CR_ThreadManager.h"
#import "XCTestCase+Criteo.h"

@import WebKit;

@interface CR_DeviceInfoTests : XCTestCase

@end

@interface CR_DeviceInfo (Tests)

@property (strong, nonatomic, readonly) WKWebView *webView;

@end

@implementation CR_DeviceInfoTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testWKWebViewSuccess {
    XCTestExpectation *expectation = [self expectationWithDescription:@"UserAgent is filled asynchronously"];

    WKWebView *wkWebViewMock = OCMStrictClassMock([WKWebView class]);
    
    OCMStub([wkWebViewMock evaluateJavaScript:@"navigator.userAgent" completionHandler:([OCMArg invokeBlockWithArgs:@"Some Ua", [NSNull null], nil])]);
    CR_ThreadManager *threadManager = [[CR_ThreadManager alloc] init];
    CR_DeviceInfo *deviceInfo = [[CR_DeviceInfo alloc] initWithThreadManager:threadManager
                                                                     webView:wkWebViewMock];
    [deviceInfo waitForUserAgent:^{
        XCTAssertEqual(@"Some Ua", deviceInfo.userAgent, @"User agent should be set if WKWebView passes it");
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:0.1];
}

- (void)testCompleteFailure {
    XCTestExpectation *expectation = [self expectationWithDescription:@"UserAgent is filled asynchronously"];
    
    WKWebView *wkWebViewMock = OCMStrictClassMock([WKWebView class]);
    
    NSError *anError = [NSError errorWithDomain:NSCocoaErrorDomain code:1 userInfo:nil];
    OCMStub([wkWebViewMock evaluateJavaScript:@"navigator.userAgent" completionHandler:([OCMArg invokeBlockWithArgs:@"Not An UA", anError, nil])]);
    CR_ThreadManager *threadManager = [[CR_ThreadManager alloc] init];
    CR_DeviceInfo *deviceInfo = [[CR_DeviceInfo alloc] initWithThreadManager:threadManager
                                                                     webView:wkWebViewMock];
    [deviceInfo waitForUserAgent:^{
        XCTAssertNil(deviceInfo.userAgent, @"User agent should be nil if we didn't manage to set it. Perhaps we can find a better solution in the future. Also we should log.");
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:0.1];
}

// This is more an ITest and should probably be moved in a separate project
- (void) testUserAgent {
    XCTestExpectation *expectation = [self expectationWithDescription:@"UserAgent is filled asynchronously"];

    CR_DeviceInfo *device = [[CR_DeviceInfo alloc] init];
    XCTAssertNil(device.userAgent, @"User-Agent is nil when we create the object");
    [device waitForUserAgent:^{
        XCTAssertNotNil(device.userAgent, @"User-Agent should be filled in after a short period of time");
        NSRange range = [device.userAgent rangeOfString:@"Mozilla.*Mobile/" options:NSRegularExpressionSearch];
        XCTAssertTrue(range.location != NSNotFound);
        [expectation fulfill];
    }];

    [self waitForExpectations:@[expectation] timeout:5];
}

- (void)testWebViewInstantiatedOnMainThread {
    XCTestExpectation *exp = [self expectationWithDescription:@"DeviceInfo created"];
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        XCTAssertNoThrow([[CR_DeviceInfo alloc] init]);
        [exp fulfill];
    });
    [self waitForExpectations:@[exp] timeout:0.2];
}

- (void)testWebViewReleasedAfterUse {
    XCTestExpectation *expectation = [self expectationWithDescription:@"WebView has been released"];

    CR_DeviceInfo *device = [[CR_DeviceInfo alloc] init];
    XCTAssertNotNil(device.webView, @"WebView has been allocated");
    [device waitForUserAgent:^{
        XCTAssertNil(device.webView, @"WebView has been released");
        [expectation fulfill];
    }];

    [self cr_waitForExpectations:@[expectation]];
}

@end
