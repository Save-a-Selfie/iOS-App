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
#import "SASLocation.h"
#import <Unirest/UNIRest.h>
#import "SASUser.h"
#import "SASJSONParser.h"


@interface DefaultDownloadWorker ()

@property (strong, nonatomic) NSURLSession *nsUrlDefaultSession;
@property (strong, nonatomic) SASLocation *sasLocation;

@end

@implementation DefaultDownloadWorker

NSString* const GET_ALL_SELFIES_URL = @"https://guarded-mountain-99906.herokuapp.com/getAllSelfies/";



- (instancetype)init {
  self = [super init];
  if (!self) {
    return nil;
  }
  _sasLocation = [[SASLocation alloc] init];
  return self;
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


// Downloads all the 'selfies' from the server.
- (void) downloadAllDevicesFromServer: (void (^)(NSData *data, NSURLResponse *response, NSError *error)) completionHandler {
  [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
    
    SASUser *sasUser = [SASUser currentUser];
    NSString *token = [sasUser token];
    NSString *tokenFormat = [NSString stringWithFormat:@"Bearer %@", token];
    
    [simpleRequest setUrl:GET_ALL_SELFIES_URL];
    [simpleRequest setHeaders:@{@"Content-Type": @"application/json",
                                @"Authorization": tokenFormat}];
    NSLog(@"%@", tokenFormat);
  }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
    NSArray *data = [SASJSONParser parseGetAllSelfieData:jsonResponse.body.object];
    NSLog(@"da");
  }];
  
}


- (void) downloadClosestDevicesFromServer:(CLLocationCoordinate2D) coordinates
                              completion: (void (^)(NSData *data, NSURLResponse *response, NSError *error)) completionHandler {
  [self constructURLForClosestSelfies:coordinates result:^(NSString *url, NSError *failedError) {
    
  }];

}


// Constructs SASDevices from NSData retrieved from the server.
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




// Returns string in the format: https://guarded-mountain-99906.herokuapp.com/getAllSelfiesByPostalCode/{postal_code}
- (void) constructURLForClosestSelfies:(CLLocationCoordinate2D) coordinates result:(void (^)(NSString *url, NSError *failedError)) url {
  [self.sasLocation beginReverseGeolocationUpdate:coordinates withUpdate:^(CLPlacemark *placeMark, NSError *error) {
    url([NSString stringWithFormat:@"%@%@", GET_ALL_SELFIES_URL, @"getAllSelfiesByPostalCode/"], error);
  }];
}

@end
