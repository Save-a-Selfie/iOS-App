//
//  AppUserDefaults.h
//  Save a Selfie
//
//  Created by Stephen Fox on 28/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASAppSharedPreferences : NSObject



+ (void) addValueForEULAAccepted:(NSString*) value;

+ (NSString *) getValueForEULAAccepted;



/**
 Sets the current logged on user's social id.
 This is usually the id generated from the api used.
 This id is stored inside keychain.
 @param The social id of the user.
 */
+ (void) setCurrentLoggedUserSocialID:(NSString*) ID;

/**
 Sets the current logged on user's token.
 This is generated from Save a Selfie servers.
 This token is stored inside keychain.
 @param The token of the user.
 */
+ (void)setCurrentLoggedUserToken:(NSString *)token;

/**
 Sets the current logged in user's email.
 This is not stored withing keychain.
 @param email The email of the user to save.
 */
+ (void) setCurrentLoggedUserEmail:(NSString*) email;

/**
 Sets the current logged in user's name.
 This is not stored withing keychain.
 @param name The email of the user to save.
 */
+ (void) setCurrentLoggedUserName:(NSString*) name;


+ (NSString*) currentLoggedUserSocialID;

+ (NSString*) currentLoggedUserToken;

+ (NSString*) currentLoggedUserName;

+ (NSString*) currentLoggedUserEmail;

/**
 Removes the all user information from keychain and NSUserDefaults.
 */
+ (void) removeUserInformation;
@end
