//
//  CR_DataProtectionConsent.m
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

#import <AdSupport/ASIdentifierManager.h>

#import "CR_Ccpa.h"
#import "CR_DataProtectionConsent.h"
#import "CR_Gdpr.h"

NSString *const CR_DataProtectionConsentMopubConsentKey = @"MopubConsent_String";

@interface CR_DataProtectionConsent ()

@property(class, nonatomic, strong, readonly) NSArray<NSString *> *mopubConsentDeclinedStrings;

@property(nonatomic, strong, readonly) NSUserDefaults *userDefaults;
@property(nonatomic, strong, readonly) CR_Ccpa *ccpa;

@end

@implementation CR_DataProtectionConsent

+ (NSArray<NSString *> *)mopubConsentDeclinedStrings {
  return @[ @"EXPLICIT_NO", @"POTENTIAL_WHITELIST", @"DNT" ];
}

- (instancetype)init {
  return [self initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
}

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults {
  if (self = [super init]) {
    _userDefaults = userDefaults;
    _ccpa = [[CR_Ccpa alloc] initWithUserDefaults:userDefaults];
    _gdpr = [[CR_Gdpr alloc] initWithUserDefaults:userDefaults];
    _isAdTrackingEnabled = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
  }
  return self;
}

- (NSString *)usPrivacyIabConsentString {
  return self.ccpa.iabConsentString;
}

- (void)setUsPrivacyCriteoState:(CR_CcpaCriteoState)usPrivacyCriteoState {
  self.ccpa.criteoState = usPrivacyCriteoState;
}

- (CR_CcpaCriteoState)usPrivacyCriteoState {
  return self.ccpa.criteoState;
}

- (BOOL)shouldSendAppEvent {
  if ([self _isMopubConsentDeclined]) {
    return NO;
  }
  return self.ccpa.isOptIn;
}

- (void)setMopubConsent:(NSString *)mopubConsent {
  [self.userDefaults setObject:mopubConsent forKey:CR_DataProtectionConsentMopubConsentKey];
}

- (NSString *)mopubConsent {
  return [self.userDefaults objectForKey:CR_DataProtectionConsentMopubConsentKey];
}

- (BOOL)_isMopubConsentDeclined {
  NSString *uppercases = [self.mopubConsent uppercaseString];
  return [self.class.mopubConsentDeclinedStrings containsObject:uppercases];
}

@end
