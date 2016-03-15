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
const NSString* USER_DICT_SOCIAL_ID = @"saveaselfie_social_id";
const NSString* USER_DICT_NAME = @"saveaselfie_name";


+ (void)setCurrentLoggedUserEmail:(NSString *)email {
  [SASAppSharedPreferences setCurrentLoggedUserEmail:email];
}

+ (void)setCurrentLoggedUserName:(NSString *)name {
  [SASAppSharedPreferences setCurrentLoggedUserName:name];
}

+ (void)setCurrentLoggedUserToken:(NSString *)token {
  [SASAppSharedPreferences setCurrentLoggedUserToken:token];
}

+ (void)setCurrentLoggedUserSocialID:(NSString *)ID {
  [SASAppSharedPreferences setCurrentLoggedUserSocialID:ID];
  
}

+ (NSDictionary *)currentLoggedUser {
  // Current logged in user's email.
  NSString *email = [SASAppSharedPreferences currentLoggedUserEmail];
  NSString *name = [SASAppSharedPreferences currentLoggedUserName];
  NSString *token = [SASAppSharedPreferences currentLoggedUserToken];
  NSString *socialId = [SASAppSharedPreferences currentLoggedUserSocialID];
  
  
  NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
  
  if (email) {
    [userDict setObject:email forKey:USER_DICT_EMAIL];
  }
  if (name) {
    [userDict setObject:name forKey:USER_DICT_NAME];
  }
  if (token) {
    [userDict setObject:token forKey:USER_DICT_TOKEN];
  }
  if (socialId) {
    [userDict setObject:socialId forKey:USER_DICT_SOCIAL_ID];
  }
  return [userDict mutableCopy];
}

+ (void)removeCurrentLoggedUser {
  [SASAppSharedPreferences removeUserInformation];
}



@end