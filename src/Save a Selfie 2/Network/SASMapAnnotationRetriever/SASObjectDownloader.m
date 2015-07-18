//
//  SASObjectDownloader.m
//  Save a Selfie
//
//  Created by Stephen Fox on 28/05/2015.
//  Copyright (c) 2015 Stephen Fox & Peter FitzGerald. All rights reserved.
//

#import "SASObjectDownloader.h"
#import "PopupImage.h"
#import "SASDevice.h"
#import "AppDelegate.h"
#import "ExtendNSLogFunctionality.h"

@interface SASObjectDownloader() <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property(strong, nonatomic) NSMutableData *responseData;
@property(strong, nonatomic) NSMutableArray *dowloadedObjects;

@property(strong, nonatomic) NSURL *url;
@property(strong, nonatomic) NSURLRequest *request;
@property(strong, nonatomic) NSURLConnection *connection;

@end


@implementation SASObjectDownloader

@synthesize delegate = _delegate;
@synthesize dowloadedObjects;
@synthesize responseData = _responseData;

#pragma mark Objects for creating up URL request.
@synthesize url = _url;
@synthesize request = _request;
@synthesize connection;



#pragma mark Object Life Cycle
- (instancetype)init {
    if(self = [super init]) {
        [self setup];
    }
    return self;
}


- (instancetype) initWithDelegate:(id) delegate {
    if (self = [super init]) {
        _delegate = delegate;
        [self setup];
    }
    return self;
}



// Set up all connection & data objects here
- (void) setup {
    _url = [NSURL URLWithString: @"http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/getMapData.php"];
    _request = [NSURLRequest requestWithURL:self.url];
    _responseData = [[NSMutableData alloc] init];
}



- (void) downloadObjectsFromServer {
    
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
    
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
    
    NSArray *objectData = [data componentsSeparatedByString:@"\n"];
    
    
    self.dowloadedObjects = [[NSMutableArray alloc] init];
    
    
    for(int i = 0; i < [objectData count]; i++) {
        if([objectData[i] length] != 0) {
            
            SASDevice *device = [[SASDevice alloc] initDeviceWithInformationFromString:[objectData objectAtIndex:i]];
            [self.dowloadedObjects insertObject:device atIndex:i];
        }
    }
    
    
    // Pass on the downloaded information to the delegate.
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sasObjectDownloader:didDownloadObjects:)]) {
        [self.delegate sasObjectDownloader:self didDownloadObjects:self.dowloadedObjects];
    }
}


@end
