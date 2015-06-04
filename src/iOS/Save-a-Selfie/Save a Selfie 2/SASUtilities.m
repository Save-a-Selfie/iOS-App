//
//  SASUtilities.m
//  Save a Selfie
//
//  Created by Stephen Fox on 04/06/2015.
//  Copyright (c) 2015 Peter FitzGerald. All rights reserved.
//

#import "SASUtilities.h"

@implementation SASUtilities

// This method uses the Haversine Formula for finding distances
// between two locations on earth.
// Taken from http://rosettacode.org/wiki/Haversine_formula#Objective-C
+ (double) distanceBetween:(CLLocationCoordinate2D) pointA and: (CLLocationCoordinate2D) pointB {

    static const double DEG_TO_RAD = 0.017453292519943295769236907684886;
    static const double EARTH_RADIUS_IN_METERS = 6372797.560856;
    
    double latitudeArc  = (pointA.latitude - pointB.latitude) * DEG_TO_RAD;
    double longitudeArc = (pointA.longitude - pointB.longitude) * DEG_TO_RAD;
    double latitudeH = sin(latitudeArc * 0.5);
    latitudeH *= latitudeH;
    double lontitudeH = sin(longitudeArc * 0.5);
    lontitudeH *= lontitudeH;
    double tmp = cos(pointA.latitude*DEG_TO_RAD) * cos(pointB.latitude*DEG_TO_RAD);
    return (EARTH_RADIUS_IN_METERS * 2.0 * asin(sqrt(latitudeH + tmp*lontitudeH))) / 1000;
}

@end
