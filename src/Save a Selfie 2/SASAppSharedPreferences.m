//
//  AppUserDefaults.m
//  Save a Selfie
//
//  Created by Stephen Fox on 28/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASAppSharedPreferences.h"


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
  // If there's a user already logged in remove them.
  if ([[NSUserDefaults standardUserDefaults] objectForKey:TokenIDKey] != nil) {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:TokenIDKey];
  }
  [[NSUserDefaults standardUserDefaults]setValue:token forKey:TokenIDKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
}



+ (void)setCurrentLoggedUserSocialID:(NSString *) ID {
  // If there's a user already logged in remove them.
  if ([[NSUserDefaults standardUserDefaults] objectForKey:SocialIDKey] != nil) {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:SocialIDKey];
  }
  [[NSUserDefaults standardUserDefaults]setValue:ID forKey:CurrentUserEmail];
  [[NSUserDefaults standardUserDefaults] synchronize];
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
  return [[NSUserDefaults standardUserDefaults] objectForKey:SocialIDKey];
}

+ (NSString *)currentLoggedUserToken {
return [[NSUserDefaults standardUserDefaults] objectForKey:TokenIDKey];
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
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:SocialIDKey];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:TokenIDKey];
}
@end
