//
//  SASUtilities.h
//  Save a Selfie
//
//  Created by Stephen Fox on 04/06/2015.
//  Copyright (c) 2015 Stephen Fox & Peter FitzGerald All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SASUtilities : NSObject



+ (NSString*) getCurrentTimeStamp;




/**
 Creates a random string of a specified length.
 
 @param length
        The length of the string.
 
 @return NSString
        A random string of characters of the specified length.
 */
+ (NSString *) generateRandomString: (NSInteger) length;

@end
