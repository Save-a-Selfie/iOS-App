//
//  SASUser.m
//  Save a Selfie
//
//  Created by Stephen Fox on 09/03/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASUser.h"

/**
 While the FBSDK has record of a user
 logged in, it does not store information
 about users on the Save a Selfie backend.
 This is what this class is for.
 */

@interface SASUser ()

@property (strong, nonatomic) NSString *token;

@end

@implementation SASUser

@synthesize token = _token;

+ (SASUser *)currentUser {
  static dispatch_once_t token;
  static SASUser *sharedInstance;
  
  dispatch_once(&token, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}


- (void) setToken:(NSString*) token {
  _token = token;
}


- (NSString *)token {
  return _token;
}

@end
