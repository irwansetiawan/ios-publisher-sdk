//
//  CR_InterstitialViewController.m
//  pubsdk
//
//  Created by Julien Stoeffler on 4/24/19.
//  Copyright © 2019 Criteo. All rights reserved.
//

#import "CR_InterstitialViewController.h"

@interface CR_InterstitialViewController ()
@end

@implementation CR_InterstitialViewController

- (instancetype)initWithWebView:(WKWebView *)webView
                   interstitial:(CRInterstitial *)interstitial {
    if(self = [super init]) {
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        webView.scrollView.scrollEnabled = false;
        webView.frame = [UIScreen mainScreen].bounds;
        _webView = webView;
        _interstitial = interstitial;
    }
    return self;
}

- (void)viewDidLoad {
    _webView.frame = self.view.bounds;
    [self initCloseButton];
    [self.view addSubview:_webView];
    [self applySafeAreaConstraintsToWebView:_webView];
    [self.view addSubview:self.closeButton];
    [self applySafeAreaConstraintsToCloseButton:self.closeButton];
    [self.webView layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [self dispatchTimerForDismiss:7.0];
}

- (void)initCloseButton {
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    CGRect circleBounds = CGRectMake(10, 10, 25, 25);
    [self.closeButton.layer addSublayer:[self circleLayerInBounds:circleBounds]];
    [self.closeButton.layer addSublayer:[self xLayerInBounds:circleBounds]];
}

- (CAShapeLayer *)circleLayerInBounds:(CGRect)bounds {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:bounds];
    circleLayer.path = circle.CGPath;
    circleLayer.fillColor = [UIColor blackColor].CGColor;
    circleLayer.strokeColor = [UIColor whiteColor].CGColor;
    circleLayer.lineWidth = 1.0;
    return circleLayer;
}

- (CAShapeLayer *)xLayerInBounds:(CGRect)bounds {
    CAShapeLayer *xLayer = [CAShapeLayer layer];
    UIBezierPath *x = [UIBezierPath new];
    CGFloat gap = 0.3 * bounds.size.width;
    [x moveToPoint:CGPointMake(bounds.origin.x + (bounds.size.width - gap), bounds.origin.y + bounds.size.height - gap)];
    [x addLineToPoint:CGPointMake(bounds.origin.x + gap, bounds.origin.y + gap)];
    [x moveToPoint:CGPointMake(bounds.origin.x + gap, bounds.origin.y + bounds.size.height - gap)];
    [x addLineToPoint:CGPointMake(bounds.origin.x + (bounds.size.width - gap), bounds.origin.y + gap)];
    xLayer.path = x.CGPath;
    xLayer.strokeColor = [UIColor whiteColor].CGColor;
    xLayer.lineWidth = 3.0;
    return xLayer;
}

- (void)dismissViewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.interstitial.delegate respondsToSelector:@selector(interstitialWillDisappear:)]) {
            [self.interstitial.delegate interstitialWillDisappear:self.interstitial];
        }
    });
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:^{
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              if([self.interstitial.delegate respondsToSelector:@selector(interstitialDidDisappear:)]) {
                                                                  [self.interstitial.delegate interstitialDidDisappear:self.interstitial];
                                                              }
                                                          });
                                                      }];
}

- (void)applySafeAreaConstraintsToWebView:(WKWebView *)webView {
    webView.translatesAutoresizingMaskIntoConstraints = NO;

    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:webView.superview attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:webView.superview attribute:NSLayoutAttributeBottomMargin multiplier:1.0 constant:0];
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:webView.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:webView.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];

    [NSLayoutConstraint activateConstraints:@[topConstraint, bottomConstraint, leadingConstraint, trailingConstraint]];
}

- (void)applySafeAreaConstraintsToCloseButton:(UIButton *)closeButton {
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;

    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:closeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:45];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:closeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:45];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:closeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.webView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:closeButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.webView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];

    [NSLayoutConstraint activateConstraints:@[widthConstraint, heightConstraint, topConstraint, leftConstraint]];
}

- (void)dispatchTimerForDismiss:(double) timeInSeconds {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([self presentingViewController]){
            [self dismissViewController];
        }
    });
}

@end
