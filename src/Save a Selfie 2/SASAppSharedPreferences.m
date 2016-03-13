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
NSString* UserToken = @"UserToken";
NSString* CurrentUserEmail = @"Email";
NSString* KeyChainId = @"saveaselfie";

+ (void)addValueForEULAAccepted:(NSString *) value {
  [[NSUserDefaults standardUserDefaults] setValue:value forKey:EULAKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *)getValueForEULAAccepted {
  return [[NSUserDefaults standardUserDefaults] valueForKey:EULAKey];
}


+ (void)addUserToken:(NSString *)token withEmail:(NSString *)email {
  FXKeychain *fxKeychain = [FXKeychain defaultKeychain];
  [fxKeychain setObject:token forKey:email];
}

+ (NSString *)userTokenWithEmail:(NSString *)email {
  FXKeychain *fxKeychain = [FXKeychain defaultKeychain];
  return [fxKeychain objectForKey:email];
}


+ (void)setCurrentLoggedUserEmail:(NSString *)email {
  // If there's a user already logged in remove them.
  if ([[NSUserDefaults standardUserDefaults] objectForKey:CurrentUserEmail] != nil) {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:CurrentUserEmail];
  }
  [[NSUserDefaults standardUserDefaults]setValue:email forKey:CurrentUserEmail];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString*) currentLoggedInUserEmail {
  return [[NSUserDefaults standardUserDefaults] objectForKey:CurrentUserEmail];
}


+ (void) removeUserInformation {
  NSString *userEmail = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentUserEmail];
  if ([[NSUserDefaults standardUserDefaults] objectForKey:CurrentUserEmail] != nil) {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:CurrentUserEmail];
  }
  
  FXKeychain *keychain = [FXKeychain defaultKeychain];
  [keychain removeObjectForKey:userEmail];
}
@end
