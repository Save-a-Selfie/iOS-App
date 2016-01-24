//
//  SASUploadManager.m
//  Save a Selfie
//
//  Created by Stephen Fox on 22/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASUploadManager.h"
#import "ParseUploadWorker.h"


@implementation SASUploadManager


+ (SASUploadManager *) sharedInstance {
  static SASUploadManager *sharedInstance;
  static dispatch_once_t token;
  
  dispatch_once(&token, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}


- (void)uploadWorker:(nonnull id<UploadWorker>) worker
          withObject:(SASUploadObject<SASVerifiedUploadObject> *) uploadObject
          completion:(UploadCompletionBlock) completionBlock {
  
  // Verify object is has correct attributes
  // and message the callee if the object is invalid.
  if (![self verifyObject:uploadObject]) {
    completionBlock(InvalidObject);
  }
  
  // Message the worker to begin uploading to the server.
  [worker uploadObject:uploadObject completion:completionBlock];
}


- (BOOL) verifyObject:(SASUploadObject <SASVerifiedUploadObject>*) object {
  if ([object captionHasBeenSet] && [object deviceHasBeenSet] && [object coordinatesHaveBeenSet]) {
    return YES;
  } else {
    return NO;
  }
}




@end
