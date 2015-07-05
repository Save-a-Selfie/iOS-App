//
//  SASNetworkUtilities.h
//  Save a Selfie
//
//  Created by Stephen Fox on 05/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SASNetworkUtilities : NSObject

// Encode a string to embed in an URL. See http://cybersam.com/ios-dev/proper-url-percent-encoding-in-ios
+ (NSString*) encodeToPercentEscapeString:(NSString *)string;


// Decode a percent escape encoded string. See http://cybersam.com/ios-dev/proper-url-percent-encoding-in-ios
+ (NSString*) decodeFromPercentEscapeString:(NSString *)string;

@end
