//
//  SASUser.m
//  Save a Selfie
//
//  Created by Stephen Fox on 09/03/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASUser.h"
#import "SASAppSharedPreferences.h"

/**
 While the FBSDK or Twitter has record of a user
 logged in, it does not store information
 about users on the Save a Selfie backend.
 This is what this class is for.
*/



@implementation SASUser

const NSString *USER_DICT_EMAIL = @"saveaselfie_email";
const NSString *USER_DICT_TOKEN = @"saveaselfie_token";

+ (void)setCurrentLoggedUser:(NSString *)token withEmail:(NSString *)email {
  // Set the current logged in user.
  [SASAppSharedPreferences setCurrentLoggedUserEmail:email];
  
  // Store that user to the device (keychain).
  [SASAppSharedPreferences addUserToken:token withEmail:email];
  
}


+ (NSDictionary *)currentLoggedUser {
  // Current logged in user's email.
  NSString *email = [SASAppSharedPreferences currentLoggedInUserEmail];
  NSString *token = [SASAppSharedPreferences userTokenWithEmail:email];
  
  NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
  [userDict setObject:email forKey:USER_DICT_EMAIL];
  [userDict setObject:token forKey:USER_DICT_TOKEN];
  
  return [userDict mutableCopy];
}

+ (void)removeCurrentLoggedUser {
  [SASAppSharedPreferences removeUserInformation];
}



@end