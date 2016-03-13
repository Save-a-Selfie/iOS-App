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

extern const NSString* USER_DICT_EMAIL; // Key for user's email.
extern const NSString* USER_DICT_TOKEN; // Key for user's token.


+ (void) setCurrentLoggedUser:(NSString*) token withEmail:(NSString*)email;


/**
 Returns information on the current logged on user.
 
 To access the infomation use:
  USER_DICT_EMAIL: Key for user's email.
  USER_DICT_TOKEN: Key for user's token.
  */
+ (NSDictionary*) currentLoggedUser;


+ (void) removeCurrentLoggedUser;


@end
