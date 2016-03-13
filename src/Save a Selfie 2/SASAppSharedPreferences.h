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
 Adds a user token with an associated email
 This is information is stored within keychain.
 @param token The user token id retrieved from the save
              selfie backend.
 @param email The email of the user.
 */
+ (void) addUserToken:(NSString*) token withEmail:(NSString*) email;

/**
 Returns the token for a user using they're email as a key.
 @param email The email which is used to access the token.
 @return The user's token. If a token doesn't exist
         then nil will be returned.
 */
+ (NSString *)userTokenWithEmail:(NSString *)email;


+ (void) setCurrentLoggedUserEmail:(NSString*) email;

+ (NSString*) currentLoggedInUserEmail;

/**
 Removes the all user information from keychain and NSUserDefaults.
 */
+ (void) removeUserInformation;
@end
