//
//  SASUploadManager.m
//  Save a Selfie
//
//  Created by Stephen Fox on 22/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASUploadManager.h"
#import "SASUploaderNew.h"

@interface SASUploadManager ()

@property (strong, nonatomic) SASUploaderNew *uploader;

@end

@implementation SASUploadManager


+ (SASUploadManager *)getSharedInstance {
  static SASUploadManager *sharedInstance;
  static dispatch_once_t token;
  
  dispatch_once(&token, ^{
    sharedInstance = [[self alloc] init];
  });
  
  return sharedInstance;
}


- (void)beginObjectUpload:(SASUploadObject<SASVerifiedUploadObject> *)uploadObject completion:(UploadCompletionBlock)completionBlock {
  
  // First check to make sure the object has all the correct information to upload.
  // We don't want a incomplete/ invalid object.
  if (![self verifyObject:uploadObject]) {
    completionBlock(InvalidObject);
  }
  
  if (!self.uploader) {
    self.uploader = [[SASUploaderNew alloc] init];
  }
  
  [self.uploader uploadObject:uploadObject];
}

- (BOOL) verifyObject:(SASUploadObject <SASVerifiedUploadObject>*) object {
  if ([object captionHasBeenSet] && [object deviceHasBeenSet] && [object coordinatesHaveBeenSet]) {
    return YES;
  } else {
    return NO;
  }
}




@end
