//
//  DefaultSignUpWorker.m
//  Save a Selfie
//
//  Created by Stephen Fox on 07/03/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "DefaultSignUpWorker.h"
#import <UNIRest.h>

@interface DefaultSignUpWorker()


@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;



@end

@implementation DefaultSignUpWorker

@synthesize param = _param;

NSString* const SIGN_UP_URL = @"https://guarded-mountain-99906.herokuapp.com/signup/";

- (void)signupWithCompletionBlock:(SignUpWorkerCompletionBlock) completion {
  [self extractFBSDKInfo];
  
  
  [[UNIRest post:^(UNISimpleRequest *simpleRequest) {
    [simpleRequest setUrl:SIGN_UP_URL];
    [simpleRequest setHeaders:@{@"application/json": @"Content-Type"}];
    [simpleRequest setParameters:<#(NSDictionary *)#>]
  }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
    
  }];
}



/**
 Get info like email name etc from Facebook.*/
- (void) extractFBSDKInfo {
  FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:self.param];
  [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
    if ([result isKindOfClass:[NSDictionary class]]) {
      self.name = result[@"name"];
      self.email = result[@"email"];
    }
  }];
}


- (void)

- (void)setParam:(NSDictionary *)param {
  _param = param;
}
@end
