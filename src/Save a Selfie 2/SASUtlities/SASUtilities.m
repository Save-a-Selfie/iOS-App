//
//  SASUtilities.m
//  Save a Selfie
//
//  Created by Stephen Fox on 04/06/2015.
//  Copyright (c) 2015 Stephen Fox & Peter FitzGerald. All rights reserved.
//

#import "SASUtilities.h"


@implementation SASUtilities



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


// http://stackoverflow.com/questions/2633801/generate-a-random-alphanumeric-string-in-cocoa
+ (NSString *) generateRandomString: (NSInteger) length {
    NSMutableString* string = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(25))];
    }
    return string;

}



@end
