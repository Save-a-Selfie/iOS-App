//
//  SASUploaderNew.m
//  Save a Selfie
//
//  Created by Stephen Fox on 22/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASUploaderNew.h"
#import "UIImage+SASImage.h"
#import "ParseFactory.h"
#import <Parse.h>

@interface SASUploaderNew ()

@property (strong, nonatomic) SASUploadObject *uploadObject;
@end

@implementation SASUploaderNew



- (void) uploadObject:(SASUploadObject*) uploadObject completion:(UploadCompletionBlock)completion {
  self.uploadObject = uploadObject;
  
  ParseFactory *parseFactory = [ParseFactory sharedInstance];
  PFObject *pfUploadObject = [parseFactory createUploadObject:uploadObject];
  
  [pfUploadObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
      completion(succeeded);
    }
    else {
      completion(false);
    }
  }];
}




@end
