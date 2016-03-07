//
//  AppUserDefaults.h
//  Save a Selfie
//
//  Created by Stephen Fox on 28/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppUserDefaults : NSObject


+ (void) addValueForEULAAccepted:(NSString*) value;

+ (NSString *) getValueForEULAAccepted;

+ (void) addValueForFacebookLoginAccepted:(NSString *) value;

+ (NSString *) getValueForFacebookLoginAccepted;


@end
