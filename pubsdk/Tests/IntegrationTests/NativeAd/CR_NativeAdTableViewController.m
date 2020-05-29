//
//  CR_NativeAdTableViewController.m
//  pubsdkITests
//
//  Copyright © 2018-2020 Criteo. All rights reserved.
//

#import "CR_NativeAdTableViewCell.h"
#import "CR_NativeAdTableViewController.h"
#import "CRNativeLoader.h"
#import "CRNativeLoader+Internal.h"
#import "CRNativeAdUnit.h"
#import "CRNativeAdView.h"
#import "CRNativeAd.h"
#import "CRMediaView.h"
#import "CR_URLOpenerMock.h"

static NSString * const kAdCellIdentifier = @"AdCell";
static NSString * const kNormalCellIdentifier = @"NormalCell";
static NSString * const kAdCellNibName = @"CR_NativeAdTableViewCell";
static const NSUInteger kCellCount = 50;


@interface CR_NativeAdTableViewController () <CRNativeDelegate>

@property (strong, nonatomic) CRNativeLoader *adLoader;
@property (strong, nonatomic) NSMutableArray<CRNativeAd *> *nativeAds;
@property (strong, nonatomic) CR_NativeAdTableViewCell *lastFilledAdCell;

@property (assign, nonatomic) NSUInteger loadAdCount;
@property (assign, nonatomic) NSUInteger adLoadedCount;
@property (assign, nonatomic) NSUInteger detectClickCount;
@property (assign, nonatomic) NSUInteger leaveAppCount;

@end

@implementation CR_NativeAdTableViewController

@synthesize adUnit = _adUnit;

+ (instancetype)nativeAdTableViewControllerWithCriteo:(Criteo *)criteo {
    CR_NativeAdTableViewController *ctrl = [[CR_NativeAdTableViewController alloc] init];
    ctrl.criteo = criteo;
    return ctrl;
}

- (NSMutableArray<CRNativeAd *> *)nativeAds {
    if (_nativeAds == nil) {
        _nativeAds = [[NSMutableArray alloc] init];
    }
    return _nativeAds;
}

- (NSArray<NSIndexPath *> *)nativeAdIndexPaths {
    if (_nativeAdIndexPaths == nil) {
        _nativeAdIndexPaths = @[
            [NSIndexPath indexPathForRow:0 inSection:0],
            [NSIndexPath indexPathForRow:1 inSection:0],
            [NSIndexPath indexPathForRow:10 inSection:0],
        ];
    }
    return _nativeAdIndexPaths;
}

- (void)setAdUnit:(CRNativeAdUnit *)adUnit {
    if (adUnit != _adUnit) {
        _adUnit = adUnit;
        self.adLoader = (_adUnit) ?
            [[CRNativeLoader alloc] initWithAdUnit:adUnit
                                            criteo:self.criteo
                                         urlOpener:[[CR_URLOpenerMock alloc] init]] :
            nil;
        self.adLoader.delegate = self;
    }
}


- (void)viewDidLoad {
    NSBundle *bundle = [NSBundle bundleForClass:CR_NativeAdTableViewCell.class];
    UINib *adCellNib = [UINib nibWithNibName:kAdCellNibName
                                      bundle:bundle];
    [self.tableView registerNib:adCellNib
         forCellReuseIdentifier:kAdCellIdentifier];
    [self.tableView registerClass:UITableViewCell.class
           forCellReuseIdentifier:kNormalCellIdentifier];
}

#pragma mark - Table view data source / delegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetHeight(self.view.frame) / 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return kCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger nativeAdIndex = [self.nativeAdIndexPaths indexOfObject:indexPath];
    if (nativeAdIndex != NSNotFound) {
        CR_NativeAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAdCellIdentifier
                                                                         forIndexPath:indexPath];

        CRNativeAd *ad = (self.nativeAds.count > nativeAdIndex) ? self.nativeAds[nativeAdIndex] : nil;
        cell.titleLabel.text = ad.title ?: @"No title";
        cell.bodyLabel.text = ad.body ?: @"No body";
        cell.productMediaView.placeholder = self.mediaPlaceholder;
        cell.productMediaView.mediaContent = ad.productMedia;
        cell.callToActionLabel.text = ad.callToAction ?: @"No callToAction";
        cell.advertiserDescriptionLabel.text = ad.advertiserDescription ?: @"No advertiserDescription";
        cell.advertiserDomainUrlLabel.text = ad.advertiserDomain ?: @"No advertiserDomain";
        cell.advertiserLogoMediaView.placeholder = self.mediaPlaceholder;
        cell.advertiserLogoMediaView.mediaContent = ad.advertiserLogoMedia;
        cell.priceLabel.text = ad.price ?: @"No price";

        if (ad) {
            self.lastFilledAdCell = cell;
        }
        return cell;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNormalCellIdentifier
                                                            forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Cell #%ld", (long)indexPath.row];
    return cell;
}

#pragma mark - CRNativeDelegate

 - (void)nativeLoader:(CRNativeLoader *)loader
         didReceiveAd:(CRNativeAd *)ad {
     [self.nativeAds addObject:ad];
     [self.tableView reloadData];
     self.adLoadedCount += 1;
}

-(void)nativeLoader:(CRNativeLoader *)loader
didFailToReceiveAdWithError:(NSError *)error {

}

- (void)nativeLoaderDidDetectImpression:(CRNativeLoader *)loader {

}

- (void)nativeLoaderDidDetectClick:(CRNativeLoader *)loader {
    self.detectClickCount += 1;
}

-(void)nativeLoaderWillLeaveApplicationForNativeAd:(CRNativeLoader *)loader {
    self.leaveAppCount += 1;
}


@end
