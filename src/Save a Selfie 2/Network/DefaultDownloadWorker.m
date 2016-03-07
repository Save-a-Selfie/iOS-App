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
#import <AddressBookUI/AddressBookUI.h>
#import <SASLocation.h>


@interface DefaultDownloadWorker ()

@property (strong, nonatomic) NSURLSession *nsUrlDefaultSession;
@property (strong, nonatomic) SASLocation *sasLocation;

@end

@implementation DefaultDownloadWorker

NSString* const downloadURL = @"https://guarded-mountain-99906.herokuapp.com/";



- (instancetype)init {
  self = [super init];
  if (!self) {
    return nil;
  }
  [self commonInit];
  return self;
}

- (void) commonInit {
  _sasLocation = [[SASLocation alloc] init];
  _nsUrlDefaultSession =
  [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}


- (void)downloadWithQuery:(SASNetworkQuery *)query completionResult:(DownloadWorkerCompletionBlock)completionBlock {
  // Call the appropriate method based on query.
  switch (query.type) {
    case SASNetworkQueryTypeAll:
      [self downloadAllDevicesFromServer:^(NSData *data, NSURLResponse *response, NSError *error) {
        // ..... do something
      }];
      break;
      
    case SASNetworkQueryTypeClosest:
#warning Should check coorinates and let caller know the coordinates are invalid.
      [self downloadClosestDevicesFromServer:query.coordinates completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
      }];

    default:
      break;
  }
}


#pragma mark DownloadWorker protocol.
//- (void)downloadWithQuery:(SASNetworkQuery *)query
//         completionResult:(DownloadWorkerCompletionBlock) completionBlock {
//  // Determine the query type.
//  switch (query.type) {
//    case SASNetworkQueryTypeAll:
//      [self downloadAllDevicesFromServer:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSLog(@"Error: %@", error);
//        NSLog(@"Response: %@", response);
//        NSArray *sasDevices = [self constructDevicesFromResponse:data];
//        
//        // Call back on main thread.
//        dispatch_async(dispatch_get_main_queue(), ^(){
//          completionBlock(sasDevices);
//        });
//      }];
//      break;
//  }
//}


- (void) downloadAllDevicesFromServer: (void (^)(NSData *data, NSURLResponse *response, NSError *error)) completionHandler {
  NSURL *url = [self constructURLForAllSelfies];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  request.HTTPMethod = @"POST";
  [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  
}


- (void) downloadClosestDevicesFromServer:(CLLocationCoordinate2D) coordinates
                              completion: (void (^)(NSData *data, NSURLResponse *response, NSError *error)) completionHandler {
  [self constructURLForClosestSelfies:coordinates result:^(NSString *url, NSError *failedError) {
    
  }];

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



- (NSURL*) constructURLForAllSelfies {
  return [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", downloadURL, @"getAllSelfies"]];
}

// Returns string in the format: https://guarded-mountain-99906.herokuapp.com/getAllSelfiesByPostalCode/{postal_code}
- (void) constructURLForClosestSelfies:(CLLocationCoordinate2D) coordinates result:(void (^)(NSString *url, NSError *failedError)) url {
  [self.sasLocation beginReverseGeolocationUpdate:coordinates withUpdate:^(CLPlacemark *placeMark, NSError *error) {
    NSLog(@"%@", placeMark.postalCode);
    url([NSString stringWithFormat:@"%@%@", downloadURL, @"getAllSelfiesByPostalCode/"], error);
  }];
}

@end
