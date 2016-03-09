//
//  AppUserDefaults.m
//  Save a Selfie
//
//  Created by Stephen Fox on 28/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "AppUserDefaults.h"

@implementation AppUserDefaults

NSString* EULAKey = @"EULAAccepted";
NSString* UserToken = @"UserToken";

+ (void)addValueForEULAAccepted:(NSString *) value {
  [[NSUserDefaults standardUserDefaults] setValue:value forKey:EULAKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *)getValueForEULAAccepted {
  return [[NSUserDefaults standardUserDefaults] valueForKey:EULAKey];
}



+ (void) addUserToken:(NSString*) token {
  [[NSUserDefaults standardUserDefaults] setValue:token forKey:UserToken];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString*) userToken {
  return [[NSUserDefaults standardUserDefaults] valueForKey:UserToken];
}

@end
