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
#import "SASAppUserDefaults.h"

@interface DefaultSignUpWorker() <SASLocationDelegate>


@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *area;
@property (strong, nonatomic) NSURL *picture;
@property (assign, nonatomic) CLLocationCoordinate2D coordinates;
@property (strong, nonatomic) SASLocation *sasLocation;
@property (assign, nonatomic) BOOL fbInfoExtracted;
@property (assign, nonatomic) BOOL geolocationSucceeded;

@property (strong, nonatomic) SignUpWorkerCompletionBlock block;


@end

@implementation DefaultSignUpWorker

@synthesize param = _param;

NSString* const SIGN_UP_URL = @"https://guarded-mountain-99906.herokuapp.com/signup";


- (instancetype)init
{
  self = [super init];
  if (self) {
    
    _coordinates = kCLLocationCoordinate2DInvalid;
    _sasLocation = [[SASLocation alloc] init];
    _sasLocation.delegate = self;
    [_sasLocation startUpdatingUsersLocation];
    
  }
  return self;
}


#pragma mark SignUpWorker.h protocol method.
- (void)signupWithCompletionBlock:(SignUpWorkerCompletionBlock) completion {
  // Reference the completion block so we can call later.
  self.block = completion;
  
  // Extract Facebook info.
  [self extractFBSDKInfo:^(BOOL completion) {
    if (self.geolocationSucceeded) {
      [self signup];
    }
  }];
}



/**
 Sign up with the save a selfie server once
 all information about the user has been set.
 */
- (void) signup {
  [[UNIRest post:^(UNISimpleRequest *simpleRequest) {
    
    [simpleRequest setUrl:SIGN_UP_URL];
    [simpleRequest setHeaders:@{@"accept": @"application/json" }];
    [simpleRequest setParameters:@{@"name": self.name,
                                   @"email": self.email,
                                   @"add": self.address,
                                   @"area": self.area,
                                   @"country": self.country,
                                   @"file": self.picture}];
    NSLog(@"");
  }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
    NSDictionary *jsonBodyObject = jsonResponse.body.object;
    NSDictionary *jsonResponseMessage = [jsonBodyObject objectForKey:@"responseMessage"];
    NSString *userToken = [jsonResponseMessage objectForKey:@"token"];
    
    dispatch_async(dispatch_get_main_queue(), ^() {
      if (userToken == nil) {
        NSError *errorOccurred = [NSError errorWithDomain:@"Error with receiving token from sas server." code:999 userInfo:nil];
        self.block(errorOccurred);
        self.block = nil; // Remove reference to block.
        return;
      }
#pragma warning: AddUserToken forUser:  so its user specific.
      [SASAppUserDefaults addUserToken:userToken];
      
      // No error occurred.
      self.block(nil);
      self.block = nil; // Remove reference to block.
      
    });
  }];
}


/**
 Get info like email name etc from Facebook.
 */
- (void) extractFBSDKInfo:(void(^)(BOOL completion)) completion {
  FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                initWithGraphPath:@"me" parameters:self.param];
  [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
    if ([result isKindOfClass:[NSDictionary class]]) {
      self.name = [result objectForKey:@"name"];
      self.email = [result objectForKey:@"email"];
      
      //Extract the facebook profile picture.
      NSDictionary *pictureInfo = [result objectForKey:@"picture"];
      NSDictionary *pictureData = [pictureInfo objectForKey:@"data"];
      NSString *pictureUrl = [pictureData objectForKey:@"url"];
      
      // Turn into base 64 string.
      self.picture = [NSURL URLWithString:pictureUrl];
      //self.picture = [[NSData dataWithContentsOfURL:picUrl] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
      
      
      self.fbInfoExtracted = YES;
      NSLog(@"FaceBook set.\n");
    }
  }];
}


#pragma mark <SASLocationDelegate>
- (void)sasLocation:(SASLocation *)sasLocation locationDidUpdate:(CLLocationCoordinate2D)location {
  
  // Check validity of coordinates.
  if (CLLocationCoordinate2DIsValid(location)) {
    self.coordinates = location;
    
    // Once we have the location info extract all the facebook info.
    [self setLocationProperties:self.coordinates];
  }
}


/**
 This begins the process of reverse geolocating the coordinates.
 */
- (void) setLocationProperties:(CLLocationCoordinate2D) location {
  [self.sasLocation beginReverseGeolocationUpdate:self.coordinates withUpdate:^(CLPlacemark *placeMark, NSError *error) {
    
    if (error) {
      NSLog(@"An error with geolocation occurred.\n");
      self.geolocationSucceeded = NO;
      
    } else {
      self.address = placeMark.name;
      self.country = placeMark.country;
      self.area = placeMark.thoroughfare;
      self.geolocationSucceeded = YES;
    }
    
    // If location information is set before
    // fb info is extracted then this will
    // cause us to wait until that is done.
    if (self.fbInfoExtracted && self.geolocationSucceeded) {
      [self signup];
      // We don't need location reference no more.
      self.sasLocation.delegate = nil;
      self.sasLocation = nil;
    }
  }];
}


- (void)setParam:(NSDictionary *)param {
  _param = param;
}
@end
