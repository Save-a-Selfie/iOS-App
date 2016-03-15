//
//  SASUser.h
//  Save a Selfie
//
//  Created by Stephen Fox on 09/03/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A Singleton class representing information
 on users and they're respetive tokens for
 requesting information from the save a selfie
 backend.
 */
@interface SASUser : NSObject

extern const NSString* USER_DICT_CREDENTIAL; // Key for user credential.
extern const NSString* USER_DICT_TOKEN; // Key for user's token.
extern const NSString* USER_DICT_SOCIAL_ID; // Key given by social media apis.
extern const NSString* USER_DICT_NAME; // The key for the name of the user.


+ (void) setCurrentLoggedUserEmail:(NSString*) email;

+ (void) setCurrentLoggedUserToken:(NSString*) token;

+ (void) setCurrentLoggedUserSocialID:(NSString*) ID;

+ (void) setCurrentLoggedUserName:(NSString*) name;

/**
 Returns information on the current logged on user.
 
 To access the infomation use:
  USER_DICT_CREDENTIAL: Key for user's credential.
  USER_DICT_TOKEN: Key for user's token.
  USER_DICT_SOCIAL_ID: Key for user's social id.
  USER_DICT_NAME: Key for user's name.
  */
+ (NSDictionary*) currentLoggedUser;


+ (void) removeCurrentLoggedUser;


@end
