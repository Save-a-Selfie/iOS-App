//
//  AppUserDefaults.m
//  Save a Selfie
//
//  Created by Stephen Fox on 28/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "AppUserDefaults.h"

@implementation AppUserDefaults

+ (void)addValueForEULAAccepted:(NSString *) value {
  [[NSUserDefaults standardUserDefaults] setValue:value forKey:@"EULAAccepted"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *)getValueForEULAAccepted {
  return [[NSUserDefaults standardUserDefaults] valueForKey:@"EULAAccepted"];
}



+ (void)addValueForFacebookLoginAccepted:(NSString *)value {
  [[NSUserDefaults standardUserDefaults] setValue:value forKey:@"FacebookLoginAccepted"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getValueForFacebookLoginAccepted {
  return [[NSUserDefaults standardUserDefaults] valueForKey:@"FacebookLoginAccepted"];
}

@end
