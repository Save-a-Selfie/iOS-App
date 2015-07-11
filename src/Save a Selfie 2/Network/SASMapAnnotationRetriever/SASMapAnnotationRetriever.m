//
//  SASMapAnnotationRetriever.m
//  Save a Selfie
//
//  Created by Stephen Fox on 28/05/2015.
//  Copyright (c) 2015 Stephen Fox & Peter FitzGerald. All rights reserved.
//

#import "SASMapAnnotationRetriever.h"
#import "PopupImage.h"
#import "SASDevice.h"
#import "AppDelegate.h"
#import "ExtendNSLogFunctionality.h"

@interface SASMapAnnotationRetriever() <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property(strong, nonatomic) NSMutableData *responseData;
@property(strong, nonatomic) NSMutableArray *devices;

@property(strong, nonatomic) NSURL *url;
@property(strong, nonatomic) NSURLRequest *request;
@property(strong, nonatomic) NSURLConnection *connection;

@end


@implementation SASMapAnnotationRetriever

@synthesize delegate;
@synthesize devices;
@synthesize responseData = _responseData;

#pragma mark Objects for creating up URL request.
@synthesize url = _url;
@synthesize request = _request;
@synthesize connection;



#pragma mark Object Life Cycle
// Set up all connection & data objects here
- (instancetype)init
{
    if(self = [super init]) {
        _url = [NSURL URLWithString: @"http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/getMapData.php"];
        _request = [NSURLRequest requestWithURL:self.url];
        _responseData = [[NSMutableData alloc] init];
    }
    return self;
}


- (void) fetchSASAnnotationsFromServer {
    
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request
                                                      delegate:self];
    
}


- (UIImage*) getImageFromURLWithString: (NSString *) string {
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:string]];
    UIImage *image = [UIImage imageWithData:data];
    
    return image;

}



#pragma mark NSURLConnectionDataDelegate methods
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength: 0];
}



- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}



#pragma mark NSURLConnectionDelegate methods
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *data = [[NSString alloc] initWithData:self.responseData
                                           encoding:NSUTF8StringEncoding];
    
    NSArray *deviceData = [data componentsSeparatedByString:@"\n"];
    
    
    self.devices = [[NSMutableArray alloc] init];
    
    
    for(int i = 0; i < [deviceData count]; i++) {
        if([deviceData[i] length] != 0) {
            
            SASDevice *device = [[SASDevice alloc] initDeviceWithInformationFromString:[deviceData objectAtIndex:i]];
            [self.devices insertObject:device atIndex:i];
        }
    }
    
    
    // Pass on the device data to any conforming object.
    if(delegate != nil && [delegate respondsToSelector:@selector(sasAnnotationsRetrieved:)]) {
        plog(@"Passing on annotations");
        [delegate sasAnnotationsRetrieved:self.devices];
    }
}


@end
