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

// This method uses the Haversine Formula for finding distances
// between two locations on earth.
// Taken from http://rosettacode.org/wiki/Haversine_formula#Objective-C
+ (double) distanceBetween:(CLLocationCoordinate2D) pointA and: (CLLocationCoordinate2D) pointB;


+ (NSString*) getCurrentTimeStamp;

// Adds a ILTranlucentView tas a subview to a desired view.
// @param: view: View to which a blurred view is added as a subview.
+ (void) addSASBlurToView:(UIView*) view;

// Changes the view to a blurview.
+ (void) blurForView:(UIView*) view;

@end
