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


- (void)downloadWithQuery:(SASNetworkQuery *)query
         completionResult:(DownloadWorkerCompletionBlock)completionBlock {
  // Call the appropriate method based on query.
  switch (query.type) {
    case SASNetworkQueryTypeAll:
      [self downloadAllDevicesFromServer: completionBlock];
      break;
      
    case SASNetworkQueryTypeClosest:
      [self downloadClosestDevicesFromServer:query.coordinates completion:completionBlock];
      
    default:
      break;
  }
}


// Downloads all the 'selfies' from the server.
- (void) downloadAllDevicesFromServer: (DownloadWorkerCompletionBlock) completionHandler {
  [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
    
    SASUser *sasUser = [SASUser currentUser];
    NSString *token = [sasUser token];
    NSString *tokenFormat = [NSString stringWithFormat:@"Bearer %@", token];
    
    [simpleRequest setUrl:GET_ALL_SELFIES_URL];
    [simpleRequest setHeaders:@{@"Accept": @"application/json",
                                @"Content-Type": @"application/json",
                                @"Authorization": tokenFormat}];
    NSLog(@"%@", tokenFormat);
  }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
    NSArray *jsonData = [SASJSONParser parseGetAllSelfieData:jsonResponse.body.object];
    NSArray<SASDevice*> *devices = [self constructDevicesFromJSONData:jsonData];
    
    dispatch_async(dispatch_get_main_queue(), ^() {
      completionHandler(devices);
    });
  }];
  
}


- (void) downloadClosestDevicesFromServer:(CLLocationCoordinate2D) coordinates
                               completion: (DownloadWorkerCompletionBlock) completionHandler {
  [self constructURLForClosestSelfies:coordinates result:^(NSString *url, NSError *failedError) {
    
  }];
  
}


// Constructs all devices retrived from server in JSON format.
- (NSArray<SASDevice*>*) constructDevicesFromJSONData:(NSArray*) jsonArray {
  NSMutableArray<SASDevice*> *devices = [[NSMutableArray alloc] init];
  
  for (NSDictionary *jsonDevice in jsonArray) {
    
    SASDeviceType deviceType = [SASDevice deviceTypeForString:[jsonDevice objectForKey:@"aid_type"]];
    NSString *imageFile = [jsonDevice objectForKey:@"file"];
    
    NSString *lat = [jsonDevice objectForKey:@"lat"];
    NSString *long_ = [jsonDevice objectForKey:@"lng"];
    
    CLLocationCoordinate2D coordinates =
    CLLocationCoordinate2DMake([lat doubleValue], [long_ doubleValue]);
    SASDevice *sasDevice = [[SASDevice alloc] initDeviceWithInfo:deviceType
                                                       imageFile:imageFile
                                                         caption:@"HELLO DARKNESS"
                                                     coordinates:coordinates];
    [devices addObject:sasDevice];
  }
  return devices;
}




// Returns string in the format: https://guarded-mountain-99906.herokuapp.com/getAllSelfiesByPostalCode/{postal_code}
- (void) constructURLForClosestSelfies:(CLLocationCoordinate2D) coordinates result:(void (^)(NSString *url, NSError *failedError)) url {
  [self.sasLocation beginReverseGeolocationUpdate:coordinates withUpdate:^(CLPlacemark *placeMark, NSError *error) {
    url([NSString stringWithFormat:@"%@%@", GET_ALL_SELFIES_URL, @"getAllSelfiesByPostalCode/"], error);
  }];
}

@end
