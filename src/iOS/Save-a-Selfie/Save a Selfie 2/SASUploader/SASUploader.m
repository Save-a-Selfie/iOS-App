//
//  SASUploader.m
//  Save a Selfie
//
//  Created by Stephen Fox on 01/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASUploader.h"

@interface SASUploader() <NSURLConnectionDelegate>

@end

@implementation SASUploader


@synthesize sasUploadObject;


- (instancetype)initWithSASUploadObject: (SASUploadObject*) object {
    
    if (self == [super init]) {
        self.sasUploadObject = object;
    }
    return self;
}


#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}




// Encode a string to embed in an URL. See http://cybersam.com/ios-dev/proper-url-percent-encoding-in-ios
-(NSString*) encodeToPercentEscapeString:(NSString *)string {
    return (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                              (CFStringRef) string,
                                                              NULL,
                                                              (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
}


// Decode a percent escape encoded string. See http://cybersam.com/ios-dev/proper-url-percent-encoding-in-ios
-(NSString*) decodeFromPercentEscapeString:(NSString *)string {
    return (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                              (CFStringRef) string,
                                                                              CFSTR(""),
                                                                              kCFStringEncodingUTF8));
}

@end
