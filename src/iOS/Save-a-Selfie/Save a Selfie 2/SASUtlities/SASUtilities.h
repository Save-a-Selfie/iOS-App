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

+ (double) distanceBetween:(CLLocationCoordinate2D) pointA and: (CLLocationCoordinate2D) pointB;

+ (NSString*) getCurrentTimeStamp;

+ (void) addSASBlurToView:(UIView*) view;

@end
