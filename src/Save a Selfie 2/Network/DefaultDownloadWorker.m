//
//  DefaultNetworkWorker.m
//  Save a Selfie
//
//  Created by Stephen Fox on 29/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "UIKit/UIKit.h"
#import "DefaultDownloadWorker.h"
#import "SASAnnotation.h"

@interface DefaultDownloadWorker () <NSURLSessionDelegate>

@property (strong, nonatomic) NSURLSession *nsUrlDefaultSession;
@property (strong, nonatomic) NSURL *url;

@end

@implementation DefaultDownloadWorker

NSString* const downloadURL = @"http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/getMapData.php";

- (instancetype)init {
  self = [super init];
  if (!self) {
    return nil;
  }
  [self commonInit];
  return self;
}

- (void) commonInit {
  
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

  self.url = [NSURL URLWithString:downloadURL];
  self.nsUrlDefaultSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
}


#pragma mark DownloadWorker protocol.
- (void)downloadWithQuery:(SASNetworkQuery *)query completionResult:(DownloadWorkerCompletionBlock)completionBlock {
  // Determine the query type.
  switch (query.type) {
    case SASNetworkQueryTypeAll:
      [self downloadAllDevicesFromServer:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *sasDevices = [self constructDevicesFromResponse:data];
        completionBlock(sasDevices);
      }];
      break;
  }
}


- (void) downloadAllDevicesFromServer: (void (^)(NSData *data, NSURLResponse *response, NSError *error)) result {
  [self.nsUrlDefaultSession dataTaskWithURL:self.url completionHandler:result];
}



/**
 Constructs SASDevices from NSData retrieved from the server.
 */
- (nullable NSArray<SASDevice *> *) constructDevicesFromResponse:(nonnull NSData *)data {
  NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  NSArray *deviceStrings = [dataString componentsSeparatedByString:@"\n"];
  NSMutableArray *devices = [[NSMutableArray alloc] init];
  
  for (int i = 0; i < [deviceStrings count]; i++) {
    if ([deviceStrings[i] length] != 0) {
      SASDevice *device = [[SASDevice alloc] initDeviceWithInformationFromString:deviceStrings[i]];
      [devices addObject:device];
    }
  }
  //Dont return the mutable version of the array.
  return [devices copy];
}

@end
