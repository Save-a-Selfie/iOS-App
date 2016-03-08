//
//  DefaultSignUpWorker.m
//  Save a Selfie
//
//  Created by Stephen Fox on 07/03/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "DefaultSignUpWorker.h"
#import <UNIRest.h>
#import "SASLocation.h"

@interface DefaultSignUpWorker() <SASLocationDelegate>


@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *area;
@property (assign, nonatomic) CLLocationCoordinate2D coordinates;
@property (strong, nonatomic) SASLocation *sasLocation;
@property (assign, nonatomic) BOOL locationIsSet;


@end

@implementation DefaultSignUpWorker

@synthesize param = _param;

NSString* const SIGN_UP_URL = @"https://guarded-mountain-99906.herokuapp.com/signup/";


- (instancetype)init
{
  self = [super init];
  if (self) {
    
    _sasLocation = [[SASLocation alloc] init];
    _sasLocation.delegate = self;
    [_sasLocation startUpdatingUsersLocation];

  }
  return self;
}

- (void)signupWithCompletionBlock:(SignUpWorkerCompletionBlock) completion {
  [self extractFBSDKInfo];
  
  
//  [[UNIRest post:^(UNISimpleRequest *simpleRequest) {
//    [simpleRequest setUrl:SIGN_UP_URL];
//    [simpleRequest setHeaders:@{@"application/json": @"Content-Type"}];
//    [simpleRequest setParameters:@{@"name": self.name,
//                                   @"email": self.email,
//                                   @"add": self.address,
//                                   @"area": self.area,
//                                   @"country": self.country}];
//  }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
//    
//  }];
}




/**
 Get info like email name etc from Facebook.*/
- (void) extractFBSDKInfo {
  FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                initWithGraphPath:@"me" parameters:self.param];
  [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
    if ([result isKindOfClass:[NSDictionary class]]) {
      self.name = result[@"name"];
      self.email = result[@"email"];
    }
  }];
}


#pragma mark <SASLocationDelegate>
- (void)sasLocation:(SASLocation *)sasLocation locationDidUpdate:(CLLocationCoordinate2D)location {
  self.coordinates = location;
  self.locationIsSet = YES;
  [self setLocationProperties:self.coordinates];
}


// Sets the location properties of this class once we have
// retrieved a location from SASLocation.
- (void) setLocationProperties:(CLLocationCoordinate2D) location {
  [self.sasLocation beginReverseGeolocationUpdate:self.coordinates withUpdate:^(CLPlacemark *placeMark, NSError *error) {
    NSArray *lines = placeMark.addressDictionary[@"FormatterdAddressLines"];
    self.address = [lines componentsJoinedByString:@"\n"];
    NSLog(self.address);
    
  }];
}


- (void)setParam:(NSDictionary *)param {
  _param = param;
}
@end
