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
 on the current, logged on user.
 */
@interface SASUser : NSObject


+ (SASUser*) currentUser;


/**
 Sets the currently logged in user token.
 */
- (void) setToken:(NSString*) token;


/**
 Gets the token
 */
- (NSString*) token;
@end
