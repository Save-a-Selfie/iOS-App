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
#import "SASAppSharedPreferences.h"
#import "SASUser.h"
#import "SASJSONParser.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "AppDelegate.h"
#import <JRSwizzle.h>
@interface DefaultSignUpWorker()


@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSURL *picture;


@property (nonatomic, copy) SignUpWorkerCompletionBlock block;


@end

@implementation DefaultSignUpWorker

@synthesize faceBookParam = _faceBookParam;
@synthesize twitterParam = _twitterParam;

NSString* const SIGN_UP_URL = @"https://guarded-mountain-99906.herokuapp.com/signup";

const NSString* USER_INFO_EMAIL_KEY = @"EMAIL_KEY";
const NSString* USER_INFO_NAME_KEY = @"NAME_KEY";
const NSString* USER_INFO_TOKEN_KEY = @"TOKEN_KEY";



#pragma mark SignUpWorker.h protocol method.
- (void)signupWithCompletionBlock:(SignUpWorkerCompletionBlock) completion {
  // Reference the completion block so we can call later, if needed.
  self.block = completion;
  
  // If facebook params are set then
  // we take info from Facebook.
  if (self.faceBookParam) {
    // Extract Facebook info.
    [self extractFBSDKInfo:^(BOOL comp) {
      if (!comp) {
        self.block = nil;
        completion(nil, SignUpWorkerResponseFailed);
      } else {
        [self signup];
      }
    }];
  } else if (self.twitterParam) {
    // Extract Twitter info.
    [self extractTWTRSDKInfo:^(BOOL comp) {
      if (!comp) {
        self.block = nil;
        completion(nil, SignUpWorkerResponseFailed);
      } else {
        [self signup];
      }
    }];
  } else {
    // If either Facebook or Twitter params
    // we're not set then we message caller
    // that an error occurred.
    self.block = nil;
    completion(nil, SignUpWorkerResponseFailed);
  }
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
                                   @"email": @"",
                                   @"add": @"",
                                   @"area": @"",
                                   @"country": @"",
                                   @"file": self.picture}];
  }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
    // Parse out the json.
    NSDictionary *jsonResponseMessage = [SASJSONParser parseSignUpResponse:jsonResponse.body.object];
    NSString *userToken = [jsonResponseMessage objectForKey:@"token"];
#pragma warning: check this status.
    NSNumber *insertStatus = [jsonResponseMessage objectForKey:@"insert_status"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
      NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
      
      // Set all the user info we have been given access to
      // including the user's token generetaed from Save A Selfie.
      if (self.email) {
        [userInfo setObject:self.email forKey:USER_INFO_EMAIL_KEY];
      }
      if (self.name) {
        [userInfo setObject:self.email forKey:USER_INFO_NAME_KEY];
      }
      if (userToken) {
        [userInfo setObject:self.email forKey:USER_INFO_NAME_KEY];
      }
      
      SignUpWorkerCompletionBlock block = self.block;
      
      // User already exists.
      if (insertStatus.integerValue == 101) {
        self.block = nil;
        block(userInfo, SignUpWorkerResponseUserExists);
      }
      else if (insertStatus.integerValue == 102) { // Failed
        self.block = nil;
        block(nil, SignUpWorkerResponseFailed);
      }
      else if (insertStatus.integerValue == 103) { // USer sign up success.
        self.block = nil;
        block(userInfo, SignUpWorkerResponseSuccess);
      }
    });
  }];
}


/**
 Get info from twitter.
 */
- (void) extractTWTRSDKInfo:(void(^)(BOOL completion)) completion {
  NSString* twtrUserID = [self.twitterParam objectForKey:@"userId"];
  
  TWTRAPIClient *twtrApiClient = [[TWTRAPIClient alloc] initWithUserID:twtrUserID];
  [twtrApiClient loadUserWithID:twtrUserID completion:^(TWTRUser *user, NSError *error) {
    if (user) {
      self.name = user.name;
      // Now get email.

      TWTRShareEmailViewController *v = [[TWTRShareEmailViewController alloc] initWithUserID:twtrUserID completion:^(NSString *email, NSError *error) {
        if (email) {
          self.email = email;
          completion(YES);
        } else {
          // Just don't use email for signup.
          self.email = @"";
          completion(YES);
        }
      }];
      
      [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:v animated:YES completion:nil];
    } else {
      completion(NO);
    }
  }];
}

/**
 Get info like email name etc from Facebook.
 */
- (void) extractFBSDKInfo:(void(^)(BOOL completion)) completion {
  FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                initWithGraphPath:@"me" parameters:self.faceBookParam];
  [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
    if (!(error) && [result isKindOfClass:[NSDictionary class]]) {
      self.name = [result objectForKey:@"name"];
      self.email = [result objectForKey:@"email"];
      
      //Extract the facebook profile picture.
      NSDictionary *pictureInfo = [result objectForKey:@"picture"];
      NSDictionary *pictureData = [pictureInfo objectForKey:@"data"];
      NSString *pictureUrl = [pictureData objectForKey:@"url"];
      
      // Turn into base 64 string.
      self.picture = [NSURL URLWithString:pictureUrl];
      //self.picture = [[NSData dataWithContentsOfURL:picUrl] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
      completion(YES);
    } else {
      completion(NO);
    }
  }];
}



- (void)setFaceBookParam:(NSDictionary *)faceBookParam {
  _faceBookParam = faceBookParam;
}


- (void)setTwitterParam:(NSDictionary *)twitterParam {
  _twitterParam = twitterParam;
}
@end
