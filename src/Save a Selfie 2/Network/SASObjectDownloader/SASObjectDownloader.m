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




#pragma mark Object Life Cycle
- (instancetype)init {
  self = [super init];
  
  if (!self)
    return nil;
  
  [self setup];
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
  
  _url = [NSURL URLWithString:
          @"http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/getMapData.php"];
  _request = [NSURLRequest requestWithURL:self.url];
  _responseData = [[NSMutableData alloc] init];
}



- (void) downloadObjectsFromServer {
  self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
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
  if (self.delegate != nil
      && [self.delegate respondsToSelector:@selector(sasObjectDownloader:didDownloadObjects:)]) {
    [self.delegate sasObjectDownloader:self didDownloadObjects:self.dowloadedObjects];
  }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *) error {
  if(self.delegate != nil
     && [self.delegate respondsToSelector:@selector(sasObjectDownloader:didFailWithError:)]) {
    [self.delegate sasObjectDownloader:self didFailWithError:error];
  }
}

@end
