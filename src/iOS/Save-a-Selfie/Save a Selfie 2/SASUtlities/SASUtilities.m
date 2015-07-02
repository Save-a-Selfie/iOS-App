//
//  SASUtilities.m
//  Save a Selfie
//
//  Created by Stephen Fox on 04/06/2015.
//  Copyright (c) 2015 Stephen Fox & Peter FitzGerald. All rights reserved.
//

#import "SASUtilities.h"
#import "ILTranslucentView.h"

@implementation SASUtilities


#pragma mark Haversine Formula
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



#pragma mark Current Timestamp
// From here: http://stackoverflow.com/questions/22359090/get-current-time-in-timestamp-format-ios

+ (NSString *)getCurrentTimeStamp {
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString    *strTime = [objDateformat stringFromDate:[NSDate date]];
    NSString    *strUTCTime = [self getUTCDateTimeFromLocalTime:strTime];
    
    return strUTCTime;
}

+ (NSString *)getUTCDateTimeFromLocalTime:(NSString *)IN_strLocalTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
     NSDate *objDate = [dateFormatter dateFromString:IN_strLocalTime];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *strDateTime   = [dateFormatter stringFromDate:objDate];
    
    return strDateTime;
}


// Adds a ILTranlucentView tas a subview to a desired view.
// @param: view: View to which a blurred view is added as a subview.
+ (void) addSASBlurToView:(UIView*) view {
    ILTranslucentView *blur = [ILTranslucentView new];
    
    blur.frame = view.frame;
    
    blur.backgroundColor = [UIColor clearColor];
    blur.translucentStyle = UIBarStyleDefault;
    blur.translucentTintColor = [UIColor clearColor];
    blur.translucentAlpha = 0.999;
    
    [view addSubview:blur];
}

// Changes the view to a blurview.
+ (void) blurForView:(UIView*) view {
    
    ILTranslucentView *blur = [ILTranslucentView new];
    blur.frame = view.frame;
    
    blur.backgroundColor = [UIColor clearColor];
    blur.translucentStyle = UIBarStyleDefault;
    blur.translucentTintColor = [UIColor clearColor];
    blur.translucentAlpha = 0.7;
    
    [view addSubview:blur];
    [view sendSubviewToBack:blur];
    view.backgroundColor = [UIColor clearColor];
}



@end
