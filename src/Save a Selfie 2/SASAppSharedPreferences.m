//
//  AppUserDefaults.m
//  Save a Selfie
//
//  Created by Stephen Fox on 28/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASAppSharedPreferences.h"
#import <FXKeychain.h>

@implementation SASAppSharedPreferences

NSString* EULAKey = @"EULAAccepted";
NSString* CurrentUserEmail = @"Email";
NSString* CurrentUserName = @"Name";
NSString* KeyChainId = @"saveaselfie";
NSString* SocialIDKey = @"SocialID";
NSString* TokenIDKey = @"TokenID";

+ (void)addValueForEULAAccepted:(NSString *) value {
  [[NSUserDefaults standardUserDefaults] setValue:value forKey:EULAKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *)getValueForEULAAccepted {
  return [[NSUserDefaults standardUserDefaults] valueForKey:EULAKey];
}



+ (void)setCurrentLoggedUserToken:(NSString *)token {
  FXKeychain *fxKeychain = [FXKeychain defaultKeychain];
  if (![fxKeychain objectForKey:TokenIDKey]) {
    [fxKeychain removeObjectForKey:TokenIDKey];
  }
  [fxKeychain setObject:token forKey:TokenIDKey];
}



+ (void)setCurrentLoggedUserSocialID:(NSString *) ID {
  FXKeychain *fxKeychain = [FXKeychain defaultKeychain];
  if (![fxKeychain objectForKey:SocialIDKey]) {
    [fxKeychain removeObjectForKey:SocialIDKey];
  }
  [fxKeychain setObject:ID forKey:SocialIDKey];
}


+ (void)setCurrentLoggedUserEmail:(NSString *)email {
  // If there's a user already logged in remove them.
  if ([[NSUserDefaults standardUserDefaults] objectForKey:CurrentUserEmail] != nil) {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:CurrentUserEmail];
  }
  [[NSUserDefaults standardUserDefaults]setValue:email forKey:CurrentUserEmail];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void) setCurrentLoggedUserName:(NSString *)name {
  // If there's a user already logged in remove them.
  if ([[NSUserDefaults standardUserDefaults] objectForKey:CurrentUserName] != nil) {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:CurrentUserName];
  }
  [[NSUserDefaults standardUserDefaults]setValue:name forKey:CurrentUserEmail];
  [[NSUserDefaults standardUserDefaults] synchronize];
}



+ (NSString *)currentLoggedUserSocialID {
  FXKeychain *k = [FXKeychain defaultKeychain];
  return [k objectForKey:SocialIDKey];
}

+ (NSString *)currentLoggedUserToken {
  FXKeychain *k = [FXKeychain defaultKeychain];
  return [k objectForKey:TokenIDKey];
}

+ (NSString*) currentLoggedUserEmail {
  return [[NSUserDefaults standardUserDefaults] objectForKey:CurrentUserEmail];
}

+ (NSString *)currentLoggedUserName {
  return [[NSUserDefaults standardUserDefaults] objectForKey:CurrentUserName];
}


+ (void) removeUserInformation {
  [[NSUserDefaults standardUserDefaults]removeObjectForKey: CurrentUserEmail];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:CurrentUserName];
  FXKeychain *keychain = [FXKeychain defaultKeychain];
  [keychain removeObjectForKey:TokenIDKey];
  [keychain removeObjectForKey:SocialIDKey];
}
@end
