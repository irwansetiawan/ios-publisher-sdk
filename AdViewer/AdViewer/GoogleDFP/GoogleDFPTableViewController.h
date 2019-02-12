//
//  GoogleDFPTableViewController.h
//  AdViewer
//
//  Created by Yegor Pavlikov on 11/9/18.
//  Copyright © 2018 Criteo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pubsdk/pubsdk.h>

#import "NetworkManagerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoogleDFPTableViewController : UITableViewController <NetworkManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textNetworkId;
@property (weak, nonatomic) IBOutlet UITextField *textAdUnitId;
@property (weak, nonatomic) IBOutlet UITextField *textAdUnitWidth;
@property (weak, nonatomic) IBOutlet UITextField *textAdUnitHeight;
@property (weak, nonatomic) IBOutlet UITextView *textFeedback;
@property (nonatomic) Criteo *criteoSdk;
@property (weak, nonatomic) IBOutlet UISwitch *bannerInterstitialSwitch;


- (IBAction)loadAdClick:(id)sender;
- (IBAction)clearButtonClick:(id)sender;
- (IBAction)registerAdUnitClick:(id)sender;
- (IBAction)bannerInterstitialSwitched:(id)sender;

@end

NS_ASSUME_NONNULL_END